keep <- function(..., list=character(0), sure=FALSE)
###########################################################################################################################
###                                                                                                                       #
### Function: keep                                                                                                        #
###                                                                                                                       #
### Purpose:  Remove objects from default workspace, except those specified                                               #
###                                                                                                                       #
### Args:     ... are objects to be kept, specified one by one, quoted or unquoted                                        #
###           list is a string vector of object names to be kept                                                          #
###           sure is whether to perform the removal, otherwise return names of objects that would have been removed      #
###                                                                                                                       #
### Notes:    Implemented with a few safety caps: all=T is not supported and sure=T is required to perform the removal    #
###                                                                                                                       #
### Returns:  String vector containing object names, or null if sure is TRUE                                              #
###                                                                                                                       #
###########################################################################################################################
{
  if(missing(...) & missing(list))
    stop("Keep something, or use rm(list=ls()) to clear workspace.")
  names <- as.character(substitute(list(...)))[-1]
  list <- c(list, names)
  keep.elements <- match(list, ls(1))

  if(sure == FALSE)
    return(ls(1)[-keep.elements])
  else
    rm(list=ls(1)[-keep.elements], pos=1)
}
