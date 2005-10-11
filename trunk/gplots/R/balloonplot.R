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


  if(is.list(x))
    {
      xlabs <- x
      x$sep=":"
      x <- do.call(paste, x)
    }
  else
    xlabs <- list(x)

  if(is.list(y))
    {
      ylabs <- y
      y$sep=":"
      y <- do.call(paste, y)
    }
  else
    ylabs <- list(y)

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

  nlabels.x <- length(ylabs)
  nlabels.y <- length(xlabs)
  
  plot(x=nlabels.x + as.numeric(x) - 1,
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
       xlim=c(0.5-rowmar,nlevels(x)+nlabels.x-0.5), # extra space on either
                                                    # end of plot for labels
       ylim=c(0.5,nlevels(y)+nlabels.y+0.5+colmar-1),# and so dots don't cross
                                                    # into margins,
       ...
     )

  ny <- nlevels(y)
  nx <- nlevels(x)
     
  sumz    <- sum(z)
  
  # add text labels
  par(adj=0.5)

       
  if(show.margins){
    stop("Broken.  Needs fixing.")
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
      rect(xleft   = 0.5-rowmar+rowmar*cy[ny:1],
           xright  = 0.5-rowmar+rowmar*cy[(ny+1):2],
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
  
  for(i in 1:length(xlabs))
    {
      text(x=i + (1:nx)+1,
           y=ny+(colmar/2)+0.5,
           labels=levels(factor(xlabs[[i]])),
           srt=colsrt
           )
    }

  for(i in 1:length(ylabs))
    {
      text(y=ny:1,
           x=i -rowmar/2-0.5,
           labels=levels(factor(ylabs[[i]])),
           srt=rowsrt)
    }
       
  # add borders between cells
  abline(v=(0:(nx+nlabels.x)+0.5))  # FIXME
  abline(h=(0:(ny+nlabels.y-1)+ 0.5)) # FIXME

  segments(x0 = c(0.5-rowmar, 0.5 ),
           x1 = c(0.5-rowmar, nx+nlabels.x - 0.5 ),
           y0 = c(ny+0.5    , ny+0.5+colmar ),
           y1 = c(0.5       , ny+colmar+nlabels.y - 0.5 ) )
  
  # annotate with actual values
  if(label){
    indiv <- if(show.zeroes) 
               1:length(y) 
             else 
               which(z != 0)
    text(x=as.numeric(x[indiv])+ nlabels.x - 1,     # as.numeric give numeric values
         y=ny - as.numeric(y[indiv]) + 1,
         labels=format(z[indiv], digits=label.digits),       # label value
         col="black", # textt color
         )
  }
  # put a nice title
  title(main=main)
}
