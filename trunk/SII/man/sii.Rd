\name{sii}
\alias{sii}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
sii(x, freq, noise, method = c("interpolate", "critical", "one-third octave", "equal-contributing", "octave"), voice = c("raised", "normal", "loud", "shout"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{ ~~Describe \code{x} here~~ }
  \item{freq}{ ~~Describe \code{freq} here~~ }
  \item{noise}{ ~~Describe \code{noise} here~~ }
  \item{method}{ ~~Describe \code{method} here~~ }
  \item{voice}{ ~~Describe \code{voice} here~~ }
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
function (x, freq, noise, method = c("interpolate", "critical", 
    "one-third octave", "equal-contributing", "octave"), voice = c("raised", 
    "normal", "loud", "shout")) 
{
    if (!(is.matrix(x) || is.data.frame(x))) 
        x <- matrix(x, nrow = 1)
    method = match.arg(method)
    voice = match.arg(voice)
    if (method == "interpolate") 
        data.name = "critical"
    else data.name = method
    table <- read.csv("SII_Table1.csv", skip = 3, header = TRUE, 
        nrows = 21, check.names = FALSE)
    if (method == "interpolate") {
        if (missing(freq) || length(freq) != ncol(x)) 
            stop("`freq' must contain the frequencies corresponding to the measurements in `x'.")
    }
    else {
        if (missing(freq)) 
            freq <- table[, "fi"]
        else if (freq != table[, "fi"]) 
            stop("`freq' does not match frequencies specified in table ", 
                data.name, ".")
    }
    if (missing(noise)) 
        noise <- rep(0, length(freq))
    nas <- is.na(x)
    if (any(nas)) {
        if (method == "interpolate") {
            x <- x[!nas]
            freq <- freq[!nas]
            noise <- noise[!nas]
        }
        else stop("NA's only permitted for method 'interpolate'")
    }
    ord <- order(freq)
    x <- x[ord]
    freq <- freq[ord]
    noise <- noise[ord]
    retval <- list()
    retval$call <- match.call()
    retval$x.orig <- x
    retval$freq.orig <- freq
    retval$noise.orig <- noise
    if (method == "interpolate") {
        approx.l <- function(x, y, xout, ...) {
            retval <- approx(log(x), y, log(xout), ...)
            retval$x <- xout
            retval
        }
        sii.freqs <- table[, "fi"]
        THDI <- approx.l(x = freq, y = x, method = "linear", 
            xout = sii.freqs, rule = 2)$y
        noise <- approx.l(x = freq, y = noise, method = "linear", 
            xout = sii.freqs, rule = 2)$y
        freq <- sii.freqs
        x <- THDI
    }
    col.names <- c("Fi", "E'i", "N'i", "T'i", "Vi", "Bi", "Ci", 
        "Z'i", "Xi", "X'i", "Di", "Ui", "Li", "Ki", "Ai", "Ii", 
        "IiAi")
    sii.tab <- matrix(nrow = length(freq), ncol = length(col.names))
    colnames(sii.tab) <- col.names
    rownames(sii.tab) <- 1:nrow(sii.tab)
    sii.tab[, "Fi"] <- freq
    sii.tab[, "E'i"] <- table[, voice]
    sii.tab[, "N'i"] <- noise
    sii.tab[, "T'i"] <- x
    if (method == "octave") 
        sii.tab[, "Zi"] <- sii.tab[, "N'i"]
    else {
        sii.tab[, "Vi"] <- sii.tab[, "E'i"] - 24
        sii.tab[, "Bi"] <- pmax(sii.tab[, "N'i"], sii.tab[, "Vi"])
        if (method == "critical" || method == "interpolate" || 
            method == "equal-contributing") {
            sii.tab[, "Ci"] = -80 + 0.6 * (sii.tab[, "Bi"] + 
                10 * log10(table[, "fi.high"] - table[, "fi.low"]))
            Zifun <- function(i) {
                if (i > 1) 
                  inner <- sum(10^(0.1 * sii.tab[1:(i - 1), "Bi"] + 
                    3.32 * sii.tab[1:(i - 1), "Ci"] * log10(table[i, 
                      "Fi"]/table[1:(i - 1), "Fi.high"])))
                else inner <- 0
                10 * log10(10^(0.1 * sii.tab[i, "N'i"]) + inner)
            }
            sii.tab[, "Z'i"] = sapply(1:nrow(sii.tab), Zifun)
        }
        else {
            sii.tab[, "Ci"] = -80 + 0.6 * (sii.tab[, "Bi"] + 
                10 * log10(sii.tab[, "Fi"]) - 6.353)
            Zifun <- function(i) {
                if (i > 1) 
                  inner <- sum(10^(0.1 * sii.tab[1:(i - 1), "Bi"] + 
                    3.32 * sii.tab[1:(i - 1), "Ci"] * log10(0.89 * 
                      table[i, "Fi"]/table[1:(i - 1), "Fi.high"])))
                else inner <- 0
                10 * log10(10^(0.1 * sii.tab[i, "N'i"]) + inner)
            }
            sii.tab[, "Z'i"] = sapply(1:nrow(sii.tab), Zifun)
        }
        sii.tab[1, "Z'i"] <- sii.tab[1, "Bi"]
    }
    sii.tab[, "Xi"] <- table[, "Xi"]
    sii.tab[, "X'i"] <- sii.tab[, "T'i"] + sii.tab[, "Xi"]
    sii.tab[, "Di"] <- max(sii.tab[, "Z'i"], sii.tab[, "X'i"])
    sii.tab[, "Ui"] <- table[, "normal"]
    enforce.range <- function(x) {
        x[x < 0] <- 0
        x[x > 1] <- 1
        x
    }
    sii.tab[, "Li"] <- enforce.range(1 - (sii.tab[, "E'i"] - 
        sii.tab[, "Ui"] - 10)/160)
    sii.tab[, "Ki"] <- enforce.range((sii.tab[, "E'i"] - sii.tab[, 
        "Di"] + 15)/30)
    sii.tab[, "Ai"] <- sii.tab[, "Li"] * sii.tab[, "Ki"]
    sii.tab[, "Ii"] <- table[, "Ii"]
    sii.tab[, "IiAi"] <- table[, "Ii"] * sii.tab[, "Ai"]
    sii.val <- sum(sii.tab[, "IiAi"])
    retval$THDN <- x
    retval$freq <- freq
    retval$sii <- sii.val
    retval$table <- sii.tab
    class(retval) <- "SII"
    retval
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
