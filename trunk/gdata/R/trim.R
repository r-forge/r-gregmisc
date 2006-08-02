# $Id$

trim <- function(s)
  UseMethod("trim", s)

trim.default <- function(s)
  return(s)

trim.character <- function(s)
{
  s <- sub(pattern="^ +", replacement="", x=s)
  s <- sub(pattern=" +$", replacement="", x=s)
  return(s)
}

trim.factor <- function(s)
{
  levels(s) <- trim(levels(s))
  return(s)
}

trim.list <- function(s)
  return(lapply(s, trim))

trim.data.frame <- function(s)
{
  s[] <- trim.list(s)
  return(s)
}
