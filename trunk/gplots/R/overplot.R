
prettylog <- function( x, n=5)
  {
    # R version of GLPretty in graphics.c
    LPR.SMALL <- 2
    LPR.MEDIUM <- 3

    ul <- min(x,na.rm=T)
    uh <- max(x,na.rm=T)
    
    p1 = ceiling(log10(ul));
    p2 = floor(log10(uh));

    if (p2 - p1 <= 0) { # floor(log10(uh)) <= ceil(log10(ul))
			# <==>	 log10(uh) - log10(ul) < 2
			# <==>		uh / ul	       < 100
	# Very small range : Use tickmarks from a LINEAR scale
	#		      Splus uses n = 9 here, but that is dumb
	pretty( x, n);
    }
    else { # extra tickmarks --> CreateAtVector(.) in	../plot.c */

      tick <- 10^seq( p1-1, p2+1, by=1)
      
      if (p2 - p1 <= LPR.SMALL)
	    n = 3 # Small range :	Use 1,2,5,10 times 10^k tickmarks 
      else if (p2 - p1 <= LPR.MEDIUM)
        n = 2 # Medium range :	Use 1,5 times 10^k tickmarks 
      else
        n = 1 # Large range :	        Use 10^k tickmarks
                #  But decimate, when there are too many
      }
  }



panel.overplot <- function(formula, data, subset, col, lty, ...)
  {
    m <- match.call()
    m[[1]] <- as.name('plot.formula')
    eval(m, parent.frame() )

    try(
        {
          m[[1]] <- as.name('lowess.formula')
          m$f <- 0.25
          tmp <- eval(m, parent.frame() )
          
          lines( tmp, col=col, lwd=2, lty=lty )
        }
       )
    

  }

overplot <- function (formula, data = parent.frame(), same.scale=FALSE,
                      xlab, 
                      xlim, ylim,
                      min.y, max.y,
                      log='',
                      panel='panel.overplot',
                      subset, plot=TRUE, groups,
                      main, ... )
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

    

  
  ###
  # Get the actual formula values
  ###
  cond <- eval(formula[[3]][[3]], envir=data, parent.frame())
  x <- eval(formula[[3]][[2]], envir=data, parent.frame())
  y <- eval(formula[[2]], envir=data, parent.frame())

  y.all.min <- min(y, na.rm=T)
  y.all.max <- min(y, na.rm=T)

  x.all.min <- min(x, na.rm=T)
  x.all.max <- min(x, na.rm=T)

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
        mycall$ylim <- range(y,na.rm=T)
    }

  # xlim is always the same for all graphs
  if(missing(xlim))
    #if( log %in% c('x','xy') )
    #  {
    #    mycall$xlim <- c( max(1, min(x, na.rm=T)), max(x,na.rm=T) )
    #  }
    #else
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

    i <- 0
    for(level in groups)
      {
        i <- i+1

        if(i>1)
          {
            par(new=TRUE)
          }

        if(!missing(subset))
          mycall$subset <- (subset) & (cond==level)
        else
          mycall$subset <- (cond==level)

        mycall$ylab <- ''
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
            eval(mycall, parent.frame())
          }

        usr <- par("usr")

        # draw y axis manually
        if( log %in% c('y','xy') )
          {
            logseq <- c(1,2,5)

            yseq <- c()
            for(j in floor(usr[3]):ceiling(usr[4]))
              yseq <- c(yseq, logseq*10^j)
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
            xseq <- pretty(usr[1:2]) #seq(usr[1],usr[2],length=5))
            axis(side=1,at=xseq,label=xseq)
          }

        # y axis label
        title(ylab=level, line=2.5*(i-1))
              
      }

  if(!missing(main))
    title(main)
  
  par(oldpar)
  
  invisible( split(data.frame(x,y),cond) )
}


