library(fork)

# ignore sigchld signals so child processes will die cleanly
#signal("SIGCHLD","ignore")

# start signal handler
.C("R_install_sigcld_handler")

for(i in 1:100)
  {
    pid = fork(slave=NULL) 
    if(pid==0) { 
      cat("Hi from the child process\n"); exit() 
    } else {
      cat("Hi from the parent process\n");
    } 
  }

# remove signal handler
.C("R_restore_sigcld_handler")
