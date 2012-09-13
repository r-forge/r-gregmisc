\name{namespace}
\alias{registerNamespace}
\alias{unregisterNamespace}
\alias{makeNamespace}
\alias{getRegisteredNamespace}
\title{
Functions to obtain, create, register, and unregister namespaces
}
\description{
User-level functions to manage namespaces not (yet) available in base R.
}
\usage{
registerNamespace(name=NULL, env=NULL)
unregisterNamespace(name=NULL)
makeNamespace(name, version=NULL, lib=NULL)
getRegisteredNamespace(name)
}
\arguments{
  \item{name}{string}
  \item{env}{namespace environment}
  \item{version}{version}
  \item{lib}{string naming the package/namespace to load}
}
\details{
  \code{registerNamespace} creates a new namespace entry with the
  provided environment.
  
  \code{unregisterNamespace} removes an existing namespace.
  
  \code{makeNamespace} creates a new namespace.
  
  \code{getRegisteredNamespace} returns the specified namespace, or NULL if
  it is not loaded.  (In R 2.16.0 this is just a wrapper for \code{base::.getNamespace}).
}
\references{
  R-devel mailing list topic "[Rd] makeNamespace and rdyncall",
  Dec. 2011:
  \url{https://stat.ethz.ch/pipermail/r-devel/2011-December/062838.html} 

  R-devel mailing list topic "[Rd] rdyncall fears removal from CRAN",
  Aug 2012:
  \url{https://stat.ethz.ch/pipermail/r-devel/2012-August/064659.html} 
}
\author{
  Winston Chang, Daniel Adler, Hadley Wickham, Gregory R. Warnes, and 
  code from the R 'base' package.
}
\note{
  These functions provide support for namespaces needed by some
  low-level packages (e.g. \code{devtools} and \code{rdynload})
  requested by their respective authors.
}
\seealso{
  \code{\link[base]{ns-internal}}
}
\examples{
## Examples needed! ##
}
\keyword{programming}
