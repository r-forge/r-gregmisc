ll <- function(pos=1, unit=c("KB","MB","bytes"), digits=0, dimensions=FALSE,
               ...)
#############################################################################
###                                                                          
### Function: ll                                                             
###                                                                          
### Purpose:  Display information about objects in a given environment       
###                                                                          
### Args:     pos is the environment position number or name                 
###           unit is the required unit for displaying object size in memory
###           ("KB", "MB", "bytes", or first letter) digits is the number of
###           decimals to display dimensions is whether object dimensions
###           (dim or length) should be returned                            
###           ... is passed to ls()                                         
###                                                                         
### Returns:  Data frame containing information about objects (name, class,
###           size, and optionally dimensions)                               
###                                                                          
#############################################################################
{
  get.object.classname <- function(object.name, pos)
  {
    object <- get(object.name, pos=pos)
    classname <- class(object)[1]  # data.class() doesn't distinguish between integer and numeric
    return(classname)
  }

  get.object.dimensions <- function(object.name, pos)
  {
    object <- get(object.name, pos=pos)
    if(!is.null(dim(object)))                           # matrix, data.frame, ...
      dimensions <- paste(dim(object), collapse=" x ")
    else                                                # vector, list, model, trellis, ...
      dimensions <- length(object)
    return(dimensions)
  }

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

  unit <- unit[1]  # no need to match.arg strictly
  denominator <- switch(substring(tolower(unit),1,1), "k"=1024, "m"=1024^2, 1)
  size.label <- switch(substring(tolower(unit),1,1), "k"="KB", "m"="MB", "bytes")

  if(is.character(pos))
    pos <- match(pos, search())
  ## pos is now a number
  if(length(ls(pos,...)) == 0)
  {
    object.frame <- data.frame()
  }
  else if(search()[pos] == "Autoloads")
  {
    object.frame <- data.frame(rep("function",length(ls(pos,...))), rep(0,length(ls(pos,...))), row.names=ls(pos,...))
    if(dimensions == TRUE)
    {
      object.frame <- cbind(object.frame, rep("",nrow(object.frame)))
      names(object.frame) <- c("Class", size.label, "Dimensions")
    }
    else
      names(object.frame) <- c("Class", size.label)
  }
  else  # environment contains at least one object and is not named Autoloads
  {
    class.vector <- sapply(ls(pos,...), get.object.classname, pos=pos)
    size.vector <- sapply(ls(pos,...), get.object.size, pos=pos)
    size.vector <- round(size.vector/denominator, digits)
    object.frame <- data.frame(class.vector=class.vector, size.vector=size.vector, row.names=names(size.vector))

    names(object.frame) <- c("Class", size.label)
    if(dimensions == TRUE)
      object.frame <- cbind(object.frame, Dimensions=sapply(ls(pos,...), get.object.dimensions, pos=pos))
  }

  return(object.frame)
}
