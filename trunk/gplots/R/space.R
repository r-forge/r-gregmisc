# $Id$
#
# $Log$
# Revision 1.3  2002/02/04 23:20:29  warneg
# - Add na.rm parameter and make the default TRUE.
#
# Revision 1.2  2001/12/07 22:24:30  warneg
#
# - Added cvs tags.
#
#

# When there are two or more points with the same (x,y) value (or
# within x+-s[1] and x+-s[2]), space these out in the y direction so
# that the points are separated by at least distance s.


space <-  function(x,y,s=1/50, na.rm=T)
  {
    if(na.rm)
      {
        ind <- is.na(x) | is.na(y)
        x <- x[!ind]
        y <- y[!ind]
      }
    
    if (length(s)==1) s <- c(s,s)
    
    spacing.x <- (max(x) - min(x))*s[1]
    spacing.y <- (max(y) - min(y))*s[2]

    within <- function(x,y,delta) { abs(x-y) < delta }

    # sort x,y so we can do the work
    ord <- order(x,y)
    undo <- order(ord)
    
    x <- x[ord]
    y <- y[ord]

    startsame <- 1
    same.x <- x[1]
    same.y <- y[1]
    
    for( i in 1:length(x) )
      {
        if(i>1 &&
           within(x[i],same.x,spacing.x) &&
           within(y[i],same.y,spacing.y) )
          {
            if(x[startsame] == same.x )
              x[startsame] <- x[startsame] 

            cumrun <- i - startsame
            
            x[i] <- x[i] + (-1)^(cumrun+1) * floor((cumrun+1) /2) * spacing.x
          } else {
            startsame <- i
            same.x <- x[i]
            same.y <- y[i]
          }
      }

    return( x=x[undo], y=y[undo] )
}    
      
