
prettylog <- function( x, n=5)
  {
    # R version of GLPretty in graphics.c
    LPR.SMALL <- 2
    LPR.MEDIUM <- 3

    ul <- min(x,na.rm=T)
    uh <- max(x,na.rm=T)

    p1 = floor(log10(ul));
    p2 = ceiling(log10(uh));

    if (p2 - p1 <= 1) {
	# Very small range : Use tickmarks from a LINEAR scale
	pretty(x, n);
    }
    else {

      step <- 10^seq( p1, p2, by=1)
      
      if (p2 - p1 <= LPR.SMALL)
        n = c(1,2,5,10)
      else if (p2 - p1 <= LPR.MEDIUM)
        n = c(1,5,10)
      else
        n = c(1,10)

      tick <- unique(c(outer(n, step, '*')))
      last <- which.max( tick > uh )
      tick <- tick[1:last]
            
      return( tick )
      }
  }



panel.overplot <- function(formula, data, subset, col, lty, ...)
  {
    m <- match.call()
    m[[1]] <- as.name('plot.formula')
    eval(m, parent.frame() )

    m[[1]] <- as.name('lowess.formula')
    tmp <- eval(m, parent.frame() )
          
    lines( tmp, col=col, lwd=2, lty=lty )
        

  }

overplot <- function (formula, data = parent.frame(),
                      same.scale=FALSE,
                      xlab, ylab,
                      xlim, ylim,
                      min.y, max.y,
                      log='',
                      panel='panel.overplot',
                      subset,
                      plot=TRUE, groups,
                      main,
                      f=2/3,
                      ... )
{

  ###
  # check that the formula had the right form
  ###
  if(
     length(formula)!=3 ||
     length(formula[[3]]) != 3  ||
     formula[[3]][[1]] != as.name("|")
     )
    stop("Formula must be of the form y ~ x1 | x2")

  if(!missing(subset))
    {
      flag <- eval(substitute(subset), envir=data)
      data <- data[flag,]
    }
  
  ###
  # Get the actual formula values
  ###
  cond <- eval(formula[[3]][[3]], envir=data, parent.frame())
  x <- eval(formula[[3]][[2]], envir=data, parent.frame())
  y <- eval(formula[[2]], envir=data, parent.frame())

  #print(data.frame(cond,x,y))
  
  y.all.min <- min(y, na.rm=T)
  y.all.max <- max(y, na.rm=T)

  x.all.min <- min(x, na.rm=T)
  x.all.max <- max(x, na.rm=T)

  if(y.all.min==y.all.max) browser()
  
  if (length(cond) == 0) {
    cond <- list(as.factor(rep(1, length(x))))
  }
  if (!is.factor(cond))
    {
      cond <- factor(cond)
    }


  ###
  # create a new call to the requested function
  ###
  mycall <- match.call(expand.dots=FALSE)
  mycall$panel <- mycall$plot <- mycall$groups <- mycall$same.scale <- NULL
  mycall$min.y <- mycall$max.y <- NULL
  mycall$data <- data
    
  # remove condition from formula
  mycall$formula[3] <- formula[[3]][2]

  # function name
  if(is.character(panel))
    panel <- as.name(panel)
  else
    panel <- deparse(substitute(panel))
  
  mycall[[1]] <- as.name(panel)

  # ylim
  if(same.scale)
    {
      if(missing(ylim))
        mycall$ylim <- range(y[y>0],na.rm=T)
    }

  # xlim is always the same for all graphs
  if(missing(xlim))
    if(log %in% c("x","xy"))
      mycall$xlim <- range(x[x>0],na.rm=T)
    else
      mycall$xlim <- range(x,na.rm=T)


  
  ###
  # Only plot groups with non-na entries
  ##
  tmp <- na.omit(data.frame(x,y,cond))
  leveln <- sapply( split(tmp, tmp$cond), nrow )

  if(missing(groups)) groups <- names(leveln)
  ngroups <- length(groups)

  if(!missing(min.y) && length(min.y==1))
    min.y <- rep(min.y, length=ngroups)
  
  if(!missing(max.y) && length(max.y==1))
    max.y <- rep(max.y, length=ngroups)
  
  ###
  # Set up the plot regions
  ###
  oldpar <- par()['mar']
  on.exit(par(oldpar))
  
  par(mar=par("mar") +c(0,ngroups*2.5,0,0))
  
  ###
  # Ok. Now iterate over groups
  ## 

    i <- 1
    for(level in groups)
      {

        if(i>1)
          {
            par(new=TRUE)
          }

        mycall$subset <- (cond==level)

        mycall$ylab <- ''
        mycall$xlab <- ''
        mycall$xaxt = 'n'
        mycall$yaxt = 'n'
        mycall$pch = i
        mycall$col = i
        mycall$lty = i

        tmp.y <- y[mycall$subset & cond==level]
        min.tmp.y <- min(tmp.y, na.rm=T)
        max.tmp.y <- max(tmp.y, na.rm=T)
                
        if( !missing(min.y) || !missing(max.y) )
          {
            if(!missing(min.y) && !missing(max.y) )
              {
                mycall$ylim <- c(min.y[i], max.y[i])                
              }
            else if(missing(min.y) && !missing(max.y))
              {
                if(same.scale)
                  mycall$ylim <- c(y.all.min, max.y[i])
                else
                  mycall$ylim <- c(min.tmp.y, max.y[i])
              }
            else # !missing(min.y) && missing(max.y)
              {
                if(same.scale)
                  mycall$ylim <- c(min.y[i], y.all.max)
                else
                  mycall$ylim <- c(min.y[i], max.tmp.y)
              }
          }

        if(plot)
          {
            status <- try(
                eval(mycall, parent.frame())
                )
            if('try-error' %in% class(status))
              break;
            
          }

        usr <- par("usr")

        # draw y axis manually
        if( log %in% c('y','xy') )
          {
            yseq <- prettylog(10^usr[3:4])
            axis(side=2,at=yseq,label=yseq,line=2.5*(i-1),lty=i,col=i,lwd=2)
          }
        else
          {
            yseq <- pretty(usr[3:4]) 
            axis(side=2,at=yseq,label=yseq,line=2.5*(i-1),lty=i,col=i,lwd=2)
          }
        
        if(i == 1)
          {
            # draw x axis manually
            if( log %in% c('x','xy') )
              {
                xseq <- prettylog(10^usr[1:2])
                axis(side=1,at=xseq,label=xseq)
              }
            else
              {
                xseq <- pretty(usr[1:2])
                axis(side=1,at=xseq,label=xseq)
              }
          }

        # y axis label
        title(ylab=level, line=2.5*(i-1))

        i <- i+1
        
      }


  if(missing(xlab))
      xlab <- as.character(formula[[3]][[2]])
  
  if(missing(ylab))
      ylab <- as.character(formula[[2]])

  if(missing(main))
    main <- paste("plot of ", xlab, "vs.", ylab, "by",
                  as.character(formula[[3]][[3]]))
  
  if(i>1)
    {
      title(main=main,xlab=xlab)
      title(ylab=ylab, line=2.5*(i-1))
    }

  par(oldpar)
  
  invisible( split(data.frame(x,y),cond) )
}


