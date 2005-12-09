\name{nwsFetch}
\alias{nwsFetch}
\alias{nwsFetch,netWorkSpace-method}
\title{Fetch something from the shared WorkSpace (blocking)}
\description{
Fetch something from the shared WorkSpace (blocking).
}
\usage{
nwsFetch(.Object, xName)
}

\arguments{
   \item{.Object}{A netWorkSpace object}
   \item{xName}{Name of variable to be fetched}
}
\details{
Block until a value for xName is found in the shared WorkSpace ".Object."
If found, remove a value associated with xName from workSpace corresponding
to .Object and return it in xName. Block if not found.  This operation is
atomic.  If there is more than one value associated with xName, the particular
value removed depends on xName's behavior. See \code{\link{nwsStore}} for details.
}
\seealso{ \code{\link{nwsStore}}, \code{\link{nwsFetchTry}} }

\examples{
\dontrun{
ws = new(netWorkSpace, 'my space')
nwsFetch(ws, 'x')
}
}
\keyword{methods}
\keyword{programming}
