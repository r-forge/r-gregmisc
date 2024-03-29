# $Id$
#

"running" <- function(X, Y=NULL,
                      fun=mean,
                      width=min(length(X), 20),
                      allow.fewer=FALSE, pad=FALSE,
                      align=c("right", "center", "left"),
                      ...)
{
  align=match.arg(align)
  
  n <- length(X)

  if (align=="left")
    {
      from  <-  1:n 
      to    <-  pmin( (1:n)+width-1, n)
    }
  else if (align=="right")
    {
      from  <-  pmax( (1:n)-width+1, 1)
      to    <-  1:n 
    }
  else #align=="center"
    {
      from <-  pmax((2-width):n,1)
      to   <-  pmin(1:(n+width-1),n)
      if(!odd(width)) stop("width must be odd for center alignment")
      
    }

  elements  <- apply(cbind(from, to), 1, function(x) seq(x[1], x[2]) )

  if(is.matrix(elements))
    elements <- as.data.frame(elements) # ensure its a list!

  names(elements) <- paste(from,to,sep=':')

  if(!allow.fewer)
    {
      len <- sapply(elements, length)
      skip <- (len < width)
    }
  else
    {
      skip <- 0
    }
  

  run.elements  <- elements[!skip]
  
  if(is.null(Y))  # univariate 
    {
      funct <- function(which,what,fun,...) fun(what[which],...)
      
      Xvar <- sapply(run.elements, funct, what=X, fun=fun, ...)
    }
  else # bivariate
    {
      funct <- function(which,XX,YY,fun,...) fun(XX[which],YY[which], ...)
      
      Xvar <- sapply(run.elements, funct, XX=X, YY=Y, fun=fun, ...)
    }

  
  if(allow.fewer || !pad)
      return(Xvar)
    
  if(is.matrix(Xvar))
    {
      wholemat <- matrix( new(class(Xvar[1,1]), NA),
                         ncol=length(to), nrow=nrow(Xvar) )
      colnames(wholemat) <- paste(from,to,sep=':')
      wholemat[,-skip] <- Xvar
      Xvar <- wholemat
    }
  else
    {
      wholelist <- rep(new(class(Xvar[1]),NA),length(from))
      names(wholelist) <-  names(elements)
      wholelist[ names(Xvar) ] <- Xvar
      Xvar <- wholelist
    }
  
  return(Xvar)}

