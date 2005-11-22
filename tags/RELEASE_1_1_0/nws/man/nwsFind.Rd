\name{nwsFind}
\alias{nwsFind}
\alias{nwsFind,netWorkSpace-method}
\title{Find something from the shared netWorkSpace (blocking)}

\description{
Find something from the shared netWorkSpace (blocking).
}

\usage{
nwsFind(.Object, xName)
}

\arguments{
\item{.Object}{A netWorkSpace object}
\item{xName}{Name of variable to be fetched}
}

\details{
Block until a value for varName is found in the shared workSpace ws.
Once found, return in X a value associated with varName. If
there is more than one value associated with varName, the
particular value returned depends on varName's behavior. See
\code{\link{nwsStore}} for details.
}

\examples{
\dontrun{
x = nwsFind(ws, 'x')
}
}

\keyword{methods}
\keyword{programming}
