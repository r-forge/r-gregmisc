\name{write.xport}
\alias{write.xport}
\title{Write Data to a SAS XPORT File}
\description{
  This function writes one or more data frames into a SAS XPORT format
  library file.
}
\usage{
write.xport(...,
            list=base::list(),
            file = stop("'file' must be specified"),
            verbose=FALSE,
            sasVer="7.00",
            osType,
            cDate=Sys.time(),
            formats=NULL,
            autogen.formats=TRUE
 )
}
\arguments{
  \item{\dots}{One or more data frames to be stored}  
  \item{list}{A list containing data frames to be stored.}
  \item{file}{File name or connection object. Use "" to view the raw data}
  \item{verbose}{Logical flag controlling whether status is reported
    during processing}
  \item{sasVer}{SAS version string}
  \item{osType}{Opererating system, defaults to "R X.Y.Z" for
    appropriate values of X, Y, and Z}
  \item{cDate}{Date object specifying dataset creation date}
  \item{formats}{Optional data frame containing SAS format information.}
  \item{autogen.formats}{Logical indiciating whether SAS formats should be
    auto-generated for factor variables.}
}
\details{
  The function creates a SAS XPORT data file (see reference) from one or
  more data frames.  This file format imposes a number of constraints:
  \itemize{
    \item Data set and variable names are truncated to 8 characters and
      converted to upper case.  All characters outside of the set A-Z,
      0-9, and '\_' are converted to '\_'.
    \item Character variables are stored as characters.
    \item If \code{make.formats=TRUE} (the default), factor variables are stored as numeric with an appropriate SAS
      format specification. If \code{make.formats=FALSE}, factor
      variables are stored as characters.
    \item All numeric variables are stored as double-precision floating
      point values utilizing the IBM mainframe double precision floating
      point format (see the reference).
    \item Date and time variables are either converted to number of days since
      1960-01-01 (date only), or number of seconds since
      1960-01-01:00:00:00 GMT (date-time variables).  
    \item Missing values are converted to the standard SAS missing value
      '.'
  }

  In addition, the SAS XPORT format allows each variable to have a
  corresponding label, display format, and input format.  To set these
  values, add the   attribute 'label', 'format', or 'iformat' to
  individual data frame variables. (See the example section.)

  The actual translation of R objects to objects appropriate for SAS is
  handled by the \code{\link{toSAS}} generic and associated methods.   
}
\value{
  No return value
}
\references{
  SAS Technical Support document TS-140: ``The Record Layout of a
  Data Set in SAS Transport (XPORT) Format'' available at
  \url{http://ftp.sas.com/techsup/download/technote/ts140.html}.
}
\author{Gregory R. Warnes \email{greg@random-technologies-llc.com}}
\note{
   This package was created by Random Technologies LLC
   \url{http://random-technologies-llc.com}
   with partial funding by Metrum Institute
   \url{http://metruminstitute.org}. 

  Technical support contracts for this and other R packages are available
  from Random Technologies LLC \url{http://random-technologies-llc.com}.

}
\seealso{
  \code{\link{toSAS}},
  \code{\link{lookup.xport}},
  \code{\link{read.xport}}
}
\examples{

#####
## R version of the example given in TS-140
#####

## manually create a data set
temp <- data.frame( x=c(1, 2, NA, NA ), y=c('a', 'B', NA, '*' ) )

## look at it
temp

## add a format specifier (not used by R)
attr(temp$x, 'format') <- 'date7.'

## add a variable label (not used by R)
attr(temp$y, 'label')  <- 'character variable'

## verify the additions
str(temp)

## rename the data set
abc <- temp

# create a SAS XPORT file 
write.xport( abc, file="xxx.dat" )

# list the contents of the file
lookup.xport("xxx.dat")

## reload the data
xxx.abc <- read.xport("xxx.dat")

## and look at it
xxx.abc

## Note that the variable names have been converted to uppercase

}
\keyword{file}
