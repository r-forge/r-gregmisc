xport.character <- function( value, width )
  {
    if(length(value)!=1) stop("Only a single character value is permitted.")
    
    .C("fill_character_field",
       value = as.character(value),
       width = as.integer(width),
       PACKAGE="SASxport"
       )

    .Call("getRawBuffer", PACKAGE="SASxport")
  }
