##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##


# We use alternating barriers to synchronize eachWorker
# invocations. Their names are common to workers and sleighs.
barrierNames <- list('barrier0', 'barrier1')

############################################################################
# Worker code.
#

# enquote and docall copied verbatim from snow
enquote <- function(x) as.call(list(as.name('quote'), x))

docall <- function(fun, args) {
  if ((is.character(fun) && length(fun) == 1) || is.name(fun))
    fun <- get(as.character(fun), env = .GlobalEnv, mode = 'function')
  do.call('fun', lapply(args, enquote))
}


openNwsWs <- function() {
  nwsHost <- Sys.getenv('RSleighNwsHost')
  nwsWsName <- Sys.getenv('RSleighNwsName')
  nwsPort <- as.integer(Sys.getenv('RSleighNwsPort'))

  # put these into global enironment so both worker loop and worker
  # code have access.
  SleighName <<- Sys.getenv('RSleighName')
  SleighNws <<- new('netWorkSpace', nwsWsName, nwsHost, nwsPort)  
  SleighRank <<- as.integer(Sys.getenv('RSleighRank'))

  if (SleighRank == -1) {
    # implies web start up --- perhaps should make explicit
    SleighRank <<- nwsFetch(SleighNws, 'rankCount')+1
    nwsStore(SleighNws, 'rankCount', SleighRank)
    # initialize for monitoring
    node = sprintf('%s@%d', SleighName, SleighRank)
    nwsDeclare(SleighNws, node, 'single')
    nwsStore(SleighNws, node, '0')
    nodeList = nwsFetch(SleighNws, 'nodeList')
    if (nodeList == '.') {
      nodeList = node
    }
    else {
      nodeList = paste(nodeList, node)
    }
    nwsStore(SleighNws, 'nodeList', nodeList)
  }
}


workerLoop <- function(wsName) {
  bx <- 1
  openNwsWs()

  # monitoring stuff here
  tasks <- 0
  nodename <- paste(SleighName, SleighRank, sep='@')

  # post some info about this worker.
  nwsStore(SleighNws, 'worker info', list(sysInfo=Sys.info(), pid=Sys.getpid()))

  repeat {
    # update the number of tasks executed
    nwsStore(SleighNws, nodename, as.character(tasks))

    t <- nwsFetch(SleighNws, 'task')
    #print(t) # use to generate an informal log.
    if (!is.list(t)) { break }

    # do something more interesting than return try error if this fails?
    value <- try(docall(t$data$fun, t$data$args))

    # to debug a bit, uncomment the following.
    #print(value)

    nwsStore(SleighNws, 'result', list(type = 'VALUE', value = value, tag = t$tag))

    tasks <- tasks + 1

    if (t$barrier) {
      nwsFind(SleighNws, barrierNames[[bx]])
      bx <- bx%%2 + 1
    }
  }
}


############################################################################
#  Sleigh code
#

sshcmd <- function(user, host)
  {
    sprintf("ssh -f -x -l %s %s", user, host)
  }

rshcmd <- function(user, host)
  {
    sprintf("rsh -l %s %s", user, host)
  }

lsfcmd <- function(user, host)
  {
    "bsub"
  }


sleigh <- function(...)
  {
    new("sleigh",...)
  }

####
# sleighPending class
#
# represents a sleigh eachWorker/eachElem invocation in progress.
setClass('sleighPending',
         representation(nws='netWorkSpace', numTasks='numeric',
                        barrierName='character', sleighState='list',
                        state='list'))
setMethod('initialize', 'sleighPending',
function(.Object, nws, numTasks, bn, ss) {
  .Object@nws = nws
  .Object@numTasks = numTasks
  .Object@barrierName = bn
  .Object@sleighState = ss
  .Object@state = list()
  .Object@state$done = FALSE;
  .Object
})



showSleighPending <- function(object)
  {
    cat('\n')
    cat('NWS Sleigh Pending Object\n')
    show(object@nws)

    cat('Tasks submitted:', object@numTasks,'\n',sep='')

    status <- checkSleigh(object)
    if(status==0)
      message <- 'Work completed.'
    else
      message <- paste(status, 'jobs still pending.')

    cat('Status:\t', message, '\n', sep='')
    cat('\n')
  }

setMethod('show', 'sleighPending', showSleighPending)



# return the number of results still outstanding.
setGeneric('checkSleigh', function(.Object) standardGeneric('checkSleigh'))
setMethod('checkSleigh', 'sleighPending',
function(.Object) {
  if (.Object@state$done) return (0) # could argue either way here... .

  tc <- textConnection(nwsListVars(.Object@nws))
  vl = scan(file=tc, what=list('', 1, 1, 1, ''), sep ='\t', quiet=TRUE)
  close(tc)

  for (x in 1:length(vl[[1]]))
    if ('result' == vl[[1]][x]) return (.Object@numTasks - vl[[2]][x])

  # didn't find the variable 'result' --- assume no results have yet
  # been generated.
  return (.Object@numTasks) 
})

