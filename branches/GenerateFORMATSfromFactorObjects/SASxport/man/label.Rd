\name{label}

\alias{label}
\alias{label.default}
\alias{label<-}
\alias{label<-.default}

\alias{formats}
\alias{formats.default}
\alias{formats<-}
\alias{formats<-.default}

\alias{iformat}
\alias{iformat.default}
\alias{iformat<-}
\alias{iformat<-.default}


\title{
Set or Retreive the 'label', 'format', or 'iformat' Attribute of a Vector  
}
\description{
  Sets or retrieves the \code{"label"}, \code{"format"}, or
  \code{"iformat"} attribute of an object.

  More comprehensive support for object labels, and formats, are
  available in Frank Harrell's \code{Hmisc} package.
}
\usage{
label(x, default)
label(x) <- value

formats(x, default)
formats(x) <- value

iformat(x, default)
iformat(x) <- value

}
\arguments{
\item{x}{any object}
\item{value}{new value for the  \code{"label"}, \code{"format"}, or
  \code{"iformat"} attribute of an object.}
\item{default}{value to return when no appropriate attribute is
  found.  The usual return value is NULL.}
}
\value{
  the contents of the \code{"label"}, \code{"format"}, or
  \code{"iformat"} attribute of x, if any; otherwise, the value provided
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
formats(fail.time) <- 'Numeric2'
iformat(fail.time) <- 'Numeric2'

# display individual attributes
label(fail.time)
formats(fail.time)
iformat(fail.time)

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

