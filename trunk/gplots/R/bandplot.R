# $Id$
#
# $Log$
# Revision 1.2  2002/02/20 20:06:45  warneg
# - Generalized to allow specification of the multiples of the standard deviation levels to be plotted (0=mean, 1=1 sd, ..).
# - Now (invisibly) returnes computed smooths.
#
# Revision 1.1  2001/08/31 23:41:58  warneg
#
# Used wrong comment character (% instead of #) in header.  Fixed.
#
#

bandplot  <-  function(x,y,
                       ..., 
                       add=F,
                       sd=c(-2:2),
                       sd.col=c("lightblue","blue","red",
                                 "blue","lightblue"),
                       method="frac", width=1/5,
                       n=50
                       )
  {

    if(length(sd.col)<length(sd)) sd <-rep(sd.col,length=length(sd))
    
    if(!add)
      {
        m <- match.call(expand.dots = FALSE)
        m$width  <- m$add  <- m$sd  <- m$sd.col  <- NULL
        m$method <- m$n <- NULL
        m[[1]] <- as.name("plot")
        mf <- eval(m, parent.frame())
      }

    x  <- as.numeric(x)
    y  <- as.numeric(y)
    
    CL <- function(x,sd)
      if(length(x)<2)
        return( NA )
      else
        mean(x)+sd*sqrt(var(x))

    sdplot <- function(S, COL)
                  {
                    where <- wapply(x,y,CL,sd=S,width=width,method=method,n=n)
                    lines(where,col=COL,...)
                    where
                  }

    stdevs <- list()
    for( i in 1:length(sd) )
      stdevs[[as.character(sd[i])]] <- sdplot( sd[i], sd.col[i] )

    invisible( stdevs )
  }
