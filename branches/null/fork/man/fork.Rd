\name{fork}
\alias{fork}
\title{Create a new R process using the Unix 'fork' system call}
\description{
  Create a new R process using the Unix 'fork' system call.
}
\usage{
fork(slave)
}
\arguments{
  \item{slave}{Function to be executed in the new R process. This can be
  \code{NULL}, see details.}
}
\details{
  This function provides a thin wrapper around the Unix "fork" system
  call, which will create a new process which is an exact copy of the current R
  process, including open files and sockets including STDIN and STDOUT.
  (In particular this means that reading from stdin in the client process
  can cause a great deal of confusion!)

  The \code{slave} parameter should  normally contain a function
  to be executed in the newly created process.  This function will be
  called in the new process, and \code{exit()} will be called when it
  returns to terminate the process.

  If you wish to explicitly control what happens in the slave process,
  you can pass \code{slave=NULL}, in which case you are responsible for
  properly closing down the created process by calling \code{exit()}.
  Don't do this unless you are ready to handle all of these complexities!  

  In particular, since the child process inherits all files, including
  stdin and stdout, code following a fork that has \code{slave=NULL}
  will be be obtained *competitively* by both processes.  This usually
  means that neither process will get a consistent picture of the
  following commands. Consequently you need to ensure that all code that
  needs to be executed has already been fed to the interpreter before
  the fork call occurs.  The simplest mechinism to accomplish this is to
  wrap the code containing the fork in a code block using curly brackets
  (\code{\{ ... \}}).  This can be a top-level code block, or can be
  withing a loop or function call.,
 
  To illustrate, this code (in a familiar C idiom) will NOT be
  interpreted properly:

    
  pid = fork(slave=NULL)
    
  if(pid==0) \{ 
    
    cat("Hi from the child process"); exit() 
    
  \} else \{ 
    
    cat("Hi from the parent process"); 
    
  \} 
    

  On the other hand, wrapping this code with curly brackets ensures it
  is intepreted properly:

    
  \{ 

    pid = fork(slave=NULL) 

    if(pid==0) \{ 

      cat("Hi from the child process\n"); exit() 

    \} else \{
      
      cat("Hi from the parent process\n");
    
    \} 
    
  \} 

}
\value{
   This function returns the process ID of the child
   process to the parent process.  If \code{slave} is \code{NULL} the
   function returns 0 to the  child  process.
}
\note{

   
\references{'fork' man page}
\author{Gregory R Warnes <gregory_r_wanres@groton.pfizer.com}
\seealso{\code{\link{exit}}, \code{\link{wait}}, \code{\link{kill}}}
\examples{

###
# Count from 1 to 10 in a separate process
###

# define the function to do the work
testfun <- function()
  {
    cat("Counting in process", getpid(), "\n")
    for(i in 1:10)
      {
        i <<- i+1  # assign into Global environment
        cat("i=",i,"\n")
      }
    cat("Done counting in process", getpid(), "\n")
  }

# run normally, the function will change our value of i
i <- 0
testfun()
i 

# Run in a separate process, our value of i remains unchanged
i <- 0
{
  pid <- fork(testfun)
  wait(pid) # wait until the child finishes, then display its exit status
}
 

###
# Use a socket to communicate between two processes.  Information
# typed on the console, which is read by the initial process, will be send
# to the child process for display. 
###
\dontrun{
send <- function()
  {
     pid <- getpid()
     con1 <- socketConnection(Sys.info()["nodename"], port = 6011)
     i <- 1
     while(TRUE)
       {
         cat("[",pid,"] ",i,": ",sep="")
         data <- readLines(stdin(), n=1)
         writeLines(data, con=con1)
         if( length(grep("quit", data))>0 )
            break;
         i <- i+1
       }
     close(con1)
  }

recieve <- function()
  {
     pid <- getpid()
     con2 <- socketConnection(port = 6011, block=TRUE, server=TRUE)
     i <- 1
     while(TRUE)
       {
          data <- readLines(con2, n=1)
          cat("[",pid,"] ",i,": ",sep="")
          writeLines(data, stdout())
          if( length(grep("quit", data))>0 )
              break;
          i <- i+1
       }
     close(con2)
  }


pid <- fork(recieve)
send()
}
}
\keyword{programmming}

