upperTriangle <- function(x, diag=FALSE)
  {
    x[upper.tri(x, diag=diag)]
  }

"upperTriangle<-" <- function(x, value, diag=FALSE)
  {
    x[upper.tri(x, diag=diag)] <- value
    x
  }

lowerTriangle <- function(x, diag=FALSE)
  {
    x[lower.tri(x, diag=diag)]
  }

"lowerTriangle<-" <- function(x, value, diag=FALSE)
  {
    x[lower.tri(x, diag=diag)] <- value
    x
  }

