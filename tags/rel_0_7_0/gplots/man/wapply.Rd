% $Id$
%
% $Log$
% Revision 1.6  2002/04/09 00:51:33  warneg
% Checkin for version 0.5.3
%
% Revision 1.5  2001/12/07 23:34:35  warneg
%
% Fixed an problem where \code was incorrectly delimited by parens
% rather than curly brackets.
%
% Revision 1.4  2001/12/05 19:36:30  warneg
%  - Clarified how the width of the window is computed when method="nobs".
%
% Revision 1.3  2001/10/16 23:15:01  warneg
%
% Fixed unbalanced brace.
%
% Revision 1.2  2001/09/01 00:01:55  warneg
% Release 0.3.0
%
% Revision 1.1  2001/08/25 05:45:10  warneg
% Initial Checkin
%
%
\name{wapply}
\alias{wapply}
\title{Compute the Value of a Functon Over a Local Region Of An X-Y Plot}
\description{  This function allows various features of a plot to be over local
     regions in the x-dimension. For example, setting `fun=mean' gives
     a the local mean.  Setting `fun=function(x) sqrt(var(x))' give a
     local estimate of the variance. 
}
\usage{
wapply(x, y, fun=mean, method="range", width=1/10, n=50, drop.na=TRUE, ...)
}
\arguments{
  \item{x}{ vector of x values for (x,y) pairs }
  \item{y}{ vector of y values for (x,y) pairs }
  \item{fun}{ function to be applied }
  \item{method}{ method of defining an x-neighborhood.  One of
    "width","nobs","range", or "fraction".  See details.}
  \item{width}{ width of an x-neighborhood. See details. }
  \item{n}{ Number of equally spaced points at which to compute local
    estimates. See details.}
  \item{drop.na}{ should points which result in missing values \code{NA}
    be omitted from the return value. Defaults to true. }
  \item{\dots}{ arguments to be passed to \code{fun} }
}
\details{
  This function allows various features of a plot to be computed over local
  regions in the x-dimension. For example, setting \code{fun=mean} gives
  a the local mean.  Setting \code{fun=function(x) sqrt(var(x))} give a
  local estimate of the variance.  

  Two basic techniques are available for determing what points fall within
  an x-neighborhood.  The first technique is selected by setting
  \code{method="width"} or \code{method="range"}. Selects points that
  are within the specified x-distance.  For  \code{method="width"} the
  \code{width} argument is an absolute distance in the x-dimension.  For
  \code{method="range"}, the width is expressed as a fraction of the
  x-range.  When either method is selected, computation of fun will
  occur for x-neighborhoods centered at \code{n} equally spaced x
  values.

  The second technique selects k neighboring points.  The
  (x,y) pairs are sorted by the x-values and the nearest k/2 points with
  higher x valus and the k/2 nearest points with lower x values are
  included in the window.  When \code{method="nobs"}, k equals
  \code{width} (actually 2*floor(\code{width}/2) ).  When
  \code{method="fraction"}, \code{width} specifies what fraction of the
  total number of points should be included. The actual number of points
  included in each window will be floor(n*frac/2)*2.  }
\value{
  Returns a list with components 
  \item{x }{x location'}
  \item{y }{Result of applying \code{fun} to the window about each x location}
}
\author{ Gregory R. Warnes \email{Gregory\_R\_Warnes\@groton.pfizer.com}
  }
\examples{

#show local mean and inner 2-sd interval to help diagnose changing mean
#or variance structure
x <- 1:1000
y <- rnorm(1000, mean=1, sd=1 + x/1000 )

plot(x,y)
lines(wapply(x,y,mean),col="red")

CL <- function(x,sd) mean(x)+sd*sqrt(var(x))

lines(wapply(x,y,CL,sd= 1),col="blue") 
lines(wapply(x,y,CL,sd=-1),col="blue") 
lines(wapply(x,y,CL,sd= 2),col="green")
lines(wapply(x,y,CL,sd=-2),col="green")

#show local mean and inner 2-sd interval to help diagnose changing mean
#or variance structure
x <- 1:1000
y <- rnorm(1000, mean=x/1000, sd=1)

plot(x,y)
lines(wapply(x,y,mean),col="red")

CL <- function(x,sd) mean(x)+sd*sqrt(var(x))

lines(wapply(x,y,CL,sd= 1,method="fraction",width=1/20),col="blue")
lines(wapply(x,y,CL,sd=-1,method="fraction",width=1/20),col="blue")
lines(wapply(x,y,CL,sd= 2,method="nobs",width=250),col="green")
lines(wapply(x,y,CL,sd=-2,method="nobs",width=250),col="green")


}
\keyword{ dplot }
