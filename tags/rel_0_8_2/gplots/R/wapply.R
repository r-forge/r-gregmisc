# $Id$
#
# $Log$
# Revision 1.8  2003/01/20 17:13:04  warnes
# - Updated wapply.R to allow specification of evaluation points when
#   method is 'width' or 'range' using the 'pts' argument.
# - Updated wapply.Rd to add 'pts' argument
# - Fixed typos, spelling errors, gramatical errors and lack of clarity
#   in wapply.Rd help text.
#
# Revision 1.7  2002/08/01 19:37:14  warnes
#
# - Corrected documentation mismatch for ci, ci.default.
#
# - Replaced all occurences of '_' for assignment with '<-'.
#
# - Replaced all occurences of 'T' or 'F' for 'TRUE' and 'FALSE' with
#   the spelled out version.
#
# - Updaded version number and date.
#
# Revision 1.6  2002/04/09 00:51:31  warneg
#
# Checkin for version 0.5.3
#
# Revision 1.5  2002/02/16 17:58:59  warneg
#
# - Fixed Bug: When method=="range", the absolute range of x was being
#   used to compute the relative width instead of the (correct) relative
#   range.
#
# Revision 1.4  2002/02/16 17:23:33  warneg
#
# - Corrected problem removing missing values: The missing values of $x
#   and $y were being removed indepdendently, leaving an uneven number
#   of points in the result.
#
# Revision 1.3  2001/12/05 19:29:50  warneg
#
# - Added a better default for "width" when method="nobs".  For this case,
#   width=max(5, length(x)/10).
#
# - Allow omission of x values which result in missing y values via
#   'drop.na' parameter.
#
# Revision 1.2  2001/08/31 23:45:45  warneg
# Used wrong character in header (% instead of #).  Fixed.
#
# Revision 1.1  2001/08/25 05:48:54  warneg
# Initial checkin.
#
#
"wapply" <- function( x, y, fun=mean, method="range",
                    width, n=50, drop.na=TRUE, pts, ...)
{
  method <- match.arg(method, c("width","range","nobs","fraction"))
  if(missing(width))
    if( method=="nobs" ) width <- max(5, length(x)/10 )
  else
    width <- 1/10

  if(method == "width" || method == "range" )
    {
      if(method=="range")
        width <- width * diff(range(x))

      if(missing(pts))
        pts <- seq(min(x),max(x),length.out=n)
      
      result <- sapply( pts, function(pts,y,width,fun,XX,...)
                      {
                        low <- min((pts-width/2),max(XX))
                        high <- max((pts+width/2), min(XX))
                        return (fun(y[(XX>= low) & (XX<=high)],...))
                      },
                      y=y,
                      width=width,
                      fun=fun,
                      XX = x,
                      ...)
      if(drop.na)
        {
          missing <- is.na(pts) & is.na(result)
          pts <- pts[!missing]
          result <- result[!missing]
        }
      
      return(x=pts,y=result)
    }
  else # method=="nobs" || method=="fraction"
    {
      if( method=="fraction")
        width <- floor(length(x) * width)

      ord <- order(x)
      x  <- x[ord]
      y  <- y[ord]

      n  <- length(x)
      center  <- 1:n
      below <- sapply(center - width/2, function(XX) max(1,XX) )
      above <- sapply(center + width/2, function(XX) min(n,XX) )

      retval  <- list()
      retval$x  <- x
      retval$y  <- apply(cbind(below,above), 1,
                         function(x) fun(y[x[1]:x[2]],...) )
                         
      if(drop.na)
        {
          missing <- is.na(retval$x) | is.na(retval$y)
          retval$x <- retval$x[!missing]
          retval$y <- retval$y[!missing]
        }


      return(retval)
    }
      
}


