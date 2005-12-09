\name{waitSleigh}
\alias{waitSleigh}
\alias{waitSleigh,sleighPending-method}
\title{Wait for outstanding tasks to complete and retrieve results}

\description{
Wait for all outstanding tasks created by eachElem or eachWorker to complete 
and retrieve those results.
}

\usage{
waitSleigh(.Object)
}

\arguments{
  \item{.Object}{a sleighPending object returned from non-blocking eachElem or non-blocking eachWorker}
}

\details{
Retrieve results from invocation of non-blocking eachElem or non-blocking eachWorker. 
If sleigh workers are still working tasks, wait for the results to return. 
}
\seealso{ \code{\link{eachWorker}}, \code{\link{eachElem}} }

\code{
\dontrun{
eo = list(blocking=0)
sp = eachWorker(s, function() {Sys.sleep(100)}, eo=eo) 
waitSleigh(sp)  # wait on workers. Each worker slept for 100 seconds. 
}
}

}
}
\keyword{methods}
\keyword{programming}
