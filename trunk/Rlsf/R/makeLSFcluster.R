makeLSFcluster <- function()
{
  ncpus <- lsf.numcpu()
  
  if (mpi.comm.size() != 0) {
    cl <-getMPIcluster()
    if(is.null(cl))
      cl <- makeCluster(type="MPI") 
  }
  else {
    cl <- makeCluster(ncpus - 1, type="MPI")
  }

  return(cl)
}
