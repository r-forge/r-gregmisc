# $Id$

quantcut <- function(x, q=c(0,1/4,2/4,3/4,4/4), na.rm=TRUE,
                     include.lowest=TRUE, ... )
  {
    quant <- quantile(x, q, na.rm=na.rm)
    cut( x, quant, include.lowest=include.lowest,  ... )
  }
