# calc.power.est.R
# function to get the list of estimated power for each gene
# for each of the sample size nrep.simu and specified fold.change

calc.power.est <- function(sd, nrep.simu, fold.change, sig.level = 0.5)
{

delta = log2(fold.change)
calc.power <- matrix(0, nr = length(sd), nc = length(nrep.simu))

for (j in 1:length(nrep.simu))
  {   calc.power[,j] <- pow(sd=sd, n=nrep.simu[j], delta=delta,
                 sig.level=sig.level)
   } # end of for
calc.power
)