### object.size.R
###------------------------------------------------------------------------
### What: Print object size in human readable format - code
### $Id$
### Time-stamp: <2008-12-30 08:05:43 ggorjan>
###------------------------------------------------------------------------
object.size <- function(...) 
{
  structure(sapply(list(...),
                   utils::object.size),
                   class=c("object_sizes", "numeric"))
}

print.object_sizes <- function(x, quote=FALSE, units,
                                  humanReadable, ...)
{  
  xOrig <- x
  if(missing(humanReadable)) {
    opt <- getOption("humanReadable")
    humanReadable <- ifelse(!is.null(opt), opt, FALSE)
  }
  if(humanReadable) {
    print(humanReadable(x), quote=quote, ...)
  } else {
    class(x) <- "numeric"
    NextMethod()
  }
  invisible(xOrig)
}

is.object_sizes <- function(x) inherits(x, what="object_sizes")
   
as.object_sizes <- function(x)
{
  if(!is.numeric(x)) stop("'x' must be numeric/integer")
  class(x) <- c("object_sizes", "numeric")
  x
}

c.object_sizes <- function(..., recursive=FALSE)
{
  x <- NextMethod()
  if(is.numeric(x)) class(x) <- c("object_sizes", "numeric")
  x
}

humanReadable <- function(x, standard="SI", units, digits=1, width=3, sep=" ")
{
  ## --- Setup ---

  suffix.decimal <- c("B", "kB",  "MB",  "GB",  "TB",  "PB",  "EB",  "ZB",  "YB")
  suffix.binary  <- c("B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB")
    
  ## --- Functions ---

  .applyHuman <- function(x, base, suffix, digits, width, sep)
  {
    ## Which suffix should we use?
    n <- length(suffix)
    for(i in 1:n) {
      if(x >= base) {
        if(i < n) x <- x / base
      } else {
        break
      }
    }
    ## Formatting
    if(is.null(width)) { ## the same formatting for all
      x <- format(round(x=x, digits=digits), nsmall=digits)
    } else {             ## similar to ls, du, and df
      lenX <- nchar(x)
      if(lenX > width) {
        digitsMy <- width - (lenX - (lenX - (nchar(round(x)) + 1)))
        digits <- ifelse(digitsMy > digits, digits, digitsMy)
      }
      if(i == 1) digits <- 0
      x <- round(x, digits=digits)
    }
    paste(x, suffix[i], sep=sep)
  }

  ## -- Work
  
  if(any(x < 0)) stop("'x' must be positive")
  if(standard == "SI") {
    suffix <- suffix.decimal
    base <- 10^3
  } else {
    suffix <- suffix.binary
    base <- 2^10
  }

  if(!missing(units))
      {
          units <- match.arg( units, suffix )
          power <- which( units %in% suffix ) -1
          X <- x/(base^power)
          X <- format.default(round(x=x, digits=digits), nsmall=digits)
          X <- paste(X, units)
          X
      }
  else
      sapply(X=x, FUN=".applyHuman", base=base, suffix=suffix, digits=digits,
             width=width, sep=sep)
}


###------------------------------------------------------------------------
### object.size.R ends here
