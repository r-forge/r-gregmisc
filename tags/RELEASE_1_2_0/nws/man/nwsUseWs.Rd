\name{nwsUseWs-methods}
\alias{nwsUseWs}
\alias{nwsUseWs,nwsServer-method}
\title{ Return a workspace object,  do not claim ownership}
\description{
Return a workspace object. Do not claim ownership.
}

\usage{
nwsUseWs(.Object, wsName, space=NULL)
}

\arguments{
   \item{.Object}{A nwsServer object}
   \item{wsName}{Name of workSpace}
   \item{space}{A netWorkSpace object}
}

\examples{
\dontrun{
s = new("nwsServer")
ws = nwsUseWs(s, "my space")
}
}
 
\keyword{methods}
\keyword{programming}
