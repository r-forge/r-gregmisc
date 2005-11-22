\name{nwsDeclare}
\alias{nwsDeclare}
\alias{nwsDeclare,netWorkSpace-method}
\title{Declare a mode for variable in a shared netWorkSpace}
\description{
Declare a mode for variable in a shared netWorkSpace.
}
\usage{
nwsDeclare(.Object, xName, mode)
}
\arguments{
   \item{.Object}{A netWorkSpace object}
   \item{xName}{Name of variable to be stored}
   \item{mode}{mode of the variable, see details}
}
\details{
If xName has not already been declared in nws, the behavior
of xName will be determined by mode. Mode can be 'FIFO',
'LIFO', 'MULTI', or 'SINGLE'. In the first three cases,
multiple values can be associated with xName. When a value is
retrieved for xName, the oldest value stored will be used in
'FIFO' mode, the youngest in 'LIFO' mode, and a
nondeterministic choice will be made in 'multi' mode. In
'single' mode, only the most recent value is retained.
}
\examples{
\dontrun{
ws = new("netWorkSpace", "my space")
nwsDeclare(ws, 'x', "LIFO")
}
}
\keyword{methods}
\keyword{programming}