# collect all results.
#
# note: a lot of code is duplicated here and in the non-blocking sections of
# eachWorker and eachElem. refactor?
setGeneric('waitSleigh', function(.Object) standardGeneric('waitSleigh'))
setMethod('waitSleigh', 'sleighPending', function(.Object) {
  if (.Object@state$done) {
    print('results already gathered.')
    return (NULL)
  }

  val <- vector('list', length(.Object@numTasks))
  for (i in 1:.Object@numTasks) {
    r = nwsFetch(.Object@nws, 'result')
    if (is.null(r)) {
      print('abnormal shutdown of sleigh workers???')
      return (NULL)
    }
    if (! is.null(r$value)) {
      val[[r$tag]] = r$value
    }
  }

  if (.Object@barrierName != '') {
    nwsStore(.Object@nws, .Object@barrierName, 1)
  }
  .Object@sleighState$occupied = FALSE
  .Object@state$done = TRUE
  val
})

####
# sleigh class
#
# represents a collection R processes running on a simple network of
# workstation pulling in tasks and generating results.

setClass('sleigh',
         representation(nodeList='character', nws='netWorkSpace',
                        nwsName='character', nwss='nwsServer',
                        options='list', state='list',
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

  cmd = paste(options$launch(options$user, machine), 'env', envVars, script, "\n")
  cat("Executing command: ", cmd )
  system(cmd)
}

initSleigh <- function(
                       .Object,
                       nodeList=c('localhost', 'localhost', 'localhost'),
                       master = Sys.info()['nodename'],
                       nwsWsName = 'sleigh_ride_%010d',
                       nwsHost = Sys.getenv("RSleighNwsPort"),
                       outfile = '/dev/null',
                       nwsPort = Sys.getenv("RSleighNwsPort"),
                       launch = sshcmd,
                       scriptDir = file.path(.path.package('nws'),'bin'),
                       user = Sys.info()['user']
                       )
{
  .Object@nodeList = nodeList
  .Object@workerCount = length(nodeList)

  if(is.null(nwsHost) || nchar(nwsHost)<1)
    nwsHost <- Sys.info()['nodename']

  if(is.null(nwsPort) || nchar(nwsPort)<1)
    nwsPort <- 8765
  
  opts <- list(
               call = match.call(), # so we now how this object
                                    # was created.
               master = master, 
               nwsWsName = nwsWsName,
               nwsHost = nwsHost,
               outfile = outfile,
               nwsPort = nwsPort,
               launch = launch,
               scriptDir = scriptDir,
               user = user
               )

  .Object@options <- opts

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

                                        # since we are calling it in the constructor, maybe this cannot be
                                        # a method?
      addWorker(.Object@nodeList[[i]], .Object@nwsName, i, opts)
    }
    nwsStore(.Object@nws, 'nodeList', paste(myList, collapse=' '))
  }
  else if (opts$launch == 'web') {
                                        # joiners will build this list on the fly.
    nwsStore(.Object@nws, 'nodeList', '.')
    nwsStore(.Object@nws, 'rankCount', 0)
    nwsStore(.Object@nws, 'runMe',
             sprintf("Sys.putenv('RSleighNwsHost'='%s', 'RSleighNwsPort'='%d', 'RSleighNwsName'='%s', 'RSleighRank'='-1', 'RSleighName'=Sys.info()['nodename']); workerLoop();", opts$nwsHost, opts$nwsPort, .Object@nwsName))
    try(nwsFetch(.Object@nws, 'deleteMeWhenAllWorkersStarted'))
    .Object@workerCount = nwsFind(.Object@nws, 'rankCount')
    
  }
  else stop('unknown launch protocol.')

  .Object@state = list()
  .Object@state$bx = 1
  .Object@state$occupied = FALSE
  .Object@state$totalTasks = 0

  { # define cleanup function
    nwss <- .Object@nwss
    nwsName <- .Object@nwsName
    finalizeSleigh <- function(...)
      {
        cat("Cleaning up Sleigh", nwsName, "\n")
        nwsDeleteWs(nwss, nwsName)
      }
  }

  # register finalizer for R system exit
  addLast( finalizeSleigh )

  .Object
}

setMethod('initialize', 'sleigh', initSleigh)

showSleigh <- function(object)
  {
    cat('\n')
    cat('NWS Sleigh Object\n')
    show(object@nws)
    cat(object@workerCount, ' Worker Nodes:\t',
        paste(object@nodeList, collapse=', '), '\n', sep='')
    cat('\n')
  }

setMethod('show', 'sleigh', showSleigh)

addLast <- function( fun )
  {
    if (!is.function(fun)) stop("`fun' must be a function")
    if(!exists(".Last", env=.GlobalEnv))
      assign(".Last", fun, env=.GlobalEnv)
    else
      {
        Last <- get(".Last", env=.GlobalEnv)
        newfun <- function(...)
          {
            fun()
            Last()
          }
        assign(".Last", newfun, env=.GlobalEnv)
      }
  }


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

storeTask <- function(nws, fun, args,
                      tag = 'anon', barrier = FALSE, return = TRUE) {
  nwsStore(nws,
           'task',
           list(type = 'EXEC',
                barrier = barrier,
                data = list(fun = fun, args = args, return = return),
                tag = tag))
}

