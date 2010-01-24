\name{sheetNames}
\Rdversion{1.1}
\alias{sheetCount}
\alias{sheetNames}
\title{
Count sheets in Excel xls spreadsheet.
}
\description{
Count the sheets in an Excel xls spreadsheet.
}
\usage{
sheetCount(xls, verbose = FALSE, perl = "perl")
sheetNames(xls, verbose = FALSE, perl = "perl")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{xls}{
File path to spreadsheet.  Is downloaded if it begins with \code{"http://"}.}
  \item{verbose}{
 If \code{TRUE} additional information displayed.
}
  \item{perl}{
	Path and file of perl interpreter or just \code{"perl"} if perl on path.
}
}
\value{
\code{sheetCount} returns the number of sheets in the spreadsheet 
and \code{sheetNames} returns
a character vector containing the sheet names in the spreadsheet.
}

\seealso{
	\code{\link{read.xls}}, \code{\link{xls2csv}}.
}
\examples{
   xlsfile <- system.file("xls", "iris.xls", package = "gdata")
   xlsfile

   sheetCount(xlsfile)

}
\keyword{ misc }
