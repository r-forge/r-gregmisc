% $Id$
%
% $Log$
% Revision 1.3  2001/10/16 23:14:46  warneg
% Fixed unbalanced brace.
%
% Revision 1.2  2001/08/25 05:52:06  warneg
% - Added CVS header.
% - Added my email address.
%
%
\name{ci}
\alias{ci}
\alias{ci.lm}
\alias{ci.summary.lm}
\title{Compute Confidence Intervals}
\description{ Compute and display confidence intervals for model
  estimates.  Methods for \code{lm} and \code{summary.lm} objects are
  provided. }
\usage{
ci(x, ...)
ci.lm(x, ...)
ci.summary.lm(x, confidence = 0.95, alpha = 1 - confidence) 
}
%- maybe also `usage' for other objects documented here.
\arguments{
  \item{x}{ object from which to compute confidence intervals. }
  \item{confidence}{ confidence level. Defaults to 0.95. }
  \item{alpha}{Type one error rate.  Defaults to 1.0-\code{confidence} }
}
%\details{
%  ~~ If necessary, more details than the __description__  above ~~
%}
\value{
  matrix with one row per model parameter and columns  \code{Estimate},
  \code{CI lower}, \code{CI upper}, \code{Std. Error}, and \code{p-value}.
}
\author{ Gregory R. Warnes \email{Gregory\_R\_Warnes\@groton.pfizer.com}
}
\seealso{ \code{\ref{MASS}\link{confint}}, \code{\link{lm}},
  \code{\link{summary.lm}} }

\examples{

data(state)
reg  <-  lm(Area ~ Population, data=as.data.frame(state.x77))
ci(reg) 

}
\keyword{ regression }
