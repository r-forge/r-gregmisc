\name{label}

\alias{label}
\alias{label.default}
\alias{label<-}
\alias{label<-.default}

\alias{SASformat}
\alias{SASformat.default}
\alias{SASformat<-}
\alias{SASformat<-.default}

\alias{SASiformat}
\alias{SASiformat.default}
\alias{SASiformat<-}
\alias{SASiformat<-.default}


\title{
Set or Retreive the 'label', 'SASformat', or 'SASiformat' Attribute of a Vector  
}
\description{
  Sets or retrieves the \code{"label"}, \code{"SASformat"}, or
  \code{"SASiformat"} attribute of an object.

  More comprehensive support for object labels, and SASformat, are
  available in Frank Harrell's \code{Hmisc} package.
}
\usage{
label(x, default)
label(x) <- value

SASformat(x, default)
SASformat(x) <- value

SASiformat(x, default)
SASiformat(x) <- value

}
\arguments{
\item{x}{any object}
\item{value}{new value for the  \code{"label"}, \code{"SASformat"}, or
  \code{"SASiformat"} attribute of an object.}
\item{default}{value to return when no appropriate attribute is
  found.  The usual return value is NULL.}
}
\value{
  the contents of the \code{"label"}, \code{"SASformat"}, or
  \code{"SASiformat"} attribute of x, if any; otherwise, the value provided
  by \code{default}.    
}
\author{Gregory R. Warnes \email{greg@random-techologies-llc.com} based
  on code from the \code{Hmisc} library by Frank E. Harrell, Jr.}
%\seealso{
%}
\examples{

fail.time <- c(10,20)

# set attributes
label(fail.time) <- 'Failure Time'
SASformat(fail.time) <- 'Numeric2'
SASiformat(fail.time) <- 'Numeric2'

# display individual attributes
label(fail.time)
SASformat(fail.time)
SASiformat(fail.time)

# display all attributes
attributes(fail.time)

# Example showing specification of default return value
a <- 70
label(a, default="no label")


\dontrun{
# for a nice display
library(Hmisc)
describe(fail.time)

f <- cph(Surv(fail.time, event) ~ xx)
plot(xx,xx2,xlab=label(xx),"s",sep=""))
}

}
\keyword{utilities}
\keyword{interface}

