% $Id$
%
% $Log$
% Revision 1.2  2003/03/12 17:58:47  warnes
% - Fixed a typo in the example
% - Added to lme example
%
% Revision 1.1  2003/01/30 21:53:09  warnes
%
% - Renamed 'contrast.lm' to 'fit.contrast'.  This new name is more
%   descriptive and makes it easier to create and use methods for other
%   classes, eg lme.
%
% - Enabled fit.contrast for lme object now that Doug Bates has provided
%   the necessary support for contrasts in the nlme package.
%
% - New contrast.lm function which generates a 'depreciated' warning and
%   calls fit.contrast
%
% - Updated help text to match changes.
%
% Revision 1.11  2003/01/03 19:02:50  warnes
%
% - Removed duplicate assigment from aov example.
%
% Revision 1.10  2002/10/29 23:00:43  warnes
%
% - Moved make.contrasts to a separate file.
% - Enhanced make contrasts to better label contrast matrix, to give
%   how.many a default value, and to coerce vectors into row matrixes.
% - Added help page for make.contrasts.
% - Added link from contrasts.lm seealso to make.contrasts.
%
% Revision 1.9  2002/10/29 19:55:15  warnes
%
% - Fix bug that prevented contrast.lm() from working on 'aov' objects
% - Add 'aov' examples to documentation for contrast.lm
% - Added note about future support for contrast.lme.
%
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
% Revision 1.6  2002/04/15 21:30:39  warneg
% - Separated out, then commented out mention of contrast.lme and lme
%   objects.  The contrast.lme function will become part of Bates and
%   Pinhiero's next NLME library.
%
% Revision 1.5  2002/04/05 18:27:25  warneg
%
% - Noted that contrats.lm can be applied to lme objects.
% - Clarified return value when conf.int is specified.
%
% Revision 1.4  2001/12/10 19:39:58  warneg
% renamed contrast.factor.Rd back to contrast.lm.Rd corresponding to rename of function.
%
% Revision 1.2  2001/12/07 23:53:34  warneg
%
% Added documentation for 'conf.int' parameter.
%
% Revision 1.1  2001/12/07 19:57:59  warneg
%
% Renamed 'contrast.lm.Rd' to 'contrast.lm.Rd'.
%
% Revision 1.2  2001/09/01 00:01:55  warneg
% Release 0.3.0
%
% Revision 1.1  2001/08/31 20:55:32  warneg
%
% Updated to match changes in contrast.lm.R version 1.2.
%
% Also added more examples.
%
%

\name{fit.contrast}
\alias{fit.contrast}
\alias{fit.contrast.lm}
\alias{fit.contrast.lme}
\title{Compute and test arbitrary contrasts for regression objects}
\description{
 Compute and test arbitrary contrasts for regression objects.
}
\usage{
fit.contrast(model, varname, coeff, ... )
\method{fit.contrast}{lm}(model, varname, coeff, showall=FALSE,
             conf.int=NULL, df=FALSE, ...)
\method{fit.contrast}{lme}(model, varname, coeff, showall=FALSE,
             conf.int=NULL, df=FALSE, ...)
}
\arguments{
  \item{model}{regression (lm,glm,aov,lme) object for which the
    contrast(s) will be computed.} 
  \item{varname}{variable name}
  \item{coeff}{vector or matrix specifying contrasts (one per row).}
  \item{showall}{return all regression coefficients. If \code{TRUE}, all
    model cofficients will be returned.  If \code{FALSE} (the default),
    only the coefficients corresponding to the specified contrast will
    be returned.}
  \item{conf.int}{numeric value on (0,1) or NULL.  If a numeric value is
    specified, confidence intervals with nominal coverage probability
    \code{conf.int} will be computed.  If \code{NULL}, confidence
    intervals will not be computed.}
  \item{df}{boolean indicating whether to return a column containing the
    degrees of freedom.}
  \item{\dots}{optional arguments provided by methods.}
  }
  
\details{
  Computes the specified contrast(s) by re-fitting the model with the
  appropriate arguments.  A contrast of the form \code{c(1,0,0,-1)}
  would compare the mean of the first group with the mean of the fourth group.
}
\value{
  Returns a matrix containing estimated coefficients, standard errors, t
  values, two-sided p-values. If \code{df} is TRUE, an additional column
  containing the degrees of freedom is included.  If \code{conf.int} is
  specified lower and upper confidence limits are also returned.}
