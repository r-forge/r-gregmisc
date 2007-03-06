## This script starts child processes, but doesn't do anything about
## collecting or ignoring child process return status. Consequently, it should 
## generate zombie child processes.

library(fork)

cat("Generating 100 child processes (to become zombies)...\n")
for(i in 1:100)
  {
    pid = fork(slave=NULL) 
    if(pid==0)
      { 
        #cat("Hi from child process",getpid(),".\n");
        #Sys.sleep(10);
        #cat("Bye from child process",getpid(),".\n");
        exit() 
      }
  }

cat("Give them 10 seconds to die and exit..\n")
Sys.sleep(10)

cat("Check the process table to see if there are any zombies...\n")
if(TRUE) # BSD-style PS command (Linux, Mac OSX, NetBSD)
{
  statusList = system("ps -o stat", intern=TRUE)[-1]
} else
{
  statusList = system("ps -o s", intern=TRUE)[-1]
}

zombies = grep("[Zz]", statusList, value=TRUE)
if(length(zombies)>50)
  stop(length(zombies), " Zombie Processes Present!")
else
  cat("Done. No Zombies present.\n")
