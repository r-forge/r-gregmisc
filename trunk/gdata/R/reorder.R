# $Id$
#
# $Log$
# Revision 1.2  2003/03/03 17:24:21  warnes
# - Added handling of factor level names in addition to numeric indexes.
#
# Revision 1.1  2002/08/01 18:06:41  warnes
#
# Added reorder() function to reorder the levels of a factor.
#
#

# Reorder the levels of a factor.

reorder <- function( X, order )
  {
    if(!is.factor(X)) stop("reorder only handles factor variables")
    if(is.numeric(order))
      factor( X, levels=levels(X)[order] )
    else
      factor( X, levels=order )
  }
