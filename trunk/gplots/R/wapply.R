# $Id$
#
# $Log$
# Revision 1.2  2001/08/31 23:45:45  warneg
# Used wrong character in header (% instead of #).  Fixed.
#
# Revision 1.1  2001/08/25 05:48:54  warneg
# Initial checkin.
#
#
"wapply" _ function( x, y, fun=mean, method="range",
                    width=1/10, n=50, ...)
{
  method <- match.arg(method, c("width","range","nobs","fraction"))

  if(method == "width" || method == "range" )
    {
      if(method=="range")
        width <- width * range(x)
      
      
      pts _ seq(min(x),max(x),length.out=n)
      
      result _ sapply( pts, function(pts,y,width,fun,XX,...)
                      {
                        low _ min((pts-width/2),max(XX))
                        high _ max((pts+width/2), min(XX))
                        return (fun(y[(XX>= low) & (XX<=high)],...))
                      },
                      y=y,
                      width=width,
                      fun=fun,
                      XX = x,
                      ...)
      
      return(x=pts,y=result)
    }
  else # method=="nobs" || method=="fraction"
    {
      if( method=="fraction")
        width <- floor(length(x) * width)
      
      ord <- order(x)
      x  <- x[ord]
      y  <- y[ord]

      n  <- length(x)
      center  <- 1:n
      below <- sapply(center - width/2, function(XX) max(1,XX) )
      above <- sapply(center + width/2, function(XX) min(n,XX) )

      retval  <- list()
      retval$x  <- x
      retval$y  <- apply(cbind(below,above), 1,
                         function(x) fun(y[x[1]:x[2]],...) )
                         
      return(retval)
    }
      
}


