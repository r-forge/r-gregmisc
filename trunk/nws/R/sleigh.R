## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# $Id$

############################################################################
#  Sleigh code
#

sleigh <- function(...) {
  new("sleigh",...)
}

####
# sleigh class
#
# represents a collection R processes running on a simple network of
# workstation pulling in tasks and generating results.

setClass('sleigh',
         representation(nodeList='character', nws='netWorkSpace',
                        nwsName='character', nwss='nwsServer',
                        options='environment', state='environment',
                        workerCount='numeric'))

# could this be a method --- it is invoked in the constructor?
addWorker <- function(machine, wsName, rank, options) {
  # basic idea is (or should be): if we can get the appropriate
  # RNWSleighWorker.sh script running on the remote node, we just need to
  # give it enough env info to take care of the rest
  script = file.path(options$scriptDir, 'RNWSSleighWorker.sh')

  envVars = paste(
    ' RSleighScriptDir=', options$scriptDir,
    ' RSleighNwsHost=', options$nwsHost,
    ' RSleighNwsName=', wsName,
    ' RSleighNwsPort=', options$nwsPort,
    ' RSleighRank=', rank,
    ' RSleighWorkerOut=', options$outfile,
    ' RSleighName=', machine,
    sep='')

  cmd = paste(options$launch(options$user, machine, options), 'env', envVars, script, "\n")
  cat("Executing command: ", cmd )
  system(cmd)
}

setMethod('initialize', 'sleigh',
function(.Object, nodeList=c('localhost', 'localhost', 'localhost'), ...) {
  .Object@nodeList = nodeList
  .Object@workerCount = length(nodeList)

  # compute default value for scriptDir
  nwsDir = .path.package('nws', quiet=TRUE)
  if (is.null(nwsDir)) {
    scriptDir = getwd()
  }
  else {
    scriptDir = file.path(nwsDir, 'bin')
  }

  # compute default value for nwsHost
  nwsHost = Sys.getenv('RSleighNwsHost')
  if (is.null(nwsHost) || (nchar(nwsHost) < 1))
    nwsHost = Sys.info()['nodename']

  # compute default value for nwsPort
  nwsPort = as.integer(Sys.getenv('RSleighNwsPort'))
  if (is.null(nwsPort) || (nchar(nwsPort) < 1))
    nwsPort = 8765

  defaultSleighOptions <-
    list(
         master =  Sys.info()['nodename'],
         nwsWsName = 'sleigh_ride_%010d',
         nwsHost = nwsHost,
         outfile = '/dev/null',
         nwsPort = nwsPort,
         launch = sshcmd,
         scriptDir = scriptDir,
         user = Sys.info()['user'],
         )

  .Object@options = new.env()
  blendOptions(.Object@options, defaultSleighOptions)
  blendOptions(.Object@options, list(...))
  opts = .Object@options

   # set up the sleigh's netWorkSpace.
  .Object@nwss = new('nwsServer', serverHost=opts$nwsHost, port=opts$nwsPort)
  .Object@nwsName = nwsMktempWs(.Object@nwss, opts$nwsWsName)
  .Object@nws = nwsOpenWs(.Object@nwss, .Object@nwsName)

  # initialize for monitoring
  nwsDeclare(.Object@nws, 'nodeList', 'single')
  nwsDeclare(.Object@nws, 'totalTasks', 'single')
  nwsStore(.Object@nws, 'totalTasks', '0')

  if (is.function(opts$launch)) {
    myList = c()
    for (i in 1:.Object@workerCount) {
      node = paste(nodeList[i], i, sep='@')
      myList[i] = node
      nwsDeclare(.Object@nws, node, 'single')
      nwsStore(.Object@nws, node, '0')
      opts$outfile = sprintf('%s_%04d', .Object@nwsName, i)

      ## since we are calling it in the constructor, maybe this cannot be
      ## a method?
      addWorker(.Object@nodeList[[i]], .Object@nwsName, i, opts)
    }
    nwsStore(.Object@nws, 'nodeList', paste(myList, collapse=' '))
  }
  else if (opts$launch == 'web') {
    ## joiners will build this list on the fly.
    nwsStore(.Object@nws, 'nodeList', '.')
    nwsStore(.Object@nws, 'rankCount', 0)
    nwsStore(.Object@nws, 'runMe',
             sprintf("Sys.putenv('RSleighNwsHost'='%s', 'RSleighNwsPort'='%d', 'RSleighNwsName'='%s', 'RSleighRank'='-1', 'RSleighName'=Sys.info()['nodename']); workerLoop();", opts$nwsHost, opts$nwsPort, .Object@nwsName))
    try(nwsFetch(.Object@nws, 'deleteMeWhenAllWorkersStarted'))
    .Object@workerCount = nwsFind(.Object@nws, 'rankCount')
    
  }
  else stop('unknown launch protocol.')

  .Object@state = new.env()
  .Object@state$bx = 1
  .Object@state$occupied = FALSE
  .Object@state$totalTasks = 0

  .Object
})

setMethod('show', 'sleigh', function(object) {
  cat('\n')
  cat('NWS Sleigh Object\n')
  show(object@nws)
  cat(object@workerCount, ' Worker Nodes:\t',
      paste(object@nodeList, collapse=', '), '\n', sep='')
  cat('\n')
})

if (! isGeneric('close'))
  setGeneric('close', function(con, ...) standardGeneric('close'))
setMethod('close', 'sleigh', function(con, ...) stopSleigh(con))

setGeneric('stopSleigh', function(.Object) standardGeneric('stopSleigh'))
setMethod('stopSleigh', 'sleigh', function(.Object) {
  nwsStore(.Object@nws, 'Sleigh ride over', 1)
  Sys.sleep(3)
  exitCount = 0
  while (nwsFetchTry(.Object@nws, 'bye', FALSE)) {
    exitCount = exitCount + 1
  }
  if (exitCount != .Object@workerCount) {
    cat(sprintf('Only %d of %d have exited.\n', exitCount, .Object@workerCount))
  }
  nwsDeleteWs(.Object@nwss, .Object@nwsName)
})

