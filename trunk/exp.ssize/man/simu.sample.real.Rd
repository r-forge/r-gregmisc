\name{simu.sample.real}
\alias{simu.sample.real}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
simu.sample.real(sd.null, sd.alt, cov.null, ngenes.null.dep, cov.alt, ngenes.alt.dep, n, var.ratio, delta)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sd.null}{ ~~Describe \code{sd.null} here~~ }
  \item{sd.alt}{ ~~Describe \code{sd.alt} here~~ }
  \item{cov.null}{ ~~Describe \code{cov.null} here~~ }
  \item{ngenes.null.dep}{ ~~Describe \code{ngenes.null.dep} here~~ }
  \item{cov.alt}{ ~~Describe \code{cov.alt} here~~ }
  \item{ngenes.alt.dep}{ ~~Describe \code{ngenes.alt.dep} here~~ }
  \item{n}{ ~~Describe \code{n} here~~ }
  \item{var.ratio}{ ~~Describe \code{var.ratio} here~~ }
  \item{delta}{ ~~Describe \code{delta} here~~ }
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
function(sd.null, sd.alt, cov.null, ngenes.null.dep, cov.alt, ngenes.alt.dep, n,
		var.ratio, delta)

{ ## start of the function simu.sample

  ngenes.null.ind <- length(sd.null)
  ngenes.alt.ind <- length(sd.alt)
  ngenes <- sum(ngenes.null.ind, ngenes.null.dep, ngenes.alt.ind, ngenes.alt.dep)

  result<- matrix(0, nr = ngenes, nc = n*2)	# place to store the simulated sample

# simulate sample for the each category

if (ngenes.null.ind > 0 ) {
  index <- c(1, ngenes.null.ind)
  result[index[1] : index[2], ] <- sample.genes.ind.2( n , sd.null, var.ratio, delta = 0)

 }
 
if (ngenes.null.dep > 0) {
  index <- ngenes.null.ind + c(1, ngenes.null.dep)
  result[index[1] : index[2], ] <- sample.dep.2(ngenes.null.dep , n, var.ratio, cov.null, delta = 0)
 }

if (ngenes.alt.ind > 0) {
  index <- ngenes.null.ind + ngenes.null.dep  + c(1, ngenes.alt.ind)
  result[index[1] : index[2], ] <- sample.genes.ind.2( n, sd.alt, var.ratio, delta)
  }

if (ngenes.alt.dep > 0) {
  index <- ngenes.null.ind + ngenes.null.dep + ngenes.alt.ind + c(1, ngenes.alt.dep)
  result[index[1] : index[2], ] <- sample.dep.2(ngenes.alt.dep , n,  var.ratio, cov.alt, delta )
  }	

 result # take n.est columns of data
  } ## the end of the function simu.sample
}
\keyword{ ~kwd1 }% at least one, from doc/KEYWORDS
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
