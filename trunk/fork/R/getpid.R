
getpid <- function()
  {
    .C("Rfork_getpid", pid=integer(1))$pid
  }

