read.xls <- function(xls, sheet = 1, verbose=FALSE, ...) {
  xls <- dQuote(xls) # dQuote in case of spaces in path
  xls2csv <- file.path(.path.package('gregmisc'),'bin','xls2csv')
  csv <- paste(tempfile(), "csv", sep = ".")
  cmd <- paste(xls2csv, xls, dQuote(csv), sheet, sep=" ")
  if(verbose)  cat("Executing ", cmd, "... \n") 
  results <- system(cmd, intern=!verbose)
  if (verbose) cat("done.\n")
  out <- read.csv(csv, ...)
  file.remove(csv)
  out
}
