\name{sample.hyp.dep}

\alias{sample.null.ind}
\alias{sample.alt.dep}

\title{ Generate observations from each hypothesis (null/alternative)
        group based on dependent normal distribution }
\description{
 	  Generate observations from each hypothesis (null/alternative)
        group based on dependent normal distribution}
\usage{
sample.null.dep(ngenes.null.dep, n, var.ratio, cov.matrix, ngenes.matrix)
sample.alt.dep(ngenes.alt.dep, n, var.ratio, cov.matrix, ngenes.matrix, delta)
}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{ngenes.null.dep}{ an integer number for the number of observations
           (gene expression values) to simulate for genes coming from true
            null hypothesis}
  \item{n}{ number of replicates for each group of control/treatment}
  \item{var.ratio}{ ratio of variance between treatment/control}
  \item{cov.matrix}{  a list of covariance matrices to sample the covariance from }
  \item{ngenes.matrix}{ the number of covariance matrices in the list of cov.matrix }
  \item{distrn}{ always being normal}

  \item{ngenes.alt.dep}{an integer number for the number of observations
           (gene expression values) to simulate for genes coming from true
            alternative hypothesis}
  \item{delta}{ effect size for sample size calculation
           the absolute distance from zero for expression values of genes 
           coming from the true alternative hypothesis group}

}
% \details{
%   ~~ If necessary, more details than the __description__  above ~~
% }

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
function( ngenes.alt.dep , n, var.ratio, cov.matrix, ngenes.matrix, delta, distrn = "normal")
{ ## start of the fn sample.null.dep

     sample <- sample.dep(ngenes.alt.dep , n,  var.ratio, cov.matrix, ngenes.matrix, delta )
     sample

  } ## the end of the function sample.null.dep
}
\keyword{ ~kwd1 }% at least one, from doc/KEYWORDS
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
