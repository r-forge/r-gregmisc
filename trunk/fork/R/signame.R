
signame <- function(val)
  {
    retval <- .C("Rfork_signame",
                 val=as.integer(val),
                 name=character(1),
                 desc=character(1))
    unlist(retval)
  }

sigval <- function(name)
  {
    name <- toupper(name)
    if( length(grep("SIG",name))!=1 )
       name <- paste("SIG", name, sep="")
    retval <- .C("Rfork_siginfo",
                 name=name,
                 val=integer(1),
                 desc=character(1))
    unlist(retval)
  }
