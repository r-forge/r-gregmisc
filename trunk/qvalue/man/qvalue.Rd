\name{qvalue}
\alias{qvalue}
\title{Estimate the q-values for a given set of p-values.}
\description{
  Estimate the q-values for a given set of p-values.  The q-value of a
  test measures the proportion of false positives incurred (called the
  false discovery rate) when that particular test is called significant.
}
\usage{
qvalue(p, lambda=seq(0,0.95,0.05), pi0.meth="smoother", fdr.level=NULL,
       robust=FALSE) 
}
\arguments{
  \item{p}{a vector of p-values (only necessary input)}
  \item{fdr.level}{a level at which to control the FDR. (optional)}
  \item{lambda}{The value of the tuning parameter to estimate
    \eqn{\pi_0}{pi_0} (optional). Must be in [0,1],  see Storey (2002).}
  \item{pi0.meth}{either "smoother" or "bootstrap"; the method for
    automatically choosing tuning parameter \code{lambda} in the
    estimation of \eqn{\pi_0}{pi_0}, the proportion of true null hypotheses if
    it is not specified}
  \item{robust}{an indicator of whether it is desired to make the
    estimate more robust for small p-values and a direct finite sample
    estimate of pFDR (optional).}
}
\details{
  If no options are selected, then the method used to estimate p 0 is
  the smoother method described in Storey and Tibshirani (2003). The
  bootstrap method is described in Storey, Taylor & Siegmund (2002).
}
\value{
  A list containing:
\item{call}{give the function call}
\item{pi0}{an estimate of the proportion of null p-values}
\item{qvalues}{a vector of the estimated q-values (the main quantity of
  interest)} 
\item{pvalues}{a vector of the original p-values}
\item{significant}{if fdr.level is specified, and indicator of whether the
  q-value fell below fdr.level (taking all such q-values to be significant
  controls FDR at level fdr.level)}
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
\author{John D. Storey <storey@stat.berkeley.edu>}
\seealso{ \code{\link{qplot}}, \code{\link{qwrite}} }
\examples{
\dontrun{
p <- scan("pvalues.txt")
qobj <- qvalue(p)
qplot(qobj)
qwrite(qobj, filename="myresults.txt")

qobj <- qvalue(p, lambda=0.5, robust=TRUE)
qobj <- qvalue(p, fdr.level=0.05, pi0.meth="bootstrap")
}
}
\keyword{misc}
