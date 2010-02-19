## s$Id: read.xls.R 1342 2009-07-16 02:49:11Z warnes $

## Double quote string using *ASCII* double quotes.
##
## (The base 'dQuote' uses local-specific quotes (e.g UTF-8 quotes)
## which Unix command line doesn't like.)
##
dQuote.ascii <- function(x) paste('"',x,'"',sep='')

findPerl <- function(perl, verbose = "FALSE") {

	if (missing(perl)) {
		if (.Platform$OS == "windows") {
			perl <- Sys.which("perl")
			if (perl == "") stop("perl not found. Use perl= argument.")
			if (length(grep("rtools", tolower(perl))) > 0) {
				perl.ftype <- shell("ftype perl", intern = TRUE)
				if (length(grep("^perl=", perl.ftype)) > 0) {
					perl <- sub('^perl="([^"]*)".*', "\\1", perl.ftype)
				}
			}
		}
		if (perl == "perl") perl <- Sys.which("perl")
	}

	if (verbose) cat("Using perl at", perl, "\n")

	perl
}


