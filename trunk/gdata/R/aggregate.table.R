# $Id$
#
# $Log$
# Revision 1.3  2002/09/23 13:59:30  warnes
# - Modified all files to include CVS Id and Log tags.
#
# Revision 1.2  2002/02/21 21:45:01  warneg
#
# - Fixed bug where row and column labels didn't always correspond to the
# contents.  This only occured when a factor was used for by1 or by2 and
# the factors levels weren't in the default sort order.
#
# Revision 1.1  2002/02/20 22:10:08  warneg
#
# New function.
#
#

aggregate.table <- function(x, by1, by2, FUN=mean, ... )
  {
    if(!is.factor(by1)) by1 <- as.factor(by1)
    if(!is.factor(by2)) by2 <- as.factor(by2)
    
    ag <- aggregate(x, by=list(by1,by2), FUN=FUN, ... )
    tab <- matrix( nrow=nlevels(by1), ncol=nlevels(by2) )
    dimnames(tab) <- list(levels(by1),levels(by2))

    for(i in 1:nrow(ag))
      tab[ as.character(ag[i,1]), as.character(ag[i,2]) ] <- ag[i,3]
    tab
  }
