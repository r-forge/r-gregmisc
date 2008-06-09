\name{sii.excel}
\alias{sii.excel}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
sii.excel(THDI = c(25, 25, 30, 35, 45, 45, 55, 60), freq = c(250, 500, 1000, 2000, 3000, 4000, 6000, 8000), matlab.spline = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{THDI}{ ~~Describe \code{THDI} here~~ }
  \item{freq}{ ~~Describe \code{freq} here~~ }
  \item{matlab.spline}{ ~~Describe \code{matlab.spline} here~~ }
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
function (THDI = c(25, 25, 30, 35, 45, 45, 55, 60), freq = c(250, 
    500, 1000, 2000, 3000, 4000, 6000, 8000), matlab.spline = TRUE) 
{
    if (length(THDI) != length(freq)) 
        stop("THDI must have the same length as freq")
    sii.freqs <- sii.constants[, 1]
    if (matlab.spline) {
        ispl <- interpSpline(THDI ~ freq)
        THDI <- predict(ispl, sii.freqs)$y
    }
    else {
        approx.l <- function(x, y, xout, ...) {
            retval <- approx(log(x), y, log(xout), ...)
            retval$x <- xout
            retval
        }
        THDI <- approx.l(x = freq, y = THDI, method = "linear", 
            xout = sii.freqs, rule = 2)$y
    }
    sii.tab <- sii.constants
    sii.tab[, c("Ti'.THDN", "Xi'.Int.Noise", "Di.Equiv.Dist", 
        "ki.Temp.Var", "Ai.BandAud", "Si.SII.band.")] <- NA
    sii.tab[, "Ti'.THDN"] <- THDI
    sii.tab[, "Xi'.Int.Noise"] <- sii.tab[, "Ti'.THDN"] + sii.tab[, 
        "Xi.Ref.Int.Nz"]
    sii.tab[, "Di.Equiv.Dist"] <- sii.tab[, "Xi'.Int.Noise"]
    sii.tab[, "ki.Temp.Var"] <- ifelse((sii.tab[, "Ei.Raised"] - 
        sii.tab[, "Di.Equiv.Dist"] + 15)/30 > 1, 1, 0)
    sii.tab[, "Ai.BandAud"] <- sii.tab[, "ki.Temp.Var"]
    sii.tab[, "Si.SII.band."] <- sii.tab[, "I.BandImp"] * sii.tab[, 
        "Ai.BandAud"]
    sii.val <- sum(sii.tab[, "Si.SII.band."])
    ret <- list(THDN = THDI, freq = freq, sii = sii.val, table = sii.tab)
    class(ret) <- "SII"
    ret
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
