\name{first}
\alias{first}
\alias{first.default}
\alias{first.list}
\alias{last}
\alias{last.default}
\alias{last.list}
\title{Return first or last element of a vector or list}
\description{
  Return first or last element of a vector or list
}
\usage{
first(x)
last(x)
\method{first}{default}(x)
\method{last}{default}(x)
\method{first}{list}(x)
\method{last}{list}(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{vector or list}
}
\value{
  The first or last element of \code{x}.
}
\author{
  Gregory R. Warnes \email{greg@warnes.net}
}
\seealso{
  \code{\link[utils]{head}},
  \code{\link[utils]{tail}},
  \code{\link{left}},
  \code{\link{right}}
}
\examples{
## works for vectors..
v <- 1:10
first(v)
last(v)

## and for lists
l <- list(a=1, b=2, c=3)
first(l)
last(l)
}
\keyword{ manip }
