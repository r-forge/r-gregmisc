# $Id$

"lsf.submit" <-
  function(func, ..., savelist = c())
  # savelist is a character vector of *names* of objects to be
  # copied to the remote R session
  {
    fname <- tempfile(pattern = ".LSFRdata", tmpdir = getwd())

    lsf.call <- as.call(list(func, ...) )

    savelist <- c(savelist, "lsf.call")

    save(list=savelist, file=fname)

    script <- paste(
                    file.path(.path.package("Rlsf"),
                              "RunLsfJob"),
                    fname
                    )

    jobid <- .Call("lsf_job_submit", script)

    if (jobid)
      list(jobid=jobid,fname=fname)
    else 
      return(NULL)
  }


# remote side needs to do:
#    newenv <- environment()
#    load(file = fname, envir=newenv)
#    retval <- eval(lsf.call, env=newenv)
#    save(retval, file=fname)

