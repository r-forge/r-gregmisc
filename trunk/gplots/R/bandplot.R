# $Id$

bandplot <- function(x, ...)
    UseMethod("bandplot")

bandplot.default  <-  function(x, y,
                       ...,
                       add=FALSE,
                       sd=c(-2:2),
                       sd.col=c("magenta","blue","red",
                                 "blue","magenta"),
                       sd.lwd=c(2,2,3,2,2),
                       sd.lty=c(2,1,1,1,2),
                       method="frac", width=1/5,
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

    ord <- order(x)
    myx <- x[ord]
    myy <- y[ord]
    sdVec <- runsd(myy, k=floor(length(x)*width))
    meanVec <- runmean(myy, k=floor(length(x)*width) )

    stdevs <- list()
    for( i in 1:length(sd) )
      {
          lines(myx,
                meanVec + sdVec * sd[i],
                col=sd.col[i],
                lwd=sd.lwd[i],
                lty=sd.lty[i]
                )

      }
    
  }


bandplot.formula <- function(x,
                             data=parent.frame(),
                             subset,
                             na.action,
                             xlab=NULL,
                             ylab=NULL,
                             ...,
                             add=FALSE,
                             sd=c(-2:2),
                             sd.col=c("magenta","blue","red",
                                      "blue","magenta"),
                             sd.lwd=c(2,2,3,2,2),
                             sd.lty=c(2,1,1,1,2),
                             method="frac", width=1/5,
                             n=50
                             )
    {
        if (missing(x) || (length(x) != 3))
            stop("x missing or incorrect")
        if (missing(na.action))
            na.action <- getOption("na.action")
        m <- match.call(expand.dots = FALSE)
        if (is.matrix(eval(m$data, parent.frame())))
            m$data <- as.data.frame(data)
        m$formula <- m$x
        m$...  <- m$x <- m$f <- m$iter <- m$delta <- NULL
        m$xlab <- m$ylab <- m$add  <- m$sd <- NULL
        m$sd.col <- m$sd.lwd <-  m$sd.lty <- NULL
        m$method <- m$width <- m$n <- NULL

        m[[1]] <- as.name("model.frame")
        mf <- eval(m, parent.frame())
        response <- attr(attr(mf, "terms"), "response")
        
        sx <- substitute(x)

        if (is.null(xlab)) {
            if (mode(x) != "name") 
                xlab <- deparse(sx[[3L]])
            else
                xlab <- "x" 
        }

        if (is.null(ylab)) {
            if (mode(x) != "name") 
                ylab <- deparse(sx[[2L]])
            else
                ylab <- "y" 
        }

        bandplot.default(x=mf[[-response]],
                 y=mf[[response]],
                 ...,
                 xlab=xlab,
                 ylab=ylab,
                 add=add,
                 sd=sd,
                 sd.col=sd.col,
                 sd.lwd=sd.lwd,
                 sd.lty=sd.lty,
                 method=method,
                 width=width,
                 n=n
                 )
    }
