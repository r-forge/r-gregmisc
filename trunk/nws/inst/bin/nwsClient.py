"""Python API for performing netWorkSpace operations.

(Need a description of this module here)

Example:

First start up the NWS server, using the twistd
command:

% twistd -ny nwsServer.py

Now you can perform operations against it using
this module:

% python
>>> from nwsClient import NetWorkSpace
>>> nws = NetWorkSpace("test")
>>> nws.store("answer", 42)
>>> count = nws.fetch("answer")
>>> print "The answer is", count
>>>

"""

import cPickle, os, socket

from types import StringType

_PythonFP =     0x01000000
_DirectString = 0x00000001

class NwsServer:

    """Perform operations against the NWS server.

    Operations against work spaces are performed
    by using the NetWorkSpace class.
    """

    def __init__(self, host='localhost', port=8765):
        """Create a connection to the NWS server.

        This constructor is only intended to be called internally.

        Arguments:
        host -- hostname of the NWS server
        port -- port of the NWS server

        """
	self.serverHost = host
	self.serverPort = port
	self.nwsSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	self.nwsSocket.connect((host, port))
	self.nwsSocket.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)

	# handshaking that does nothing at the moment.
	self.nwsSocket.send('1111')
	self._recvN(4)

    def _recvN(self, n):
        b = ''
        while len(b) < n:
            d = self.nwsSocket.recv(n-len(b))
            if not d: raise Exception('connection dropped?')
            b += d
        return b
        
    def close(self):
        """Close the connection to the NWS server.

        """
	try:
	    self.nwsSocket.shutdown(2)
	    self.nwsSocket.close()
	except:	pass

    def deleteWs(self, wsName):
        """Delete the specfied work space on the NWS server.

        Arguments:
        wsName -- name of the work space to delete

        """
        op = 'delete ws'

	self.nwsSocket.send('0002%020d%s%020d%s' % (len(op), op, len(wsName), wsName))

	status = self._recvN(4) # unused at the moment.

    def listWss(self):
        """Return a listing of all of the work spaces on the NWS server.

        """
        op = 'list wss'
        self.nwsSocket.send('0001%020d%s' % (len(op), op))
	status = self._recvN(4) # unused at the moment.
        desc = self._recvN(20) # unused at the moment.
        return self._recvN(int(self._recvN(20)))

    def mktempWs(self, wsName='__pyws__%d'):
        """Make a temporary work space on the NWS server.

        Arguments:
        wsName -- name of the work space to make

        """
	op = 'mktemp ws'
        self.nwsSocket.send('0002%020d%s%020d%s' % (len(op), op, len(wsName), wsName))
	status = self._recvN(4) # unused at the moment.
        desc = self._recvN(20) # unused at the moment.
        return self._recvN(int(self._recvN(20)))

    def openWs(self, wsName, space=None, **opt):
        """Return a NetWorkSpace object.

        Arguments:
        wsName -- name of the work space to open

        """
	# if invoked diectly by user, we need to create a space
	# instance. if invoked via networkspace constructor, use the
	# space passed in.
	if not space: space = NetWorkSpace(wsName, server=self)

        op = 'open ws'
	owner = '%d' % os.getpid()
	
	p = 'no'
	if opt.get('persistent', False): p = 'yes'

	self.nwsSocket.send('0004%020d%s%020d%s%020d%s%020d%s' % (len(op), op, len(wsName), wsName, len(owner), owner, len(p), p))

	status = self._recvN(4) # unused at the moment.
	return space

    def useWs(self, wsName, space=None):
        """Return a NetWorkSpace object.

        Arguments:
        wsName -- name of the work space to open
        space -- work space object to return

        """
	# see openWs
	if not space: space = NetWorkSpace(wsName, server=self)
	return space

	
