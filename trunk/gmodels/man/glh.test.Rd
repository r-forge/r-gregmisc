\name{glh.test}
\alias{glh.test}
\alias{print.glh.test}
\alias{summary.glh.test}

\title{ Test a General Linear Hypothesis for a Regression Model }
\description{
Test, print, or summarize a general linear hypothesis for a regression model }
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
  \eqn{ C \hat{beta} = d }{C \%*\% beta_hat == d }
  for the regression model \code{reg}.

  The test statistic is obtained from the formula: 
  \deqn{f = \frac{(C \hat{\beta} - d)' ( C (X'X)^{-1} C' ) (C \hat{\beta}
      - d) / r }{ SSE / (n-p) } }{ 
    F = (C Beta-hat - d)' ( C (X'X)^-1   C' ) (C Beta-hat - d) / r /
        ( SSE / (n-p) )
  }
  
  Under the null hypothesis, f will follow a F-distribution with r and
  n-p degrees of freedom.
}
\value{
  Object of class \code{c("glh.test","htest")} with elements:
  \item{call }{Function call that created the object}
  \item{statistic }{F statistic}
  \item{parameter}{ vector containing the numerator (r) and denominator
    (n-p) degrees of freedom }
  \item{p.value}{ p-value}
  \item{estimate}{ computed estimate for each row of \code{cm} }
  \item{null.value}{ d }
  \item{method}{ description of the method }
  \item{data.name}{ name of the model given for \code{reg} }
  \item{matrix} { matrix specifying the general linear hypotheis
    (\code{cm}) }
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
