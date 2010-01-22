## s$Id$

read.xls <- function(xls, sheet = 1, verbose=FALSE, pattern, ...,
                     method=c("csv","tab"), perl="perl")
{
  con <- tfn <- NULL
  on.exit({ 
    if (inherits(con, "connection") && isOpen(con)) close(con)
    if (file.exists(tfn)) file.remove(tfn)
  })

  method <- match.arg(method)
  
  ## expand file path, translating ~ to user's home directory, etc.
  xls <- path.expand(xls)


  ## translate from xls to csv/tab format (returns csv file name)
  if(method=="csv")
    con <- xls2csv(xls, sheet, verbose=verbose, ..., perl = perl)
  else if(method=="tab")
    con <- xls2tab(xls, sheet, verbose=verbose, ..., perl = perl)
  else
    stop("Unknown method", method)

  ## load the csv file
  open(con)
  tfn <- summary(con)$description
  if (missing(pattern))
    {
      if(verbose)
        cat("Reading", method, "file ", dQuote.ascii(tfn), "...\n")
      else
        cat("Reading", method, "file... ")
      
      if(method=="csv")
        retval <- read.csv(con, ...)
      else if (method=="tab")
        retval <- read.delim(con, ...)
      else
        stop("Unknown method", method)
        
      cat("Done.\n")
    }
  else {
    cat("Searching for lines containing pattern ", pattern, "... ")
    idx <- grep(pattern, readLines(con))
    if (length(idx) == 0) {
      warning("pattern not found")
      return(NULL)
    }
    cat("Done.\n")
    
    seek(con, 0)

    if(verbose)
      cat("Reading", method, "file ", dQuote.ascii(tfn), "...\n")
    else
      cat("Reading", method, "file... ")       

    if(method=="csv")
      retval <- read.csv(con, skip = idx[1]-1, ...)
    else if (method=="tab")
      retval <- read.delim(con, skip = idx[1]-1, ...)
    else
      stop("Unknown method", method)

    cat("Done.\n")     
  }
  retval
}