class NetWorkSpace:

    """Perform operations against work spaces on NWS servers.

    """

    def __init__(self, wsName='__default', serverHost='localhost', serverPort=8765, useUse=False, server=None, **opt):
        """Create a NetWorkSpace object that points to the
        NWS server on the specified host and port.

        Arguments:
        wsName -- name of the work space to use
        serverHost -- hostname of the NWS server
        serverPort -- port of the NWS server

        """
	self.currentWs = wsName

	# if invoked (indirectly) via a server openWs or useWs method,
	# the server will be passed in and used. if invoked directly,
	# need to create a new server instance.
	if not server:
	    self.server = NwsServer(serverHost, serverPort)
	    # now give the server a chance to do its thing.
	    if useUse:
		# at the moment, this is really a no op.
		self.server.useWs(wsName, self)
	    else:
		self.server.openWs(wsName, self, **opt)
	else:
	    self.server = server


	self.send = self.server.nwsSocket.send
	self.recv = self.server._recvN

    def currentWs(self):
        """Return the name of the current workspace.

        """
        return self.currentWs

    def declare(self, varName, mode):
        """Declare a variable in a work space with the specified mode.
        
        This method is used to specify a mode other than the default
        mode of 'fifo'.  Legal values for the mode are:

            'fifo', 'lifo', 'multi', and 'single'

        In the first three modes, multiple value can be stored in
        a variable.  If the mode is 'fifo', then values are retrieved
        in a "first-in, first-out" fashion.  That is, the first value
        stored, will be the first value fetched.  If the mode is 'lifo',
        then values are retreived in a "last-in, first-out" fashion,
        as in a stack.  If the mode is 'multi', then the order of
        retreival is undefined.

        The 'single' mode means that only a single value can be
        stored in the variable.  Each new store operation will overwrite
        the current value of the variable.

        If a variable is created using a store operation, then the
        mode defaults to 'fifo'.  The mode cannot be changed with
        subsequent calls to declare, regardless of whether the variable
        was originally created using store or declare.

        Arguments:
        varName -- name of the variable to declare
        mode -- mode of the variable

        """
        op = 'declare var'
	self.send('0004%020d%s%020d%s%020d%s%020d%s' % (len(op), op, len(self.currentWs), self.currentWs, len(varName), varName, len(mode), mode))

	status = self.recv(4) # unused at the moment.
	
    def deleteVar(self, varName):
        """Delete a variable from a work space.

        All values of the variable are destroyed, and all currently
        blocking fetch and find operations will be aborted.

        Arguments:
        varName -- name of the variable to delete

        """
        op = 'delete var'

	self.send('0003%020d%s%020d%s%020d%s' % (len(op), op, len(self.currentWs), self.currentWs, len(varName), varName))

	status = self.recv(4) # unused at the moment.
	
    def __retrieve(self, varName, op, missing):
        self.send('0003%020d%s%020d%s%020d%s' % (len(op), op, len(self.currentWs), self.currentWs, len(varName), varName))
	status = int(self.recv(4)) # barely used at the moment.

        # even if failure status, read the rest of the bytes.
        desc = int(self.recv(20))

        pVal = self.recv(int(self.recv(20)))

        if status: raise Exception('retrieval failed')

        if pVal:
            if desc & _DirectString:
                return pVal
            else:
                return cPickle.loads(pVal)
        else:
            return missing

    def fetch(self, varName):
        """Return and remove a value of a variable from a work space.

        If the variable has no values, the operation will block
        until it does.

        Arguments:
        varName -- name of the variable to fetch

        """
        return self.__retrieve(varName, 'fetch', None)

    def fetchTry(self, varName, missing=None):
        """Try to return and remove a value of a variable from a work space.

        If the variable has no values, the operation will return
        the value specified by "missing", which defaults to None.

        Arguments:
        varName -- name of the variable to fetch
        missing -- value to return if the variable has no values

        """
        try:	return self.__retrieve(varName, 'fetchTry', missing)
        except:	return missing
        
    def find(self, varName):
        """Return a value of a variable from a work space.

        If the variable has no values, the operation will block
        until it does.

        Arguments:
        varName -- name of the variable to find

        """
        return self.__retrieve(varName, 'find', None)

    def findTry(self, varName, missing=None):
        """Try to return a value of a variable from a work space.

        If the variable has no values, the operation will return
        the value specified by "missing", which defaults to None.

        Arguments:
        varName -- name of the variable to find
        missing -- value to return if the variable has no values

        """
        try:	return self.__retrieve(varName, 'findTry', missing)
        except:	return missing

    def listVars(self, wsName=None):
        """Return a listing of the variables in the work space.

        Arguments:
        wsName -- name of the work space to list
                  The default value of None means to use
                  the current work space.

        """
        op = 'list vars'
	if not wsName: wsName = self.currentWs
        self.send('0002%020d%s%020d%s' % (len(op), op, len(wsName), wsName))
	status = self.recv(4) # unused at the moment.
        desc = self.recv(20) # unused at the moment.
        return self.recv(int(self.recv(20)))

    def store(self, varName, val):
        """Store a new value into a variable in the work space.

        Arguments:
        varName -- name of the variable
        val -- value to store in the variable

        """
        op = 'store'

        desc = _PythonFP
        if StringType == type(val): desc |= _DirectString
        descTxt = '%020u' % desc

        if desc & _DirectString:
            pVal = val
        else:
            pVal = cPickle.dumps(val)

	self.send('0005%020d%s%020d%s%020d%s%020d%s%020d' % (len(op), op, len(self.currentWs), self.currentWs, len(varName), varName, len(descTxt), descTxt, len(pVal)))
	self.send(pVal)

	status = int(self.recv(4))
        if status: raise Exception('store failed')
        
