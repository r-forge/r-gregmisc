elem <- function(object, unit=c("KB","MB","bytes"), digits=0, dimensions=FALSE)
{
  get.element.classname <- function(object, element.name)
  {
    element <- object[[match(element.name, names(object))]]
    classname <- class(element)[1]
    return(classname)
  }

  get.element.dimensions <- function(object, element.name)
  {
    element <- object[[match(element.name, names(object))]]
    if(!is.null(dim(element)))
      dimensions <- paste(dim(element), collapse=" x ")
    else
      dimensions <- length(element)
    return(dimensions)
  }

  get.element.size <- function(object, element.name)
  {
    element <- object[[match(element.name, names(object))]]
    use.zero <- c("classRepresentation", "ClassUnionRepresentation", "grob")
    if(class(element)[1] %in% use.zero)
      size <- 0
    else
      size <- object.size(element)
    return(size)
  }

  unit <- unit[1]
  if(is.null(names(object)))
  {
    element.frame <- data.frame()
  }
  else
  {
    class.vector <- sapply(names(object), get.element.classname, object=object)
    size.vector <- sapply(names(object), get.element.size, object=object)
    if(is.data.frame(object))
    {
      class.vector <- c(class(row.names(object))[1], class.vector)
      size.vector <- c("<row.names>"=object.size(row.names(object)),
                       size.vector)
    }
    denominator <- switch(substring(tolower(unit),1,1), "k"=1024, "m"=1024^2, 1)
    size.label <- switch(substring(tolower(unit),1,1), "k"="KB", "m"="MB",
                    "bytes")
    size.vector <- round(size.vector/denominator, digits)
    element.frame <- data.frame(class.vector=class.vector,
                       size.vector=size.vector, row.names=names(size.vector))
    names(element.frame) <- c("Class", size.label)
    if(dimensions==TRUE && is.data.frame(object))
    {
      element.frame <- cbind(element.frame, Dim=c(nrow(object),
                         sapply(names(object),get.element.dimensions,
                         object=object)))
    }
    else if(dimensions==TRUE && !is.data.frame(object))
      element.frame <- cbind(element.frame, Dim=sapply(names(object),
                         get.element.dimensions,object=object))
  }

  return(element.frame)
}

