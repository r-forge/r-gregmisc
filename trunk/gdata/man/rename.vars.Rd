\name{rename.vars}
\alias{rename.vars}
\title{ Rename variables in a dataframe }
\description{
  Rename a variables in a data frame.
}
\usage{
rename.vars(data, from="", to="", info=T)
}
\arguments{
  \item{data}{ dataframe to be modified.  }
  \item{from}{ character vector containing the current name of each variable to be renamed.}
  \item{from}{ character vector containing the new name of each variable to be renamed.}
  \item{info}{ ~~Describe \code{info} here~~ }
}
%\details{
%  ~~ If necessary, more details than the __description__  above ~~
%}
\value{
  The updated data frame with variables listed in \code{from} renamed to
  the corresponding element of \code{to}.
}
\author{Code by ??.  Documentation by Gregory R. Warnes \email{gregory_r_warnes\@groton.pfizer.com} }
\seealso{ \code{\link{names}}, \code{\link{colnames}}, \code{\link{dataframe}} }

\examples{
data(Orthodont)
class(Orthodont)
names(Orthodont)
Orthodont <- rename.vars(Orthodont,c("distance","age"),c("Distance","Age"))
names(Orthodont)
}
\keyword{ manip  }

