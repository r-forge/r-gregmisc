# $Id$
#
# $Log$
# Revision 1.2  2003/04/04 13:41:42  warnes
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


  if(is.character(object))
    object <- paste(object, collapse="\n")
  else
    object <- sprint(object)

  textplot.character(object, halign,  valign, cex, ...)
}


textplot.data.frame <- function(object,
                             halign=c("center","center","right"),
                             valign=c("center","top","bottom"),
                             cex, ... )
    textplot.matrix(object, halign, valign, cex, ... )  



textplot.character <- function(object,
                             halign=c("center","left","right"),
                             valign=c("center","top","bottom"),
                             cex, ... )
{
  
  halign=match.arg(halign)
  valign=match.arg(valign)

  # setup plot area
  plot.new()
  pmar <- par()[c("mar","xpd")]
  on.exit( par(pmar) )
  par(mar=c(0,0,3,0)+0.1,xpd=NA )

  plot.window(xlim=c(0,1),ylim=c(0,1), log = "", asp=NA)

  # figure out how big to make the text
  if(missing(cex))
    {
      cex <- 1.0
      # iterate to find the best text size
      for(i in 1:20)
        {
          oldcex <- cex
          width <- strwidth(object,cex=cex)
          height <- strheight(object,cex=cex)
          cex <- oldcex/2 * (1 + 0.9/max(width,height) )
          if( abs(oldcex - cex) < 0.001) break
        }
    }

  width  <- strwidth(object,cex=cex)
  height <- strheight(object,cex=cex)
  
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
    ypos <- 1 - (1-height)
    
  # make the plot
  text( x=xpos, y=ypos, object, adj=c(0,1), cex=cex, ... )

  invisible()
}


textplot.matrix <- function(object,
                            halign=c("center","left","right"),
                            valign=c("center","top","bottom"),
                            cex, cmar=2, rmar=0.5,
                            show.rownames=TRUE, show.colnames=TRUE,
                            hadj=1,
                            vadj=1,
                            ... )
{

  if(is.vector(object))
    object <- t(as.matrix(object))
  else
    object <- as.matrix(object)

  halign=match.arg(halign)
  valign=match.arg(valign)
  
  opar <- par()[c("mar","xpd")]
  par(mar=c(0,0,3,0)+0.1,xpd=FALSE )
  on.exit( par(opar) )
    
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
      cex = 1.0
      for(i in 1:20)  # try to find the right text size
        {
          oldcex <- cex
            
          width  <- sum(
                        apply( object, 2,
                              function(x) max(strwidth(x,cex=1) ) )
                        ) +
                          strwidth('M', cex=cex) * cmar * ncol(object)
        
          height <- strheight('M', cex=cex) * nrow(object) *
                    (1 + rmar)

          cex <- round(oldcex/2 * (1 + 0.95/max(width,height)), 2)
          if( abs(oldcex - cex) < 0.001) break
        }
      }

  # compute the individual row and column heights
  rowheight<-strheight("M",cex=cex) * (1 + rmar)
  colwidth<- apply( object, 2, function(XX) max(strwidth(XX, cex=cex)) ) + 
               strwidth("M")*cmar

  
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

}

