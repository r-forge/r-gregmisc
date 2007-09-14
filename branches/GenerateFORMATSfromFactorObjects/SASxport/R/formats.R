formats <- function(x, default)
  UseMethod("formats")

formats.default <- function(x, default=NULL)
{
  lab <- attr(x,"format")
  if(is.null(lab))
    default
  else
  lab
}

"formats<-" <- function(x, value)
  UseMethod("formats<-")

"formats<-.default" <- function(x, value)
{
  attr(x,'format') <- value
  x
}
