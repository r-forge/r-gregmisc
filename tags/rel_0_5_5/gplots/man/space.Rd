\name{space}
\alias{space}
\title{Space points in an x-y plot so they don't overlap.}
\description{
  Space points in an x-y plot so they don't overlap.
}
\usage{
space(x, y, s=1/50, na.rm=TRUE)
}
\arguments{
  \item{x}{numeric vector of x coordonates.}
  \item{y}{numeric vector of x coordonates.}
  \item{s}{either a single numeric value or 2 element vector specifying
  the minimum distance between points in the x and y dimensions as a
  fraction of the x and y range.  Defaults to 1/50.}
  \item{na.rm}{logical indicating whether pairs where one or both
    elements are missing should be removed.  Defaults to TRUE.}
}
\details{
  In an x-y plot where at least one variable has discrete levels several
  points may be plotted at or very near the same coordonates.
  This makes it difficult to guage the number of points in a specific
  region.  A common method of resolving this problem is to 'jitter' the
  points by adding random noise.

  This function takes a different approach to the same problem.  

  When there are two or more points with the same (x,y) value (or
  within x+-s[1] and x+-s[2]), it spaces these out in the x direction
  so that the points are separated by at least distance s.
}
\value{
  list with two components
  \item{x}{(modified) x location for each input point}
  \item{y}{y location of each input point}
}
\author{ Gregory R. Warnes \email{gregory\_r\_warnes\@groton.pfizer.com} }
\seealso{ \code{\link{jitter}} }

\examples{
   x <- rep(1:5, 10)
   y <- round(rnorm(length(x),x))

   # standard x-y plot with overlapping points
   plot(x,y)

   # 'spaced' plot 
   plot(space(x,y))

   \testonly{
     # check that missign values correctly handled
     x <- c(x,NA)
     y <- c(y,NA)
     plot(space(x,y))
   }
}
\keyword{ dplot }

