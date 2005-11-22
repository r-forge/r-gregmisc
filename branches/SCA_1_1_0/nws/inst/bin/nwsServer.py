
## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# server for netWorkSpaces.

from tempfile import mkstemp
from os import getcwd
from random import randint

from twisted.application import internet, service
from twisted.internet import defer, protocol, reactor
from twisted.python import log
from twisted.web import server

from nwsProtocol import NwsProtocol
from nwsWeb import NwsWeb

from babelConfig import *
from dummyComm import *
from hexDump import hexDump

import cgi

import nwsConfig

# bit codings for the descriptor.
DirectString = 1

class netWorkSpace:
    def __init__(self, name, owned=False, owner='', persistent=False):
	self.bindings = {}
	self.name = name
	self.owned = owned
	self.owner = owner
	self.persistent = persistent

class Variable:
    def __init__(self, mode='unknown'):
	self.fetchers, self.finders, self.values = [], [], []
	self.mode = mode

class ValueTranslation:
    def __init__(self, server, value, cb, *a):
        self.dc = DummyConnection(self.writeStatusLenValue)
        self.d = defer.Deferred()
        self.d.addCallback(cb, *a)
        envId = (value.desc >> 24) & 0xFF
        babelNwsName, self.tcb = babelEngines[envId]
        server.openWs(self.dc, 'use ws', babelNwsName, '', 'no')
        server.setVar(self.dc, 'store', babelNwsName, 'food', value.desc, value.val)
        server.getVar(self.dc, 'fetch', babelNwsName, 'doof')
        
    def writeStatusLenValue(self, (status, value)):
        self.tcb(self.d, value.val)
        
class Value:
    def __init__(self, desc, val):
        self.desc = desc
        self.val = val
        
    def translate(self, server, cb, *a):
        if self.desc & DirectString:
            cb(self.val, *a)
        else:
            ValueTranslation(server, self, cb, *a)

def varList(bindings):
    k = bindings.keys()
    k.sort()
    return ','.join(k)

