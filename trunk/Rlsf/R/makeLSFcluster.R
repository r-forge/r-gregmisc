makeLSFcluster <- function(ncpu)
{
  if (mpi.comm.size()!=0)
    {
      scat("Using existing MPI cluster with", mpi.comm.size(), "nodes ")
      cl <-getMPIcluster()
      if( is.null(cl) )
        cl <- makeCluster(type="MPI") 
    }
  else
    {
      scat("Starting MPI cluster with", ncpu, "nodes")
      cl <- makeCluster(ncpu-1, type="MPI")
    }
  scat("Done.")

  return(cl)
}
