\name{signame}
\alias{signame}
\alias{siginfo}
\alias{siglist}
\title{Obtain information about signals}.
\description{
  \code{signame} looks up signal information by the symbolic signal name.
  \code{sigval}  looks up signal information by the numeric value.
  \code{siglist} returns a table of signal information.
}
\usage{
signame(val)
siginfo(name)
siglist()
}
\arguments{
  \item{val}{Integer signal value.}
  \item{name}{Symbolic signal name (with or without the SIG prefix).}
}
\details{
  These functions return information stored in a table constructed at
  compile time.
}
\value{
  A vector (\code{signame}, \code{siginfo}) or data frame
  (\code{siglist}) containing the components:
  \item{name}{Symbolic name}
  \item{val}{Integer value}
  \item{desc}{Description}
}
\references{Unix "signal" man page.}
\author{ Gregory R. Warnes \email{gregory\_r\_warnes\@groton.pfizer.com}}
\seealso{\code{\link{getpid}}, \code{\link{exit}}, \code{\link{wait}},
         \code{\link{kill}}, \code{\link{killall}}}}
\examples{

   # look up the numeric value for SIGABT:
   sigval("SIGABT")

   # the 'SIG' component can be ommitted:
   sigval("HALT")

   # now look up based on value
   signame(9)

   # and get a complete table of signal information
   siglist()
}
\keyword{programming}
