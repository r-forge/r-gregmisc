% $Id$
\name{getpid}
\alias{getpid}
\title{Obtain the process id for the current process.}
\description{
  Obtain the process number for the current process.
}
\usage{
getpid()
}
\details{
  This function is a simple wrapper around the Unix "getpid" function call.
}
\value{
  Integer process id.
}
\references{Unix "getpid" man page}
\author{ Gregory R. Warnes \email{gregory\_r\_warnes\@groton.pfizer.com}}
\seealso{\code{\link{fork}}, \code{\link{exit}}, \code{\link{wait}},
         \code{\link{kill}}, \code{\link{killall}}}}
\examples{

for(i in 1:10)
  fork( function() cat("PID:", getpid(), "\n") )
}
\keyword{programming}
