# $Id$

wait <- function(pid, continued=FALSE, nohang=FALSE,
                      nowait=FALSE, untraced=FALSE)
{
  if(missing(pid) || is.null(pid)) 
    retval <-   .C("Rfork_wait", pid=integer(1), status=integer(1) )
  else
    retval <- .C("Rfork_waitpid",
                 pid = as.integer(pid),
                 as.integer(continued),
                 as.integer(nohang),
                 as.integer(nowait),
                 as.integer(untraced),
                 status=integer(1) )

  return(c("pid"=retval$pid,
           "status"=retval$status))
}

