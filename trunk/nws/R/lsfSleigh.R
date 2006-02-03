## This Function Will Properly Check To See If The R Script Has Been
## Launched In A Parallel Fashion.  If So, It Will Start Jobs On The
## Provided Nodes Using Ssh.  If Not, It Expects That The Parameter
## 'N' Contains The Number Of Nodes To Start Via 'Bsub'.  Extra
## Arguments To Bsub Can Be Provided Using The Lsfoptions Parameter.
lsfSleigh <- function(n, lsfOptions="", ...)
{
  hostList <- unlist(Sys.getenv("LSB_HOSTS"))
  if(!is.null(hostList) && hostList>" ")
    {
      hosts <- unlist(strsplit(hostList," "))
      hosts <- hosts[hosts > " "]
      if(!missing(n) && n!=length(hosts))
        warning("Number of requested nodes (", n,
                ") does not match number of nodes assigned by LSF (",
                length(hosts),
                ").  Using the ", length(hosts), " hosts LSF has assigned.")
      n <- length(hosts)
      cmd <- sshcmd
    }
  else if(missing(n))
    stop("No requested and no hosts assigned by LSF")
  else
    {
      hosts <- as.character(1:n)
      cmd <- function (user, host, options) 
        {
          paste("bsub",paste(lsfOptions, sep=" ", collapse=" "))
        }
    }
  
  sleigh(launch=cmd, nodeList=hosts, ...)
}
  

