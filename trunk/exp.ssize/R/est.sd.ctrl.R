# est.sd.ctrl.R
# function to estimate the sd from "known" control sample

est.sd.ctrl<- function(sample.ctrl, nrep)
{

ngenes <- dim(sample.ctrl)[1]
nrep <- nrep[nrep <= dim(sample.ctrl)[2]]

est.sd <- matrix(0, ngenes, length(nrep));

  for ( j in 1:length(nrep))
   {
   est.sd[,j] <- sd(t(sample.ctrl[,1:nrep[j]]))
   est.sd
   } # end of for j

}