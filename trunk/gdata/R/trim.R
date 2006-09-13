# $Id$

trim <- function(s)
  UseMethod("trim", s)

trim.default <- function(s)
  s

trim.character <- function(s)
{
  s <- sub(pattern="^ +", replacement="", x=s)
  s <- sub(pattern=" +$", replacement="", x=s)
  s
}

trim.factor <- function(s)
{
  levels(s) <- trim(levels(s))
  s
}

trim.list <- function(s)
  lapply(s, trim)

trim.data.frame <- function(s)
{
  s[] <- trim.list(s)
  s
}
