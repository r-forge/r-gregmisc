# $Id$

fork <- function(slave)
  
  {
    if(missing(slave) || class(slave)!="function" && !is.null(slave) )
      stop("function for slave process to exectute must be provided.")

    pid  <- .C("Rfork_fork",pid=integer(1))$pid

    if(pid==0)
      {
        # the slave shouldn't get a list of the master's children (?)
        if(exists(".pidlist",where="package:fork"))
          remove(".pidlist",pos="package:fork")
        
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
        if(!exists(".pidlist",where="package:fork"))
          assign(".pidlist",pid,pos="package:fork")
        else
          assign(".pidlist",c(.pidlist, pid),pos="package:fork")
      }

    return(pid)
  }
    
