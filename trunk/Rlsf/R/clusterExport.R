# $Id$

# export data from current frame to nodes of cluster
clusterExport <- function (cl, list, pos=-1)
{
    for (name in list) {
        clusterCall(cl,
                    function(n, v) assign(n, v, env = .GlobalEnv), 
                    name,
                    get(name, envir=sys.frame(sys.parent()))
                    )
    }
}

# export data from current frame to nodes of cluster via shared fs
clusterFSExport <- function (cl, list, envir=parent.frame())
{
  fname <- paste(".clusterFSExport",Sys.getpid(),"Rda",sep=".")
  fname <- file.path(getwd(),fname)
  fname <- sub("^/Volumes/","/net/gsun374/Volumes/",fname)
  scat("Saving data to ", fname, "")
  save(list=list, file=fname, envir=envir)
  scat("Done.")
  
  scat("Asking all nodes to load data from ", fname, "")
  clusterExport(cl, "fname")
  clusterCall(cl, function(x) load(fname, envir=.GlobalEnv) )
  scat("Done.")  
}
