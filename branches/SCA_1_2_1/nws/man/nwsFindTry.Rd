\name{nwsFindTry}
\alias{nwsFindTry}
\alias{nwsFindTry,netWorkSpace-method}
\title{Find something from the shared netWorkSpace (non-blocking)}
\description{
Find something from the shared netWorkSpace (non-blocking).
}

\usage{
nwsFindTry(.Object, xName, defaultVal=NULL)
}

\arguments{
   \item{.Object}{A netWorkSpace object}
   \item{xName}{Name of variable to be fetched}
   \item{defaultVal}{default value to return if xName is not found}
}

\details{
Look in the shared workSpace for a value bound to xName. 
If found, return in xName a value associated with xName. 
The third optional argument 'defaultVal' is returned if xName is not
found. if the third argument is missing failure to fetch will return
NULL.If there is more than one value associated with xName, the
particular value returned depends on varName's behavior. See
\code{\link{nwsStore}} for details.
}

\examples{
\dontrun{
x = nwsFindTry(ws, 'x', 0)
}
}
\keyword{methods}
\keyword{programming}
