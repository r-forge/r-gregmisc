
plotCI <- function (x, y = NULL,
                    uiw, liw = uiw,   # bar widths  -OR-
                    ui, li, # bar ends
                    err='y', # bar direction, 'y' or 'x'
                    col=par("col"),
                    ylim=NULL,
                    xlim=NULL,
                    barcol=col,
                    sfrac = 0.01,
                    gap=1,
                    lwd=par("lwd"),
                    lty=par("lty"),
                    labels=FALSE,
                    add=FALSE,
                    xlab,
                    ylab,
                    ...
                    )
{
  if (is.list(x)) { 
    y <- x$y 
    x <- x$x 
  }

  if(missing(xlab))
    xlab <- deparse(substitute(x))
  
  if(missing(ylab))
    {
      if(is.null(y))
        {
          xlab  <- ""
          ylab <- deparse(substitute(x))
        }
      else
        ylab <- deparse(substitute(y))
    }

  if (is.null(y)) { 
    if (is.null(x)) 
      stop("both x and y NULL") 
    y <- as.numeric(x) 
    x <- seq(along = x) 
  }

  
  if(err=="y")
    z  <- y
  else
    z  <- x
  
  if(missing(ui))
    ui <- z + uiw
  if(missing(li)) 
    li <- z - liw
   
  if(err=="y" & is.null(ylim))
    {
      ylim <- range(c(y, ui, li), na.rm=TRUE)
    }
  else if(err=="x" & is.null(xlim))
    {
      xlim <- range(c(x, ui, li), na.rm=TRUE)
    }

    
  if(!add)
    {
      if(missing(labels) || labels==F )
        plot(x, y, ylim = ylim, xlim=xlim, col=col,
             xlab=xlab, ylab=ylab, ...)
      else
        {
          plot(x, y, ylim = ylim, xlim=xlim, col=col, type="n",
               xlab=xlab, ylab=ylab,  ...)
          text(x, y, label=labels, col=col )
        }
    }

 
  if(err=="y")
    {
      if(gap!=FALSE)
        gap <- strheight("O") * gap
      smidge <- par("fin")[1] * sfrac

      # draw upper bar
      if(!is.null(li))
          arrows(x , li, x, pmax(y-gap,li), col=barcol, lwd=lwd,
                 lty=lty, angle=90, length=smidge, code=1)
      # draw lower bar
      if(!is.null(ui))
          arrows(x , ui, x, pmin(y+gap,ui), col=barcol,
                 lwd=lwd, lty=lty, angle=90, length=smidge, code=1)
    }
  else
    {
      if(gap!=FALSE)
        gap <- strwidth("O") * gap
      smidge <- par("fin")[2] * sfrac

      # draw left bar
      if(li!=NULL)
        arrows(li, y, pmax(x-gap,li), y, col=col, lwd=lwd, lty=slty,
               angle=90, length=smidge, code=1)
      if(ui!=NULL)
        arrows(ui, y, pmin(x+gap,ui), y, col=col, lwd=lwd, lty=slty,
               angle=90, length=smidge, code=1)
      
    }
      
    

invisible(list(x = x, y = y)) 
} 
