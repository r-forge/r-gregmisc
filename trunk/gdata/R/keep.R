keep <- function(..., list=character(0), sure=FALSE)
{
  if(missing(...) && missing(list))
    stop("Keep something, or use rm(list=ls()) to clear workspace.")
  names <- as.character(substitute(list(...)))[-1]
  list <- c(list, names)
  keep.elements <- match(list, ls(1))

  if(any(is.na(keep.elements)))
    stop("You tried to keep \"", list[which(is.na(keep.elements))[1]],
         "\" which doesn't exist in workspace. Nothing was removed.", sep="")

  if(sure)
    rm(list=ls(1)[-keep.elements], pos=1)
  else
    return(ls(1)[-keep.elements])
}

