# Plot means with confidence intervals for groups defined by right
# side of formulae
#
# example:
#

# data  <-  data.frame(y=rnorm(100), x=factor(rep(c("A","C","F","Z"),25)))

# means.plot( y ~ x, data=data, connect=F )


plotmeans  <- function (formula, data = NULL, subset, na.action,
                         bars=T, p=0.95,
                         xlab=names(mf)[2], ylab=names(mf)[1],
                         mean.labels=F, ci.label=F, n.label=T,
                         digits=getOption("digits"), col="black",
                         barwidth=1,
                         barcol="blue",
                         connect=T,
                         ccol=col,
                         legends=names(means),
                         ...)
{
    if (missing(formula) || (length(formula) != 3)) 
        stop("formula missing or incorrect")
    if (missing(na.action)) 
        na.action <- getOption("na.action")
    m <- match.call(expand.dots = FALSE)
    if (is.matrix(eval(m$data, parent.frame()))) 
        m$data <- as.data.frame(data)
    m$... <- m$bars <- m$barcol <- m$p   <- NULL
    m$xlab <- m$ylab  <-  NULL
    m$col  <- m$barwidth  <- NULL
    m$digits  <- m$mean.labels  <- m$ci.label  <- m$n.label <- NULL
    m$connect  <- m$ccol  <-  m$legends <- m$labels<- NULL
    m[[1]] <- as.name("model.frame")
    mf <- eval(m, parent.frame())
    response <- attr(attr(mf, "terms"), "response")
    means  <-  sapply(split(mf[[response]], mf[[-response]]), mean, na.rm=T)
    xlim  <-  c(0.5, length(means)+0.5)
    
    if(!bars)
      {
        plot( means, ..., col=col, xlim=xlim)
      }
    else
      {
    vars <- sapply(split(mf[[response]], mf[[-response]]), var, na.rm=T)
    ns   <- sapply( sapply(split(mf[[response]], mf[[-response]]), na.omit,
                           simplify=F), length )
    ci.width  <- qnorm( (1+p)/2 ) * sqrt(vars/(ns-1) )
#    ci.lower  <- means - qnorm( (1+p)/2 ) * sqrt(vars/(ns-1) )    
#    ci.upper  <- means + qnorm( (1+p)/2 ) * sqrt(vars/(ns-1) )
#    error.bar( x=1:length(means), y=means, lower=ci.lower, upper=ci.upper,
#              incr=F, xaxt="n" )

    if(length(mean.labels)==1 && mean.labels==T)
      mean.labels  <-  format( round(means, digits=digits ))
    else if (mean.labels==F)
      mean.lable  <- NULL

    plotCI(x=1:length(means), y=means, uiw=ci.width, xaxt="n",
           xlab=xlab, ylab=ylab, labels=mean.labels, col=col, xlim=xlim,
           lwd=barwidth, barcol=barcol, ... )
    axis(1, at = 1:length(means), labels = legends)
    
    if(ci.label)
      {
        ci.lower <- means-ci.width
        ci.upper <- means+ci.width 
        labels.lower <- paste( " \n", format(round(ci.lower, digits=digits)),
                              sep="")
        labels.upper <- paste( format(round(ci.upper, digits=digits)), "\n ",
                              sep="")

        text(x=1:length(means),y=ci.lower, labels=labels.lower, col=col)
        text(x=1:length(means),y=ci.upper, labels=labels.upper, col=col)
      }
    
  }
    
    
    if(n.label)
      text(x=1:length(means),y=par("usr")[3],
           labels=paste("n=",ns,"\n",sep=""))
    
    if(connect!=F)
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

