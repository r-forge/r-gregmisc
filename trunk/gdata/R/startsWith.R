startsWith <- function(str, pattern, trim=FALSE)
  {
    if(trim) str <- trim(str)
    substr(str,start=1,stop=nchar(pattern))==pattern
  }
