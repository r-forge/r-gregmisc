\name{numcpu.lsf}
\alias{numcpu.lsf}
\title{Determine the number of CPUs assigned by LSF}
\description{
  Determine the number of CPUs assigned by LSF.
}
\usage{
numcpu.lsf(default)
}
\arguments{
  \item{default}{If present, A default number of CPUs to use if unable to determine
    the number from LSF, otherwise fail.}
}
\details{
  This function determines the number of hosts present in the LSB_HOSTS
  environement variable.  If the environment variable does not exist or
  is empty, the value provided in \code{default} will be used.  If no
  \code{default} was provided, an error will be generated.
}
\value{
  The number of nodes assigned to by LSF.
}
%\references{ ~put references to the literature/web site here ~ }
\author{Gregory R. Warnes \email{gregory\_r\_warnes@groton.pfizer.com}}
%\seealso{ ~~objects to See Also as \code{\link{~~fun~~}}, ~~~ }
\examples{
   # get the number of cpus, fail if unable to do so
   numcpu.lsf()

   # get the number of cpus, use '8' if unable to do so
   numcpu.lsf(default=8)

}
\keyword{utilities}
