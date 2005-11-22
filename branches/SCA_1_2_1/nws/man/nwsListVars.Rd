\name{nwsListVars}
\alias{nwsListVars}
\alias{nwsListVars,netWorkSpace-method}
\title{List variables in a netWorkSpace}
\description{
List variables in a netWorkSpace.
}

\usage{
nwsListVars(.Object, wsName='')
}

\arguments{
  \item{.Object}{A netWorkSpace object}
  \item{wsName}{Name of netWorkSpace}
}

\details{
Return listing of variables in the named netWorkSpace.
To see list output clearly use: write(nwsListVars(), stdout())
}
\keyword{methods}
\keyword{programming}
