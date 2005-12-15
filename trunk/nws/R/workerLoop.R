## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# $Id$

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

workerLoop <- function(verbose=FALSE) {
  bx <- 1
  openNwsWs()


  ## set RNG seed to a pseudo-unique value
  ## FIXME: Use sprng instead!
  setRNGSeed <- function()
    {
      now <- as.numeric(Sys.time())
      seedval <- as.integer( (now * 2^SleighRank-1 )%% 2^31-1 )
      set.seed(seedval)
      seedval
    }

  setRNGSeed()

  
  # monitoring stuff here
  tasks <- 0
  nodename <- paste(SleighName, SleighRank, sep='@')

  # post some info about this worker.
  nwsStore(SleighNws, 'worker info', list(sysInfo=Sys.info(), pid=Sys.getpid()))

  repeat {
    # update the number of tasks executed
    nwsStore(SleighNws, nodename, as.character(tasks))

    t <- nwsFetch(SleighNws, 'task')

    if(verbose)
      {
        cat("Task:\n")
        print(t)
      }

    if (!is.list(t)) { break }

    ## unpack message
    varArgs=t$data$args$varArgs
    fixedArgs=t$data$args$fixedArgs
    by=t$by
    chunkSize=t$chunkSize
    fun=t$data$fun
    
    if(!is.null(varArgs) & length(varArgs)>0)
      {
        ## iterate over chuck contents, accumlating results
        value <- list()
        for(i in 1:countElement(varArgs[[1]], by=by, chunkSize=1))
          {
            innerVarArgs <- lapply(varArgs, getElement, i=i, by=by, chunkSize=1,
                                   drop=TRUE)
            value[[i]] <- try(docall(fun, c(innerVarArgs,fixedArgs)))
          }
      }
    else
      {
        value <- try(docall(fun, fixedArgs))
      }
    
    if(verbose)
      {
        cat("Value:\n")
        print(value)
      }

    nwsStore(SleighNws, 'result', list(type='VALUE', value=value, tag=t$tag))

    tasks <- tasks + 1

    if (!is.null(t$barrier)) {
      nwsFind(SleighNws, t$barrier)
    }
  }
}
