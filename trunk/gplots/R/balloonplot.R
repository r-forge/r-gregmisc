# $Id$

balloonplot <- function(x,...)
  UseMethod("balloonplot",x)



balloonplot.table <- function(x, xlab, ylab, zlab, show.zeroes = FALSE, 
                              show.margins = TRUE, ... )
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

    balloonplot.default(x, y, z, xlab=xlab, ylab=ylab, zlab=zlab, 
                        show.zeroes = show.zeroes, 
                        show.margins = show.margins, ...)
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
                                colsrt=par("srt"),
                                rowsrt=par("srt"),
                                colmar=1,
                                rowmar=1,
                                show.zeroes=FALSE,
                                show.margins=FALSE,
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

      X <- min + (X/max(X, na.rm=TRUE) * (max - min) )
      X
    }

  plot(x=as.numeric(x),
       y=nlevels(y) - as.numeric(y) + 1,
       cex=scale(z, max=dotsize, scale.method=scale.method),
       pch=dotchar, # plot character
       col=dotcolor, # dot color
       xlab=xlab,
       ylab=ylab,
       xaxt="n", # no x axis lables
       yaxt="n", # no y axis lables
       bty="n",  # no box around the plot
       xaxs = "i",
       yaxs = "i",
       xlim=c(0.5-rowmar,nlevels(x)+0.5), # extra space on either end of plot
       ylim=c(0.5,nlevels(y)+1.5+colmar-1),  # so dots don't cross into margins,
       ...
     )

  ny <- nlevels(y)
  nx <- nlevels(x)
     
  sumz    <- sum(z)
  
  # add text labels
  par(adj=0.5)

       
  if(show.margins){
      ztab = z
      dim(ztab) <- c(nx,ny)
      rowsumz <- rowSums(ztab)
      colsumz <- colSums(ztab)
  
      cx <- c(0, cumsum(rowsumz) / sumz)
      rect(xleft   = 1:nx-0.5,
           xright  = 1:nx+0.5,
           ybottom = ny+0.5+cx[1:nx]*colmar,
           ytop    = ny+0.5+cx[2:(nx+1)]*colmar,
           col     = "gray",
           border  = NA)

      cy <- c(0, cumsum(colsumz) / sumz)
      rect(xleft   = 0.5-rowmar+rowmar*cy[1:ny],
           xright  = 0.5-rowmar+rowmar*cy[2:(ny+1)],
           ybottom = 1:ny-0.5,
           ytop    = 1:ny+0.5,
           col     = "gray",
           border  = NA)
           
  
     tx <- paste(levels(x),"\n[",rowsumz,"]")
     ty <- paste(levels(y),"\n[",colsumz,"]")
  }
  else{
     tx <- levels(x)
     ty <- levels(y)
  }
  
  
  text(x=1:nx,
       y=ny+(colmar/2)+0.5,
       labels=tx,
       srt=colsrt)

  text(y=ny:1,
       x=-rowmar/2+0.5,
       labels=ty,
       srt=rowsrt)
       
  # add borders between cells
  abline(v=(0:nx+0.5))
  abline(h=(0:ny+0.5))

  segments(x0 = c(0.5-rowmar, 0.5 ),
           x1 = c(0.5-rowmar, nx+0.5 ),
           y0 = c(ny+0.5    , ny+0.5+colmar ),
           y1 = c(0.5       , ny+0.5+colmar ) )
  
  # annotate with actual values
  if(label){
    indiv <- if(show.zeroes) 
               1:length(y) 
             else 
               which(z != 0)
    text(x=as.numeric(x[indiv]),     # as.numeric give numeric values
         y=ny - as.numeric(y[indiv]) + 1,
         labels=format(z[indiv], digits=label.digits),       # label value
         col="black", # textt color
         )
  }
  # put a nice title
  title(main=main)
}

