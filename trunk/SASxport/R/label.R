label <- function(x, default)
  UseMethod("label")

label.default <- function(x, default=NULL)
{
  lab <- attr(x,"label")
  if(is.null(lab))
    default
  else
  lab
}

"label<-" <- function(x, value)
  UseMethod("label<-")

"label<-.default" <- function(x, value)
{
  attr(x,'label') <- value
  x
}
