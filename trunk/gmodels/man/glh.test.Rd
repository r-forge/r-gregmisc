\name{glh.test}
\alias{glh.test}
\alias{print.glh.test}
\alias{summary.glh.test}

\title{ Test a General Linear Hypothesis for a Regression Model }
\description{
Test a general linear hypothesis for a regression model }
}

\usage{
glh.test(reg, cm, d=rep(0, nrow(cm)) )
print.glh.test(x, digits=4)
summary.glh.test(x, digits=4)
}

\arguments{
  \item{reg}{ Regression model }
  \item{cm}{ matrix .  Each row specifies a linear combination of the
    coefficients }
  \item{d}{ vector specifying the null hypothis values for each linear
    combination}
  \item{x}{glh.test object}
  \item{digits}{number of digits.}
}
\details{
  Test the general lineary hypothesis
  $$ C \hat{\beta} = d $$
  for the regression model \code{reg}.

  The test statistic is obtained from the formula


  $$
  f = \frac{(CB - d)' ( C {(X'X)}^{-1}   C' ) (CB - d) / r
           {        SSE / (n-p) }
  $$

  Under the null hypothesis, f will follow a F-distribution with r and
  n-p degrees of freedom.
  

}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of `comp1'}
  \item{comp2 }{Description of `comp2'}
  ...
}
\references{ R.H. Myers, Classical and Modern Regression with
  Applications,  2nd Ed, 1990, p. 105}
\author{Gregory R. Warnes \email{gregory\_r\_warnes\@groton.pfizer.com} }
\seealso{\code{\link{contrast.lm}}, \code{\link{estimable}},
  \code{\link{contrast}}, \code{\link{contrasts}} }
\examples{

# fit a simple model
y _ rnorm(100)
x _  cut(rnorm(100, mean=y, sd=0.25),c(-4,-1.5,0,1.5,4))
reg _ lm(y ~ x)
summary(reg)

# test both group 1 = group 2  and group 3 = group 4
C <- rbind( c(0,-1,0,0), c(0,0,-1,1) )
ret <- glh.test(reg, C)
ret  # same as 'print(ret) '
summary(ret)


}
\keyword{ models }
\keyword{ regression }
