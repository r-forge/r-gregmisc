\name{kill}
\alias{kill}
\alias{killall}
\title{Send a signal to one or more processes.}
\description{ 
  This function sends a signal to a process.}
}
\usage{
kill(pid, signal = 9)
killall(signal)
}
\arguments{
  \item{pid}{Process ID for the target process}
  \item{signal}{Signal number to send.  Defaults to 9 (SIGKILL)}
}
\details{
  The \code{kill} function provides a thin wrapper around the Unix
  "kill" system, which sends a signal to the specified process.  The
  \code{killall} function sends a signal to all processes which have
  been \code{forked} during this session.

  Refer to the local Unix man pages for details.
}
\value{
  Returns 0 on successful completion, otherwise -1.
}
\references{"kill" and "waitpid"  man pages}
\author{Gregory R Warnes <gregory_r_wanres@groton.pfizer.com}
\seealso{\code{\link{fork}}, \code{\link{exit}}, \code{\link{kill}}}
\examples{

   # start a process that just sleeps for 10 seconds
    sleepy <- function() 
     {
       cat("Going to sleep..")
       Sys.sleep(10)
       cat("Woke up!")
     }
   pid <- fork( sleepy )

   # kill the sleeping process
   kill(pid)


}
\keyword{programming}

