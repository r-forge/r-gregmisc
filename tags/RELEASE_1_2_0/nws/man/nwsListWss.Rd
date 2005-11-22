\name{nwsListWss}
\alias{nwsListWss}
\alias{nwsListWss,nwsServer-method}
\title{Returns a text string containing a list of workspaces in a server object}
\description{
Returns a text string containing a list of workspaces in a server object.
}

\usage{
nwsListWss(.Object)
}

\arguments{
  \item{.Object}{A nwsServer object}
}

\details{
}

\example{
\dontrun{
   s = new("nwsServer")
   ws1 = openWss(s, "my space")
   # ...
   ws2 = openWss(s, "other space")
   # ...
   nwsListWss(s)
}
}
\keyword{methods}
\keyword{programming}
