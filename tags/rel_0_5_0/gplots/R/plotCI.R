# $Id$
#
# $Log$
# Revision 1.3  2001/10/16 23:00:19  warneg
# - Added minbar and maxbar parameters
# - Added cvs id and log tags to header
#
#


plotCI <- function (x, y = NULL,
                    uiw, liw = uiw,   
                    ui, li, 
                    err='y', 
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
                    minbar,
                    maxbar,
                    ...
                    )
{
  is.R <- get("is.R")
  if(is.null(is.R)) is.R <- function(x) FALSE

  if(!is.R())
    {
      strwidth   <-  function(...)
        {
          par("cin")[1] / par("fin")[1] * (par("usr")[2] - par("usr")[1])
        }

      strheight <-  function(...)
        {
          par("cin")[2] / par("fin")[2] * (par("usr")[4] - par("usr")[3])
        }
    }

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

  if(!missing(minbar))
    li <- ifelse( li < minbar, minbar, li)

  if(!missing(maxbar))
    ui <- ifelse( ui > maxbar, maxbar, ui)
  
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
  if(is.R())
    myarrows <- function(...) arrows(...)
  else
    myarrows <- function(x1,y1,x2,y2,angle,code,length,...)
      {
        segments(x1,y1,x2,y2,open=T,...)
        if(code==1)
          segments(x1-length/2,y1,x1+length/2,y1,...)
        else
          segments(x2-length/2,y2,x2+length/2,y2,...)
      }
 
  if(err=="y")
    {
      if(gap!=FALSE)
        gap <- strheight("O") * gap
      smidge <- par("fin")[1] * sfrac

      
      # draw upper bar
      if(!is.null(li))
          myarrows(x , li, x, pmax(y-gap,li), col=barcol, lwd=lwd,
                 lty=lty, angle=90, length=smidge, code=1)
      # draw lower bar
      if(!is.null(ui))
          myarrows(x , ui, x, pmin(y+gap,ui), col=barcol,
                 lwd=lwd, lty=lty, angle=90, length=smidge, code=1)
    }
  else
    {
      if(gap!=FALSE)
        gap <- strwidth("O") * gap
      smidge <- par("fin")[2] * sfrac

      # draw left bar
      if(!is.null(li))
        myarrows(li, y, pmax(x-gap,li), y, col=col, lwd=lwd, lty=slty,
               angle=90, length=smidge, code=1)
      if(!is.null(ui))
        myarrows(ui, y, pmin(x+gap,ui), y, col=col, lwd=lwd, lty=slty,
               angle=90, length=smidge, code=1)
      
    }
      
    

invisible(list(x = x, y = y)) 
} 
