# $Id$
#
# $Log$
# Revision 1.7  2004/06/30 19:32:10  warnes
# Remove commented-out code.
#
# Revision 1.6  2004/06/30 19:26:22  warnes
# Fixed text size calculations
#
# Revision 1.5  2004/03/30 19:04:53  warnes
# - Fix bug in textplot() reported by Wright, Kevin <kevin.d.wright@pioneer.com>.
#
# Revision 1.4  2004/03/26 22:16:44  warnes
# Misc changes.
#
# Revision 1.3  2004/01/21 04:31:25  warnes
# - Mark sprint() as depreciated.
# - Replace references to sprint with capture.output()
# - Use match.arg for halign and valign arguments to textplot.default.
# - Fix textplot.character so that a vector of characters is properly
#   displayed. Previouslt, character vectors were plotted on top of each
#   other.
#
# Revision 1.2  2003/04/04 13:41:42  warnes
#
#
# - Added textplot.character to handle character strings.
# - Moved test for vector and matrix arguments to textplot.default.
# - Renamed arguments "col.margin" and "row.margin" to "cmar", and
#   "rmar" so that specifying "col='red'" is possible.
#
# Revision 1.1  2003/04/02 22:29:53  warnes
#
# - Added textplot function and friends, as well as documentation.
#
#

textplot <- function(object, halign="center", valign="center", cex, ... )
  UseMethod('textplot')


textplot.default <- function(object,
                             halign=c("center","left","right"),
                             valign=c("center","top","bottom"),
                             cex, ... )
{

  if (is.matrix(object) || (is.vector(object) && length(object)>1) )
    return(textplot.matrix(object, halign, valign, cex, ... ))

  halign <- match.arg(halign)
  valign <- match.arg(valign)

  textplot.character(object, halign,  valign, cex, ...)
}


textplot.data.frame <- function(object,
                             halign=c("center","left","right"),
                             valign=c("center","top","bottom"),
                             cex, ... )
    textplot.matrix(object, halign, valign, cex, ... )  


textplot.matrix <- function(object,
                            halign=c("center","left","right"),
                            valign=c("center","top","bottom"),
                            cex, cmar=2, rmar=0.5,
                            show.rownames=TRUE, show.colnames=TRUE,
                            hadj=1,
                            vadj=1,
                            mar= c(1,1,4,1)+0.1,
                            ... )
{

  if(is.vector(object))
    object <- t(as.matrix(object))
  else
    object <- as.matrix(object)

  halign=match.arg(halign)
  valign=match.arg(valign)
  
  opar <- par()[c("mar","xpd","cex")]
  on.exit( par(opar) )
  par(mar=mar, xpd=FALSE )
    
  # setup plot area
  plot.new()
  plot.window(xlim=c(0,1),ylim=c(0,1), log = "", asp=NA)


  
  # add 'r-style' row and column labels if not present
  if( is.null(colnames(object) ) )
    colnames(object) <- paste( "[,", 1:ncol(object), "]", sep="" )
  if( is.null(rownames(object)) )
    rownames(object) <- paste( "[", 1:nrow(object), ",]", sep="")

  
  # extend the matrix to include them
  if( show.rownames )
    {
      object <- cbind( rownames(object), object )
    }
  if( show.colnames )
    {
        
      object <- rbind( colnames(object), object )
    }

  # set the character size
  if( missing(cex) )
    {
      cex <- 1.0
      lastloop <- FALSE
    }
  else
    {
      lastloop <- TRUE
    }

  for (i in 1:20)
    {
      oldcex <- cex

      width  <- sum(
                    apply( object, 2,
                          function(x) max(strwidth(x,cex=cex) ) )
                    ) +
                      strwidth('M', cex=cex) * cmar * ncol(object)
      
      height <- strheight('M', cex=cex) * nrow(object) * (1 + rmar)

      if(lastloop) break

      cex <- cex / max(width,height) 

      if (abs(oldcex - cex) < 0.001)
        {
          lastloop <- TRUE
        }
    }

  
  # compute the individual row and column heights
  rowheight<-strheight("W",cex=cex) * (1 + rmar)
  colwidth<- apply( object, 2, function(XX) max(strwidth(XX, cex=cex)) ) + 
               strwidth("W")*cmar

  
  width  <- sum(colwidth)
  height <- rowheight*nrow(object)

  # setup x alignment
  if(halign=="left")
    xpos <- 0
  else if(halign=="center")
    xpos <- 0 + (1-width)/2
  else #if(halign=="right")
    xpos <- 0 + (1-width)

  # setup y alignment
  if(valign=="top")
    ypos <- 1
  else if (valign=="center") 
    ypos <- 1 - (1-height)/2
  else #if (valign=="bottom") 
    ypos <- 0 + height

  x <- xpos
  y <- ypos
  
  # iterate across elements, plotting them
  xpos<-x
  for(i in 1:ncol(object)) {
    xpos <- xpos + colwidth[i]
    for(j in 1:nrow(object)) {
      ypos<-y-(j-1)*rowheight
      if( (show.rownames && i==1) || (show.colnames && j==1) )
        text(xpos, ypos, object[j,i], adj=c(hadj,vadj), cex=cex, font=2, ... )
      else
        text(xpos, ypos, object[j,i], adj=c(hadj,vadj), cex=cex, font=1, ... )
    }
  }

  par(opar)
}

