sheetCount <- function(xls, verbose = FALSE, perl = "perl")
{

  ##
  ## directories
  package.dir <- .path.package('gdata')
  perl.dir <- file.path(package.dir,'perl')
  ##
  ##

  ##
  ## files
  tf <- NULL
  if ( substring(xls, 1, 7) == "http://" ||
      substring(xls, 1, 6) == "ftp://" )
    {
      tf <- paste(tempfile(), "xls", sep = ".")
      if(verbose)
        cat("Downloading",
            dQuote.ascii(xls), " to ",
            dQuote.ascii(tf), "...\n")
      else
        cat("Downloading...\n")
      download.file(xls, tf, mode = "wb")
      cat("Done.\n")
      xls <- tf
    }
  ##
  
  sc <- file.path(perl.dir,'sheetCount.pl')
  
  ##
  ##

  ##
  ## execution command
  cmd <- paste(perl, sc, dQuote.ascii(xls), sep=" ")
  ##
  ##

  ##
  ## do the translation
  if(verbose)
    {
      cat("\n")
      cat("Extracting sheet count from\n")
      cat("   ", dQuote.ascii(xls), "\n")
      cat("... \n\n")
    }
  ##
  results <- system(cmd, intern=TRUE)
  ##
  if (verbose) cat("Done.\n\n")
  
  as.numeric(results)
}


