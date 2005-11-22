\name{nwsServer}
\alias{nwsServer}
\alias{nwsServer,nwsServer-class}
\title{Class "nwsServer"}
\description{
Class respresenting connection to a netWorkSpace server.\cr
Objects can be created by calls of the form \code{new("nwsServer")}
}

\section{Methods}{
  \describe{
    \item{initialize}{\code{signature(.Object = "nwsServer")}: ... }
    \item{nwsDeleteWs}{\code{signature(.Object = "nwsServer")}: ... }
    \item{nwsListWss}{\code{signature(.Object = "nwsServer")}: ... }
    \item{nwsMktempWs}{\code{signature(.Object = "nwsServer")}: ... }
    \item{nwsOpenWs}{\code{signature(.Object = "nwsServer")}: ... }
    \item{nwsUseWs}{\code{signature(.Object = "nwsServer")}: ... }
  }
}
\examples{
\dontrun{
s = new("nwsServer")
}
}

\keyword{classes}
\keyword{programming}

