# $Id$
#
# $Log$
# Revision 1.1  2001/12/10 19:35:32  warneg
# Renamed 'contrsts.coeff.Rd' to 'estimable.Rd' corresponding to function rename.
#
# Revision 1.1  2001/12/07 20:39:04  warneg
#
# - Initial checkin
#
#

\name{estimable}
\alias{estimable}
\title{Compute and test estimable linear functions (including
  contrasts) from the fitted coefficients of regression objects}
\description{Compute and test estimable linear functions (including
  contrasts) from the fitted coefficients of regression objects}
\usage{
estimable(obj, cm=NULL, alpha=0.05)
}
\arguments{
  \item{reg}{Regression (lm,glm,lme) object.}
    be computed.}
  \item{cm}{matrix specifying estimable linear functions or contrasts (one per
    row). The number of columns must match the number of fitted
    coefficients in the model.} 
  \item{alpha}{significance level for confidence intervals}
}
\details{
  Computes estimates, confidence intervals and significance tests for
  for linear functions of the model coefficients given by the rows of
  \code{cm}.  The estimates and thier variances are obtainied by
  applying the matrix \code{cm} to the model estimates
  variance-covariance matrix.  Degrees of freedom are obtained from the
  appropriate model terms.
  
  The user is responsible for ensuring that the specified
  linear functions are meaningful.  For computing contrasts among levels
  of a single factor, \code{\link{contrast.factor}} may be more
  convenient.
}
\note{
  The estimated fixed effect parameter of \code{lme} objects may have
  different degrees of freedom.  If a specified contrast includes
  nonzero coefficients for parameters with differing degrees of freedom,
  the smallest number of degrees of freedom is used and a warning
  message is issued.
  }
\value{
  Returns a matrix with one row per linear function.  Columns contain
  estimated coefficients, standard errors, t values, degrees of
  freedom, two-sided p-values, and the lower and  upper endpoints of the
  1-alpha confidence intervals. 
}
\author{ BXC (Bendix Carstensen) \email{bxc\@novonordisk.com} and
  Gregory R. Warnes \email{Gregory\_R\_Warnes\@groton.pfizer.com}}

\seealso{
  \code{\link{contrast.factor}},
  \code{\link{lm}}, \code{\link{lme}},
  \code{\link{contrasts}},
  \code{\link{contr.treatment}},  \code{\link{contr.poly}}  }

\examples{

y _ rnorm(100)
x _  cut(rnorm(100, mean=y, sd=0.25),c(-4,-1.5,0,1.5,4))
reg _ lm(y ~ x)
summary(reg)

# look at the group means
gm <- sapply(split(y,x),mean)
gm


# contrast mean of 2nd group vs mean of 4th group
estimable(reg, c(    0,   1,    0,   -1) )
# estimate should be equal to:
gm[2] - gm[4]

# confidence intervals etc. for the line for level 4
# for a separate continuous variable modelled as spline
# with a single knot at 0.5:
x2 <- rnorm(100,mean=y,sd=0.5)
reg2 <- lm(y ~ x + x2 + pmax(x2-0.5,0) )

xx2<-seq(-2,2,,50)
tmp <- estimable(reg2,cbind(1,0,0,1,xx2,pmax(xx2-0.5,0)))
plotCI(x=xx2,y=tmp[,1],li=tmp[,6],ui=tmp[,7])
}
\keyword{ models }
\keyword{ regression }

