# $Id$
#
# $Log$
# Revision 1.3  2001/12/08 01:54:19  warneg
# Changed 'T' to 'TRUE' in parameter list.
#
# Revision 1.2  2001/12/07 22:55:32  warneg
#
# Added attribution.
#
# Revision 1.1  2001/12/07 21:40:54  warneg
#
# Initial checkin
#
#

# submitted by Don MacQueen <macq@llnl.gov>

rename.vars <- function(data,from='',to='',info=TRUE) {

   dsn <- deparse(substitute(data))
   dfn <- names(data)

   if ( length(from) != length(to)) {
     cat('--------- from and to not same length ---------\n')
     stop()
   }

   if (length(dfn) < length(to)) {
     cat('--------- too many new names ---------\n')
     stop()
   }

   chng <- match(from,dfn)

   frm.in <- from %in% dfn
   if (!all(frm.in) ) {
     cat('---------- some of the from names not found in',dsn,'\n')
     stop()
   }

   if (length(to) != length(unique(to))) {
     cat('---------- New names not unique\n')
     stop()
   }

   dfn.new <- dfn
   dfn.new[chng] <- to
   if (info) cat('\nChanging in',dsn)
     tmp <- rbind(from,to)
     dimnames(tmp)[[1]] <- c('From:','To:')
     dimnames(tmp)[[2]] <- rep('',length(from))
   if (info) print(tmp,quote=F)
   names(data) <- dfn.new
   invisible(data)
}


