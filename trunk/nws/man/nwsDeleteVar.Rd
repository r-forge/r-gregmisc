\name{nwsDeleteVar}
\alias{nwsDeleteVar}
\alias{nwsDeleteVar,netWorkSpace-method}
\title{Delete a variable from a shared netWorkSpace}

\description{
Delete a variable from a shared netWorkSpace.
}

\usage{
nwsDeleteVar(.Object, xName)
}

\arguments{
  \item{.Object}{A netWorkSpace object}
  \item{xName}{Name of variable to be stored}
}
\examples{
\dontrun{
ws = new("netWorkSpace", "my space")
nwsDeleteVar(ws, 'x')
}
}
\keyword{methods}
\keyword{cluster}
