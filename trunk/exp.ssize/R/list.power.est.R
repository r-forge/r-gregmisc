# list.power.est.R
# to calculate estimated power for all sets of sd

list.power.est <- function(ngenes, fractn.dep, cov.matrix, ngenes.matrix,
			 nrep.est, nrep.simu, fold.change)

{
 n <- max(nrep.est) / 2 # ssize for treatment = control

 sample.est <- simu.sample(ngenes, n, fractn.alt = 0, fractn.dep, var.ratio = 1,
 cov.matrix, ngenes.matrix, delta = 0)
 # generate sample of size [ngenes x max(nrep.est)]
 # note: treatment = control for est sd

 est.sd <- est.sd.ctrl(sample.est, nrep.est)
 # output is matrix of sd with dim [ngenes x length(nrep.est)]

 nsd <- dim(est.sd)[2]
 
 list.power.est <- list(nsd)

 for ( i in 1: nsd)
 {list.power.est[[i]] <- calc.power.est(est.sd[,i], nrep.simu, fold.change, sig.level = 0.05)}

 list.power.est
 # output is a list with the same length as nrep.est
 # each element of the list consists of results for 
 # each set of sd based on corresponding nrep.est

}