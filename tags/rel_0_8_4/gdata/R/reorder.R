# $Id$
#
# $Log$
# Revision 1.3  2003/04/22 15:42:33  warnes
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

reorder.factor <- function( x, order )
  {
    if(is.numeric(order))
      factor( x, levels=levels(x)[order] )
    else
      factor( x, levels=order )
  }
