"qplot" <- function(qobj, rng=0.1, ...) {
  # This function produces various plots. Written by John D. Storey
  # Copyright 2002 by John D. Storey
  # qobj is a q-value object returned by the above function
  # rng is the range of q-values to consider (optional)
  q2 <- qobj$qval[order(qobj$pval)]
  p2 <- qobj$pval[order(qobj$pval)]
  par(mfrow=c(2,2))
  lam <- seq(0,0.95,0.01)
  pi0 <- rep(0,length(lam))
  for(i in 1:length(lam)) {
    pi0[i] <- mean(p2>lam[i])/(1-lam[i])
  }    
  spi0 <- smooth.spline(lam,pi0,df=3,w=(1-lam))
  pi00 <- round(qobj$pi0,3)
  plot(lam,pi0,xlab=expression(lambda),ylab=expression(hat(pi)[0](lambda)),
       pch=".", ...)
  mtext(substitute(hat(pi)[0] == that, list(that= pi00)), ...)
  lines(spi0, ...)

  if(any(q2<=rng))
    {
      plot(p2[q2<=rng],q2[q2<=rng],type="l",xlab="p-value",ylab="q-value", ...)
      plot(q2[q2<=rng],1:sum(q2<=rng),type="l",xlab="q-value cut-off",ylab="significant tests", ...)
      plot(1:sum(q2<=rng),q2[q2<=rng]*(1:sum(q2<=rng)),type="l",xlab="significant tests",ylab="expected false positives", ...)
    }
  else
    {
      warning("No observed q-values less than ", rng, " Some plots omitted.")
    }
  par(mfrow=c(1,1))
}

plot.qvalue <- function(x,...) qplot(x,...)
