# $Id$

.Last <- function()
{
  if (is.loaded("mpi_initialize")){
    if (mpi.comm.size(1) > 1){
      print("Please use mpi.close.Rslaves() to close slaves")
      mpi.close.Rslaves(comm=1)
    }
  }
  print("Please use mpi.quit() to quit R")
  mpi.quit()
}
