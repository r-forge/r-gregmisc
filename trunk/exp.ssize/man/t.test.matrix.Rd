\name{t.test.matrix}
\alias{t.test.matrix}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
t.test.matrix(ctr, trt)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ctr}{ ~~Describe \code{ctr} here~~ }
  \item{trt}{ ~~Describe \code{trt} here~~ }
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
function(ctr, trt)

{ ngenes <- dim(ctr)[1]
  ctr.s <- get.cumsum(ctr)
  trt.s <- get.cumsum(trt)

  ctr.m <- ctr.s/col(ctr.s) # mean ctr exprs for each gene
  trt.m <- trt.s/col(trt.s)

  diff <- ctr.m - trt.m

  ctr.ss <- get.cumsum(ctr^2) # get sum(Xi ^2)
  trt.ss <- get.cumsum(trt^2)

  ctr.ms <- (ctr.m)^2
  trt.ms <- (trt.m)^2
  ss.pool <- ctr.ss - col(ctr.ms) * ctr.ms + trt.ss - col(trt.ms) * trt.ms
  var.pool <- (ss.pool)/(col(ctr.ms) + col(trt.ms) - 2 )

  se.pool <- sqrt(var.pool * (1/col(ctr.ms) + 1/col(trt.ms) ))

# using the formula se = sqrt((sd.p)^2 * (1/n1 + 1/n2))
# where sd.p = ( sum(x - mean(x))^2 + sum(y - mean(y))^2 )/(n1 + n2 -2)
# 	  sum(x - mean(x))^2 = sum(x.^2) - n1 * (mean(x))^2

# pooled sd for equal sample size for both group
  
  ts <- diff/se.pool
  df <- col(ctr) + col(trt) - 2

# get rid of those null columns (for n =1)
  df<- matrix(df[!is.na(ts)], nr = ngenes)
  ts<- matrix(ts[!is.na(ts)], nr = ngenes)

  tp <- matrix(2*pt(-abs(c(ts)),df =c(df)), nrow = nrow(ts), nc = ncol(ts))
# multiplication factor 2: for 2-sided test p-values

tp
# output is a matrix of p-values of 2-sided t-test with dim
# ngenes x [ncol(ctr)-1]

  }
}
\keyword{ ~kwd1 }% at least one, from doc/KEYWORDS
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
