\name{units}
\alias{units}

\alias{units.default}

\alias{units<-}

\alias{label}
\alias{label<-}

\alias{formats}
\alias{formats<-}

\alias{iformat}
\alias{iformat<-}
\title{
Set or Retreive the Label, Format, iFormat, or Units Attribute of a Vector  
}
\description{
  Sets or retrieves the \code{"label"}, \code{"format"},
  \code{"iformat"}, or \code{"units"} attribute of an object.

  More comprehensive support for object labels, formats, and units are
  available in Frank Harrell's \code{Hmisc} package.
}
\usage{
units(x, ...)
\method{units}{default}(x, none='', \dots)
units(x) <- value
}
\arguments{
\item{x}{any object}
\item{\dots}{ignored}
\item{value}{the units of the object, or ""}
\item{none}{value to which to set result if no appropriate attribute is
  found}
}
\value{
the units attribute of x, if any; otherwise, the \code{units} attribute of
the \code{tspar} attribute of \code{x} if any; otherwise the value \code{none}
}
\author{Gregory R. Warnes \email{greg@random-techologies-llc.com} based
  on code from the \code{Hmisc} library by Frank E. Harrell, Jr.}
\seealso{\code{\link{label}}}
\examples{
fail.time <- c(10,20)
units(fail.time) <- "Day"
label(fail.time) <- 'Failure Time'
fail.time
\dontrun{

# for a nice display
library(Hmisc)
describe(fail.time)



f <- cph(Surv(fail.time, event) ~ xx)
plot(xx,xx2,xlab=paste(label(xx),", ",units(xx),"s",sep=""))
}
}
\keyword{utilities}
\keyword{interface}
% Converted by Sd2Rd version 1.21.
