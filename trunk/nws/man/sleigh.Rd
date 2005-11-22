\name{sleigh}
\alias{sleigh}
\alias{sleigh,sleigh-class}
\title{Class representing sleigh}
}
\description{
Class representing sleigh. 
Objects can be created by calls of the form \code{sleigh(nodeList, ...)}\cr
nodeList is a list of machine names to start up sleigh workers. 
}

\details{
Takes a list of node names (which may be repeated)  and a list of options
(for nws host, port, and space name template, launch command, user, 
and script directory). All options have default values. \cr
nws host defaults to localhost.\cr
port defaults to 8765.\cr
space name defaults to unique generated name with prefix `sleigh\_ride' \cr
lauch command defaults to SSH.\cr
user defaults to the user who starts up R session. \cr
script directory defaults to the directory where R session starts. \cr
}


\section{Slots}{
  \describe{
    \item{\code{nodeList}:}{Object of class \code{"character"} representation of hosts, where workers will be created}
    \item{\code{nws}:}{Object of class \code{"netWorkSpace"} representation of netWorkSpace object. }
    \item{\code{nwsName}:}{Object of class \code{"character"} netWorkSpace name.}
    \item{\code{nwss}:}{Object of class \code{"nwsServer"} representation of nwsServer object.} 
    \item{\code{options}:}{Object of class \code{"environment"} options environment variable.}
    \item{\code{state}:}{Object of class \code{"environment"} representation of sleigh state.}
    \item{\code{workerCount}:}{Object of class \code{"numeric"} number of sleigh workers.}
  }
}


\section{Methods}{
  \describe{
    \item{eachElem}{\code{signature(.Object = "sleigh")}: ... }
    \item{eachWorker}{\code{signature(.Object = "sleigh")}: ... }
    \item{initialize}{\code{signature(.Object = "sleigh")}: ... }
    \item{stopSleigh}{\code{signature(.Object = "sleigh")}: ... }
  }
}

\examples{
\dontrun{
# Default option: create three sleigh workers on local host
s = sleigh()
# Or, 
s = new('sleigh')

# Create sleigh workers on multiple machines
s = sleigh(c('n1', 'n2', 'n3'))

# Use LSF instead of SSH for remote login. 
# to login to remote machines. 
s = sleigh(launch=lsfcmd)

# Use RSH instead
s = sleigh(launch=rshcmd)
}
}
\keyword{classes}
\keyword{programming}

