## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# $Id$

# run fun once on each worker of the sleigh. pass in a val from the
# range 1:#Workers
setGeneric('eachWorker',
           function(.Object, fun, ..., eo=NULL, DEBUG=FALSE)
           standardGeneric('eachWorker'))
setMethod('eachWorker', 'sleigh',
function(.Object, fun, ..., eo=NULL, DEBUG=FALSE) {
  if (.Object@state$occupied) 
    stop('sleigh already in use. wait your turn.')

  if(DEBUG) browser()
  
  fun <- fun # need to force the argument (NJC: why?)

  nws = .Object@nws
  wc = .Object@workerCount
  
  blocking = 1
  if (!is.null(eo)) {
    if (is.environment(eo) || is.list(eo)) {
      blocking = eo$blocking;
      if (is.null(blocking)) blocking = 1
    }
    else 
      stop('options arg must be a list or environment.')
  }
  
  # use alternating barrier to sync eachWorker invocations with the workers.
  bx = .Object@state$bx
  bn = sprintf("barrier%d", bx)
  .Object@state$bx = bx%%2 + 1

  nwsFetchTry(.Object@nws, bn)

  # update the total number of submitted tasks
  .Object@state$totalTasks <- .Object@state$totalTasks + wc
  nwsStore(.Object@nws, 'totalTasks', as.character(.Object@state$totalTasks))
  
  for (i in 1:wc) {
    storeTask(nws, fun, list(fixedArgs=list(...)),
              tag=i, barrier=bn)
  }

  if (!blocking) {
    .Object@state$occupied = TRUE
    return (new('sleighPending', nws, wc, bn, .Object@state))
  }

  val <- vector('list', length(wc))
  for (i in 1:wc) {
    r = nwsFetch(nws, 'result')
    if (is.null(r))
      print('Abnormal shutdown of sleigh.')

    if (! is.null(r$value)) {
      val[[r$tag]] = r$value
    }
  }

  nwsStore(.Object@nws, bn, 1)
  val
})

