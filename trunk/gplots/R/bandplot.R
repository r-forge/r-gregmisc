# $Id$
#
# $Log$
# Revision 1.1  2001/08/31 23:41:58  warneg
# Used wrong comment character (% instead of #) in header.  Fixed.
#
#

bandplot  <-  function(x,y,width=diff(range(x))/3,...,add=F,
                      meancol="red",varcol="blue")
  {
    if(!add)
      {
        m <- match.call(expand.dots = FALSE)
        m$width  <- m$add  <- m$meancol  <- m$varcol  <- NULL
        m[[1]] <- as.name("plot")
        mf <- eval(m, parent.frame())
      }

    x  <- as.numeric(x)
    y  <- as.numeric(y)
    
    m <- wapply(x,y,mean,width=width)
    s <- wapply(x,y,function(x)sqrt(var(x)),width=width)$y
    lines(m,col=meancol,...)
    lines(m$x,m$y+s,col=varcol,...)
    lines(m$x,m$y-s,col=varcol,...)
  }
