#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

void Rfork_fork(int *pid)
{
  *pid = (int) fork();
}

void Rfork_getpid(int *pid)
{
  *pid = (int) getpid();
}


void Rfork_kill(int *pid, int *signal, int *flag)
{
  *flag = kill(*pid, *signal);
}

void Rfork__exit(int *status)
{
  _exit(*status);
}

void Rfork_waitpid(int *pid, int *continued, int *nohang, int *nowait, 
		   int *untraced, int *status)
{
  int options=0;
  int pidnew=0;
  if(*continued) options |= WCONTINUED;
  if(*nohang)    options |= WNOHANG;
  if(*nowait)    options |= WNOWAIT;
  if(*untraced)  options |= WUNTRACED;

  *pid = waitpid( *pid, status, options);
}
  

void Rfork_wait(int *pid, int *status)
{
  *pid = wait(status);
}
  

