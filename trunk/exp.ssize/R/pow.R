"pow" <-
function(sd, n, delta, sig.level, alpha.correct="Bonferonni")
{
  ntest <- length(sd)

  if(length(delta)==1) delta <- rep(delta,ntest)

  if(alpha.correct=="Bonferonni")
    alpha <- sig.level/ntest
  else
    alpha <- sig.level
  
  retval<-rep(NA, ntest)
  names(retval)<-names(sd)
  for(i in 1:ntest)
  {
    if(i%%10==0) cat(".")
      try(
          retval[i]<-power.t.test(n=n,
                                  delta=delta[i],
                                  sd=sd[i],
                                  sig.level=alpha, 
                                  power=NULL,
                                  type="two.sample",
                                  alternative="two.sided")$power
          )
  }   

  retval
}
