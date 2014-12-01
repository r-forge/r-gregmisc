\name{bandplot}
\alias{bandplot}
\alias{bandplot.formula}
\alias{bandplot.default}
\title{Plot x-y Points with Locally Smoothed Mean and Standard Deviation}
\description{
  Plot x-y points with curves for locally smoothed mean and standard deviation.
}
\usage{
bandplot(x,...)
\method{bandplot}{formula}(x, data=parent.frame(), subset, na.action, ...,
           xlab=NULL, ylab=NULL, add = FALSE, sd = c(-2:2),
           sd.col=c("magenta", "blue", "red", "blue", "magenta"),
           sd.lwd=c(2, 2, 3, 2, 2),  sd.lty=c(2, 1, 1, 1, 2), 
           method = "frac", width = 1/5, n=50)
\method{bandplot}{default}(x, y, ..., add = FALSE, sd = c(-2:2),
           sd.col=c("magenta", "blue", "red", "blue", "magenta"),
           sd.lwd=c(2, 2, 3, 2, 2),  sd.lty=c(2, 1, 1, 1, 2), 
           method = "frac", width = 1/5, n=50)
}
\arguments{
  \item{x}{either formula providing a single dependent variable (y) and
    an single independent variable (x) to use as coordinates in the
    scatter plot  or a numeric vector of x locations}
  \item{y}{numeric vector of y locations}
  \item{data}{a data.frame (or list) from which the variables in `formula'
          should be taken.}
  \item{subset}{ an optional vector specifying a subset of observations to be
          used in the fitting process. }
  \item{\dots}{Additional plotting parameters. }
  \item{add}{ Boolean indicating whether the local mean and standard
    deviation lines should be added to an existing plot.  Defaults to
    FALSE.}
  \item{sd}{Vector of multiples of the standard devation that should be
    plotted.  \code{0} gives the mean, \code{-1} gives the mean minus
    one standard deviation, etc.  Defaults to -2:2.}
  \item{sd.col,sd.lwd,sd.lty}{Color, line width, and line type of each plotted line.}
  \item{method, width, n}{ Parameters controlling the smoothing. See the
    help page for \code{\link{wapply}} for details.}
}
\details{

  \code{bandplot} was created to look for changes in the mean or
  variance of scatter plots, particularly plots of regression residuals.
  
  The local mean and standard deviation are calculated by calling
  'wapply'.  By default, bandplot asks wapply to smooth using intervals
  that include the nearest 1/5 of the data.  See the documentation of
  that function for details on the algorithm.
  
}
\value{
  Invisibly returns a list containing the x,y points plotted for each line.
}
\author{ Gregory R. Warnes \email{greg@warnes.net}
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

#
# changing mean and variance
#
x <- abs(rnorm(500))
y <- rnorm(500, mean=2*x, sd=2+2*x)

# the changing mean and dispersion are hard to see whith the points alone:
plot(x,y )

# regression picks up the mean trend, but not the change in variance
reg <- lm(y~x)
summary(reg)

# using bandplot on the original data helps to show the mean and
# variance trend
bandplot(x,y)

# using bandplot on the residuals helps to see that regression removes
# the mean trend but leaves the trend in variability
bandplot(predict(reg),resid(reg))

}
\keyword{ dplot }
