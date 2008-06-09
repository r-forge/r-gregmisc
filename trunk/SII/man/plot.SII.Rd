\name{plot.SII}
\alias{plot.SII}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plot.SII(x, matlab, title, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{ ~~Describe \code{x} here~~ }
  \item{matlab}{ ~~Describe \code{matlab} here~~ }
  \item{title}{ ~~Describe \code{title} here~~ }
  \item{\dots}{ ~~Describe \code{\dots} here~~ }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x, matlab, title, ...) 
{
    plot(x = x$freq.orig, y = x$x.orig, col = "black", cex = 2, 
        log = "x", xlab = "Frequency (Herz)", ylab = "Threshhold of Detection (dB)", 
        ylim = c(1, 80), xlim = c(100, 8500))
    if (!missing(matlab)) 
        lines(sii.constants[, 1], matlab, type = "l", col = "red", 
            lwd = 3)
    lines(x = sii.constants[, 1], y = x$table[, "T'i"], col = "blue", 
        lwd = 2)
    abline(v = sii.constants[, 1], lty = 2)
    legend("topleft", legend = c("Measured data", "Matlab INTERP1(X, Y, XI, 'spline', 'extrap')", 
        "R's approx(X,Y, XI, xout=XI,\n method='linear', rule=2)"), 
        col = c("black", "red", "blue", "green", "orange", "magenta"), 
        pch = c(1, NA, NA, NA, NA, NA), lty = c(NA, 1, 1, 1, 
            1, 1), lwd = c(NA, 3, 2, 2, 2, 2), bg = "white")
    title(title)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
