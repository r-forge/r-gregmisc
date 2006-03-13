# $Id$

trim <- function(s)
  {
    s <- sub("^ +","",s)
    s <- sub(" +$","",s)
    s
  }

trim.character <- function(s)
{
  return(trim(s))
}

trim.factor <- function(s)
{
  levels(s) <- trim(levels(s))
  return(s)
}

