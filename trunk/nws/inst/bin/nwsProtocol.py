##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##

from twisted.protocols import stateful

class NwsProtocol(stateful.StatefulProtocol):

    # generic protocol: first 4 bytes are 4 ascii digits holding a
    # count of the args. each arg is a 20 digit length followed by
    # that many bytes holding the 'value' of the arg.

    # why 20? 2^64 fits into 20 digits. The string
    # '99999999999999999999' is allowed for the count of args.  it
    # means keep reading args until another '99999999999999999999' is
    # encountered as the len of an arg.

    # the operation itself is an argument, so there should always be
    # at least one arg.

    sentinelCount = '99999999999999999999'
    
    def connectionMade(self):
        self.transport.setTcpNoDelay(1)

	# this is start state for argument processing. the initial
	# state for the connection is "handshake".
	self.startState = (self.receiveArgCount, 4)

	# per connection opaque state to be manipulated by the eval
	# service.
        self.peer = '%s' % self.transport.getPeer()
        self.mySets = [] # tracks workspaces owned by this connection.
        self.wsMap = {}  # map from external to internal workspace name. see nwsServer.

    def handshake(self, data):
	# will eventually do some interesting protocol versioning
	# reconciliation and option processing here.
	self.context = data
	self.transport.write('2222')

	return self.startState

    def connectionLost(self, reason):
        self.factory.goodbye(self)

    def writeStatusLenValue(self, (status, value)):
	self.transport.write('%04d%020d%020d' % (status, value.desc, len(value.val)))
	self.transport.write(value.val)

    def getInitialState(self): return (self.handshake, 4)

    def receiveArgCount(self, data):
	if data == self.sentinelCount:
	    self.argCount = -1
	else:
	    self.argCount = int(data)
	    if self.argCount < 1:
		log.msg('bad arg count: '+data)
		self.transport.loseConnection()
	self.args = []
	return (self.receiveLenArg, 20)

    def receiveLenArg(self, data):
	if self.argCount == -1 and data == self.sentinelCount:
	    self.factory.doOp(self)
	    return self.startState
	else:
	    return (self.receiveArg, int(data))

    def receiveArg(self, data):
	self.args.append(data)
	if len(self.args) == self.argCount:
	    self.factory.doOp(self)
	    return self.startState
	else:
	    return (self.receiveLenArg, 20)

