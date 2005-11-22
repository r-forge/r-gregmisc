\name{sleighPending}
\alias{sleighPending, sleighPending-class}
\title{Class representing sleighPending}
\description{
Class representing sleighPending.\cr
Objects can be created by calls of the form \code{new("sleighPending", nws, numTasks, bn, ss)}.
However, this class is often used in conjunction with non-blocking eachWorker or non-blocking eachElem. 
}

\section{Slots}{
  \describe{
    \item{\code{nws}:}{Object of class \code{"netWorkSpace"} representation of netWorkSpace object. }
    \item{\code{numTasks}:}{Object of class \code{"numeric"} represents the number of tasks. }
    \item{\code{barrierName}:}{Object of class \code{"character"} barrier name}
    \item{\code{sleighState}:}{Object of class \code{"environment"} representation of sleigh state. }
    \item{\code{state}:}{Object of class \code{"environment"} representation of sleighPending state.}
  }
}
\section{Methods}{
  \describe{
    \item{checkSleigh}{\code{signature(.Object = "sleighPending")}: ... }
    \item{initialize}{\code{signature(.Object = "sleighPending")}: ... }
    \item{waitSleigh}{\code{signature(.Object = "sleighPending")}: ... }
  }
}

\keyword{classes}
\keyword{programming}
