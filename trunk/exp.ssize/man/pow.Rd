\name{pow}
\alias{pow}

\title{ Calculate power given sd, n, effect size (delta), sig.level }
\description{
 Calculate power given sd, n, effect size (delta), sig.level 
}
\usage{
pow(sd, n, delta, sig.level, alpha.correct = "Bonferonni")
}

\arguments{
  \item{sd}{ vector of sd }
  \item{n}{ sample size }
  \item{delta}{ effect size }
  \item{sig.level}{ type I error rate to control }
  \item{alpha.correct}{ default is Bonferroni adjustment ,
	 if specified to be others, no adjustment for multiple comparison }
}
%\details{
%  calls power.t.test
%}
\value{
	returns a vector of power for corresponding sd
}
\references{ ctest library }
\author{ Gregory R. Warnes\email{Gregory_R_Warnes@groton.pfizer.com}}

% \note{ ~~further notes~~ }
% ~Make other sections like Warning with \section{Warning }{....} ~
% \seealso{ ~~objects to See Also as \code{\link{~~fun~~}}, ~~~ }

\examples{
sd<-(1:4) *0.1
test <- pow(sd, n=6, delta=1, sig.level=0.05, alpha.correct="Bonferonni")
}
\keyword{ statistics } 