# 
# $Id$
#
# $Log$
# Revision 1.1  2002/02/20 22:10:08  warneg
# New function.
#
#

aggregate.table <- function(x, by1, by2, FUN=mean, ... )
  {
    by1 <- as.factor(by1)
    by2 <- as.factor(by2)
    
    ag <- aggregate(x, by=list(by1,by2), FUN=FUN, ... )
    tab <- matrix( nrow=nlevels(by1), ncol=nlevels(by2) )
    dimnames(tab) <- list(levels(by1),levels(by2))

    #for(i in 1:nrow(ag))
    #  tab[ ag[i,1], ag[i,2] ] <- ag[i,3]
    tab[ ag[1:2] ] <- ag[,3]
    tab
  }
