# $Id$

parse822 <- function( filename )
  {
    
    fileH <- file(filename,"r")
    text <- readChar(fileH, nchars=1e5)
    close(fileH)

    text <- gsub("\n([ \t]*\n)+","\n",text) # remove whitespace only lines

    text <- gsub("\n[ \t]+"," ",text)       # \n+whitespace continues same field
    text <- unlist(strsplit(text, "\n"))    # split on \n
    text <- gsub("[ \t]+"," ",text)         # condense multiple spaces
    text <- gsub("^[ \t]+","",text)         # remove excess leading space
    text <- gsub("[ \t]+:",":",text )       # remove excess space before sep
    text <- gsub(":[ \t]+",":",text )       # remove excess space after sep
    text <- gsub("[ \t]+$","",text)         # remove excess trailing space
    text <- strsplit(text,':')

    # make into list with named elements
    retval <- lapply(text, function(x) if(length(x)>=2) x[2] else NULL)
    namelist <- sapply(text, function(x) x[1])
    names(retval) <- tolower(namelist) # force names to lower case

    retval
  }

