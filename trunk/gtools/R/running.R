# $Id$
#
# $Log$
# Revision 1.6  2004/03/26 15:34:26  warnes
# Fix bug discovered by Sean Davis <sdavis2@mail.nih.gov>.  The running
# function took an improper shortcut.  When allow.fewer=FALSE it was
# still passing shorter lists of elements to the called function, and
# then overwriting the results for the shorter lists with NAs.  The code
# now skips evaluation of the function on lists shorter than the
# specified length when allow.fewer=FALSE.
#
# Revision 1.5  2002/09/24 14:57:19  warnes
#
# - Fixed error where running was always calling running2 with
#   'fun=mean', ignoring the specified funtion.
#
# Revision 1.4  2002/08/01 19:37:14  warnes
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
# Revision 1.3  2002/03/07 23:38:37  warneg
#
# - Added "running2", which handles both univariate and bivariate cases
# - Modified "running" to call "running2"
#
# Revision 1.2  2001/09/01 00:01:54  warneg
# Release 0.3.0
#
# Revision 1.1  2001/08/25 05:53:37  warneg
# Initial CVS checkin.
#
#

"running" <- function( X, fun=mean, width=min(length(X),20),
                     allow.fewer=FALSE,...)
  running2(X=X, fun=fun, width=width, allow.fewer=allow.fewer, ...)

"running2" <- function( X, Y=NULL, fun=mean, width=min(length(X),20),
                     allow.fewer=FALSE,...)
{
  n <- length(X)

  from  <-  sapply( (1:n) - width + 1, function(x) max(x,1) )
  to    <-  1:n

  if(!allow.fewer)
    {
      from <- from[ -(1:(width-1)) ]
      to <- to[ -(1:(width-1)) ]
    }
  
  elements  <- apply(cbind(from,to), 1,function(x) seq(x[1], x[2]) )

  if(is.matrix(elements))
    elements  <- as.data.frame(elements)

  if(is.null(Y))  # univariate 
    {
      funct <- function(which,what,fun,...) fun(what[which],...)
      
      Xvar <- sapply(elements, funct, what=X, fun=fun, ...)
    }
  else # bivariate
    {
      funct <- function(which,XX,YY,fun,...) fun(XX[which],YY[which], ...)
      
      Xvar <- sapply(elements, funct, XX=X, YY=Y, fun=fun, ...)
    }

  
  names(Xvar) <- paste(from,to,sep=":")

  return(Xvar)
}
