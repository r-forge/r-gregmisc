Args <- function(name, sort.args=FALSE)
{
  a <- formals(get(as.character(substitute(name))))
  if(is.null(a))
    return(NULL)
  arg.labels <- names(a)
  arg.values <- as.character(a)
  char <- sapply(a, is.character)
  arg.values[char] <- paste("\"", arg.values[char], "\"", sep="")

  if(sort.args)
  {
    ord <- order(arg.labels)
    if(any(arg.labels == "..."))
      ord <- c(ord[-1], length(ord))
    arg.labels <- arg.labels[ord]
    arg.values <- arg.values[ord]
  }

  output <- data.frame(value=I(arg.values), row.names=arg.labels)
  print(output, right=FALSE)

  invisible(output)
}