\references{Venables & Ripley, Section 6.2}
  
\author{ Gregory R. Warnes \email{Gregory\_R\_Warnes@groton.pfizer.com}}

\seealso{ \code{\link{lm}}, \code{\link{contrasts}},
  \code{\link{contr.treatment}},  \code{\link{contr.poly}},
  Computation and testing of General Linear Hypothesis:
  \code{\link{glh.test}}, Computation and testing of estimable functions
  of model coefficients: \code{\link{estimable}}, \code{\link{make.contrasts}}
  }

\examples{
y <- rnorm(100)
x <-  cut(rnorm(100, mean=y, sd=0.25),c(-4,-1.5,0,1.5,4))
reg <- lm(y ~ x)
summary(reg)

# look at the group means
gm <- sapply(split(y,x),mean)
gm


# mean of 1st group vs mean of 4th group
fit.contrast(reg, x, c(    1,    0,    0,   -1) )
# estimate should be equal to:
gm[1] - gm[4]

# mean of 1st and 2nd groups vs mean of 3rd and 4th groups
fit.contrast(reg, x, c( -1/2, -1/2,  1/2,  1/2) )
# estimate should be equal to:
sum(-1/2*gm[1], -1/2*gm[2], 1/2*gm[3], 1/2*gm[4])

# mean of 1st group vs mean of 2nd, 3rd and 4th groups
fit.contrast(reg, x, c( -3/3,  1/3,  1/3,  1/3) ) 
# estimate should be equal to:
sum(-3/3*gm[1], 1/3*gm[2], 1/3*gm[3], 1/3*gm[4])

# all at once
cmat <- rbind( "1 vs 4"    =c(-1, 0, 0, 1),
               "1+2 vs 3+4"=c(-1/2,-1/2, 1/2, 1/2),
               "1 vs 2+3+4"=c(-3/3, 1/3, 1/3, 1/3))
fit.contrast(reg,x,cmat)

#
x2 <- rnorm(100,mean=y,sd=0.5)
reg2 <- lm(y ~ x + x2 )
fit.contrast(reg2,x,c(-1,0,0,1))

#
# Example for Analysis of Variance
#

set.seed(03215)
Genotype <- sample(c("WT","KO"), 1000, replace=TRUE)
Time <- factor(sample(1:3, 1000, replace=TRUE))
y <- rnorm(1000)
data <- data.frame(y, Genotype, Time)


# Compute Contrasts & obtain 95\% confidence intervals

model <- aov( y ~ Genotype + Time + Genotype:Time, data=data )

fit.contrast( model, "Genotype", rbind("KO vs WT"=c(-1,1) ), conf=0.95 )

fit.contrast( model, "Time",
            rbind("1 vs 2"=c(-1,1,0),
                  "2 vs 3"=c(0,-1,1)
                  ),
            conf=0.95 )


cm.G <- rbind("KO vs WT"=c(-1,1) )
cm.T <- rbind("1 vs 2"=c(-1,1,0),
              "2 vs 3"=c(0,-1,1) )

# Compute contrasts and show SSQ decompositions

model <- aov( y ~ Genotype + Time + Genotype:Time, data=data,
              contrasts=list(Genotype=make.contrasts(cm.G),
                             Time=make.contrasts(cm.T) )
            )

summary(model, split=list( Genotype=list( "KO vs WT"=1 ),
                           Time = list( "1 vs 2" = 1,
                                        "2 vs 3" = 2 ) ) )


# example for lme 
library(nlme)
data(Orthodont)
fm1 <- lme(distance ~ Sex, data = Orthodont,random=~1|Subject) 

# Contrast for sex.  This example is equivalent to standard treatment
# contrast.
#
fit.contrast(fm1, "Sex", c(-1,1), conf.int=0.95 )
#
# and identical results can be obtained using lme built-in 'intervals'
#
intervals(fm1)

# Cut age into quantile groups & compute some contrasts
Orthodont$AgeGroup <- quantcut(Orthodont$age)
fm2 <- lme(distance ~ Sex + AgeGroup, data = Orthodont,random=~1|Subject)
#
fit.contrast(fm2, "AgeGroup", rbind("Linear"=c(-2,-1,1,2),
                                    "U-Shaped"=c(-1,1,1,-1),
                                    "Change-Point at 11"=c(-1,-1,1,1)),
                              conf.int=0.95)


}
\keyword{ models }
\keyword{ regression }

