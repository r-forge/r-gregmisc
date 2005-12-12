# run fun once for each element of a vector.

getElement <- function(x, i, by=c("row","column","cell"), chunkSize=1)
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
      switch(by,
             "row"=x[indexSet,,drop=FALSE],
             "column"=x[,indexSet,drop=FALSE],
             "cell"=x[indexSet]
             )
    else if(is.data.frame(x))
      switch(by,
             "row"=x[indexSet,,drop=FALSE],
             "column"=x[,indexSet,drop=FALSE],
             "cell"=dfGetElement(x,indexSet)
             )
    else
      x[[indexSet]]
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

