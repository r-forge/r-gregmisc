\name{nwsFetchTry}
\alias{nwsFetchTry}
\alias{nwsFetchTry,netWorkSpace-method}
\title{Fetch something from the shared WorkSpace (non-blocking)}
\description{
Fetch something from the shared WorkSpace (non-blocking).
}

\usage{
nwsFetchTry(.Object, xName, defaultVal=NULL)
}

\arguments{
   \item{.Object}{A netWorkSpace object}
   \item{xName}{Name of variable to be fetched}
   \item{defaultVal}{default value to return if xName is not found}
}
\details{
Look in the shared workSpace for a value bound to xName.  If found,
remove a value associated with xName from nws and return it in
xName. The third optional argument 'default' is returned if xName is not
found. if the third argument is missing failure to fetch will return
NULL. This operation is atomic. If there is more than one value
associated with xName, the particular value removed depends on
xName's behavior.
}
\seealso{ \code{\link{nwsStore}}, \code{\link{nwsFetch}} }

\examples{
\dontrun{
ws = new(netWorkSpace, 'my space')
# To fecth value of variable 'x' from workspace 'ws, and to return NULL if not found:
nwsFetch(ws, 'xName')
# To fecth value of variable 'x' from workspace 'ws, and to return 10 if not found:
nwsFetch(ws, 'xName', 10)
}
}

\keyword{methods}
\keyword{programming}
