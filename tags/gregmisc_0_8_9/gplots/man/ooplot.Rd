\name{ooplot.default}
\alias{ooplot.default}
\alias{ooplot}
\title{Create an open-office style plot}
\description{
  Create an open-office style line plot from a matrix or table.
}
\usage{
ooplot(data, ...)
\method[default]{ooplot}(data, width=1, space=NULL, names.arg=NULL,
       legend.text=NULL, beside=TRUE, horiz=FALSE, density=NULL,
       angle=45, type=c("xyplot", "linear", "barplot"),
       col=heat.colors(NR), prcol=NULL, border=par("fg"), main=NULL,
       sub=NULL, xlab=NULL, ylab=NULL, xlim=NULL, ylim=NULL, xpd=TRUE,
       log="", axes=TRUE, axisnames=TRUE, cex.axis=par("cex.axis"),
       cex.names=par("cex.axis"), cex.values=0.7, inside=TRUE,
       plot=TRUE, axis.lty=0, plot.ci=FALSE, ci.l=NULL, ci.u=NULL,
       ci.color="black", ci.lty="solid", ci.lwd=1, plot.grid=FALSE,
       grid.inc=NULL, grid.lty="dotted", grid.lwd=1, grid.col="black",
       add=FALSE, by.row=FALSE, ...)
}
\arguments{
  \item{data}{A dataframe or matrix with one column (row if
    \code{by.row}=TRUE) of x-values and one or more columns (rows) of
    y-values.}
  \item{width}{ (Not yet documented.) }
  \item{space}{ (Not yet documented.) }
  \item{names.arg}{ (Not yet documented.) }
  \item{legend.text}{ (Not yet documented.) }
  \item{beside}{ (Not yet documented.) }
  \item{horiz}{ (Not yet documented.) }
  \item{density}{ (Not yet documented.) }
  \item{angle}{ (Not yet documented.) }
  \item{type}{ (Not yet documented.) }
  \item{col}{ (Not yet documented.) }
  \item{prcol}{ (Not yet documented.) }
  \item{border}{ (Not yet documented.) }
  \item{main}{ (Not yet documented.) }
  \item{sub}{ (Not yet documented.) }
  \item{xlab}{ (Not yet documented.) }
  \item{ylab}{ (Not yet documented.) }
  \item{xlim}{ (Not yet documented.) }
  \item{ylim}{ (Not yet documented.) }
  \item{xpd}{ (Not yet documented.) }
  \item{log}{ (Not yet documented.) }
  \item{axes}{ (Not yet documented.) }
  \item{axisnames}{ (Not yet documented.) }
  \item{cex.axis}{ (Not yet documented.) }
  \item{cex.names}{ (Not yet documented.) }
  \item{cex.values}{ (Not yet documented.) }
  \item{inside}{ (Not yet documented.) }
  \item{plot}{ (Not yet documented.) }
  \item{axis.lty}{ (Not yet documented.) }
  \item{plot.ci}{ (Not yet documented.) }
  \item{ci.l}{ (Not yet documented.) }
  \item{ci.u}{ (Not yet documented.) }
  \item{ci.color}{ (Not yet documented.) }
  \item{ci.lty}{ (Not yet documented.) }
  \item{ci.lwd}{ (Not yet documented.) }
  \item{plot.grid}{ (Not yet documented.) }
  \item{grid.inc}{ (Not yet documented.) }
  \item{grid.lty}{ (Not yet documented.) }
  \item{grid.lwd}{ (Not yet documented.) }
  \item{grid.col}{ (Not yet documented.) }
  \item{add}{Logical value.  If FALSE (the default), a new plot region is
    created.  If TRUE, the plot is added to the current plot region.}
  \item{by.row}{Logical value.  If FALSE (the default), each column
    represents a variable.  If TRUE, each row represents a variable.}
  \item{\dots}{Optional plotting parameters.}
}
\details{
  \emph{This code is not yet properly documented.  Feel free to help out.}
}
\value{
  To be written.
}
\author{Lodewijk Bonebakker \email{bonebakker@comcast.net} with modifications
  by Gregory R. Warnes \email{gregory\_r\_warnes@groton.pfizer.com}.
  }
\seealso{\code{\link{barplot2}},\code{\link[base]{barplot}} }
\examples{
     data(VADeaths, package = "base")

     VADeaths <- cbind( Age=c(50,55,60,65,70), VADeaths)

     mp <- ooplot(VADeaths) # default
     mp <- ooplot(VADeaths, type="xyplot")  # same as default
     mp <- ooplot(VADeaths, type="linear")  # linear scale
     mp <- ooplot(VADeaths, type="barplot") # barplot

     tot <- colMeans(VADeaths[,-1])
     ooplot(VADeaths, 
             col = c("lightblue", "mistyrose", "lightcyan", "lavender"),
             legend = colnames(VADeaths)[-1], ylim = c(0, 100),
             type="barplot", cex.values=1)
     title(main = "Death Rates in Virginia", font.main = 4)
}
\keyword{hplot}
