% $Id$
%
% $Log$
% Revision 1.1  2001/08/25 05:53:37  warneg
% Initial CVS checkin.
%
%
"running" _ function( X, fun=mean, width=min(length(X),20),
                     allow.fewer=FALSE,...)
{
  n _ length(X)

  from  <-  sapply( (1:n) - width + 1, function(x) max(x,1) )
  to    <-  1:n

  elements  <- apply(cbind(from,to), 1,function(x) seq(x[1], x[2]) )

  if(is.matrix(elements))
    elements  <- as.data.frame(elements)
  
  funct _ function(which,what,fun,...) fun(what[which],...)
  
  Xvar _ sapply(elements, funct, what=X, fun=fun, ...)
  names(Xvar) <- paste(from,to,sep=":")

  if(!allow.fewer)
    Xvar[1:(width-1)]  <- NA
  
  return(Xvar)
}
