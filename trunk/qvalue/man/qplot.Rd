\name{qplot}
\alias{qplot}
\alias{plot.qvalue}
\title{Graphical display of qvalue objects}
\description{
  Graphical display of qvalue objects
}
\usage{
qplot(qobj, rng = 0.1, ...)
\method{plot}{qvalue}(x, ...)
}
\arguments{
  \item{qobj,x}{qvalue object}
  \item{rng}{upper limit of range of q-values to consider (optional)}
  \item{\dots}{optional arguments to be passed from \code{plot.qvalue}
    to \code{qplot}, or optional arguments plot commands.}
}
\details{
  The function qplot genearates four plots:

  \describe{
  \item{Upper-left:}{The estimated \eqn{\widehat{\pi_0}}{pi_0} versus the
    tuning parameter \eqn{\lambda}{lambda} with a smoother.}
  \item{Upper-right:}{The q-values versus the p-values}
  \item{Lower-left:}{The number of significant tests versus each q-value
    cut-off}
  \item{Lower-right:}{The number of expected false positives versus the
    number of significant tests}
  }

  The main purpose of the first plot is to gauge how reliable the
  estimate of \eqn{\pi_0}{pi_0} is. Basically, a tuning parameter
  \eqn{\lambda}{lambda} has to be chosen to estimate
  \eqn{\pi_0}{pi_0}. It can be fixed or automatically chosen. The
  estimated \eqn{\pi_0}{pi_0} is plotted versus the tuning parameter
  \eqn{\lambda}{lambda}. As \eqn{\lambda}{lambda} gets larger, the
  bias of the estimate decreases, yet the variance increases. See Storey
  (2002) for more on this. Comparing your estimate of \eqn{\pi_0}{pi_0}
  to this plot gives a good sense as to its quality. The remaining plots
  show how many tests are significant, as well as how many false
  positives to expect for each q-value cut-off. A thorough discussion of
  these plots can be found in Storey & Tibshirani (2003).
  
}
\value{
  Nothing of interest.
}
\references{
  Benjamini Y and Hochberg Y. (1995) Controlling the false discovery
  rate: A practical and powerful approach to multiple testing.
  
  Ihaka R and Gentleman R. (1996) R: A language for data analysis and
  graphics. Journal of Computational and Graphical Statistics, 5:
  299-314.
  
  Storey JD. (2001) The positive false discovery rate: A Bayesian
  interpretation and the q-value. Annals of Statistics, in press.
  
  Storey JD. (2002) A direct approach to false discovery rates. Journal
  of the Royal Statistical Society, Series B, 64: 479-498.
  
  Storey JD, Taylor JE, and Siegmund D. (2002) Strong control,
  conservative point estimation, and simultaneous conservative
  consistency of false discovery rates: A unified approach. Journal of
  the Royal Statistical Society, Series B, in press.
  
  Storey JD and Tibshirani R. (2003) Statistical significance for
  genome-wide experiments. Submitted, available at
  http://www.stat.berkeley.edu/~storey/. 
}
\seealso{ \code{\link{qvalue}}, \code{\link{qwrite}}}
\examples{
\dontrun{
p <- scan(?pvalues.txt?) 
qobj <- qvalue(p) 
qplot(qobj) 
qwrite(qobj, filename=?myresults.txt?)


# view a range of q-values, say,  0 to 0.3:
plot(qobj, rng=0.3)
}
}
\keyword{misc}
