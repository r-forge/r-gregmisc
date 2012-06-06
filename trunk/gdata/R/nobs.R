# $Id$

## Now provided by 'stats' package, provide aliase here to satisfy
## dependencies
nobs <- stats::nobs

nobs.default <- function(object, ...)
  {
    if(is.vector(object))
      sum( !is.na(object) )
    else
      stats::nobs.default(object, ...)
  }
    

nobs.data.frame <- function(object, ...)
  sapply(object, nobs.default)

## Now provided by 'stats' package, provide 'alias' to satisfy
## dependencies
nobs.lm <- stats:::nobs.lm

