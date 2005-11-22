\name{nwsStore}
\alias{nwsStore}
\alias{nwsStore,netWorkSpace-method}
\title{Store something in a WorkSpace}
\description{
Store something in a WorkSpace.}

\usage{
nwsStore(.Object, xName, xVal)
}

\arguments{
   \item{.Object}{A netWorkSpace object}
   \item{xName}{Name of variable to be stored}
   \item{xVal}{Value to be stored}
}

\details{
nwsStore associates the value xVal with the variable xName in the
shared netWorkSpace corresponding to .Object, thereby making the
value available to all the distributed R processes.  If no mode is
given and a mode has not already been set for VarName, FIFO will be
used. The other options for mode are LIFO, multi,and single. See
\code{\link{nwsDeclare}}.  If no variable name is given, then xName
must itself be a variable, and the value xName will be asssociated
with the variables name in the WorkSpace.
}

\example{
\dontrun{
ws = new(netWorkSpace, 'my space')

# To store value 5 bound to variable 'x' on workspace 'ws': 
# (If 'x' already x exists the mode is inherited, otherwise gets the default mode 'fifo')
nwsStore(ws, 'x', 5)
}
}

\keyword{methods}
\keyword{programming}
