\name{balloonplot}
\alias{balloonplot}
\alias{balloonplot.default}
\alias{balloonplot.table}
\title{Plot a graphical matrix where each cell contains a dot whose size
  reflects the relative magnitude of the corresponding component.}
\description{
  Plot a graphical matrix where each cell contains a dot whose size
  reflects the relative magnitude of the corresponding component.
}
\usage{
balloonplot(x, ...)
\method{balloonplot}{table}function (x, xlab, ylab, zlab, ...)
\method{balloonplot}{default}(x, y, z, xlab = deparse(substitute(x)),
    ylab = deparse(substitute(y)), 
    zlab = deparse(substitute(z)), dotcolor = "skyblue", main, 
    label = TRUE, label.digits = 2, scale.method = c("volume", 
        "diameter"), ...)
}
\arguments{
  \item{x}{Either a table object, or a vector of values for the first
    (x) dimension of the plotted matrix.}
  \item{y}{Vector of values for the second (y) dimension of the plotted
    matrix.}
  \item{z}{Vector of values for the size of the dots in the plotted matrix.}
  \item{xlab}{Text label for the x dimension. This will be displayed on the
    x axis and in the plot title.}
  \item{ylab}{Text label for the y dimension. This will be displayed on the
    y axis and in the plot title.}
  \item{zlab}{Text label for the dot size. This will be included in the
    plot title.}
  \item{dotcolor}{Scalar or vector specifying the color(s) of the dots in
    the plot.}
  \item{main}{Plot title text.}
  \item{label}{Boolean flag indicating whether the actual value of the
    elements should be shown on the plot.}
  \item{label.digits}{Number of digits used in formatting value labels.}
  \item{scale.method}{Method of scaling the sizes of the dot, either
    "volume" or "diameter". See below.}
  \item{\dots}{ Additional arguments passed to \code{balloonplot.default}
    or \code{plot}, as appropriate.}
}
\details{
  This function plots a visual matrix.  In each \code{x},\code{y} cell a
  dot is plotted which reflects the relative size of the corresponding
  value of \code{z}.  When \code{scale.method="volume"} the volume of
  the dot is proportional to the relative size of \code{z}.  When
  \code{scale.method="diameter"}, the diameter of the dot is proportional to
  the the relative size of \code{z}.  The "volume" method is default
  because the "diameter" method visually exaggerates differences.
}
\value{
  Nothing of interest.
}
\note{
  \code{z} is expected to be non-negative.  The function will still
  operate correctly if there are negative values of \code{z}, but the
  corresponding dots will have 0 size and a warning will be generated.
  }
\references{Function inspired by question posed on R-help by Ramon
  \email{allende@gredos.cnb.uam.es}.}

\author{ Gregory R. Warnes \email{Gregory\_R\_Warnes@groton.pfizer.com}}

\seealso{ \code{\link{plot.table}} }

\examples{
\testonly{
set.seed(12425421)
}

# Create an Example Data Frame Containing Car x Color data
carnames <- c("bmw","renault","mercedes","seat")
carcolors <- c("red","white","silver","green")
datavals <- round(rnorm(16, mean=100, sd=60),1)
data <- data.frame(Car=rep(carnames,4),
                   Color=rep(carcolors, c(4,4,4,4) ),
                   Value=datavals )
# show the data
data

# generate balloon plot with default scaling
balloonplot( data$Car, data$Color, data$Value)


# Create an example using table
xnames <- sample( letters[1:3], 50, replace=2)
ynames <- sample( 1:5, 50, replace=2)

tab <- table(xnames, ynames)

balloonplot(tab)


}
\keyword{dplot}
\keyword{hplot}
