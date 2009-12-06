\name{Args}
\alias{Args}
\title{
  Formatted Argument List of a Function
}
\description{
  Display function argument names and corresponding default values,
  formatted in two columns for easy reading.
}
\usage{
Args(name, sort.args = FALSE)
}
\arguments{
  \item{name}{a function or function name.}
  \item{sort}{whether arguments should be sorted.}
}
\value{
  A data frame with named rows and a single column called \code{value},
  containing the default value of each argument.
}
\note{
  In recent versions of \R, primitive functions like \code{sum} and
  \code{all} have no formal arguments. See the \code{\link{formals}}
  help page.
}
\author{Arni Magnusson \email{arnima@u.washington.edu}}
\seealso{
  \code{\link{args}},
  \code{\link{formals}},
  \code{\link{help}}.
}
\examples{
Args(glm)
Args(scan)
Args(legend)
}
% Programming
\keyword{programming}
\keyword{utilities}
\keyword{documentation}
