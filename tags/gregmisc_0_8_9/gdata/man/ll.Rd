\name{ll}
\alias{ll}
\title{
  Display Information about Objects in a Given Environment
}
\description{
  Display name, class, size, and dimensions of each object in a given
  environment.
}
\usage{
ll(pos=1, unit=c("KB","MB","bytes"), digits=0, dimensions=FALSE,
        function.dim="", ...)
}
\arguments{
  \item{pos}{environment position number or name.}
  \item{unit}{required unit for displaying object size: "KB", "MB",
    "bytes", or first letter.}
  \item{digits}{number of decimals to display when rounding object
    size.}
  \item{dimensions}{whether object dimensions should be returned.}
  \item{function.dim}{value to report as the dimension of function objects.}
  \item{...}{passed to \code{ls()}.}
}
\details{
  A verbose alternative to \code{ls()}.
}
\value{
  A data frame with named rows and the following columns:
  \item{Class}{object class.}
  \item{KB}{object size \emph{(see notes)}.}
  \item{Dim}{object dimensions \emph{(optional)}.}
}
\note{
  The name of the object size column is the same as the unit used.

  Objects of class \code{classRepresentation},
  \code{ClassUnionRepresentation}, and \code{grob} do not have a defined
  size, so 0 bytes are assumed for those.
}
\author{Arni Magnusson \email{arnima@u.washington.edu}}
\seealso{
  \code{\link{ls}} displays names of objects in a given environment.

  \code{\link{elem}} and \code{\link{env}} are related to \code{ll}.
}
\examples{
ll()
ll(all=TRUE)
ll("package:base")
ll("package:base")[ll("package:base")$Class!="function",]
}
% Basics
\keyword{data}
\keyword{attribute}
\keyword{classes}
% Programming
\keyword{environment}
\keyword{utilities}
