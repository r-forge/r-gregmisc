# $Id$
#
# $Log$
# Revision 1.1  2001/09/01 19:19:13  warneg
# Initial checkin.
#
#
# Code necessary for contrast.lm to work in S-Plus

is.R <- function() 
  exists("version") &&
  !is.null(vl <- version$language) &&
  vl == "R"

if(!is.R())
{
  
  colnames <- function (x, do.NULL = TRUE, prefix = "col") 
    {
      dn <- dimnames(x)
      if (!is.null(dn[[2]])) 
        dn[[2]]
      else {
        if (do.NULL) 
          NULL
        else paste(prefix, seq(length = NCOL(x)), sep = "")
      }
    }
  rownames <- function (x, do.NULL = TRUE, prefix = "row") 
    {
    dn <- dimnames(x)
    if (!is.null(dn[[1]])) 
        dn[[1]]
    else {
      if (do.NULL) 
        NULL
      else paste(prefix, seq(length = NROW(x)), sep = "")
    }
  }
  
  "rownames<-" <- function (x, value) 
    {
      dn <- dimnames(x)
      ndn <- names(dn)
      dn <- list(value, if (!is.null(dn)) dn[[2]])
      names(dn) <- ndn
      dimnames(x) <- dn
      x
    }
  "colnames<-" <- function (x, value) 
    {
      dn <- dimnames(x)
      ndn <- names(dn)
      dn <- list(if (!is.null(dn)) dn[[1]], value)
      names(dn) <- ndn
      dimnames(x) <- dn
      x
    }
  
  # from the MASS library by Venables & Ripley 
  ginv <- function (X, tol = sqrt(.Machine$double.eps))
    {
      if (length(dim(X)) > 2 || !(is.numeric(X) || is.complex(X)))
        stop("X must be a numeric or complex matrix")
      if (!is.matrix(X))
        X <- as.matrix(X)
      Xsvd <- svd(X)
      if (is.complex(X))
        Xsvd$u <- Conj(Xsvd$u)
      Positive <- Xsvd$d > max(tol * Xsvd$d[1], 0)
      if (all(Positive)) Xsvd$v %*% (1/Xsvd$d * t(Xsvd$u))
      else if (!any(Positive)) array(0, dim(X)[2:1])
      else Xsvd$v[, Positive] %*% ((1/Xsvd$d[Positive]) * t(Xsvd$u[, Positive]))
    }


}
