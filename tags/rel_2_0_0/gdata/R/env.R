# $Id$

env <- function(unit=c("KB","MB","bytes"), digits=0)
{
  get.object.size <- function(object.name, pos)
  {
    object <- get(object.name, pos=pos)
    use.zero <- c("classRepresentation", "ClassUnionRepresentation", "grob")
    if(class(object)[1] %in% use.zero)
      size <- 0
    else
      size <- object.size(object)
    return(size)
  }

  get.environment.size <- function(pos)
  {
    if(search()[pos]=="Autoloads" || length(ls(pos,all=TRUE))==0)
      size <- 0
    else
      size <- sum(sapply(ls(pos,all=TRUE), get.object.size, pos=pos))
    return(size)
  }

  get.environment.nobjects <- function(pos)
  {
    nobjects <- length(ls(pos,all=TRUE))
    return(nobjects)
  }

  unit <- match.arg(unit)
  denominator <- switch(unit, "KB"=1024, "MB"=1024^2, 1)
  size.vector <- sapply(seq(along=search()), get.environment.size)
  size.vector <- round(size.vector/denominator, digits)
  nobjects.vector <- sapply(seq(along=search()), get.environment.nobjects)
  env.frame <- data.frame(search(), nobjects.vector, size.vector)
  names(env.frame) <- c("Environment", "Objects", unit)

  print(env.frame, right=FALSE)
  invisible(env.frame)
}

