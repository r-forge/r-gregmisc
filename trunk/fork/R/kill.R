# $Id$

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
    if(!exists(".pidlist",pos="package:fork"))
      warning("No processes to kill, ignored.")
    for(pid in get(".pidlist",pos="package:fork"))
      kill(pid, signal)
    invisible()
  }

