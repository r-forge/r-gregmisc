% $Id$
%
% $Log$
% Revision 1.2  2002/09/23 13:59:30  warnes
% - Modified all files to include CVS Id and Log tags.
%
% Revision 1.1  2002/03/26 14:49:10  warneg
%
% Initial Checkin
%
%

\name{quantcut}
\alias{quantcut}

\title{ Create a Factor Variable Using the Quantiles of a Continuous Variable}}
\description{
  Create a factor variable using the quantiles of a continous variable.
}
\usage{
quantcut(x, q=c(0, 1/4, 2/4, 3/4, 4/4), na.rm=TRUE, include.lowest=TRUE, ...)
}
%- maybe also `usage' for other objects documented here.
\arguments{
  \item{x}{ Continous variable. }
  \item{q}{ Vector of quantiles used for creating groups. Defaults to
    \code{c(0, 1/4, 2/4, 3/4, 4/4)}.  See \code{\link{quantile}} for details. }
  \item{na.rm}{ Boolean indicating whether missing values should be
    removed when computing quantiles.  Defaults to TRUE.}
  \item{include.lowest}{ Boolean indicating whether values exactly
    equal to the lowest specified quantile be included in the lowest
    group.  See \code{\link{cut}} for details. }
  \item{\dots}{ Optional arguments passed to \code{\link{cut}}. }
}
\details{
  This function is simply a uses \code{\link{quantile}} to obtaine the
  quantiles of \code{x}, then calls \code{\link{cut}} to create a factor
  variable using the quantiles for cut points.
}
\value{
  Factor variable with one level for each quantile interval given by \code{q}.
}

\author{Gregory R. Warnes \email{Gregory\_R\_Warnes@groton.pfizer.com}}

\seealso{ \code{\link{cut}}, \code{\link{quantile}} }

\examples{

  x <- rnorm(1000)
  quants <- quantcut( x )
  table(quants)
}

\keyword{ manip  }

