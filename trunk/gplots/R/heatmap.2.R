heatmap.2 <- function (x,
                       Rowv,
                       Colv,
                       distfun = dist,
                       hclustfun = hclust, 
                       add.expr,
                       scale = c("row", "column", "none"),
                       na.rm = TRUE,
                       col=redgreen(255),
                       dendogram = c("both","row","column"),
                       rowlabel.space = 5,
                       collabel.space = 5,
                       legend.show = TRUE,
                       trace=c("no","column","row","both"),
                       breaks,
                       ...) 
{
    scale <- match.arg(scale)
    dendogram <- match.arg(dendogram)
    trace <- match.arg(trace)
    
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
      breaks <- seq( -max(abs(x)), max(abs(x)), length=length(col)+1 )

    image(1:ncol(x), 1:nrow(x), t(x), axes = FALSE, xlim = c(0.5, 
        ncol(x) + 0.5), ylim = c(0.5, nrow(x) + 0.5), xlab = "", 
        ylab = "", col=col, breaks=breaks,
          ...)

    
    # show traces
    tmp <- (x - min(x))/(max(x) - min(x))  # scale to [0,1]

    if(trace %in% c("both","column") )
      {
        for( i in colInd )
          {
            abline(v=c(i-0.5,i+0.5), col='black', lty=1)
            abline(v=i, col='black', lty=2)
            xv <- rep(i, nrow(tmp)) + tmp[,i] - 0.5
            xv <- c(xv[1], xv)
            yv <- 1:length(xv)-0.5
            lines(x=xv, y=yv, lwd=1, col='yellow', type="s")
          }
      }

    if(trace %in% c("both","row") )
      {
        for( i in rowInd )
          {
            abline(h=c(i-0.5,i+0.5), col='black', lty=1)
            abline(h=i, col='black', lty=2)
            yv <- rep(i, ncol(tmp)) + tmp[i,] - 0.5
            yv <- rev(c(yv[1], yv))
            xv <- length(yv):1-0.5
            lines(x=xv, y=yv, lwd=1, col='yellow', type="s")
          }
      }



    # add axes
    axis(1, 1:ncol(x), las = 2, line = -0.5, tick = 0, labels = if (is.null(colnames(x))) 
        (1:ncol(x))[colInd]
    else colnames(x), cex.axis = c.cex)
    axis(4, 1:nrow(x), las = 2, line = -0.5, tick = 0, labels = if (is.null(rownames(x))) 
        (1:nrow(x))[rowInd]
    else rownames(x), cex.axis = r.cex)
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
        z <- seq(min(breaks),max(breaks),length=1000)
        image( z=matrix(z, ncol=1),
              col=col, breaks=breaks,
              xaxt="n", yaxt="n" )

        xv <- seq(0,1,length=7) 
        lv <- pretty(quantile(breaks))
        axis(1,at=xv,labels=format(lv, digits=2) )

        # Experimental : also plot density of data
        dens <- density(x, adjust=0.25)
        omit <- dens$x < min(breaks) | dens$x > min(breaks)
        dens$x <- dens$x[-omit]
        dens$y <- dens$y[-omit]
        dens$x <- (dens$x - min(dens$x) )/ (max(dens$x)-min(dens$x))
        dens$y <- dens$y / max(dens$y) * par("usr")[4] * 0.95
        lines(dens$x, dens$y, col="yellow", lwd=1)
        
      }
    
    invisible(list(rowInd = rowInd, colInd = colInd))
}
