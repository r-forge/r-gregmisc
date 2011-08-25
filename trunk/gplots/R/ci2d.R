## first(...) selects the first element of which(...)
first <- function(x,...)
  {
  w <- which(x,...)
  if(length(x)>1)
    w[1]
  else
    w
}

## first(...) selects the first element of which(...)
last <- function(x,...)
  {
  w <- which(x,...)
  if(length(x)>1)
    rev(w)[1]
  else
    w
}

## non-parametric 2 dimensional approximate confidence interval
## based on 2 dimensional histogram
ci2d <- function(x,
                 y = NULL,
                 nbins=25,
                 ci.levels=c(0.50,0.75,0.90,0.95,0.975),
                 show=c("filled.contour","contour","image","none"),
                 xlab=deparse(substitute(x)),
                 ylab=deparse(substitute(y)),
                 col=topo.colors(length(breaks)-1),
                 ...)
  {

    show=match.arg(show)
    breaks <- unique(c(0, ci.levels, 1.0))
    
    h2d <- hist2d(x,y, show=FALSE, nbins=nbins, ...)
    h2d$density <- h2d$counts / sum(h2d$counts, na.rm=TRUE)

    uniqueVals <- rev(unique(sort(h2d$density)))
    cumProbs <- sapply( uniqueVals, function(val) sum( h2d$density[h2d$density>=val] ) )
    names(cumProbs) <- uniqueVals
    h2d$cumDensity <- matrix(nrow=nrow(h2d$density), ncol=ncol(h2d$density))
    h2d$cumDensity[] <- cumProbs[as.character(h2d$density)]

    if(show=="image")
      {
        image( h2d$x, h2d$y, h2d$cumDensity, xlab=xlab, ylab=ylab, breaks=breaks, col=col)
      }
    else if(show=="filled.contour")
      {
        filled.contour(h2d$x, h2d$y, h2d$cumDensity,
                       levels=breaks,
                       col=col,
                       key.axes={axis(4, at=breaks); title("\nCI Level")}
                       )
       }
    else if(show=="contour")
        contour(h2d$x, h2d$y, h2d$cumDensity, levels=breaks, nlevels=length(breaks))

    h2d$contours <- contourLines(h2d$x, h2d$y, h2d$cumDensity, levels=breaks, nlevels=length(breaks))
    names
    invisible(h2d)
  }
