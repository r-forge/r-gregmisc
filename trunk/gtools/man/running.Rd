% $Id$
%
% $Log$
% Revision 1.1  2001/08/25 03:59:52  warneg
% Initial Checkin
%
%

\name{running}
\alias{running}
\title{Apply a Function Over Adjacent Subsets of a Vector}
\description{Applies a function over subsets of the vector formed by
  taking a fixed number of previous points.}
\usage{
running(X, fun=mean, width=min(length(X),20), allow.fewer=FALSE,...)
}
\arguments{
  \item{X}{ data vector }
  \item{fun}{ function to apply. Default is \code{mean}}
  \item{width}{integer giving the number of vector elements to include
    in the subsets.  Defaults to the lesser of the length of the data and
    20 elements.}
  \item{allow.fewer}{Boolean indicating whether the function should be
    computed for initial subsets with
    fewer than \code{width} points}
  \item{\dots}{ parameters to be passed to \code{fun} }
}
%\details{
%  
%}
\value{
 Vector containg the results of applying the function \code{fun} to the subsets.
}
\author{ Gregory R. Warnes \email{Gregory\_R\_Warnes\@groton.pfizer.com} }
%\note{ ~~further notes~~ }
%\seealso{ ~~objects to SEE ALSO as \code{\link{~~fun~~}}, ~~~ }

\examples{

running(1:20,width=5)

plot(1:20, running(1:20,width=5))
plot(1:20, running(1:20,width=5, allow.fewer=T))

# plot running mean and central 2 standard deviation range
# estimated by last 40 observations
dat <- rnorm(500, sd=1 + (1:500)/500 )
plot(x)
fun <- function(x,sign=1) mean(x) + sign * sqrt(var(x))
lines(running(dat,width=50,fun=mean,allow=T),col="blue")
lines(running(dat,width=50,fun=fun, sign=-1, allow=T),col="red")
lines(running(dat,width=50,fun=fun, sign=1, allow=T),col="red")

}
\keyword{misc}
