## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# $Id$

# run fun once for each element of a vector.
setGeneric('eachElem',
           function(.Object, fun, elementArgs=list(),
                    fixedArgs=list(), by="row", chunkSize=1, DEBUG=FALSE, eo=NULL)
           standardGeneric('eachElem')
           )

setMethod('eachElem', 'sleigh',
          function(.Object, fun, elementArgs=list(),
                   fixedArgs=list(), by="row", chunkSize=1, DEBUG=FALSE, eo=NULL)
{

  if(DEBUG)
    browser()
  
  if (.Object@state$occupied)
    stop('sleigh already in use. wait your turn.')


  fun <- fun # need to force the argument (NJC: why?)
  numTasks <- countElement(elementArgs[[1]], by=by, chunkSize=chunkSize)

  nws = .Object@nws
  wc = .Object@workerCount

  blocking = 1
  lf = 0
  if (!is.null(eo)) {
    if (is.environment(eo) || is.list(eo)) {
      blocking = eo$blocking;
      if (is.null(blocking)) blocking = 1
      lf = eo$loadFactor;
      if (is.null(lf)) lf = 0
    }
    else 
      stop('options arg must be a list or environment.')
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
  if (length(elementArgs)>1)
    { 
      for (ea in elementArgs[2:length(elementArgs)])
        {
          if (countElement(ea, by=by, chunkSize=chunkSize) != numTasks) 
            stop('all elementArgs arguments must be the same length.')
        }
    }

  # update the total number of submitted tasks
  .Object@state$totalTasks <- .Object@state$totalTasks + numTasks
  nwsStore(.Object@nws, 'totalTasks', as.character(.Object@state$totalTasks))

  # fill the pool
  for (i in 1:taskLimit)
    {
      args <- list()
      args$fixedArgs <- fixedArgs
      args$varArgs <- lapply(elementArgs, getElement, i=i, by=by,
                                 chunkSize=chunkSize)
      storeTask(nws, fun, args, tag=i, barrier=NULL, by=by, chunkSize=chunkSize)
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
      if (is.null(r)) 
        stop('Abnormal shutdown of sleigh')
      if (! is.null(r$value)) {
        val[[r$tag]] = r$value
      }
      args = list()
      args$varArgs <- lapply(elementArgs, getElement, i=i, by=by,
                             chunkSize=chunkSize)
      args$fixedArgs <- fixedArgs
      storeTask(nws, fun, args, tag=i, barrier=NULL, by=by, chunkSize=chunkSize)
    }
  }

  # drain the pool
  for (i in (numTasks-taskLimit+1):numTasks) {
    r = nwsFetch(nws, 'result')
    if (is.null(r)) 
      stop('Abnormal shutdown of sleigh.')

    if (! is.null(r$value)) {
      val[[r$tag]] = r$value
    }
  }

  # combine chunks
  unlist(val, recursive=FALSE)
})
