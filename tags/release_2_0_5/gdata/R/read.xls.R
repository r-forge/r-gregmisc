# $Id$

read.xls <- function(xls, sheet = 1, verbose=FALSE, ..., perl="perl")
{
  ###
  # directories
  package.dir <- .path.package('gdata')
  perl.dir <- file.path(package.dir,'perl')
  #
  ###

  ###
  # files
  xls <- dQuote(xls) # dQuote in case of spaces in path
  xls2csv <- file.path(perl.dir,'xls2csv.pl')
  csv <- paste(tempfile(), "csv", sep = ".")
  #
  ###

  ###
  # execution command
  cmd <- paste(perl, xls2csv, xls, dQuote(csv), sheet, sep=" ")
  #
  ###

  ###
  # do the translation
  if(verbose)  cat("Executing ", cmd, "... \n")
  #
  results <- system(cmd, intern=!verbose)
  #
  if (verbose) cat("done.\n")
  #
  ###

  # prepare for cleanup now, in case of error reading file
  on.exit(file.remove(csv))  
  
  # now read the csv file
  out <- read.csv(csv, ...)

  # clean up
  file.remove(csv)
  
  return(out)
}
