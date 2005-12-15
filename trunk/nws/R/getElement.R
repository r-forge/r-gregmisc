## Copyright (c) 2005, Pfizer, Inc.
## All rights reserved.

# $Id$

# This function extracts the i'th element (or chunk if chunkSize!=1)
# When chunkSize==1 and x is a matrix or data.frame, we turn the
# result into a simple vector, mirroring how apply() works (unless
# drop is FALSE)

getElement <- function(x, i,
                       by=c("row","column","cell"),
                       chunkSize=1,
                       drop=FALSE)
  {
    by <- match.arg(by) # do partial mathing to get one of the options


    maxElement <- countElement(x, by=by, chunkSize=1)

    if(i<1 || i > maxElement) stop("i outside of valid range for x")
    
    indexSet <- seq(from=(i-1)*chunkSize + 1,
                    to=min(i*chunkSize, maxElement),
                    by=1)

    ## This is necessary since x[i] gets the i'th *column* of a data
    ## frame object rather than the i'th cell
    dfGetElement <- function(x, obs)
        {
          row <- (obs-1) %% nrow(x) + 1
          col <- floor((obs-1)/nrow(x))+1
          x[cbind(row,col)]  # pair (r,c) to select elements
        }
    
    if(is.matrix(x))
      retval <- switch(by,
                       "row"=x[indexSet,,drop=drop],
                       "column"=x[,indexSet,drop=drop],
                       "cell"=x[indexSet]
                       )
    else if(is.data.frame(x))
      retval <- switch(by,
                       "row"=x[indexSet,,drop=drop],
                       "column"=x[,indexSet,drop=drop],
                       "cell"=dfGetElement(x,indexSet)
                       )
    else
      retval <- x[indexSet]
    if(drop && chunkSize==1 && class(x) %in% c("data.frame", "matrix"))
      return(unlist(retval))
    else
      return(retval)
  }

countElement <- function(x, by=c("row","column","cell"), chunkSize=1)
  {
    by <- match.arg(by) # do partial mathing to get one of the options

    if(is.matrix(x))
      nElem <- switch(by,
                      "row"=nrow(x),
                      "column"=ncol(x),
                      "cell"=length(x)
                      )
    else if (is.data.frame(x))
      nElem <- switch(by,
                      "row"=nrow(x),
                      "column"=ncol(x),
                      "cell"=nrow(x)*ncol(x)
                      )
    else
      nElem <- length(x)

    retval <- ceiling( nElem / chunkSize )
    retval
  }

