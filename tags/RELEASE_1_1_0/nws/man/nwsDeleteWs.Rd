\name{nwsDeleteWs}
\alias{nwsDeleteWs}
\alias{nwsDeleteWs,nwsServer-method}
\title{Delete a workspace form server}
\description{
Delete a workspace form server.
}

\usage{
nwsDeleteWs(.Object, 'wsName')
}
\arguments{
   \item{.Object}{A nwsServer object}
   \item{wsName}{Name of workSpace to be deleted}
}
\examples{
\dontrun{
# example 1
s = new("nwsServer")
ws = openWs(s, "my space")
# ...
nwsDeleteWs(s, "my space")

# example 2
ws = new("netWorkSpace", "my space")
# ...
nwsDeleteWs(ws@server, "my space")
}
}
 
\keyword{methods}
\keyword{programming}
