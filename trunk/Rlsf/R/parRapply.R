# $Id$

lsf.parCapply <- function(x, ...)
  lsf.parRapply( t(x), ...)


lsf.parRapply <- function (x, fun, ...,
                           join.method=cbind,
                           njobs=floor(nrows(x)/50),
                           trace=TRUE,
                           packages=NULL,
                           savelist=NULL
                           )
  {
    require(snow)
    
    if(!is.matrix(x) && !is.data.frame(x))
      stop("x must be a matrix or data frame")

    if(njobs>1)
      rowSet <- splitRows(x, njobs)
    else
      rowSet <- list(x)
    
    if(trace) cat("Submitting ", njobs, "jobs...")
    jobs <- lapply( rowSet,
                    function(x) lsf.submit(apply,
                                           X=x, MARGIN=1, FUN=fun, ...,
                                           savelist=savelist,
                                           packages=packages)
                   )
    if(trace) cat("Done\n")
    done <- FALSE
    while(!done)
      {
        if(trace) cat("Waiting 5s for jobs to complete...")
        Sys.sleep(5)
        if(trace) cat("Done.\n")
        
        status <- sapply( jobs, lsf.job.status)

        if(trace) cat("Current status:\n")
        statusTable <- as.matrix(table(status))
        statusTable <- data.frame("N"=statusTable, "%"=formatC(statusTable/njobs,format="f", width=4, digits=2), check.names=F)
        if(trace) print(statusTable)
        done <- all(status %in% c("DONE","EXIT","ZOMBI","UNKWN") )
      }
    
    results <- lapply( jobs, lsf.get.result )

    retval <- docall(join.method, results)

    retval
  }
