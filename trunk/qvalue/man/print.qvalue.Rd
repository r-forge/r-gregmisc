\name{print.qvalue}
\alias{print.qvalue}
\alias{summary.qvalue}
\title{Display qvalue object}
\description{
  Display summary information for a qvalue object.  
}
\usage{
\method{print}{qvalue}(x, cut = c(1e-04, 0.001, 0.01, 0.025, 0.05, 0.1, 1),
             digits = getOption("digits"), ...)
\method{summary}{qvalue}(object, ...)
}
\arguments{
  \item{x, object}{qvalue object}
  \item{cut}{Vector of significance value to use for table}
  \item{digits}{Significant digits to display}
  \item{\dots}{Arguments passed to \code{print.qvalue}}
}
\details{
  \code{print.qvalue} shows the original call, estimated proportion of
  true null hypotheses, and a table comparing the number of significant calls
  for the raw p-values and for the calculated q-values using a set of
  cutoffs given by \code{cut}. \code{summary.qvalue} simply calls
  \code{print.pvalue}.
}
\value{
  Invisibly returns the original object.
}
\author{Gregory R. Warnes <gregory\_r\_warnes@groton.pfizer.com}
\seealso{ \code{\link{qvalue}}, \code{\link{qplot}},
  \code{\link{qwrite}} }
\examples{
\dontrun{
qobj <- qvalue(p)
print(qobj)
summary(qobj, cutoff=c(0.01, 0.05) )
}
}
\keyword{misc}
