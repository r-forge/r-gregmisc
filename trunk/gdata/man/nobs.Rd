
interleave <- function(...)
  {
    sources <- list(...)
    tmp <- rbind(...)
    nrows <- nrow(sources[[1]])
    nsources <- length(sources)

    indexes <- outer( ( 0:(nsources-1) ) * nrows , 1:nrows, "+" )

    tmp[indexes,]
  }


aggregate.table <- function(x, by1, by2,  ... )
  {
    ag <- aggregate(x, by=list(by1,by2), ... )
    tab <- matrix( ncol=nlevels(by1), nrow=nlevels(by2) )
    dimnames(tab) <- list(levels(by1),levels(by2))
    tab[ ag[,1], ag[,2] ] <- ag[,3]
    tab
  }

nobs <- function(x,...)
  UseMethod("nobs",x)

nobs.default <- function(x) sum( !is.na(x) )

nobs.data.frame <- function(x)
  sapply(x, nobs)

