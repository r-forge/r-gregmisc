fork <- function(slave)
  
  {
    if(missing(slave) || class(slave)!="function" && !is.null(slave) )
      stop("function for slave process to exectute must be provided.")

    pid  <- .C("Rfork_fork",pid=integer(1))$pid

    if(pid==0)
      {
        # the slave shouldn't get a list of the master's children (?)
        if(exists(".pidlist",envir=.GlobalEnv))
          remove(".pidlist",envir=.GlobalEnv)
        
        if(!is.null(slave))
          {
            on.exit( { cat("ERROR. Calling exit()..."); exit(); }  );
            slave();
            exit();
          }
      }
    else
      {
        # save all the pid's that get created just in case the user forgets
        # to keep track of them!
        if(!exists(".pidlist",envir=.GlobalEnv))
          assign(".pidlist",pid,envir=.GlobalEnv)
        else
          assign(".pidlist",c(.pidlist, pid),envir=.GlobalEnv)
      }

    return(pid)
  }
    

getpid <- function()
  {
    .C("Rfork_getpid", pid=integer(1))$pid
  }


kill <- function(pid, signal=15)
  {
    .C("Rfork_kill",
       as.integer(pid),
       as.integer(signal),
       flag=integer(1)
       )$flag
  }

killall <- function(signal)
  {
    if(!exists(".pidlist",envir=.GlobalEnv))
      warning("No processes to kill, ignored.")
    for(pid in .pidlist)
      kill(pid, signal)
  }


exit <- function(status=0)
  {
    .C("Rfork__exit", as.integer(status))
  }

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

