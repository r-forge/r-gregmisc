first <- function(x) UseMethod("first")
last  <- function(x) UseMethod("last")
left  <- function(x, n) UseMethod("left")
right <- function(x, n) UseMethod("left")

first.default <- function(x) x[1]
last.default  <- function(x) x[length(x)] 

first.list <- function(x, ...) x[[1]]
last.list  <- function(x, ...) x[[length(x)]]


left.data.frame <- function(x, n=6)
{
   n <- min(n, ncol(x))
   x[, 1:n]
}
left.matrix <- left.data.frame

right.data.frame <- function(x, n=6)
{
   n <- min(n, ncol(x))
   x[, (ncol(x)-n+1):ncol(x)]
}
right.matrix <- right.data.frame

