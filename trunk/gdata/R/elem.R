elem <- function(object, unit=c("KB", "MB", "bytes"), digits=0, dimensions=FALSE)
###########################################################################################################################
###                                                                                                                       #
### Function: elem                                                                                                        #
###                                                                                                                       #
### Purpose:  Display information about elements in a given object                                                        #
###                                                                                                                       #
### Args:     object is an object containing named elements, perhaps a model or data.frame                                #
###           unit is the required unit for displaying object size in memory ("KB", "MB", "bytes", or first letter)       #
###           digits is the number of decimals to display                                                                 #
###           dimensions is whether object dimensions (dim or length) should be returned                                  #
###                                                                                                                       #
### Returns:  Data frame containing information about object elements (name, class, size, and optionally dimensions)      #
###                                                                                                                       #
###########################################################################################################################
{
  get.element.classname <- function(object, element.name)
  {
    element <- object[[match(element.name, names(object))]]
    classname <- class(element)[1]  # data.class() doesn't distinguish between numeric and integer
    return(classname)
  }

  get.element.dimensions <- function(object, element.name)
  {
    element <- object[[match(element.name, names(object))]]
    if(!is.null(dim(element)))                               # matrix, data.frame, ...
      dimensions <- paste(dim(element), collapse=" x ")
    else                                                     # vector, list, model, trellis, ...
      dimensions <- length(element)
    return(dimensions)
  }

  get.element.size <- function(object, element.name)
  {
    element <- object[[match(element.name, names(object))]]
    ## classes whose size is not defined, assume 0
    if(class(element)[1] %in% c("classRepresentation","ClassUnionRepresentation","grob"))
      size <- 0
    else
      size <- object.size(element)
    return(size)
  }

  unit <- unit[1]  # no need to match.arg strictly
  if(is.null(names(object)))
    element.frame <- data.frame()
  else  # object has elements
  {
    class.vector <- sapply(names(object), get.element.classname, object=object)
    size.vector <- sapply(names(object), get.element.size, object=object)
    if(is.data.frame(object))                                                      # if object is data.frame,
    {
      class.vector <- c(class(row.names(object))[1], class.vector)
      size.vector <- c("<row.names>"=object.size(row.names(object)), size.vector)  # then include size of row.names
    }
    denominator <- switch(substring(tolower(unit),1,1), "k"=1024, "m"=1024^2, 1)
    size.label <- switch(substring(tolower(unit),1,1), "k"="KB", "m"="MB", "bytes")
    size.vector <- round(size.vector/denominator, digits)
    element.frame <- data.frame(class.vector=class.vector, size.vector=size.vector, row.names=names(size.vector))
    names(element.frame) <- c("Class", size.label)
    if(dimensions==TRUE & is.data.frame(object))
      element.frame <- cbind(element.frame, Dim=c(nrow(object),sapply(names(object),get.element.dimensions,object=object)))
    else if(dimensions==TRUE & !is.data.frame(object))
      element.frame <- cbind(element.frame, Dim=sapply(names(object),get.element.dimensions,object=object))
  }

  return(element.frame)
}
