\name{bandplot}
\alias{bandplot}
\title{Plot x-y Points with local Mean and Standard Deviation Lines}
\description{
  Plot x-y Points with lines showing locally smoothed mean and
  standard deviation lines
  }
\usage{
  bandplot(x, y,
           ..., add = F, sd = c(-2:2),
           sd.col = c("lightblue", "blue", "red", "blue", "lightblue"),
           method = "range", width = diff(range(x, na.rm = T))/10, n=50) 
NULL

}
\arguments{
  \item{x}{numeric vector of x locations}
  \item{y}{numeric vector of x locations}
  \item{\dots}{Additional plotting parameters. }
  \item{add}{ Boolean indicating whether the local mean and standard
    deviation lines should be added to an existing plot.  Defaults to
    FALSE.}
  \item{sd}{Vector of multiples of the standard devation that should be
    plotted.  \code{0} gives the mean, \code{-1} gives the mean minus
    one standard deviation, etc.  Defaults to -2:2.}
  \item{sd.col}{Color of each plotted line.}
  \item{method, width, n}{ Parameters controlling the smoothing. See the
    help page for \code{\link{wapply}} for details.}
}
\details{

  \code{bandplot} was created to look for changes in the mean or
  variance of scatter plots, particularly plots of regression residuals.
  
  The local mean and standard deviation are calculated by calling
  'wapply'.  By default, bandplot asks wapply to smooth using intervals
  that span 1/10 of the x range.  See the documentation of that function
  for details on the algorithm.
  
}
\value{
  Invisibly returns a list containing the x,y points plotted for each line.
}
\author{ Gregory R. Warnes \email{Gregory\_R\_Warnes\@groton.pfizer.com}
}
\seealso{ \code{\link{wapply}}, \code{\link{lowess}}}
\examples{

# fixed mean, changing variance
x <- 1:1000
y <- rnorm(1000, mean=1, sd=1 + x/1000 )
bandplot(x,y)

# fixed varance, changing mean
x <- 1:1000
y <- rnorm(1000, mean=x/1000, sd=1)
bandplot(x,y)

# changing mean and variance
x <- rnorm(400)
y <- rnorm(400, mean=x, sd=1+1.5*abs(x))

# the change in dispersion is hard to see whith the points alone:
plot(x,y, xlim=c(-2,2) )

# the change is clear with the mean and sd smooths added:
bandplot(x,y, add=T)


# bandplot helps to see that regression removes the mean trend but
# leaves the trend in variability

reg <- lm(y~x)
summary(reg)
bandplot(x,resid(reg))
bandplot(predict(reg),resid(reg))

}
\keyword{ dplot }
