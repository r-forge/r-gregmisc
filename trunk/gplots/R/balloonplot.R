# $Id$
#
# $Log$
# Revision 1.2  2003/01/20 18:35:47  warnes
# - Updated balloonplot help page.
#
# Revision 1.1  2003/01/03 21:34:06  warnes
# - Initial checkin of balloonplot functions and documentation.
#
#

balloonplot <- function(x,...)
  UseMethod("balloonplot",x)



balloonplot.table <- function(x, xlab, ylab, zlab, ... )
  {
    obj <- x
    tmp <- as.data.frame(x)
    x <- tmp[,1]
    y <- tmp[,2]
    z <- tmp[,3]
    tableflag <- TRUE
      
    if(missing(xlab)) xlab <- names(dimnames(obj))[1] 
    if(missing(ylab)) ylab <- names(dimnames(obj))[2]
    if(missing(zlab)) zlab <- "Freq"

    balloonplot.default(x, y, z, xlab=xlab, ylab=ylab, zlab=zlab, ...)
  }



balloonplot.default <- function(x,y,z,
                                xlab=deparse(substitute(x)),
                                ylab=deparse(substitute(y)),
                                zlab=deparse(substitute(z)),
                                dotsize=2/max(strwidth(19),strheight(19)),
                                dotchar=19,
                                dotcolor="skyblue",
                                main,
                                label=TRUE,
                                label.digits=2,
                                scale.method=c("volume","diameter"),
                                ... )
{

  scale.method <- match.arg(scale.method)
  
  if(missing(main))
    {
      if(scale.method=="volume")
        main <- paste("Balloon Plot for ", xlab," by ", ylab,
                      ".\nArea is proportional to ", zlab, ".", sep='')
      else
        main <- paste("Balloon Plot for ", xlab," by ", ylab,
                      ".\nDiameter is proportional to ", zlab, ".", sep='')
      }
      

    
  x <- as.factor(x)
  y <- as.factor(y)
  z <- as.numeric(z)

  if( any(z < 0 ) )
    warning("z value(s) below zero detected. These will have zero size.")

  scale <- function(X, min=0, max=16, scale.method)
    {
      #X <- ( X -min(X) )
      if(scale.method=="volume")
        {
          X[X<0] <- 0
          X <- sqrt(X)
        }
      
      X <- min + (X/max(X, na.rm=T) * (max - min) )
      X
    }
  
  plot(x=as.numeric(x),
       y=as.numeric(y),
       cex=scale(z, max=dotsize, scale.method=scale.method),
       pch=dotchar, # plot character
       col=dotcolor, # dot color
       xlab=xlab,
       ylab=ylab,
       xaxt="n", # no x axis lables
       yaxt="n", # no y axis lables
       bty="n",  # no box around the plot
       xlim=c(0,nlevels(x)+0.5), # extra space on either end of plot
       ylim=c(0.5,nlevels(y)+1.5)  # so dots don't cross into margins
     )

  # add text labels
  text(x=1:nlevels(x), y=nlevels(y)+1, labels=levels(x))
  text(y=1:nlevels(y), x=0,            labels=levels(y) )
  
  # add borders between cells
  abline(v=(0:nlevels(x)+0.5))
  abline(h=(0:nlevels(y)+0.5))
  
  # annotate with actual values
  if(label)
    text(x=as.numeric(x),     # as.numeric give numeric values
         y=as.numeric(y), 
         labels=format(z, digits=label.digits),       # label value
         col="black", # textt color
         )
  
  # put a nice title
  title(main=main)
}

