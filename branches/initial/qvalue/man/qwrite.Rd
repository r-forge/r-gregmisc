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
  \item{qobj}{qvalue object}
  \item{filename}{output filename}
}
\details{
  The output file lists the estimate of \deqn{\pi_0}{pi_0}, which is the
  proportion of true null hypotheses. It also lists each p-value and
  corresponding q-value, one per line.
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