class NwsService(service.Service):
    # marker for list output.
    myOwnDesignation = {True: '>', False: ' '}

    # tuples here encode the properties remove and block.
    lValueOps = { 'fetch' : (1, 1), 'fetchTry': (1, 0), 'find': (0, 1), 'findTry': (0, 0) }

    # allowable queing modes for variables.
    modes = ['fifo', 'lifo', 'multi', 'single']

    nullValue = Value(0, '')
    
    def __init__(self):
        self.extToIntWsName = {'__default' : ('__default', 0)}
        self.spaces = {('__default', 0) : netWorkSpace('__default', True, '[system]')}

	self.opTable = {
	    'declare var':	self.declareVar,
	    'delete ws':	self.deleteNetWorkSpace,
	    'delete var':	self.deleteVar,
	    'fetch':		self.getVar,
	    'fetchTry':		self.getVar,
	    'find':		self.getVar,
	    'findTry': 		self.getVar,
	    'list vars':	self.listVars,
	    'list wss':		self.listWss,
	    'mktemp ws':	self.mktempWs,
	    'open ws':		self.openWs,
	    'store':		self.setVar,
	    'use ws':		self.openWs,
	}

	self.wsCounter = 0
	wd = getcwd()
	self.tempFile, self.wsBaseName = mkstemp(prefix='_tmp', dir=wd)
	self.wsBaseName = self.wsBaseName[len(wd)+1:]

    def doOp(self, cState):
	# dispatch
	try:	self.opTable[cState.args[0]](cState, *cState.args)
	except  Exception, e: log.msg('ignoring: '+ str(cState.args) + ' ' + str(e))

    def referenceSpace(self, wsName, cState, assertOwnership=False, owner = ''):
        if not self.extToIntWsName.has_key(wsName):
            # don't recognize the external workspace name, create it. we use a
            # separate internal name that allows has to track instances. e.g.,
            # workspace 'foo' is created, deleted and created again. a
            # connection using the first may map 'foo' to the internal "name"
            # the tuple '(foo, 1)' while a connection using the second may map
            # 'foo' to '(foo, 7)'.

            intWsName = (wsName, self.wsCounter)
            self.wsCounter += 1
	    if assertOwnership:
		space = self.spaces.setdefault(intWsName, netWorkSpace(wsName, True, owner))
		space.owned, space.owner = True, owner
		cState.mySets.append(intWsName)
	    else:
		space = self.spaces.setdefault(wsName, netWorkSpace(wsName))
            self.spaces[intWsName] = space
            self.extToIntWsName[wsName] = intWsName
        else:
            intWsName = self.extToIntWsName[wsName]
            space = self.spaces[intWsName]
            if not space.owned and assertOwnership:
                space.owned, space.owner = True, owner
                cState.mySets.append(intWsName)
        if cState.wsMap.get(wsName, intWsName) != intWsName:
            log.msg('connection has new reference (%s, %s)' % (cState.wsMap[wsName]), intWsName)
        cState.wsMap[wsName] = intWsName

    def declareVar(self, cState, op, wsName, varName, mode):
        try:	bindings = self.spaces[cState.wsMap[wsName]].bindings
        except:
            log.msg('has this connection opened/used %s?' % (wsName))
	    # eventually return error via status bytes.
	    cState.transport.write('0000')
            return
        
	if mode not in self.modes:
	    log.msg('variable "%s", binding set "%s": unrecognized mode "%s", using fifo.' % (varName, wsName, mode))
	    mode = 'fifo'

        status = '0000'
	if bindings.has_key(varName):
	    if bindings[varName].mode == 'unknown':
		bindings[varName].mode = mode
	    elif bindings[varName].mode != mode:
		log.msg('variable "%s" (mode %s) already exists in netWorkSpace "%s" with a different mode (%s), ignoring declare.' % (varName, mode, wsName, bindings[varName].mode))
                status = '0001'
	else:
	    bindings[varName] = Variable(mode)
        cState.transport.write(status)

    def deleteNetWorkSpace(self, cState, op, wsName):
	try:
	    self.purgeNetWorkSpace(self.spaces.pop(self.extToIntWsName[wsName]).bindings)
            self.extToIntWsName.pop(wsName)
	    cState.transport.write('0000')
	except KeyError:
	    log.msg('binding set %s does not exist.' % wsName)
	    cState.transport.write('0001')

    def deleteVar(self, cState, op, wsName, varName):
        try:	bindings = self.spaces[cState.wsMap[wsName]].bindings
        except:
            log.msg('has this connection opened/used %s?' % (wsName))
            cState.transport.write('0001')
            return
        
	try:
	    var = bindings.pop(varName)
	    fetchers, finders = var.fetchers, var.finders
	    
	    cState.transport.write('0000')
	except KeyError:
	    log.msg('cannot delete "%s" in binding set "%s".' % (varName, wsName))
	    fetchers, finders = [], []
	    cState.transport.write('0001')

	for d in fetchers: d.callback((1, self.nullValue))
	for d in finders: d.callback((1, self.nullValue))

    def getVar(self, cState, op, wsName, varName):
        removeP, blockP = self.lValueOps[op]

        try:	bindings = self.spaces[cState.wsMap[wsName]].bindings
        except:
            log.msg('has this connection opened/used %s?' % (wsName))
            cState.writeStatusLenValue((1, self.nullValue))
            return
        
	if not bindings.has_key(varName): bindings[varName] = Variable()
	var = bindings[varName]

	if var.values:
	    # if we have values for this var, the mode cannot be 'unknown'.
	    if var.mode == 'single':	x = 0
	    elif var.mode == 'lifo':	x = -1
	    elif var.mode == 'fifo':	x = 0
	    else:			x = randint(0,len(var.values)-1)

	    if removeP:	val = var.values.pop(x)
	    else:	val = var.values[x]
	    d = defer.succeed((0, val))
        else:
	    if blockP:
		d = defer.Deferred()
		if removeP:	var.fetchers.append(d)
		else:		var.finders.append(d)
	    else:
		d = defer.succeed((1, self.nullValue))
	
	d.addCallback(cState.writeStatusLenValue)

    def listVars(self, cState, op, wsName):
        try:	bindings = self.spaces[cState.wsMap[wsName]].bindings
        except:
            log.msg('has this connection opened/used %s?' % (wsName))
            cState.writeStatusLenValue((1, self.nullValue))
            return
        
	vars = bindings.keys()
	vars.sort()
	varListData = '\n'.join(['%s\t%d\t%d\t%d\t%s' % (varName, len(var.values), len(var.fetchers), len(var.finders), var.mode) for varName in vars for var in [bindings[varName]]])
	cState.writeStatusLenValue((0, Value(0, varListData)))

    def listWss(self, cState, op, wsName=None):
	wsNames = self.extToIntWsName.keys()
	wsNames.sort()
	setList = '\n'.join(['%s%s\t%s\t%s\t%d\t%s'%(self.myOwnDesignation[n in cState.mySets],
                                                     n[0],
                                                     self.spaces[n].owner,
                                                     self.spaces[n].persistent,
                                                     len(b),
                                                     varList(b))
                             for extName in wsNames if (not wsName or wsName == extName)
                             for n in [self.extToIntWsName[extName]]
                             for s in [self.spaces[n]]
                             for b in [s.bindings]])+'\n'
	cState.writeStatusLenValue((0, Value(0, setList)))

    def mktempWs(self, cState, op, template='__ws__%d'):
	# step the counter on every attempt.
	cc = self.wsCounter
	self.wsCounter += 1

	try:	newName = (template % cc) + self.wsBaseName
	except:
	    log.msg('mktemp: bad template "%s".' % template)
	    cState.writeStatusLenValue((1, self.nullValue))
			     
	if self.spaces.has_key(newName):
	    log.msg('mktemp: new name "%s" already exists!' % newName)
	    cState.writeStatusLenValue((1, self.nullValue))

	# make a non-owning reference (triggering existence).
	self.referenceSpace(newName, cState)
	cState.writeStatusLenValue((0, Value(0, newName)))

    def openWs(self, cState, op, wsName, ownerData, persistent):
        if op == 'open ws':
            ownerDataTxt = '%s (%s)' % (cState.peer, ownerData)
            self.referenceSpace(wsName, cState, True, ownerDataTxt)
            if 'yes' == persistent: self.spaces[wsName].persistent = True
        else:
            self.referenceSpace(wsName, cState, False, '')
                
	cState.transport.write('0000')

    def purgeNetWorkSpace(self, bindings):
	keys = bindings.keys()
	for k in keys:
	    var = bindings.pop(k)
	    for d in var.fetchers: d.callback((1, self.nullValue))
	    for d in var.finders: d.callback((1, self.nullValue))
        
    def purgeOwnedWorkspaces(self, cState):
        for wsName in cState.mySets:
            extWsName = wsName[0]
	    try:	
		if not self.spaces[wsName].persistent:
		    space = self.spaces.pop(wsName)
		    self.purgeNetWorkSpace(space.bindings)
                    self.extToIntWsName.pop(extWsName)
	    except Exception, e:	log.msg('purging %s: %s' % (wsName, str(e)))
        
    def setVar(self, cState, op, wsName, varName, valDesc, valPayload):
        try:	bindings = self.spaces[cState.wsMap[wsName]].bindings
        except:
            log.msg('has this connection opened/used %s?' % (wsName))
	    cState.transport.write('0001')
            return
        
	if not bindings.has_key(varName):
	    bindings[varName] = Variable('fifo')
	else:
	    if bindings[varName].mode == 'unknown':
		bindings[varName].mode = 'fifo'

	var = bindings[varName]

        val = Value(int(valDesc), valPayload)
	for d in var.finders: d.callback((0, val))
	var.finders = []

	if var.fetchers:
	    var.fetchers.pop(0).callback((0, val))
	elif 'single' == var.mode:
	    if var.values: var.values[0] = val
	    else:          var.values.append(val)
	else:
	    var.values.append(val)

	cState.transport.write('0000')

    def getEnvFactory(self):
	f = protocol.ServerFactory()
	f.protocol = NwsProtocol

	f.doOp = self.doOp
	f.goodbye = self.purgeOwnedWorkspaces
	return f

    def getResource(self):
	return NwsWeb(self)

#application = service.Application('env', uid=1, gid=1)
application = service.Application('env')
f = NwsService()
serviceCollection = service.IServiceCollection(application)
internet.TCPServer(nwsConfig.nwsServerPort, f.getEnvFactory()).setServiceParent(serviceCollection)

# web interface
internet.TCPServer(nwsConfig.nwsWebPort, server.Site(f.getResource())).setServiceParent(serviceCollection)
