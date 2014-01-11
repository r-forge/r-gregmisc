\name{gtools-defunct}
\alias{gtools-defunct}
\alias{assert}
\alias{addLast}
\title{Defunct Functions in package \code{gtools}}
\description{
     The functions or variables listed here are no longer part of
     package \code{gtools}.
}
\usage{
assert(FLAG)
addLast(fun)
capture(
}
%\arguments{
%  \item{FLAG}{ Expression that should evaluate to a boolean vector}
%  \item{fun}{Function to be called.}
%}
\details{
  \itemize{
    \item{ \code{assert} is a defunct synonym for
          \code{\link[base]{stopifnot}}. }
    \item{ \code{addLast} has been replaced by \code{lastAdd}, which has
          the same purpose but appled using different syntax. }
    \item{ \code{capture} and \code{capture.output} have been removed in
          favor of \code{capture.output} from the \code{base} package.}
  }
}
\seealso{
  \code{\link[base]{Defunct}},
  \code{\link[base]{stopifnot}},
  \code{\link[gtools]{lastAdd}},
  \code{\link[base]{capture.output}
}
\keyword{misc}
