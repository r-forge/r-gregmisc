# $Id$

trim <- function(s)
  {
    s <- sub("^ +","",s)
    s <- sub(" +$","",s)
    s
  }
