qplot <- function(qobj, rng=0.1, ...o) {
#Input
#=============================================================================
#qobj: a q-value object returned by the qvalue function
#rng: the range of q-values to be plotted (optional)
#
#Output
#=============================================================================
#Four plots: 
#Upper-left: pi0.hat(lambda) versus lambda with a smoother
#Upper-right: q-values versus p-values
#Lower-left: number of significant tests per each q-value cut-off
#Lower-right: number of expected false positives versus number of significant tests
#library(modreg)
q2 <- qobj$qval[order(qobj$pval)]
if(min(q2) > rng) {rng <- quantile(q2, 0.1)}
p2 <- qobj$pval[order(qobj$pval)]
par(mfrow=c(2,2))
lambda <- qobj$lambda
if(length(lambda)==1) {lambda <- seq(0,max(0.95,lambda),0.05)}
pi0 <- rep(0,length(lambda))
for(i in 1:length(lambda)) {
    pi0[i] <- mean(p2>lambda[i])/(1-lambda[i])
    }    
spi0 <- smooth.spline(lambda,pi0,df=3)
pi00 <- round(qobj$pi0,3)
plot(lambda,pi0,xlab=expression(lambda),ylab=expression(hat(pi)[0](lambda)),pch=".", ...)
mtext(substitute(hat(pi)[0] == that, list(that= pi00)))
lines(spi0)
plot(p2[q2<=rng],q2[q2<=rng],type="l",xlab="p-value",ylab="q-value", ...)
plot(q2[q2<=rng],1:sum(q2<=rng),type="l",xlab="q-value cut-off",ylab="significant tests", ...)
plot(1:sum(q2<=rng),q2[q2<=rng]*(1:sum(q2<=rng)),type="l",xlab="significant tests",ylab="expected false positives", ...)
par(mfrow=c(1,1))
}

plot.qvalue <- function(x,...) qplot(x,...)
