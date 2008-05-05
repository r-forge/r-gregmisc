# $Id$

bandplot  <-  function(x,y,
                       ...,
                       add=FALSE,
                       sd=c(-2:2),
                       sd.col=c("lightblue","blue","red",
                                 "blue","lightblue"),
                       sd.lwd=c(2,2,3,2,2),
                       sd.lty=c(2,1,1,1,2),
                       method="frac", width=1/5,
                       use.runsd=TRUE,
                       n=50
                       )
  {

    if(length(sd.col)<length(sd)) sd <-rep(sd.col,length=length(sd))
    if(length(sd.lwd)<length(sd)) sd <-rep(sd.lwd,length=length(sd))
    if(length(sd.lty)<length(sd)) sd <-rep(sd.lty,length=length(sd))    
    if(!add)
      {
        m <- match.call(expand.dots = TRUE)
        m$width  <- m$add  <- m$sd  <- m$sd.col  <- NULL
        m$method <- m$n <- m$sd.lty <- m$sd.lwd  <- NULL
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

    sdplot <- function(S, COL, LWD, LTY)
                  {
                    if(use.runsd)
                      {
                        ord <- order(x)
                        myx <- x[ord]
                        myy <- y[ord]
                        sd <- runsd(myy, k=floor(length(x)*width))
                        where <- list()
                        where$x <- myx
                        where$y <- runmean(myy, k=floor(length(x)*width) ) + S * sd
                      }
                    else
                      where <- wapply(x,y,CL,sd=S,width=width,method=method,n=n)
                    lines(where,col=COL,lwd=LWD,lty=LTY,...)
                    where
                  }

    stdevs <- list()
    for( i in 1:length(sd) )
      stdevs[[as.character(sd[i])]] <- sdplot(
                                              sd[i],
                                              COL=sd.col[i],
                                              LWD=sd.lwd[i],
                                              LTY=sd.lty[i]
                                              )

    invisible( stdevs )
  }
