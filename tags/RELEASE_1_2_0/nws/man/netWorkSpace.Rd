\name{netWorkSpace}
\alias{netWorkSpace}
\alias{netWorkSpace,netWorkSpace-class}
\title{Class "netWorkSpace" }
\description{Class representing netWorkSpace.\cr
Objects can be created by calls of the form \code{new('netWorkSpace', wsName, serverHost, port, useUse, serverWrap, ...)}
}

\section{Methods}{
  \describe{
    \item{initialize}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsClose}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsDeclare}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsDeleteVar}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsFetch}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsFetchTry}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsFind}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsFindTry}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsListVars}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsStore}{\code{signature(.Object = "netWorkSpace")}: ... }
    \item{nwsWsName}{\code{signature(.Object = "netWorkSpace")}: ... }
  }
}
\note{
Creates a NetWorkSpace object referencing the workspace in outer space. (creating the workspace if need be).
More generally, may include arguments to specify host on which the NetWorkSpace server runs, port for that server, and optional attributes for the workspace.
}
\examples{
\dontrun{
# To create a new workspace with the name "my space" use:
ws = new('networkspace', 'my space')

# To create a new workspace called "my space2" on nws server 
# running on port 8245 on machine zeus:
ws = new('networkspace', wsName='my space2', serverHost='zeus', port=8245)
}
}
\keyword{classes}
\keyword{programming}

