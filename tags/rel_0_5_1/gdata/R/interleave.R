#
# $Id$
#
# $Log$
# Revision 1.1  2002/02/20 21:42:23  warneg
# Initial checkin.
#
#

interleave <- function(..., append.source=T, sep=": ")
  {
    sources <- list(...)
    tmp <- rbind(...)
    nrows <- nrow(sources[[1]])
    nsources <- length(sources)

    indexes <- outer( ( 0:(nsources-1) ) * nrows , 1:nrows, "+" )

    retval <- tmp[indexes,]

    if(append.source && !is.null(names(sources) ) )
      row.names(retval) <- paste( row.names(retval), names(sources), sep=sep)

    retval
  }
