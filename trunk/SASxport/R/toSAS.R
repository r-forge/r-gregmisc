toSAS <- function(x, format)
  UseMethod("toSAS")

toSAS.numeric <- function(x, format="")
  {
    retval <- as.numeric(x)
    attr(retval, "format")=format
    retval
  }

toSAS.logical <- function(x, format="")
  {
    retval <- as.character(x)
    attr(retval, "format")=format
    retval
  }
  

toSAS.character <- function(x, format="")
  {
    retval <- as.character(x)
    attr(retval, "format")=format
    retval
  }

toSAS.factor <- function(x, format="")
  {
    retval <- as.character(x)
    attr(retval, "format")=format
    retval
  }

toSAS.POSIXt <- function( x, format="DATETIME16." )
  {
    sasBaseSeconds <- as.numeric(ISOdatetime(1960,1,1,0,0,0))
    retval <- unclass(as.POSIXct(x))  - sasBaseSeconds  # sasBaseSeconds is negative
    attr(retval,"format") <- format
    retval
  }

toSAS.Date <- function(x, format="DATE9." )
  {
    sasBase <- as.Date(strptime("01/01/1960", "%m/%d/%Y", tz="GMT")) # days
    retval <- as.numeric( as.Date(x) - sasBase)
    attr(retval, "format") <- format
    retval
  }

toSAS.default <- function(x, format="")
  {
    retval <- as.character(x)
    attr(retval, "format")=format
    retval
  }
    
