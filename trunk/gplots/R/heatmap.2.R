# $Id$


###
# Utility Functions
###

# Scale data to [0,1]
foldchange.scale01 <- function(x, low=min(x), high=max(x) )
  {
    x <- sign(x)*(abs(x) - 1)
    x <- (x-low)/(high - low)
    x
  }

scale01 <- function(x, low=min(x), high=max(x) )
  {
    x <- (x-low)/(high - low)
    x
  }

# detect odd/even integers
odd <- function(x) x!=as.integer(x/2)*2
even <- function(x) x==as.integer(x/2)*2 

colorpanel <- function(n,low,mid,high)
  {
    if(even(n)) warning("n is even: colors panel will not be symmetric")

    # convert to rgb
    low <- col2rgb(low)
    mid <- col2rgb(mid)
    high <- col2rgb(high)

    # determine length of each component
    lower <- floor(n/2)
    upper <- n - lower
    
    red  <- c(
              seq(low[1,1], mid [1,1], length=lower),
              seq(mid[1,1], high[1,1], length=upper)
              )/255

    green <- c(
               seq(low[3,1], mid [3,1], length=lower),
               seq(mid[3,1], high[3,1], length=upper)
               )/255

    blue <- c(
              seq(low[2,1], mid [2,1], length=lower),
              seq(mid[2,1], high[2,1], length=upper)
              )/255

             
    rgb(red,blue,green)
  }



# Generate red-to-green colorscale
redgreen <- function(n) colorpanel(n, 'red', 'black', 'green')
greenred <- function(n) colorpanel(n, 'green', 'black', 'red' )
bluered  <- function(n) colorpanel(n, 'blue','white','red')
redblue  <- function(n) colorpanel(n, 'red','white','blue')

# Compute foldchange from log-ratio values
logratio2foldchange <- function(logratio, base=2)
  {
    retval <- base^(logratio)
    retval <- ifelse(retval < 1, -1/retval, retval)
    retval
  }

foldchange2logratio <- function(foldchange, base=2)
  {
    retval <- ifelse( foldchange<0, 1/-foldchange, foldchange)
    retval <- log(retval,base)
    retval
  }






