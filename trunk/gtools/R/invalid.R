invalid <- function(x)
  {
    if( missing(x) || is.null(x) || length(x)==0 )
      return(FALSE)
    if(is.list(x)) 
      return(all(sapply(x,invalid)))
    else
      return(all(is.na(x)))
  }
