\name{qqnorm.aov}
\alias{qqnorm.aov}

\title{ Makes a half or full normal plot for the effects from an aov model }
\description{
  Makes a half or full normal plot for the effects from a model
  inheriting from class \code{aov}. One can interactively label the
  points in the plot. 
}
\usage{
qqnorm.aov(obj, full=FALSE, label=FALSE, omit=NULL,
           xlab=paste(if (full) "" else "Half", " Normal plot"),
           ylab="Effects", ...)
}

\arguments{
  \item{obj}{A model object inheriting from \code{aov}}
  \item{full}{Full or half normal plot (half is default) }
  \item{label}{if \code{TRUE}, function allows interactive
                          labelling of points in plot }
  \item{omit}{Numeric or character vector of effects to omit,
                    the intercept is always omitted}
  \item{xlab}{horizontal axix label }
  \item{ylab}{vertical axis label }
  \item{\dots}{further arguments to be given to the plot function }
}
\details{
  This is a simpler implementation than the one in S-Plus.
}
\value{
 If \code{label=TRUE}, the vector of points identified, else nothing of
  interest.
}

\author{ Kjetil Halvorsen \email{kjetilh@jupiter.umsanet.edu.bo} }

\examples{
library(MASS)
data(npk)
npk.aov <- aov(yield ~ block + N*P*K, npk)
qqnorm(npk.aov)
if (dev.interactive()) qqnorm(npk.aov, omit=2:6, label=T)
}
\keyword{ hplot }%
\keyword{ design }


