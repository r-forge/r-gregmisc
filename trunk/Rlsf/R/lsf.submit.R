# $Id$

"lsf.submit" <-
  function(funcname, ..., savelist)
  {
    fname <- tempfile(pattern = ".LSFRdata", tmpdir = getwd())

    if(missing(savelist))
      savelist <- list()

    savelist$lsf.submit.call <- match.call()
    
    save(list = savelist, file = fname)

    script <- file.path(.path.package("Rlsf"), "RunLsfJob")

    args <- ""
    for (i in 1:length(arglist)) {
      args <- paste(args, arglist[i])
    }
    
    scmd <- paste(script, fname, funcname, args)
    
    jobid <- .Call("lsf_job_submit", scmd)
    if (jobid)
      list(jobid=jobid,fname=fname)
    else 
      return(NULL)
  }
