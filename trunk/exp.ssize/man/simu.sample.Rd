\name{simu.sample}
\alias{simu.sample}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
simu.sample(ngenes, n, fractn.alt, fractn.dep, var.ratio, cov.matrix, ngenes.matrix, delta)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ngenes}{ ~~Describe \code{ngenes} here~~ }
  \item{n}{ ~~Describe \code{n} here~~ }
  \item{fractn.alt}{ ~~Describe \code{fractn.alt} here~~ }
  \item{fractn.dep}{ ~~Describe \code{fractn.dep} here~~ }
  \item{var.ratio}{ ~~Describe \code{var.ratio} here~~ }
  \item{cov.matrix}{ ~~Describe \code{cov.matrix} here~~ }
  \item{ngenes.matrix}{ ~~Describe \code{ngenes.matrix} here~~ }
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
function(ngenes, n, fractn.alt, fractn.dep, var.ratio, cov.matrix, ngenes.matrix, delta)
{ ## start of the function simu.sample

# get the number of genes in each of the four categories
  ngenes.null.ind <- round(ngenes * ( 1-fractn.alt ) * ( 1-fractn.dep ))
  ngenes.null.dep <- round(ngenes * ( 1-fractn.alt ) * fractn.dep )

  ngenes.alt.ind <- round(ngenes * fractn.alt * ( 1-fractn.dep ))
  ngenes.alt.dep <- ngenes - ngenes.null.ind - ngenes.null.dep - ngenes.alt.ind  

  result<- array(0, c(ngenes, n*2))	# place to store the simulated sample
					# for each gene, first n samples from ctrl
					# then n samples from treatment group


# simulate sample for the each category
  index <- c(1, ngenes.null.ind)
  result[index[1] : index[2], ] <- sample.null.ind( ngenes.null.ind , n, var.ratio)

  index <- index[2] + c(1, ngenes.null.dep)
  result[index[1] : index[2], ] <- sample.null.dep( ngenes.null.dep , n, var.ratio, cov.matrix, ngenes.matrix)

  index <- index[2] + c(1, ngenes.alt.ind)
  result[index[1] : index[2], ] <- sample.alt.ind( ngenes.alt.ind , n, var.ratio, delta)

  index <- index[2] + c(1, ngenes.alt.dep)
  result[index[1] : index[2], ] <- sample.alt.dep( ngenes.alt.dep , n, var.ratio, cov.matrix, ngenes.matrix, delta)	
	
 result[1:ngenes,]
  } ## the end of the function simu.sample
}
\keyword{ datagen }% at least one, from doc/KEYWORDS
\keyword{ multivariate }% __ONLY ONE__ keyword per line
