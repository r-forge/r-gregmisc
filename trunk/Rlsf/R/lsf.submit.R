# $Id$

"lsf.submit" <-
  function(funcname, savelist = ls(parent.frame()))
  {
    fname <- tempfile(pattern = ".LSFRdata", tmpdir = getwd())
    save(list = savelist, file = fname)

    script <- file.path(.path.package("Rlsf"), "RunLsfJob")
    scmd <- paste(script, fname, funcname)
    
    jobid <- .Call("lsf_job_submit", scmd)
    if (jobid)
      list(jobid=jobid,fname=fname)
    else 
      return(NULL)
  }