# run fun once on each worker of the sleigh. pass in a val from the
# range 1:#Workers
setGeneric('eachWorker',
           function(.Object, fun, ..., eo=NULL) standardGeneric('eachWorker'))
setMethod('eachWorker', 'sleigh',
function(.Object, fun, ..., eo=NULL) {
  if (.Object@state$occupied) {
    print('wait your turn.')
    # should throw some kind of exception here.
    return (NULL)
  }

  fun <- fun # need to force the argument (NJC: why?)

  nws = .Object@nws
  wc = .Object@workerCount
  
  blocking = 1
  if (!is.null(eo)) {
    if (is.list(eo)) {
      blocking = eo$blocking;
      if (is.null(blocking)) blocking = 1
    }
    else {
      print("`arg' must be a list.")
      return(NULL)
    }
  }
  
  # use alternating barrier to sync eachWorker invocations with the workers.
  bx = .Object@state$bx
  bn = barrierNames[[bx]]
  .Object@state$bx = bx%%2 + 1

  nwsFetchTry(.Object@nws, bn)

  # update the total number of submitted tasks
  .Object@state$totalTasks <- .Object@state$totalTasks + wc
  nwsStore(.Object@nws, 'totalTasks', as.character(.Object@state$totalTasks))
  
  for (i in 1:wc) {
    storeTask(nws, fun, list(...), tag=i, barrier=TRUE)
  }

  if (!blocking) {
    .Object@state$occupied = TRUE
    return (new('sleighPending', nws, wc, bn, .Object@state))
  }

  val <- vector('list', length(wc))
  for (i in 1:wc) {
    r = nwsFetch(nws, 'result')
    if (is.null(r)) {
      print('abnormal shutdown of sleigh workers???')
      return (NULL)
    }
    if (! is.null(r$value)) {
      val[[r$tag]] = r$value
    }
  }

  nwsStore(.Object@nws, bn, 1)
  val
})

# run fun once for each element of a vector.
setGeneric('eachElem',
           function(.Object, fun, elementArgs=list(), fixedArgs=list(), eo=NULL) standardGeneric('eachElem'))
setMethod('eachElem', 'sleigh',
function(.Object, fun, elementArgs=list(), fixedArgs=list(), eo=NULL) {
  if (.Object@state$occupied) {
    print('wait your turn.')
    # should throw some kind of exception here.
    return (NULL)
  }

  fun <- fun # need to force the argument (NJC: why?)
  numTasks <- length(elementArgs[[1]])

  nws = .Object@nws
  wc = .Object@workerCount

  argPermute = NULL
  blocking = 1
  lf = 0
  if (!is.null(eo)) {
    if (is.list(eo)) {
      argPermute = eo$argPermute
      blocking = eo$blocking;
      if (is.null(blocking)) blocking = 1
      lf = eo$loadFactor;
      if (is.null(lf)) lf = 0
    }
    else {
      print("`arg' must be a list.")
      return(NULL)
    }
  }
  taskLimit = numTasks

  if (blocking && wc < numTasks && lf > 0) {
    taskLimit = eo$loadFactor * wc
    if (taskLimit < wc) {
      taskLimit = wc
    }
    else if (taskLimit > numTasks) {
      taskLimit = numTasks
    }
  }

  # check the extra args
  if (length(elementArgs)>1) { 
    for (ea in elementArgs[2:length(elementArgs)]) {
      if (length(ea) != numTasks) {
        print('all vector arguments must be the same length.')
        return(NULL)
      }
    }
  }

  # update the total number of submitted tasks
  .Object@state$totalTasks <- .Object@state$totalTasks + numTasks
  nwsStore(.Object@nws, 'totalTasks', as.character(.Object@state$totalTasks))

  # fill the pool
  for (i in 1:taskLimit) {
    args = c(lapply(elementArgs, '[[', i), fixedArgs)
    if (!is.null(argPermute)) { args = args[argPermute] }
    storeTask(nws, fun, args, tag=i, barrier=FALSE)
  }

  if (!blocking) {
    .Object@state$occupied = TRUE
    return (new('sleighPending', nws, numTasks, '', .Object@state))
  }

  val <- vector('list', numTasks)

  # submit one new task for every task completed
  if (taskLimit < numTasks) {
    for (i in (taskLimit+1):numTasks) {
      r = nwsFetch(nws, 'result')
      if (is.null(r)) {
        print('abnormal shutdown of sleigh workers???')
        return (NULL)
      }
      if (! is.null(r$value)) {
        val[[r$tag]] = r$value
      }
      args = c(lapply(elementArgs, '[[', i), fixedArgs)
      if (!is.null(argPermute)) { args = args[argPermute] }
      storeTask(nws, fun, args, tag=i, barrier=FALSE)
    }
  }

  # drain the pool
  for (i in (numTasks-taskLimit+1):numTasks) {
    r = nwsFetch(nws, 'result')
    if (is.null(r)) {
      print('abnormal shutdown of sleigh workers???')
      return (NULL)
    }
    if (! is.null(r$value)) {
      val[[r$tag]] = r$value
    }
  }

  val
})
