% $Id$
%
% $Log$
% Revision 1.5  2003/01/30 21:56:29  warnes
% - Fixed typo in email address.
%
% Revision 1.4  2002/04/09 00:51:33  warneg
%
% Checkin for version 0.5.3
%
% Revision 1.3  2002/03/07 23:39:00  warneg
% - Added documentation and example for running2
%
% Revision 1.2  2001/09/01 00:01:55  warneg
% Release 0.3.0
%
% Revision 1.1  2001/08/25 03:59:52  warneg
% Initial Checkin
%
%

\name{running}
\alias{running}
\alias{running2}
\title{Apply a Function Over Adjacent Subsets of a Vector}
\description{Applies a function over subsets of the vector(s) formed by
  taking a fixed number of previous points.}
\usage{
running(X, fun=mean, width=min(length(X),20), allow.fewer=FALSE,...)
running2(X,Y, fun=mean, width=min(length(X),20), allow.fewer=FALSE,...)
}
\arguments{
  \item{X}{ data vector }
  \item{Y}{ data vector }
  \item{fun}{ function to apply. Default is \code{mean}}
  \item{width}{integer giving the number of vector elements to include
    in the subsets.  Defaults to the lesser of the length of the data and
    20 elements.}
  \item{allow.fewer}{Boolean indicating whether the function should be
    computed for initial subsets with
    fewer than \code{width} points}
  \item{\dots}{ parameters to be passed to \code{fun} }
}
\details{
  \code{running} applies the specified \emph{univariate} function to
  sequential windows on \code{X}.

  \code{running2} applies the specified \emph{bivariate}
  function to sequential windows of \code{X} and \code{Y}.
  
}
\value{
  Vector containg the results of applying the function \code{fun} to the
  subsets of \code{X} (\code{running}) or \code{X} and \code{Y} (running2).
}
\author{ Gregory R. Warnes \email{Gregory\_R\_Warnes@groton.pfizer.com} }
%\note{ ~~further notes~~ }
%\seealso{ ~~objects to SEE ALSO as \code{\link{~~fun~~}}, ~~~ }

\examples{

running(1:20,width=5)

plot(1:20, running(1:20,width=5))
plot(1:20, running(1:20,width=5, allow.fewer=TRUE))

# plot running mean and central 2 standard deviation range
# estimated by last 40 observations
dat <- rnorm(500, sd=1 + (1:500)/500 )
plot(dat)
fun <- function(x,sign=1) mean(x) + sign * sqrt(var(x))
lines(running(dat,width=50,fun=mean,allow=TRUE),col="blue")
lines(running(dat,width=50,fun=fun, sign=-1, allow=TRUE),col="red")
lines(running(dat,width=50,fun=fun, sign=1, allow=TRUE),col="red")

# plot running running correlation estimated by last 40 observations
# along with true (local) correlation
X <- rnorm(500, sd=1)
Y <- X + rnorm(500, sd=(1:500)/500)
rho <- 1/ ( 1 * sqrt(1 + (1:500)/500) )  # true 

plot(running2(X,Y,width=20,fun=cor),col="red",type="s")
lines(rho,type="l",col="blue")


}
\keyword{misc}
