\name{checkSleigh}
\alias{checkSleigh}
\alias{checkSleigh,sleighPending-method}
\title{Check for number of outstanding tasks}
\description{
Check for number of outstanding tasks.
}

\usage{
checkSleigh(.Object)
}

\arguments{
\item{.Object}{a sleighPending object returned from non-blocking eachElem or non-blocking eachWorker}
}

\details{
This method is only for non-blocking version of eachWorker and eachElem.
}
\seealso{ \code{\link{eachWorker}}, \code{\link{eachElem}} }

\examples{
\dontrun{
eo = list(blocking=0)

# returns immediately
sp = eachElem(s, function(x) {Sys.sleep(100); x}, list(1:10), eo=eo) 
checkSleigh(sp)  
}
}
\keyword{methods}
\keyword{programming}