textplot.character <- function (object, 
                                halign = c("center", "left", "right"), 
                                valign = c("center", "top", "bottom"), 
                                cex, fixed.width=TRUE,
                                cspace=1,
                                lspace=1,
                                mar=c(0,0,3,0)+0.1,
                                ...)
  {
    # when fixed.withd=TRUE, we simulate a fixed width font by
    # explicitly placing characters at appropriate x,y positions


    object <- paste(object,collapse="\n",sep="")
  
    halign = match.arg(halign)
    valign = match.arg(valign)
    plot.new()

    opar <- par()[c("mar","xpd","cex")]
    on.exit( par(opar) )

    par(mar=mar,xpd=FALSE )
    plot.window(xlim = c(0, 1), ylim = c(0, 1), log = "", asp = NA)

    slist   <- unlist(lapply(object, function(x) strsplit(x,'\n')))
    slist   <- lapply(slist, function(x) unlist(strsplit(x,'')))
    
    slen    <- sapply(slist, length)
    slines  <- length(slist)

    if (missing(cex))
      {
        lastloop <- FALSE
        cex <- 1
      }
    else
      lastloop <- TRUE

    
    for (i in 1:20)
      {
        oldcex <- cex
        
        cwidth  <- max(sapply(unlist(slist), strwidth,  cex=cex)) * cspace
        cheight <- max(sapply(unlist(slist), strheight, cex=cex)) * ( lspace + 0.5 )

        if(fixed.width)
          {
            width  <- max(slen) * cwidth
            height <- slines * cheight
          }
        else
          {
            width <- strwidth(object, cex=cex)
            height <- strheight(object, cex=cex)
          }

        if(lastloop) break

        cex <- cex  / max(width, height)
        
        if (abs(oldcex - cex) < 0.001)
          {
            lastloop <- TRUE
          }

      }

    if (halign == "left")
        xpos <- 0
    else if (halign == "center")
        xpos <- 0 + (1 - width)/2
    else xpos <- 0 + (1 - width)

    if (valign == "top")
        ypos <- 1
    else if (valign == "center")
        ypos <- 1 - (1 - height)/2
    else ypos <- 1 - (1 - height)

    if(fixed.width)
      {
        
        for(line in 1:slines)
          {
            cpos <- ((1:length(slist[[line]]))-1) * cwidth
            
            if(length(slist[[line]])>0)
              text(x = xpos + cpos,
                   y = ypos - (line-1)*cheight,
                   labels=unlist(slist[[line]]),
                   adj = c(0.5, 1),
                   cex = cex, ...)
          }
      }
    else
      {
        text(x=xpos, y=ypos, labels=object, adj=c(0,1),
             cex=cex, ...)
      }

    par(opar)
    invisible(cex)
}
