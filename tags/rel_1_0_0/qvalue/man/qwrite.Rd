\name{qwrite}
\alias{qwrite}
\title{Write the results of the q-value object qobj to a file}
\description{
  Write the results of the q-value object qobj to a file. 
}
\usage{
qwrite(qobj, filename)
}
\arguments{
  \item{qobj}{a q-value object returned by the qvalue function}
  \item{filename}{the name of the file where the results are written}
}
\details{
  A file is sent to "filename" with the following:
  \describe{
    \item{First row:}{the function call used to produce the estimates}
    \item{Second row:}{the estimate of the proportion of false positives, pi0}
    \item{Third row and below:}{the p-values (1st column) and the
      estimated q-values (2nd column) }
    }
  }
\value{
  Nothing of interest.
}
\author{John D. Storey <storey@stat.berkeley.edu>}
\seealso{ \code{\link{qvalue}}, \code{\link{qplot}} }
\examples{
\dontrun{
p <- scan("pvalues.txt")
qobj <- qvalue(p)
qplot(qobj)
qwrite(qobj, filename="myresults.txt")
}
}
\keyword{misc}
