\name{ooplot.default}
\alias{ooplot.default}
\alias{ooplot}
\title{Create an open-office style plot}
\description{
  Create an open-office style line plot from a matrix or table.
}
\usage{
ooplot(data, ...)
ooplot.default(data, width=1, space=NULL, names.arg=NULL,
               legend.text=NULL, beside=TRUE, horiz=FALSE,
               density=NULL, angle=45,
               type=c("xyplot","linear","barplot"),
               col=heat.colors(NR), prcol=NULL, border=par("fg"),
               main=NULL, sub=NULL, xlab=NULL, ylab=NULL, xlim=NULL,
               ylim=NULL, xpd=TRUE, log="", axes=TRUE, axisnames=TRUE,
               cex.axis=par("cex.axis"), cex.names=par("cex.axis"),
               cex.values=0.7, inside=TRUE, plot=TRUE, axis.lty=0,
               plot.ci=FALSE, ci.l=NULL, ci.u=NULL, ci.color="black",
               ci.lty="solid", ci.lwd=1, plot.grid=FALSE,
               grid.inc=NULL, grid.lty="dotted", grid.lwd=1,
               grid.col="black", add=FALSE, , by.row=FALSE,
               ...)
}
\arguments{
  \item{data}{ ~~Describe \code{data} here~~ }
  \item{width}{ ~~Describe \code{width} here~~ }
  \item{space}{ ~~Describe \code{space} here~~ }
  \item{names.arg}{ ~~Describe \code{names.arg} here~~ }
  \item{legend.text}{ ~~Describe \code{legend.text} here~~ }
  \item{beside}{ ~~Describe \code{beside} here~~ }
  \item{horiz}{ ~~Describe \code{horiz} here~~ }
  \item{density}{ ~~Describe \code{density} here~~ }
  \item{angle}{ ~~Describe \code{angle} here~~ }
  \item{type}{ ~~Describe \code{type} here~~ }
  \item{col}{ ~~Describe \code{col} here~~ }
  \item{prcol}{ ~~Describe \code{prcol} here~~ }
  \item{border}{ ~~Describe \code{border} here~~ }
  \item{main}{ ~~Describe \code{main} here~~ }
  \item{sub}{ ~~Describe \code{sub} here~~ }
  \item{xlab}{ ~~Describe \code{xlab} here~~ }
  \item{ylab}{ ~~Describe \code{ylab} here~~ }
  \item{xlim}{ ~~Describe \code{xlim} here~~ }
  \item{ylim}{ ~~Describe \code{ylim} here~~ }
  \item{xpd}{ ~~Describe \code{xpd} here~~ }
  \item{log}{ ~~Describe \code{log} here~~ }
  \item{axes}{ ~~Describe \code{axes} here~~ }
  \item{axisnames}{ ~~Describe \code{axisnames} here~~ }
  \item{cex.axis}{ ~~Describe \code{cex.axis} here~~ }
  \item{cex.names}{ ~~Describe \code{cex.names} here~~ }
  \item{cex.values}{ ~~Describe \code{cex.values} here~~ }
  \item{inside}{ ~~Describe \code{inside} here~~ }
  \item{plot}{ ~~Describe \code{plot} here~~ }
  \item{axis.lty}{ ~~Describe \code{axis.lty} here~~ }
  \item{plot.ci}{ ~~Describe \code{plot.ci} here~~ }
  \item{ci.l}{ ~~Describe \code{ci.l} here~~ }
  \item{ci.u}{ ~~Describe \code{ci.u} here~~ }
  \item{ci.color}{ ~~Describe \code{ci.color} here~~ }
  \item{ci.lty}{ ~~Describe \code{ci.lty} here~~ }
  \item{ci.lwd}{ ~~Describe \code{ci.lwd} here~~ }
  \item{plot.grid}{ ~~Describe \code{plot.grid} here~~ }
  \item{grid.inc}{ ~~Describe \code{grid.inc} here~~ }
  \item{grid.lty}{ ~~Describe \code{grid.lty} here~~ }
  \item{grid.lwd}{ ~~Describe \code{grid.lwd} here~~ }
  \item{grid.col}{ ~~Describe \code{grid.col} here~~ }
  \item{add}{ ~~Describe \code{add} here~~ }
  \item{by.row}{Logical value.  If \code{TRUE} the data matrix is
    organized with variables along rows rather than down colums.}
  \item{\dots}{ ~~Describe \code{\dots} here~~ }
}
\details{
  ~~ If necessary, more details than the __description__  above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{Lodewijk Bonebakker \email{bonebakker@comcast.net} with modifications
  by Gregory R. Warnes \email{gregory\_r\_warnes@groton.pfizer.com}.
  }
\note{ ~~further notes~~ }

\seealso{ ~~objects to See Also as \code{\link{~~fun~~}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

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

