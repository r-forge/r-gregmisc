% $Id$
%
% $Log$
% Revision 1.6  2004/03/26 22:19:18  warnes
% - Update to match changes in running()
% - Add examples to illustrate new arguments.
% - Modify running correlation plot example to be more clear.
%
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
\title{Apply a Function Over Adjacent Subsets of a Vector}
\description{Applies a function over subsets of the vector(s) formed by
  taking a fixed number of previous points.}
\usage{
running(X, Y=NULL, fun=mean, width=min(length(X), 20),
        allow.fewer=FALSE, pad=FALSE, align=c("right", "center", "left"),
        ...)
}
\arguments{
  \item{X}{ data vector }
  \item{Y}{ data vector (optional) }
  \item{fun}{ Function to apply. Default is \code{mean}}
  \item{width}{Integer giving the number of vector elements to include
    in the subsets.  Defaults to the lesser of the length of the data and
    20 elements.}
  \item{allow.fewer}{Boolean indicating whether the function should be
    computed for subsets with fewer than \code{width} points}
  \item{pad}{Boolean indicating whether the returned results should
    be 'padded' with NAs corresponding to sets with less than
    \code{width} elements.  This only applies when when
    \code{allow.fewer} is FALSE.}
  \item{align}{One of "right", "center", or "left".
    This controls the relative location of `short' subsets with less
    then \code{width} elements: "right" allows short subsets only at the
    beginning of the sequence so that all of the complete subsets are at
    the end of the sequence (i.e. `right aligned'), "left" allows short
    subsets only at the end of the data so that the complete subsets
    are `left aligned', and "center" allows short subsets at both ends
    of the data so that complete subsets are `centered'. 
    }
  \item{\dots}{ parameters to be passed to \code{fun} }
}
\details{
  \code{running} applies the specified function to
  a sequential windows on \code{X} and (optionally) \code{Y}.  If
  \code{Y} is specified the function must be bivariate.
}
\value{
  Vector containg the results of applying the function \code{fun} to the
  subsets of \code{X} (\code{running}) or \code{X} and \code{Y}.
}
\author{ Gregory R. Warnes \email{Gregory\_R\_Warnes@groton.pfizer.com} }
\seealso{ \code{\link{wapply}} to apply a function over an x-y window
  centered at each x point }

\examples{

# show effect of pad
running(1:20,width=5)
running(1:20,width=5,pad=TRUE)

# show effect of align
running(1:20,width=5, align="left", pad=TRUE)
running(1:20,width=5, align="center", pad=TRUE)
running(1:20,width=5, align="right", pad=TRUE)

# Use 'pad' to ensure correct length of vector, also show the effect
# of allow.fewer.
par(mfrow=c(2,1))
plot(1:20, running(1:20,width=5, allow.fewer=FALSE, pad=TRUE), type="b")
plot(1:20, running(1:20,width=5, allow.fewer=TRUE,  pad=TRUE), type="b")
par(mfrow=c(1,1))

# plot running mean and central 2 standard deviation range
# estimated by *last* 40 observations
dat <- rnorm(500, sd=1 + (1:500)/500 )
plot(dat)
sdfun <- function(x,sign=1) mean(x) + sign * sqrt(var(x))
lines(running(dat, width=51, pad=TRUE, fun=mean), col="blue")
lines(running(dat, width=51, pad=TRUE, fun=sdfun, sign=-1), col="red")
lines(running(dat, width=51, pad=TRUE, fun=sdfun, sign= 1), col="red")


# plot running correlation estimated by last 40 observations (red)
# against the true local correlation (blue)
sd.Y <- seq(0,1,length=500)

X <- rnorm(500, sd=1)
Y <- rnorm(500, sd=sd.Y)

plot(running(X,X+Y,width=20,fun=cor,pad=TRUE),col="red",type="s")

r <- 1 / sqrt(1 + sd.Y^2) # true cor of (X,X+Y)
lines(r,type="l",col="blue")
}
\keyword{misc}
