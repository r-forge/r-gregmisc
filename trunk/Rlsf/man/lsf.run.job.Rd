\name{lsf.run.job}
\alias{lsf.run.job}
\title{Evaluate a function synchronously through LSF}
\description{
  Evaluates an \R function synchronously through the LSF queuing
  system. 
}
\usage{
lsf.run.job(func, ..., savelist = c(), interval = 15)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{func}{This argument provides the name of the function that will
    be evaluated through LSF. It must be defined in the current scope.}
  \item{\dots}{Any arguments to \code{func} should be passed after the
    function name. They must be within the current scope, and must be
    provided to the remote function call as part of the
    \code{savelist}}
  \item{savelist}{A list of symbols to export to the remote
    environment. Any arguments to \code{func} should be listed in the
    savelist.}
  \item{interval}{Defines the amount of time (in seconds) to wait
    between polls for the job status. If this is too low, it will cause
    undue load on the LSF scheduler.}
}
\details{
  \code{lsf.run.job} is a convenience function that provides the
  ability to synchronously evaluate an \R function through LSF. It is
  implemented by composing the \code{lsf.submit},
  \code{lsf.job.status}, and \code{lsf.get.result} \R functions. 
}
\value{
  Returns the result of \code{func} as evaluated through LSF.
}
\author{Chris Smith \email{csmith@platform.com}}
\seealso{\code{\link{lsf.submit}}, \code{\link{lsf.job.status}},
  \code{\link{lsf.get.result}}} 
\examples{

   # define the function to remotely run
   myfunc <- function() { 2+3 }

   # submit the function to run in batch
   result <- lsf.run.job(myfunc)

}
\keyword{utilities}
