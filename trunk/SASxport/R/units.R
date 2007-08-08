units <- function(x, default)
  UseMethod("units")

units.default <- function(x, default=NULL)
{
  lab <- attr(x,"units")
  if(is.null(lab))
    default
  else
  lab
}

"units<-" <- function(x, value)
  UseMethod("units<-")

"units<-.default" <- function(x, value)
{
  attr(x,'units') <- value
  x
}
