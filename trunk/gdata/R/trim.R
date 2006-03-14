# $Id$

trim <- function(s)
  UseMethod("trim",s)

trim.default <- function(s)
  {
    s <- sub("^ +","",s)
    s <- sub(" +$","",s)
    s
  }

trim.character <- function(s)
{
  return(trim.default(s))
}

trim.factor <- function(s)
{
  levels(s) <- trim.default(levels(s))
  return(s)
}

