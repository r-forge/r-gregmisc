# $Id$
#
# $Log$
# Revision 1.1  2002/08/01 18:06:41  warnes
# Added reorder() function to reorder the levels of a factor.
#
#

# Reorder the levels of a factor.

reorder <- function( X, order )
  {
    if(!is.factor(X)) stop("reorder only handles factor variables")
    factor( X, levels=levels(X)[order] )
  }
