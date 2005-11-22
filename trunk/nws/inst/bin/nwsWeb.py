##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##

# to do: uniformally cope with get encodings... 

import os

from twisted.internet import defer
from twisted.web import resource, server, static

from dummyComm import *

import nwsConfig

# borrowed from twisted's default web file serving.
styleBlock='''
  <style>
    .even { background-color: #eee }
    .odd { background-color: #dedede }
    .icon { text-align: center }
    .listing {
        margin-left: auto;
        margin-right: auto;
        width: 50%%;
        padding: 0.1em;
        }

    body { border: 0; padding: 0; margin: 0; background-color: #efefef; }
    h4 {padding: 0.1em; background-color: #777; color: white; border-bottom: thin white dashed;}
    h5 {padding: 0.1em; background-color: #999; color: white; border-bottom: thin green dashed; border-top: thin green dashed;}

    </style>
'''

class Translator:
    def __init__(self, server, request, wsName, varName, vVals):
        self.request, self.wsName, self.varName = request, wsName, varName
        request.write('''
<html>
 <head>
  <title>Values of %s in %s</title>
 </head>
 %s    
 <body>
  <h4> Values of %s in %s </h4>
  <table cellpadding="4">
   <tr pattern="listHeader">
    <th>Slot</th>
    <th>Value</th>
   </tr>
'''%(varName, wsName, styleBlock, varName, wsName))
        self.numVals, self.pop = len(vVals), 0
        self.queue = [None for x in xrange(self.numVals)]

        # we kick off all translations here, rather than ping/pong-ing
        # them. we do this to avoid problems with the list of values
        # changing as the process unfolds.
        if 0 == self.numVals:
            self.endTranslation()
        else:
            for x in xrange(self.numVals):
                vVals[x].translate(server, self.collectTranslation, x)
            
    def collectTranslation(self, text, x):
        self.queue[x] = text
        self.pop += 1
        if self.pop == self.numVals:
            for i in xrange(0, self.numVals):
                self.request.write('<tr class="%s"><td>%d</td><td>%s</td></tr>' % (['even', 'odd'][i%2], i+1, self.queue[i].replace('\n', '<p>')))
            self.endTranslation()
            
    def endTranslation(self):
        self.request.write('''
</table>
<p>
<p>
<a href="doit?op=confirmFetchTryVar&wsName=%s&varName=%s">FetchTry (I.e., Remove) a Value?</a>
<p>
<a href="doit?op=confirmDeleteVar&wsName=%s&varName=%s">Remove Variable?</a>
<p>
<h5><a href="doit?op=listVars&wsName=%s"> List variables in %s </a></h5>
<p>
<h5><a href="doit?op=listWss"> List netWorkSpaces </a></h5>
</body>
</html>
'''%(self.wsName, self.varName, self.wsName, self.varName, self.wsName, self.wsName))
        self.request.finish()

    
