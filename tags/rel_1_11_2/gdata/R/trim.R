# $Id$
#
# $Log$
# Revision 1.1  2003/05/20 13:16:47  warnes
# - Added function trim() and assocated docs.
#
#

trim <- function(s)
  {
    s <- sub("^ +","",s)
    s <- sub(" +$","",s)
    s
  }
