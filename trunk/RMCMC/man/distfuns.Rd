\name{distfuns}
\alias{distfuns}
\docType{data}
\title{ ~~ data name/kind ... ~~}
\description{
  ~~ A concise (1-5 lines) description of the dataset. ~~
}
\usage{data(distfuns)}
\format{
  The format is:
List of 2
 $ Normal        :List of 5
  ..$ aliases   : chr [1:4] "N" "Norm" "Normal" "Gaussian"
  ..$ random    : chr "rnorm"
  ..$ density   : chr "dnorm"
  ..$ logdensity: chr "log.dnorm"
  ..$ package   : chr "stats"
 $ Inverted Gamma:List of 5
  ..$ aliases   : chr [1:3] "IG" "InvGamma" "Inverted Gamma"
  ..$ random    : chr "rinvgamma"
  ..$ density   : chr "dinvgamma"
  ..$ logdensity: chr "log.dinvgamma"
  ..$ package   : chr "MCMCpack"
}
\details{
  ~~ If necessary, more details than the __description__ above ~~
}
\source{
  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
  ~~ possibly secondary sources and usages ~~
}
\examples{
data(distfuns)
## maybe str(distfuns) ; plot(distfuns) ...
}
\keyword{datasets}
