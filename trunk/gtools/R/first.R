first <- function(x) UseMethod("first")
last  <- function(x) UseMethod("last")

first.default <- function(x) x[1]
last.default  <- function(x) x[length(x)]

left <- function(x, n=6)
{
   n <- min(n, ncol(x))
   x[, 1:n]
}

right <- function(x, n=6)
{
   n <- min(n, ncol(x))
   x[, (ncol(x)-n):ncol(x)]
}
