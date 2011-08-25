\name{ci2d}
\alias{ci2d}
\title{
  Create 2-dimensional empirical confidence regions
}
\description{
  Create 2-dimensional empirical confidence regions based on a
  2-dimensoinal histogram.
}
\usage{
ci2d(x, y=NULL,
     nbins=25,
     ci.levels=c(0.5, 0.75, 0.9, 0.95, 0.975),
     show=c("filled.contour", "contour", "image", "none"),
     xlab=deparse(substitute(x)),
     ylab=deparse(substitute(y)),
     col=topo.colors(length(breaks) - 1),
     ...)
}
\arguments{
  \item{x}{either a vector containing the x coordinates
    or a matrix with 2 columns. }
  \item{y}{a vector contianing the y coordinates, not required if `x'
    is matrix}
  \item{nbins}{number of bins in each dimension. May be a scalar or a
    2 element vector.  Defaults to 25.}
  \item{ci.levels}{Confidence level(s) to use for plotting
    data. Defaults to \code{c(0.5, 0.75, 0.9, 0.95, 0.975)} }
  \item{show}{Plot type to be displaed.  One of "filled.contour",
    "contour", "image", or "none".  Defaults to "filled.contour".}
  \item{xlab, ylab}{Axis labels}
  \item{col}{Colors to use for plots.}
  \item{\dots}{Additional arguments passed to \code{hist2d}. }
}
\details{
  This function utilizes \code{hist2d} to create a 2-dimensional
  histogram of the data passed as an argument.  This data is then
  converted into densities and used to create and display confidence
  regions.
}
\value{
  A list containing 3 elements:
  \item{counts}{Matrix containing the number of points falling into each
    bin}
  \item{x}{lower x limit of each bin}
  \item{y}{lower y limit of each bin}
  \item{density}{Matrix containing the probability density of each bin (count in bin/total
    count)}
  \item{cumDensity}{Matrix where each element contains the cumulative probability density
    of all elements with the same density (used to create the confidence
    region plots) }
  \item{contours}{Contours of each confidence region}
}
%\references{
%}
\author{ Gregory R. Warnes \email{greg@warnes.net}}
\seealso{
  \code{\link{hist2d}}
}
\examples{
   # example data, bivariate normal, no correlation
   x <- rnorm(2000, sd=4)
   y <- rnorm(2000, sd=1)

   # 2-d confidence intervals based on 2d histogram
   ci2d(x,y)

   # same scale for each axis, this looks oval
   ci2d(x,y, same.scale=TRUE)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{dplot}
\keyword{hplot}
\keyword{nonparametric}