###
# Enhanced heatmap function
###
heatmap.2 <- function (x,
                       Rowv,
                       Colv,
                       distfun = dist,
                       hclustfun = hclust, 
                       add.expr,
                       scale = c("row", "column", "none"),
                       na.rm = TRUE,
                       col=redgreen(255),
                       dendogram = c("both","row","column","none"),
                       rowlabel.space = 5,
                       collabel.space = 5,
                       legend.show = TRUE,
                       trace=c("none","column","row","both"),
                       breaks,
                       density.info=c("histogram","density","none"),
                       colsep,
                       rowsep,
                       cellnote,
                       notecex=0.75,
                       scale01=foldchange.scale01,
                       hline,
                       vline,
                       min.scale=min(breaks),
                       max.scale=max(breaks),
                       ...
                       ) 
{

    scale <- match.arg(scale)
    dendogram <- match.arg(dendogram)
    trace <- match.arg(trace)
    density.info <- match.arg(density.info)
    
    
    if (length(di <- dim(x)) != 2 || !is.numeric(x)) 
        stop("`x' must be a numeric matrix")
    nr <- di[1]
    nc <- di[2]
    if (nr <= 1 || nc <= 1) 
        stop("`x' must have at least 2 rows and 2 columns")
    r.cex <- 0.2 + 1/log10(nr)
    c.cex <- 0.2 + 1/log10(nc)
    if (missing(Rowv)) 
        Rowv <- rowMeans(x, na.rm = na.rm)
    if (missing(Colv)) 
        Colv <- colMeans(x, na.rm = na.rm)


    if( dendogram %in% c("both","row") )
      {
        if (!inherits(Rowv, "dendrogram")) {
          hcr <- hclustfun(distfun(x))
          ddr <- as.dendrogram(hcr)
          ddr <- reorder(ddr, Rowv)
        }
        else ddr <- Rowv
        rowInd <- order.dendrogram(ddr)
      }
    else
      {
        rowInd <- order(Rowv)
      }
    
    if( dendogram %in% c("both","column") )
      {
        if (!inherits(Colv, "dendrogram")) {
          hcc <- hclustfun(distfun(t(x)))
          ddc <- as.dendrogram(hcc)
          ddc <- reorder(ddc, Colv)
        }
        else ddc <- Colv
        colInd <- order.dendrogram(ddc)
      }
    else
      {
        colInd <- order(Colv)
      }
    
    x <- x[rowInd, colInd]
    if (scale == "row") {
        x <- sweep(x, 1, rowMeans(x, na.rm = na.rm))
        sd <- apply(x, 1, sd, na.rm = na.rm)
        x <- sweep(x, 1, sd, "/")
    }
    else if (scale == "column") {
        x <- sweep(x, 2, colMeans(x, na.rm = na.rm))
        sd <- apply(x, 2, sd, na.rm = na.rm)
        x <- sweep(x, 2, sd, "/")
    }
    op <- par(no.readonly = TRUE)
    on.exit(par(op))
    layout(matrix(c(4, 3, 2, 1), 2, 2, byrow = TRUE), widths = c(1, 
        4), heights = c(1, 4), respect = TRUE)
    par(mar = c(collabel.space, 0, 0, rowlabel.space))
    if(missing(breaks))
      breaks <- seq( min(x), max(x), length=length(col)+1 )

    min.breaks <- min(breaks)
    max.breaks <- max(breaks)
    
    # force data into range given by breaks
    x[] <- ifelse(x<min.breaks, min.breaks, x)
    x[] <- ifelse(x>max.breaks, max.breaks, x)

    
    image(1:ncol(x), 1:nrow(x), t(x), axes = FALSE, xlim = c(0.5, 
        ncol(x) + 0.5), ylim = c(0.5, nrow(x) + 0.5), xlab = "", 
        ylab = "", col=col, breaks=breaks,
          ...)

    if(!missing(colsep))
      rect(xleft=colsep+0.5,   ybottom=rep(0,length(colsep)),
           xright=colsep+0.55, ytop=rep(nrow(x)+1,colsep),
           lty=1, lwd=1, col="white", border="white")

    if(!missing(rowsep))
      rect(xleft=0,          ybottom=nrow(x)+1-rowsep-0.5,
           xright=ncol(x)+1, ytop=nrow(x)+1-rowsep-0.55,
           lty=1, lwd=1, col="white", border="white")

    if(!missing(cellnote))
      text(x=c(col(cellnote)),
           y=nrow(cellnote)+1-c(row(cellnote)), labels=c(cellnote),
           col="yellow", cex=notecex)
    
    # show traces
    x.scaled <- scale01(x, min.scale, max.scale)

    if(trace %in% c("both","column") )
      {
        for( i in colInd )
          {
            if(!missing(vline))
              {
                vline.vals <- scale01(vline, min.scale, max.scale)
                abline(v=i-0.5 + vline.vals, col='black', lty=2)
              }
            xv <- rep(i, nrow(x.scaled)) + x.scaled[,i] - 0.5
            xv <- c(xv[1], xv)
            yv <- 1:length(xv)-0.5
            lines(x=xv, y=yv, lwd=1, col='yellow', type="s")
          }
      }

    if(trace %in% c("both","row") )
      {
        for( i in rowInd )
          {
            if(!missing(hline))
              {
                hline.vals <- scale01(hline, min.scale, max.scale)
                #abline(v=i-0.5 + vline, col='black', lty=2)
                # FIXME
              }
            yv <- rep(i, ncol(x.scaled)) + x.scaled[i,] - 0.5
            yv <- rev(c(yv[1], yv))
            xv <- length(yv):1-0.5
            lines(x=xv, y=yv, lwd=1, col='yellow', type="s")
          }
      }

    # add axes
    if (is.null(colnames(x))) {
      axis(1, 1:ncol(x), las = 2, line = -0.5, tick = 0,
           labels = (1:ncol(x))[colInd])
    } else {
      axis(1, 1:ncol(x), las = 2, line = -0.5, tick = 0,
           colnames(x), cex.axis = c.cex)
    }
    
    if (is.null(rownames(x))) {
      axis(4, 1:nrow(x), las = 2, line = -0.5, tick = 0,
           labels = (1:nrow(x))[rowInd])
    } else {
      axis(4, 1:nrow(x), las = 2, line = -0.5, tick = 0,
           rownames(x), cex.axis = r.cex)
    }
    
    if (!missing(add.expr)) 
        eval(substitute(add.expr))

    par(mar = c(collabel.space, 3, 0, 0))

    if( dendogram %in% c("both","row") )
      plot(ddr, horiz = TRUE, axes = FALSE, yaxs = "i", leaflab = "none")
    else
      plot.new()
    
    par(mar = c(0, 0, 5, rowlabel.space ) )

    if( dendogram %in% c("both","column") )
      plot(ddc, axes = FALSE, xaxs = "i", leaflab = "none")
    else
      plot.new()

    par(mar = c(3, 2, 5, 1))
    
    if(legend.show)
      {
        z <- breaks[-1]#seq(min(breaks),max(breaks),length=100)
        image(z=matrix(z, ncol=1),
              col=col, breaks=breaks,
              xaxt="n", yaxt="n" )

        par(usr=c(0,1,0,1))
        lv <- pretty(seq(min.scale,max.scale,length=5))
        xv <- scale01(as.numeric(lv), min.scale, max.scale)
        axis(1, at=xv, labels=lv)

        if(density.info=="density")
          {
            # Experimental : also plot density of data
            dens <- density(x, adjust=0.25)
            omit <- dens$x < min(breaks) | dens$x > min(breaks)
            dens$x <- dens$x[-omit]
            dens$y <- dens$y[-omit]
            dens$x <- scale01(dens$x)
            dens$y <- dens$y / max(dens$y) * 0.95
            lines(dens$x, dens$y, col="yellow", lwd=1)
          }
        else if(density.info=="histogram")
          {
            h <- hist(x, plot=F, breaks=breaks)
            x <- h$breaks
            x <- scale01(breaks,min.scale,max.scale)
            y <- c(h$density, h$density[length(h$density)]) 
            y <- y/max(y) * 0.95
            lines(x, y, col="yellow", lwd=1, type="s")
          }
        
      }
    
    invisible(list(rowInd = rowInd, colInd = colInd))
}
