# $Id$

"lsf.get.result" <-
  function(job)
  {
    if (lsf.job.status(job) != "DONE")
      return(NULL)
    if (!file.exists(job$fname))
      return(NULL)
    load(job$fname)
    file.remove(job$fname)
    get("lsf.ret")
  }
