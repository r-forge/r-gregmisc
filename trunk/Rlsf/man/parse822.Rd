\name{parse822}
\alias{parse822}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
parse822(filename)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{filename}{ ~~Describe \code{filename} here~~ }
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
\author{ ~~who you are~~ }
\note{ ~~further notes~~ }

 ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{ ~~objects to See Also as \code{\link{~~fun~~}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (filename) 
{
    fileH <- file(filename, "r")
    text <- readChar(fileH, nchars = 1e+05)
    close(fileH)
    text <- gsub("\n([ \t]*\n)+", "\n", text)
    text <- gsub("\n[ \t]+", " ", text)
    text <- unlist(strsplit(text, "\n"))
    text <- gsub("[ \t]+", " ", text)
    text <- gsub("^[ \t]+", "", text)
    text <- gsub("[ \t]+:", ":", text)
    text <- gsub(":[ \t]+", ":", text)
    text <- gsub("[ \t]+$", "", text)
    text <- strsplit(text, ":")
    retval <- lapply(text, function(x) if (length(x) >= 2) 
        x[2]
    else NULL)
    namelist <- sapply(text, function(x) x[1])
    names(retval) <- tolower(namelist)
    retval
  }
}
\keyword{ ~kwd1 }% at least one, from doc/KEYWORDS
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
