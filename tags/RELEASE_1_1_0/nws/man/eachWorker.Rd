\name{eachWorker}
\alias{eachWorker}
\alias{eachWorker,sleigh-method}
\title{eachWorker enforces each worker executes a function once}
\description{
eachWorker enforces each worker executes function fun exactly once.
}

\usage{
eachWorker(.Object, fun, ..., eo=NULL)
}

\arguments{
\item{.Object}{A sleigh object}
\item{fun}{function to run on remote nodes}
\item{...}{optional fixed arguments to be passed onto function "fun"}
\item{eo}{additional options, see details}
}

\details{
eo argument is used to set blocking or non-blocking eachWorker. 
By default, blocking mode is set 1, which means eachWorker does not 
return until every worker finish executes function fun. 
If blocking mode is 0,  then eachWorker returns immediately with a 
SleighPending object. Users can then use this object to invoke
checkSleigh to check the number of outstanding tasks, or invoke 
waitSleigh to wait for the results. 
}
\examples{
\dontrun{
# example 1
s = sleigh()
eachWorker(s, function() {'x<<-1'})
# eachElem can use global variable x initialized by eachWorker.
eachElem(s, function(y) {x+y}, list(1:10)) 

# example 2
options = list(blocking=0)
sp = eachWorker(s, function(z) {Sys.sleep(100)}, eo=options)
checkSleigh(sp)
waitSleigh(sp)	

# example 3
# pass in fixed arguments to eachWorker
eachWorker(s, function(x, y) {x+y}, 10, 5)
}
}
\keyword{methods}
\keyword{programming}
