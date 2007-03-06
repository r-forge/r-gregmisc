## This script starts child processes, but doesn't do anything about
## collecting or ignoring child process return status. Consequently, it should 
## generate zombie child processes.

library(fork)

source("checkZombies.R")

nZombies <- checkZombies()

if(nZombies)
  stop("Zombie processes created")
else
  cat("Success!\n")
