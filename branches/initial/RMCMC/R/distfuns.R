# Table of distributions   (FullNames, ShortNames, random, density, package)
distfuns <-
  list(
       "Normal" = list(
         aliases=c('N','Norm','Normal','Gaussian'),
         random='rnorm',
         density='dnorm',
         logdensity='log.dnorm',
         package='stats'),
       "Inverted Gamma" = list(
         aliases=c("IG",'InvGamma',"Inverted Gamma"),
         random='rinvgamma',
         density='dinvgamma',
         logdensity='log.dinvgamma',         
         package='MCMCpack')
       )

log.dnorm <- function(...) dnorm(..., log=TRUE)
log.dinvgamma <- function(...) log(dinvgamma(...))


make.lookup.table <- function(distfuns)
{
  retval <- list()
  for(item in distfuns)
    {
      cat("Working on:")
      print(item)
      aliases <- item$aliases
      item$aliases <- NULL
      
      for( name in aliases )
        retval[[name]] <- item
    }
  retval
}

lookup.table <- make.lookup.table(distfuns)
