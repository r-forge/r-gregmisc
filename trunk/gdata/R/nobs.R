# $Id$

## Now provided by 'stats' package
## nobs <- function(x,...)
##  UseMethod("nobs",x)

nobs.default <- function(object, ...) sum( !is.na(object) )

nobs.data.frame <- function(object, ...)
  sapply(object, nobs.default)

## Now provided by the 'stats' package
## nobs.lm <- function(x, ...)
##   nobs.default(x$residuals)
