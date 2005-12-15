## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# $Id$

####
# sleighPending class
#
# represents a sleigh eachWorker/eachElem invocation in progress.
setClass('sleighPending',
         representation(nws='netWorkSpace', numTasks='numeric',
                        barrierName='character', sleighState='environment',
                        state='environment'))
setMethod('initialize', 'sleighPending',
function(.Object, nws, numTasks, bn, ss) {
  .Object@nws = nws
  .Object@numTasks = numTasks
  .Object@barrierName = bn
  .Object@sleighState = ss
  .Object@state = new.env()
  .Object@state$done = FALSE;
  .Object
})

setMethod('show', 'sleighPending', function(object) {
  cat('\n')
  cat('NWS Sleigh Pending Object\n')
  show(object@nws)

  cat('Tasks submitted:', object@numTasks, '\n', sep='')

  status <- checkSleigh(object)
  if (status == 0)
    message <- 'Work completed.'
  else
    message <- paste(status, 'jobs still pending.')

  cat('Status:\t', message, '\n', sep='')
  cat('\n')
})

# return the number of results still outstanding.
setGeneric('checkSleigh', function(.Object) standardGeneric('checkSleigh'))
setMethod('checkSleigh', 'sleighPending',
function(.Object) {
  if (.Object@state$done) return (0) # could argue either way here... .
  
  tc = textConnection(nwsListVars(.Object@nws))
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
  if (.Object@state$done) 
    stop('results already gathered.')

  val <- vector('list', length(.Object@numTasks))
  for (i in 1:.Object@numTasks) {
    r = nwsFetch(.Object@nws, 'result')
    if (is.null(r)) 
      stop('Abnormal shutdown of sleigh.')

    if (! is.null(r$value)) {
      val[[r$tag]] = r$value
    }
  }

  if (.Object@barrierName != '') {
    nwsStore(.Object@nws, .Object@barrierName, 1)
  }
  .Object@sleighState$occupied = FALSE
  .Object@state$done = TRUE

  # combine chunks
  unlist(val, recursive=FALSE)
})
