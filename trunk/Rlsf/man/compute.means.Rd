\name{compute.means}
\alias{compute.means}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
compute.means(SRC.DIR, AFFY.DIR, INPUT.DIR, WORK.DIR, OUT.DIR)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SRC.DIR}{ ~~Describe \code{SRC.DIR} here~~ }
  \item{AFFY.DIR}{ ~~Describe \code{AFFY.DIR} here~~ }
  \item{INPUT.DIR}{ ~~Describe \code{INPUT.DIR} here~~ }
  \item{WORK.DIR}{ ~~Describe \code{WORK.DIR} here~~ }
  \item{OUT.DIR}{ ~~Describe \code{OUT.DIR} here~~ }
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
function (SRC.DIR, AFFY.DIR, INPUT.DIR, WORK.DIR, OUT.DIR) 
{
    setwd(WORK.DIR)
    library(affy)
    library(gregmisc)
    source(file.path(SRC.DIR, "parse822.R"))
    source(file.path(SRC.DIR, "utility.R"))
    load(file.path(WORK.DIR, "probeset_data.Rda"))
    group.means <- fit.model(fun = "lm", formula = "-1 + Label", 
        coef.only = TRUE, )
    outfile <- "means.Rda"
    cat("Writing out results for group means to ", outfile, "...\n")
    save(group.means, file = file.path(WORK.DIR, outfile), compress = T)
    save(group.means, file = "group_means.Rda")
  }
}
\keyword{ ~kwd1 }% at least one, from doc/KEYWORDS
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
