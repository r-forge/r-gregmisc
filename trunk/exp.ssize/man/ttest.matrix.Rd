\name{ttest.matrix}
\alias{ttest.matrix}

\title{ Vectorized t test }
\description{
Perform 2-sided t test for two matrices: one is control and one is treatment group.
Perform tests for the first two columns up to all columns
}
\usage{
ttest.matrix(ctr, trt)
}

\arguments{
  \item{ctr}{ a matrix of observations from control group
	rows are observations and columns are replicates}
  \item{trt}{ a matrix of observations from treatment group
	rows are observations and columns are replicates }
}
% \details{
%    t-test in cumulative columns fashion, with the first column
%    of result (p-value) for test with the first two columns
%    and the last column of result for test with all data
% }
\value{
returns a matrix of p-values for 2-sample 2-sided t test
the matrix has one column less than the sample matrix dimention
}

\author{ Peng Liu \email{peng_liu@groton.pfizer.com}}

% \note{ ~~further notes~~ }
% ~Make other sections like Warning with \section{Warning }{....} ~
% \seealso{ ~~objects to See Also as \code{\link{~~fun~~}}, ~~~ }

\examples{
ctr <- matrix(0, nr = 5, nc = 6)
trt <- matrix(rnorm(30,5,0.5), nr = 5, nc = 6)
a <- ttest.matrix(ctr,trt)
}
\keyword{ univar }
