# $Id$
#
# $Log$
# Revision 1.3  2002/03/07 23:38:37  warneg
# - Added "running2", which handles both univariate and bivariate cases
# - Modified "running" to call "running2"
#
# Revision 1.2  2001/09/01 00:01:54  warneg
# Release 0.3.0
#
# Revision 1.1  2001/08/25 05:53:37  warneg
# Initial CVS checkin.
#
#

"running" _ function( X, fun=mean, width=min(length(X),20),
                     allow.fewer=FALSE,...)
  running2(X=X, fun=mean, width=width, allow.fewer=allow.fewer, ...)

"running2" _ function( X, Y=NULL, fun=mean, width=min(length(X),20),
                     allow.fewer=FALSE,...)
{
  n _ length(X)

  from  <-  sapply( (1:n) - width + 1, function(x) max(x,1) )
  to    <-  1:n

  elements  <- apply(cbind(from,to), 1,function(x) seq(x[1], x[2]) )

  if(is.matrix(elements))
    elements  <- as.data.frame(elements)

  if(is.null(Y))  # univariate 
    {
      funct _ function(which,what,fun,...) fun(what[which],...)
      
      Xvar _ sapply(elements, funct, what=X, fun=fun, ...)
    }
  else # bivariate
    {
      funct _ function(which,XX,YY,fun,...) fun(XX[which],YY[which], ...)
      
      Xvar _ sapply(elements, funct, XX=X, YY=Y, fun=fun, ...)
    }

  
  names(Xvar) <- paste(from,to,sep=":")

  if(!allow.fewer)
    Xvar[1:(width-1)]  <- NA
  
  return(Xvar)
}
