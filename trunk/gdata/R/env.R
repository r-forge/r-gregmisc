env <- function(unit=c("KB","MB","bytes"), digits=0)
###########################################################################################################################
###                                                                                                                       #
### Function: env                                                                                                         #
###                                                                                                                       #
### Purpose:  Display information about all loaded environments                                                           #
###                                                                                                                       #
### Args:     unit is the required unit for displaying object size in memory ("KB", "MB", "bytes", or first letter)       #
###           digits is the number of decimals to display                                                                 #
###                                                                                                                       #
### Returns:  Data frame containing information about environments (name, number of objects, and size in memory)          #
###                                                                                                                       #
###########################################################################################################################
{
  get.object.size <- function(object.name, pos)
  {
    object <- get(object.name, pos=pos)
    ## classes whose size is not defined, assume 0
    if(class(object)[1] %in% c("classRepresentation","ClassUnionRepresentation","grob"))
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

  unit <- unit[1]  # no need to match.arg strictly
  denominator <- switch(substring(tolower(unit),1,1), "k"=1024, "m"=1024^2, 1)
  size.label <- switch(substring(tolower(unit),1,1), "k"="KB", "m"="MB", "bytes")
  size.vector <- sapply(seq(along=search()), get.environment.size)
  size.vector <- round(size.vector/denominator, digits)
  nobjects.vector <- sapply(seq(along=search()), get.environment.nobjects)
  env.frame <- data.frame(search(), nobjects.vector, size.vector)
  names(env.frame) <- c("Environment", "Objects", size.label)

  print(env.frame, right=FALSE)
  invisible(env.frame)
}
