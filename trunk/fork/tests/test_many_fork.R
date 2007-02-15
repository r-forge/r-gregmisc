library(fork)

# ignore sigchld signals so child processes will die cleanly
#signal("SIGCHLD","ignore")

# start signal handler
.C("R_install_sigcld_handler")

cat("Hi from the parent process\n");

for(i in 1:100)
  {
    pid = fork(slave=NULL) 
    if(pid==0)
      { 
        cat("Hi from child process",getpid(),".\n");
        Sys.sleep(10);
        cat("Bye from child process",getpid(),".\n");
        exit() 
      }
  }

Sys.sleep(300)
cat("Bye from the parent process",pid,".\n");

# remove signal handler
.C("R_restore_sigcld_handler")
