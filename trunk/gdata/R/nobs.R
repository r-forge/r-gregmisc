#
# $Id$
#
# $Log$
# Revision 1.2  2002/03/26 14:28:02  warneg
# - Added CVS tags
#
#

nobs <- function(x,...)
  UseMethod("nobs",x)

nobs.default <- function(x) sum( !is.na(x) )

nobs.data.frame <- function(x)
  sapply(x, nobs.default)

nobs.lm <- function(x)
  nobs.default(x$residuals)
