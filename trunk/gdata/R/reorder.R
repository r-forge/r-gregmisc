# $Id$
#
# $Log$
# Revision 1.5  2004/08/27 21:57:41  warnes
# Fixed bug in mixedsort, and modified reorder.factor to use mixedsort.
#
# Revision 1.4  2004/01/21 12:06:26  warnes
# - Add ... argument to match generic provided in mva.
#
# Revision 1.3  2003/04/22 15:42:33  warnes
#
# - The mva package (which is part of recommended) now provides a
#   generic 'reorder' function.  Consequently, the 'reorder' function
#   here has been renamed to 'reorder.factor'.
#
# - Removed check of whether the argument is a factor object.
#
# Revision 1.2  2003/03/03 17:24:21  warnes
#
# - Added handling of factor level names in addition to numeric indexes.
#
# Revision 1.1  2002/08/01 18:06:41  warnes
#
# Added reorder() function to reorder the levels of a factor.
#
#

# Reorder the levels of a factor.

reorder.factor <- function( x, order="mixedsort", ... )
  {
    if(is.numeric(order))
      factor( x, levels=levels(x)[order] )
    else if(length(order)==1 & !is.na(pmatch(order,"mixedsort")))
      factor( x, levels=mixedsort(levels(x)))
    else
      factor( x, levels=order )
  }
