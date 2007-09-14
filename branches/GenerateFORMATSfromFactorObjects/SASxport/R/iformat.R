iformat <- function(x, default)
  UseMethod("iformat")

iformat.default <- function(x, default=NULL)
{
  lab <- attr(x,"iformat")
  if(is.null(lab))
    default
  else
  lab
}

"iformat<-" <- function(x, value)
  UseMethod("iformat<-")

"iformat<-.default" <- function(x, value)
{
  attr(x,'iformat') <- value
  x
}
