\name{nwsOpenWs}
\alias{nwsOpenWs}
\alias{nwsOpenWs,nwsServer-method}
\title{ Return a workspace object, claim ownership if not owned}
\description{
Return a workspace object. Claim ownership if not owned.
}

\usage{
nwsOpenWs(.Object, wsName, space=NULL, ...)
}

\arguments{
  \item{.Object}{A nwsServer object}
  \item{wsName}{Name of workSpace to be deleted}
  \item{space}{A netWorkSpace object}
  \item{...}{Optinal arguments related to persistence}
}

\examples{
\dontrun{
s = new("nwsServer")
ws = openWs(s, "my space")
}
}
 
\keyword{methods}
\keyword{programming}
