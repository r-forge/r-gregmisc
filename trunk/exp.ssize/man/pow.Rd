\name{pow}
\alias{pow}
\alias{power.plot}
\title{Compute and plot power for gene expression experiment}
\description{
  Compute and plot power for a gene expression experiment
}
\usage{
pow(sd, n, delta, sig.level, alpha.correct = "Bonferonni")
power.plot(x, xlab = "Power", ylab = "Proportion of Genes with Power >= x", 
    marks = c(0.7, 0.8, 0.9), ...)
}
\arguments{
  \item{sd}{Vector of standard deviations for control samples}
  \item{n}{Number of observations (per group)}
  \item{delta}{Hypothetical True difference in expression.}
  \item{sig.level}{Significance level (Type I error probability)}
  \item{alpha.correct}{Type of correction for multiple comparison.  One
    of "Bonferonni" or "None".}
}
\details{
  The \code{pow} function computes power for each element of a gene
  expression experiment using an vector of estimated standard
  deviations.  The power is computed separately for each gene, with an
  optional correction to the significance level for multiple
  comparison.  The \code{power.plot} function generates a cumulative
  power plot illustrating the fraction and number of genes achieve a
  given power for the specified sample size, significance level, and
  delta.
}
\value{
  \code{pow} returns a vector containing the power for each standard deviation.
}
\references{
  Warnes GR and Fasheng Li
  ``Sample Size Selection for Microarray based Gene Expression Studies,''
  Talk,
  "2003 FDA/Industry Statistics Workshop: From Theory to Regulatory
  Acceptance",
  American Statistical Association, Bethesda, MD, Sept 18-19, 2003.
  \url{http://www.warnes.net/Research/PresentationFolder/SampleSize.pdf}
}
\author{Gregory R. Warnes \email{Gregory\_R\_Warnes\@groton.pfizer.com}}
\seealso{
  \code{\link{ssize}},
  \code{\link{ssize.plot}},
  \code{\link{delta}},
  \code{\link{delta.plot}}
}
\examples{
library(gregmisc)

n<-6
fold.change<-2.0
power<-0.8
sig.level<-0.05;

# compute power
all.power <- pow(sd=exp.sd, n=n, delta=log2(fold.change),
                 sig.level=sig.level)

# now plot it
power.plot(all.power, lwd=2, col="blue")
xmax <- par("usr")[2]-0.05; ymax <- par("usr")[4]-0.05
legend(x=xmax, y=ymax,
       legend= strsplit( paste("n=",n,",",
                              "fold change=",fold.change,",",
                              "alpha=", sig.level, ",",
                              "# genes=", nobs(exp.sd), sep=''), "," )[[1]],
       xjust=1, yjust=1, cex=1.0)
title("Power to Detect 2-Fold Change (All Genes)")
}
\keyword{htest}
\keyword{design}
