
nobs <- function(x,...)
  UseMethod("nobs",x)

nobs.default <- function(x) sum( !is.na(x) )

nobs.data.frame <- function(x)
  sapply(x, nobs.default)

nobs.lm <- function(x)
  nobs.default(x$residuals)
