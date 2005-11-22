\name{nwsMktempWs}
\alias{nwsMktempWs}
\alias{nwsMktempWs,nwsServer-method}
\title{Returns a text string containing a list of workspaces in a server object}
\description{
Returns a text string containing a list of workspaces in a server object.
}

\usage{
nwsMktempWs(.Object, wsNameTemplate)
}

\arguments{
   \item{.Object}{A nwsServer object}
   \item{wsNameTemplate}{Text string}
}

\details{
}

\example{
\dontrun{
s = new("nwsServer")
tws = nwsMktempWs(s, "_temp_%d")
}
}

\keyword{methods}
\keyword{programming}
