% $Id$
%
% $Log$
% Revision 1.8  2002/09/23 13:59:30  warnes
% - Modified all files to include CVS Id and Log tags.
%
% Revision 1.7  2002/08/01 19:37:14  warnes
%
% - Corrected documentation mismatch for ci, ci.default.
%
% - Replaced all occurences of '_' for assignment with '<-'.
%
% - Replaced all occurences of 'T' or 'F' for 'TRUE' and 'FALSE' with
%   the spelled out version.
%
% - Updaded version number and date.
%
% Revision 1.6  2002/02/20 20:09:02  warneg
%
% Minor changes, typo and formatting fixes.
%
% Revision 1.5  2002/01/17 23:51:06  warneg
%
% - Fixed errror in last example by adding 'conf.int' parameter to
%   'estimable' call.
%
% Revision 1.4  2001/12/18 22:14:14  warneg
%
% - Updated documentation to reflect change of parameters from 'alpha'
%   to 'conf.int', including the new optional status of the confidence
%   intervals.
%
% Revision 1.3  2001/12/17 18:59:29  warneg
%
% - Fixed spelling errors.
%
% Revision 1.1  2001/12/17 18:58:27  warneg
% Initial revision
%
% Revision 1.2  2001/12/17 18:52:55  warneg
%
% - Fixed the link to contrasts.lm.
% - Rephrased title/description to be more clear.
%
% Revision 1.1  2001/12/10 19:35:32  warneg
% Renamed 'contrsts.coeff.Rd' to 'estimable.Rd' corresponding to function rename.
%
% Revision 1.1  2001/12/07 20:39:04  warneg
%
% - Initial checkin
%
%

\name{estimable}
\alias{estimable}
\title{Compute and test estimable linear functions of the fitted
  coefficients (including contrasts) of regression objects}
\description{Compute and test estimable linear functions of the fitted
  coefficients (including contrasts) of regression objects}
\usage{
estimable(obj, cm, conf.int=NULL)
}
\arguments{
  \item{obj}{Regression (lm,glm,lme) object. }
  \item{cm}{matrix specifying estimable linear functions or contrasts (one per
    row). The number of columns must match the number of fitted
    coefficients in the model.} 
  \item{conf.int}{Confidence level.  If provided, confidence intervals
    will be computed. }
}
\details{
  Computes an estimate, test statitic, significance test, and (optional)
  confidence interval for each linear functions of the model
  coefficients specified by the rows of \code{cm}.  The estimates and
  their variances are obtained by applying the matrix \code{cm} to the
  model estimates variance-covariance matrix.  Degrees of freedom are
  obtained from the appropriate model terms.
  
  The user is responsible for ensuring that the specified
  linear functions are meaningful.  For computing contrasts among levels
  of a single factor, \code{\link{contrast.lm}} may be more
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
  \code{\link{contrast.lm}},
  \code{\link{lm}}, \code{\link{lme}},
  \code{\link{contrasts}},
  \code{\link{contr.treatment}},  \code{\link{contr.poly}}  }

\examples{

y <- rnorm(100)
x <-  cut(rnorm(100, mean=y, sd=0.25),c(-4,-1.5,0,1.5,4))
reg <- lm(y ~ x)
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
tmp <- estimable(reg2,cbind(1,0,0,1,xx2,pmax(xx2-0.5,0)), conf.int=0.95)
plotCI(x=xx2,y=tmp[,1],li=tmp[,6],ui=tmp[,7])
}
\keyword{ models }
\keyword{ regression }

