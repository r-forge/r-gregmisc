# $Id$

par.apply.model <- function(fun,
                            matrix,
                            covariates,
                            ...,
                            ncpu=lsf.numcpu(8),
                            nelem,
                            packages=.packages(),
                            cltype="MPI",
                            debug = TRUE,
                            cl = NULL
                            )
  {

    if(!missing(nelem))
      if(length(nelem)==1)
        matrix <- matrix[1:nelem,]            # include first nelem elements
      else
        matrix <- matrix[nelem[1]:nelem[2],]  # include subset of elements

    #
    # Test on a single probeset so we easily catch general errors.
    #

    result <- fun(matrix[1,],covariates=covariates)

    #
    # Start up the cluster...
    #

    library(snow)

    scat("numcpu=", ncpu, "\n")
    makeLSFcluster(ncpu=ncpu)
    
    exitfun <- function()
      {
        traceback()
        scat("ERROR, Stopping cluster ")
        stopCluster(cl)
        scat("Done.")
      }
    on.exit( exitfun, add=TRUE )

    #
    # Test if all cluster nodes are working
    #
    scat("Test cluster elemets by listing hostnames.")
    tmp <- clusterCall(cl, function() system('hostname',intern=T))
    scat("Done.")
    #
    # Initialize the cluster elements
    #

    load.libs <- function(packages)
      {
        for(pack in packages)
          library(pack, character.only=TRUE)
      }

    scat("Initialize the cluster elements with libraries ")
    clusterCall(cl, load.libs, packages=packages)
    if(exists("last.warning"))  # work around R bug
      warnings()
    scat("Done.")

    #
    # Evaluate the function on all rows of the data set, distributing the
    # work across the cluster
    #

    scat("Starting paralle model fit with", ncpu, "nodes ")
    time <- system.time(
                        fits <- parRapply(cl,
                                          matrix,
                                          fun,
                                          covariates=covariates,
                                          join=cbind )
                        )
    scat("Done. Computation used", time, "")

    if(exists("last.warning"))  # work around R bug
      warnings()

    #
    # Stop the Custer
    #

    scat("Stop the cluster. ")
    stopCluster(cl)
    on.exit(NULL)
    scat("Done.")

    return(t(fits))

  }

