makeLSFcluster <- function()
{
  if (!require(Rmpi))
    stop("The 'Rmpi' package is needed for parallel LSF jobs.")
  if (!require(snow))
    stop("The 'snow' package could not be found.")
  
  if (mpi.comm.size() != 0) {
    cl <-getMPIcluster()
    if(is.null(cl))
      cl <- makeCluster(type="MPI") 
  }
  else {
    cl <- makeCluster(lsf.numcpu(), type="MPI")
  }

  return(cl)
}