class NwsWebDynamic(resource.Resource):
    isLeaf = True # never call getChild, go to render_GET directly.

    def __init__(self, nwsServer):
	resource.Resource.__init__(self)

        self.extToInt = nwsServer.extToIntWsName
	self.spaces = nwsServer.spaces
	self.dc = DummyConnection()
	self.nwsServer = nwsServer

	self.opTable = {
	    'confirmDeleteVar':		self.confirmDeleteVar,
	    'confirmDeleteWs':		self.confirmDeleteWs,
	    'deleteVar':		self.deleteVar,
	    'deleteWs':			self.deleteWs,
	    'confirmFetchTryVar':	self.confirmFetchTryVar,
	    'fetchTryVar':		self.fetchTryVar,
	    'listVars':			self.listVars,
	    'listWss':			self.listWss,
	    'showVar':			self.showVar,
	}
	    
    def varList(self, vl):
	if not vl: return '[NONE]'
	k = vl.keys()
	k.sort()
	return ','.join(k)

    def confirmDeleteVar(self, request):
	try:
	    varName = request.args['varName'][0]
	    wsName = request.args['wsName'][0]
	    confirm = '''
<html>
<head>
 <title>Confirm Variable Deletion</title>
</head>
<body>
<table bordeer="0" cellspacing="0" cellpadding="20"><tr><td>Really delete %s from netWorkSpace %s?</td><td><a href="doit?op=deleteVar&wsName=%s&varName=%s">Yes</a></td><td><a href="doit?op=listWss">No</a></td></tr></table>
</body>
</html>
'''%(varName, wsName, wsName, varName)
	except: confirm = '<html><body>Malformed request.</body></html>'
	return confirm

    def confirmDeleteWs(self, request):
	try:
	    wsName = request.args['wsName'][0]
	    confirm = '''
<html>
<head>
 <title>Confirm Workspace Deletion</title>
</head>
<body>
<table bordeer="0" cellspacing="0" cellpadding="20"><tr><td>Really delete netWorkSpace %s?</td><td><a href="doit?op=deleteWs&wsName=%s">Yes</a></td><td><a href="doit?op=listWss">No</a></td></tr></table>
</body>
</html>
'''%(wsName, wsName)
	except: confirm = '<html><body>Malformed request.</body></html>'
	return confirm

    def confirmFetchTryVar(self, request):
	try:
	    wsName = request.args['wsName'][0]
	    varName = request.args['varName'][0]
	    confirm = '''
<html>
<head>
 <title>Confirm FetchTry</title>
</head>
<body>
<table bordeer="0" cellspacing="0" cellpadding="20"><tr><td>Really fetchTry %s from %s?</td><td><a href="doit?op=fetchTryVar&wsName=%s&varName=%s">Yes</a></td><td><a href="doit?op=listWss">No</a></td></tr></table>
</body>
</html>
'''%(varName, wsName, wsName, varName)
	except: confirm = '<html><body>Malformed request.</body></html>'
	return confirm

    def deleteVar(self, request):
	try:
	    varName = request.args['varName'][0]
	    wsName = request.args['wsName'][0]
	    bindings = self.spaces[self.extToInt[wsName]].bindings
    	except KeyError: return '<html> What\'s a %s in a %s? </html>' % (varName, wsName)

        self.nwsServer.openWs(self.dc, 'use ws', wsName, '', 'no')
	self.nwsServer.deleteVar(self.dc, 'delete var', wsName, varName);
	deletedWs = '''
<html>
<body>
Deleted %s in %s.
<p>
<h5><a href="doit?op=listVars&wsName=%s">List vars in %s.</a></h5>
<p>
<h5><a href="doit?op=listWss">List workspaces..</a></h5>
</body>
</html>
'''%(varName, wsName, wsName, wsName)
	return deletedWs

    def deleteWs(self, request):
	try:
	    wsName = request.args['wsName'][0]
	    bindings = self.spaces[self.extToInt[wsName]].bindings
    	except KeyError: return '<html> Never heard of %s. </html>' % wsName

	self.nwsServer.deleteNetWorkSpace(self.dc, 'delete ws', wsName);
	deletedWs = '''
<html>
<body>
Deleted %s.
<p>
<h5><a href="doit?op=listWss">List workspaces.</a></h5>
</body>
</html>
'''%wsName
	return deletedWs

    def listWss(self, request):
	extWsNames = self.extToInt.keys()
	extWsNames.sort()
	setList = '''
<html>
<head>
 <title>NetWorkSpaces</title>
</head>
%s
<body>
<h4>NetWorkSpaces</h4>
<table cellpadding="4">
<tr pattern='listHeader'><th>Name</th><th>Owner</th><th>Persistent</th><th># Variables</th><th>Variable List</th><th>Delete?</th></tr>
'''%(styleBlock)
	for i in xrange(len(extWsNames)):
	    n = extWsNames[i]
            intName = self.extToInt[n]
	    b = self.spaces[intName].bindings
	    setList += '<tr class="%s"><td><a href="doit?op=listVars&wsName=%s">%s</a></td><td>%s</td><td>%s</td><td>%d</td><td>%s</td><td><a href="doit?op=confirmDeleteWs&wsName=%s"><font color=#EE1111>X</font></a></td></tr>'%(['even', 'odd'][i%2], n, n, self.spaces[intName].owner, self.spaces[intName].persistent, len(b), self.varList(b), n)
	setList += '''
</table>
</body>
</html>
'''
	return setList

    def listVars(self, request):
	wsName = '<get wsName data missing>'
	try:
	    wsName = request.args['wsName'][0]
	    bindings = self.spaces[self.extToInt[wsName]].bindings
    	except KeyError: return '<html> Never heard of %s. </html>' % wsName

	vars = bindings.keys()
	vars.sort()
	varListData = '''
<html>
%s
<body>
<h4> Variables in %s </h4>
<p>
<table cellpadding="4">
<tr pattern="listHeader"><th>Variable</th><th># Values</th><th># Fetchers</th><th># Finders</th><th>Mode</th></tr>
''' % (styleBlock, wsName)
	for i in xrange(len(vars)):
	    varName = vars[i]
	    var = bindings[varName]
	    varListData += '<tr class="%s"><td><a href="doit?op=showVar&wsName=%s&varName=%s">%s</a></td><td align="right">%d</td><td align="right">%d</td><td align="right">%d</td><td>%s</td></tr>' % \
	                   (['even', 'odd'][i%2], wsName, varName, varName, len(var.values), len(var.fetchers), len(var.finders), var.mode)
	varListData += '''
</table>
<p>
<h5><a href="doit?op=listWss"> List netWorkSpaces </a></h5>
</body>
</html>
'''
	return varListData

    def showVar(self, request):
	wsName, varName = '<get wsName data missing>', '<get varName data missing>'
	try:
	    wsName, varName = request.args['wsName'][0], request.args['varName'][0]
	    vVals = self.spaces[self.extToInt[wsName]].bindings[varName].values
    	except KeyError: return '<html> Don\'t seem to have a %s in %s. </html>' % (varName, wsName)

        Translator(self.nwsServer, request, wsName, varName, vVals)
        return server.NOT_DONE_YET

    def fetchTryVar(self, request):
	wsName, varName = request.args['wsName'][0], request.args['varName'][0]
        self.nwsServer.openWs(self.dc, 'use ws', wsName, '', 'no')
	self.nwsServer.getVar(self.dc, 'fetchTry', wsName, varName)
	return self.showVar(request)

    def render_GET(self, request):
	return self.opTable.get(request.args.get('op', ['listWss'])[0], self.listWss)(request)

class NwsWeb(resource.Resource):
    def __init__(self, nwsServer):
	resource.Resource.__init__(self)

        self.dynamic = NwsWebDynamic(nwsServer)

        if os.path.isdir(nwsConfig.nwsWebServedDir):
            cc = static.File('clientCode')
            cc.contentTypes.update({
                '.m': 'text/plain', '.M': 'text/plain',
                '.py': 'text/plain', '.PY': 'text/plain',
                '.r': 'text/plain', '.R': 'text/plain'})
        else:
            cc = static.Data('<html><body>Cannot serve files from the directory "%s".</body></html>' % nwsConfig.nwsWebServedDir, 'text/html')
        self.putChild('clientCode', cc)
            
        
    def getChild(self, name, request):
        return self.dynamic
