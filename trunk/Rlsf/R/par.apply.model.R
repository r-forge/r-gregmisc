# $Id$

par.apply.model <- function(fun,
                            matrix,
                            covariates,
                            ...,
                            ncpu=lsf.numcpu(8),
                            nelem,
                            packages=.packages(),
                            debug = TRUE
                            )
  {

    if(!missing(nelem))
      if(length(nelem)==1)
        matrix <- matrix[1:nelem,]            # include first nelem elements
      else
        matrix <- matrix[nelem[1]:nelem[2],]  # include subset of elements

    if(exists("last.warning"))  # work around R bug
      remove("last.warning",inherits=TRUE)


    
    #
    # Test on a single probeset so we easily catch general errors.
    #

    result <- fun(matrix[1,],covariates=covariates)

    if(exists("last.warning"))  # work around R bug
      warnings()

    #
    # Test if LSF is working
    #
    scat("Test if LSF is working...")
    tmp <- lsf.run.job( function() system('hostname',intern=T))
    scat("Done.")
    #
    # Evaluate the function on all rows of the data set, distributing the
    # work across the cluster
    #

    scat("Starting paralle model fit with", ncpu, "nodes ")
    time <- system.time(
                        fits <- lsf.parRapply(
                                              matrix,
                                              fun,
                                              ...,
                                              covariates=covariates,
                                              join.method=cbind,
                                              njobs=ncpu,
                                              packages=packages
                                              )
                        )
    scat("Done. Computation used", time, "")

    if(exists("last.warning"))  # work around R bug
      warnings()

    return(t(fits))

  }

