\name{read.xls}
\alias{read.xls}
\title{Read Excel files}
\description{Reads a Microsoft Excel file into a data frame}
\usage{
read.xls(xls, sheet=1, verbose=FALSE, ...)
}
\arguments{
  \item{xls}{name of the Microsoft Excel file}
  \item{sheet}{number of sheet within the Excel file from which data are
    to be read}
  \item{verbose}{logical flag idicating whether details should be
    printed as the file is processed.}
  \item{...}{additional arguments to read.table. The defaults of
    read.csv are used.}
}
\value{
  a data frame
}
\details{
  This function works translating the named Microsoft Excel file into a
  temporary .csv file, using Greg Warnes' xls2csv perl script (installed
  as part of the gregmisc package).

  Note that, in the conversion to csv, strings will be quoted. This is a
  problem if you are trying to use the \code{comment.char} option of
  \code{read.table} since the first character of all lines (including
  comment lines) will be "\"" after conversion.
}
\references{http://www.analytics.washington.edu/statcomp/downloads/xls2csv}
\seealso{ \code{\link[base]{read.csv}} }
\examples{

   # iris.xls is included in the gregmisc package for use as an example
   xlsfile <- file.path(.path.package('gregmisc'),'xls','iris.xls')
   xlsfile

   iris <- read.xls(xlsfile)  

}
\author{Jim Rogers \email{james_a_rogers@groton.pfizer.com}, modified
  and extenede by Gregory R. Warnes \email{gregory_r_warnes@groton.pfizer.com}.
}
\keyword{file}
