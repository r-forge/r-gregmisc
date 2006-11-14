# $Id$

c.factor <- function(...,
                     recursive=FALSE # ignored
                     )
{
  dots <- list(...) # recursive below is not related to one above!
  mapCha <- c(mapLevels(dots, codes=FALSE), recursive=TRUE)
  class(mapCha) <- "levelsMap"
  dots <- unlist(lapply(dots, "mapLevels<-", mapCha))
  mapLevels(dots) <- mapLevels(as.character(mapCha))
  dots
}



                                               
                                            
