# $Id$
#
# $Log$
# Revision 1.13  2003/11/10 22:11:13  warnes
# - Add files contributed by Arni Magnusson
#   <arnima@u.washington.edu>. As well as some of my own.
#
# Revision 1.12  2003/04/22 17:28:56  warnes
#
# - Fixeed warning messing caused when 'connect' is a vector.
#
# Revision 1.11  2002/09/24 14:53:56  warnes
#
# - Changed digits=options("digits") which produces a list of length 1
#   to digits=getOption("digits") which returns a vector of length one.
#   The former was causing an error when passed to round().
#
# Revision 1.10  2002/04/09 00:51:30  warneg
#
# Checkin for version 0.5.3
#
# Revision 1.9  2002/03/20 04:17:05  warneg
# - Changes to add compatibility with S-Plus 2000
#
# Revision 1.8  2002/03/05 16:44:24  warneg
# - Replace "TRUE" with "TRUE".  Problems arrive when there is a variable named "TRUE".
#
# Revision 1.7  2001/12/05 19:49:29  warneg
# - Added ability to use the t-distribution to compute confidence
#   intervals.  This is controlled using the 'use.t' parameter.
#
# Revision 1.6  2001/10/26 02:48:19  warneg
#
# Added correct handling of 'xaxt="n"'.
#
# Revision 1.5  2001/10/16 22:59:27  warneg
#
# Added cvs id and log tag to file header
#
#


# Plot means with confidence intervals for groups defined by right
# side of formulae
#
# example:
#
# data  <-  data.frame(y=rnorm(100), x=factor(rep(c("A","C","FALSE","Z"),25)))
# plotmeans( y ~ x, data=data, connect=FALSE )

plotmeans  <- function (formula, data = NULL, subset, na.action,
                         bars=TRUE, p=0.95,
                         minsd=0, minbar=NULL, maxbar=NULL,
                         xlab=names(mf)[2], ylab=names(mf)[1],
                         mean.labels=FALSE, ci.label=FALSE, n.label=TRUE,
                         digits=getOption("digits"), col="black",
                         barwidth=1,
                         barcol="blue",
                         connect=TRUE,
                         ccol=col,
                         legends=names(means),
                         xaxt,
                         use.t = TRUE,
                         ...)
{
  is.R <- get("is.R")
  if(is.null(is.R)) is.R <- function(x) FALSE

  if(!is.R())
    {
      if(col=="black")
        col <- 1
      if(barcol=="blue")
        barcol <- 2
    }
  
    if (missing(formula) || (length(formula) != 3)) 
        stop("formula missing or incorrect")
    if (missing(na.action)) 
        na.action <- options("na.action")
    m <- match.call(expand.dots = FALSE)
    if(is.R())
      {
        if (is.matrix(eval(m$data, parent.frame()))) 
          m$data <- as.data.frame(data)
      }
    else
      {
        if (is.matrix(eval(m$data, FALSE)))
          m$data <- as.data.frame(data)
      }
    m$... <- m$bars <- m$barcol <- m$p <- NULL
    m$minsd <- m$minbar <- m$maxbar <- NULL
    m$xlab <- m$ylab <-  NULL
    m$col  <- m$barwidth  <- NULL
    m$digits  <- m$mean.labels  <- m$ci.label  <- m$n.label <- NULL
    m$connect  <- m$ccol  <-  m$legends <- m$labels<- NULL
    m$xaxt <- m$use.t <- NULL
    m[[1]] <- as.name("model.frame")
    mf <- eval(m, parent.frame())
    response <- attr(attr(mf, "terms"), "response")
    means  <-  sapply(split(mf[[response]], mf[[-response]]), mean, na.rm=TRUE)
    xlim  <-  c(0.5, length(means)+0.5)
    
    if(!bars)
      {
        plot( means, ..., col=col, xlim=xlim)
      }
    else
      {

    myvar  <-  function(x) var(x[!is.na(x)])
        
    vars <- sapply(split(mf[[response]], mf[[-response]]), myvar)
    ns   <- sapply( sapply(split(mf[[response]], mf[[-response]]), na.omit,
                           simplify=FALSE), length )

    # apply minimum variance specified by minsd^2
    vars <- ifelse( vars < (minsd^2), (minsd^2), vars)

    if(use.t)
      ci.width  <- qt( (1+p)/2, ns-1 ) * sqrt(vars/ns)
    else
      ci.width  <- qnorm( (1+p)/2 ) * sqrt(vars/ns)

    if(length(mean.labels)==1 && mean.labels==TRUE)
      mean.labels  <-  format( round(means, digits=digits ))
    else if (mean.labels==FALSE)
      mean.lable  <- NULL

    plotCI(x=1:length(means), y=means, uiw=ci.width, xaxt="n",
           xlab=xlab, ylab=ylab, labels=mean.labels, col=col, xlim=xlim,
           lwd=barwidth, barcol=barcol, minbar=minbar, maxbar=maxbar, ... )
    if(missing(xaxt) || xaxt!="n")
      axis(1, at = 1:length(means), labels = legends)
    
    if(ci.label)
      {
        ci.lower <- means-ci.width
        ci.upper <- means+ci.width

        if(!missing(minbar))
          ci.lower <- ifelse(ci.lower < minbar, minbar, ci.lower)
        if(!missing(maxbar))
          ci.upper <- ifelse(ci.upper > maxbar, maxbar, ci.upper)
        
        labels.lower <- paste( " \n", format(round(ci.lower, digits=digits)),
                              sep="")
        labels.upper <- paste( format(round(ci.upper, digits=digits)), "\n ",
                              sep="")

        text(x=1:length(means),y=ci.lower, labels=labels.lower, col=col)
        text(x=1:length(means),y=ci.upper, labels=labels.upper, col=col)
      }
    
  }
    
    
    if(n.label)
      if(is.R())
        text(x=1:length(means),y=par("usr")[3],
             labels=paste("n=",ns,"\n",sep=""))
      else
        {
          axisadj <- (par("usr")[4] - (par("usr")[3]) )/75
          text(x=1:length(means),y=par("usr")[3] + axisadj,
               labels=paste("n=",ns,"\n",sep=""))
        }
    
    if(any(connect!=FALSE))
      {
        if(is.list(connect))
          {
            if(length(ccol)==1)
              ccol  <-  rep(ccol, length(connect) )
            
            for(which in 1:length(connect))
              lines(x=connect[[which]],y=means[connect[[which]]],col=ccol[which])
          }
        else  
          lines(means, ..., col=ccol)
      }
    

    
}

