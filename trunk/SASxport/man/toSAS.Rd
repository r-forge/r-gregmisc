\name{toSAS.default}
\alias{toSAS}
\alias{toSAS.numeric}
\alias{toSAS.logical}
\alias{toSAS.character}
\alias{toSAS.factor}
\alias{toSAS.POSIXt}
\alias{toSAS.Date}
\alias{toSAS.default}
\title{Convert R data object for storage in SAS xport file}
\description{
  The \code{toSAS} methods control how R objects and data types are
  represented when stored into a SAS xport format file using
  \code{write.xport}.  
}
\usage{
toSAS(x, format)
\method{toSAS}{default}(x, format="")
\method{toSAS}{numeric}(x, format="")
\method{toSAS}{logical}(x, format="")
\method{toSAS}{character}(x, format="")
\method{toSAS}{factor}(x, format="")
\method{toSAS}{POSIXt}( x, format="DATETIME16." )
\method{toSAS}{Date}(x, format="DATE9." )
}
\arguments{
  \item{x}{ Object to be converted }
  \item{format}{SAS format name}
}
\details{
  To add support for a new object type, create an appropriate
  \code{toSAS} method.  This method must convert the object data to
  either an object of type "numeric" or type "character", and should add
  an attribute named "format" to the object providing an appropriate SAS
  format string or "" (indicating the default SAS format).
}
\value{
  A vector of type "character" or of type "numeric", with an attribute
  named "lable" containing the SAS format specification.
}
\author{ Gregory R. Warnes \email{greg@random-technologies-llc.com} }
\seealso{
  \code{\link{write.xport}},
  \code{\link{read.xport}},
  \code{\link{lookup.xport}}
}
\examples{

####
## See how an R date object will be stored in a SAS xport file:
####

dateObj <- ISOdate(2007,08,01,10,14,37)
dateObj

sasObj <- toSAS(dateObj)
str(sasObj)

####
## Create a new R object class based on factor to hold color names
####
colorFactor <- function(x) # constructor
  {
    retval <- factor(x, levels=c("Red","Green","Blue") )
    class(retval) <- c("colorFactor","factor")
    retval
  }

## create one and look at it
cf <- colorFactor( c("Red","Red","Blue",NA) )


## See how it will be represented in a SAS xport file
toSAS(cf)
class(toSAS(cf))

## Create a new conversion function to store as a RGB hex value
toSAS.colorFactor <- function(x, format="")
{
   retval <- ifelse(x=="Red", "#FF0000", ifelse(x=="Green", "#00FF00", "#0000FF") )
   attr(retval, "format") <- format
   retval
}

## see it in action
toSAS(cf)

}
\keyword{manip}
\keyword{IO}
