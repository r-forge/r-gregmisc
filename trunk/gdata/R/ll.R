ll <- function(pos=1, unit=c("KB","MB","bytes"), digits=0, dimensions=FALSE,
        function.dim="", ...)
{
  get.object.classname <- function(object.name, pos)
  {
    object <- get(object.name, pos=pos)
    classname <- class(object)[1]
    return(classname)
  }

  get.object.dimensions <- function(object.name, pos)
  {
    object <- get(object.name, pos=pos)
    if(class(object) == "function")
      dimensions <- function.dim
    else if(!is.null(dim(object)))
      dimensions <- paste(dim(object), collapse=" x ")
    else
      dimensions <- length(object)
    return(dimensions)
  }

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

  unit <- match.arg(unit)
  denominator <- switch(unit, "KB"=1024, "MB"=1024^2, 1)

  if(is.character(pos))
    pos <- match(pos, search())

  if(length(ls(pos,...)) == 0)
  {
    object.frame <- data.frame()
  }
  else if(search()[pos] == "Autoloads")
  {
    object.frame <- data.frame(rep("function",length(ls(pos,...))),
                      rep(0,length(ls(pos,...))), row.names=ls(pos,...))
    if(dimensions == TRUE)
    {
      object.frame <- cbind(object.frame, rep("",nrow(object.frame)))
      names(object.frame) <- c("Class", unit, "Dimensions")
    }
    else
      names(object.frame) <- c("Class", unit)
  }
  else
  {
    class.vector <- sapply(ls(pos,...), get.object.classname, pos=pos)
    size.vector <- sapply(ls(pos,...), get.object.size, pos=pos)
    size.vector <- round(size.vector/denominator, digits)
    object.frame <- data.frame(class.vector=class.vector,
                      size.vector=size.vector, row.names=names(size.vector))
    names(object.frame) <- c("Class", unit)
    if(dimensions == TRUE)
      object.frame <- cbind(object.frame, Dim=sapply(ls(pos,...),
                        get.object.dimensions, pos=pos))
  }

  return(object.frame)
}

