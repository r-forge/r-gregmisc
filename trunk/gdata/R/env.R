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
    if(search()[pos] == "Autoloads")
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

  unit <- unit[1]
  denominator <- switch(substring(tolower(unit),1,1), "k"=1024, "m"=1024^2, 1)
  size.label <- switch(substring(tolower(unit),1,1), "k"="KB", "m"="MB",
                  "bytes")
  size.vector <- sapply(seq(along=search()), get.environment.size)
  size.vector <- round(size.vector/denominator, digits)
  nobjects.vector <- sapply(seq(along=search()), get.environment.nobjects)
  env.frame <- data.frame(search(), nobjects.vector, size.vector)
  names(env.frame) <- c("Environment", "Objects", size.label)

  print(env.frame, right=FALSE)
  invisible(env.frame)
}

