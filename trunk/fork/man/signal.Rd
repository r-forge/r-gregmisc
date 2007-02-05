\name{signal}
\alias{signal}
\title{Enable or disable handling of signals}
\description{ 
  This function allows enabling or disabling handling of the specified signal.
}
\usage{
signal(signal, action = c("ignore", "default"))
}
\arguments{
  \item{signal}{Signal handler to manipulate, either as a numeric id or
    character mnemonic}
  \item{action}{Either "ignore" or "default"}
}
\details{
  It is occasionally necessary to instruct the R process to ignore
  certain signals.  This function allows changing the status of a signal
  to either igore the signal (SIG\_IGN="ignore") or to the OS's default
  handler (SIG\_DFL="default")  
}
\value{
  Nothing of interest.
}
\references{ See the unix man page for "signal" for more information}
\author{Gregory R. Warnes \email{gregory.warnes@rochester.edu} }
\note{
  Be very careful with this function.  It can be used to totally
  confuse the R process.
}
\seealso{  \code{\link{sigval}}, \code{\link{fork}} }
\examples{
\dontrun{
# Ignore child termination signals for forked processes
signal("SIGCHLD","ignore")

# Fork off a child process to say "Hi!".
 {
    pid = fork(slave=NULL) 
    if(pid==0) {
      # only runs in the child process
      cat("Hi from the child process!\n");
      exit() # force process to die
    } 
 } 
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{programming}
