\name{drop.levels}
\alias{drop.levels}
\title{Drop unused factor levels from factors within a data frame}
\description{
  Drop unused factor levels from factors within a data frame
}
\usage{
drop.levels(x)
}
\arguments{
  \item{x}{Data frame}
}
\value{
  A data frame.  All non-factor columns will be unchanged.  Factor
  columns will have the factor levels modified to drop levels which are
  not present in the data.
}
\author{Jim Rogers \email{james\_a\_rogers@groton.pfizer.com}}
\seealso{ \code{\link{frameApply}}}
\examples{

df <- data.frame(
                   a = factor( sample(letters[1:3], size=20, replace=TRUE),
                               levels=letters[1:10] ),
                   b = rnorm(20),
                   c = letters[1:20]
                  )

df$a

dfd <- drop.levels(df)



}
\keyword{manip}
