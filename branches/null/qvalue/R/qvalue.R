qvalue <- function(p, alpha=NULL, lam=NULL, lam.meth="smoother", robust=F) { 
#This is a function for estimating the q-values for a given set of p-values. The
#methodology mainly comes from:
#Storey JD. (2002) A direct approach to false discovery rates. 
#Journal of the Royal Statistical Society, Series B, 64: 479-498.
#See http://www.stat.berkeley.edu/~storey/ for more info. 
#This function was written by John D. Storey. Copyright 2002 by John D. Storey.
#All rights are reserved and no responsibility is assumed for mistakes in or caused by
#the program.
#
#Input
#=============================================================================
#p: a vector of p-values (only necessary input)
#alpha: a level at which to control the FDR (optional)
#lam: the value of the tuning parameter to estimate pi0 (optional)
#lam.method: either "smoother" or "bootstrap"; the method for automatically
#           choosing tuning parameter lam if it is not specified
#robust: an indicator of whether it is desired to make the estimate more robust 
#        for small p-values (optional)
#
#Output
#=============================================================================
#remarks: tells the user what options were used, and gives any relevant warnings
#pi0: an estimate of the proportion of null p-values
#qvalues: a vector of the estimated q-values (the main quantity of interest)
#pvalues: a vector of the original p-values
#significant: if alpha is specified, and indicator of whether the q-value fell below alpha 
#    (taking all such q-values to be significant controls FDR at level alpha)

#This is just some pre-processing
    if(min(p)<0 || max(p)>1) {
    print("ERROR: p-values not in valid range"); return(0)
    }
    m <- length(p)
#These next few functions are the various ways to estimate pi0
    if(!is.null(lam)) {
        pi0 <- mean(p>lam)/(1-lam)
        pi0 <- min(pi0,1)
        remark <- "The user prespecified lam in the calculation of pi0."
    }
    else{
        lam <- seq(0,0.95,0.01)
        pi0 <- rep(0,length(lam))
        for(i in 1:length(lam)) {
            pi0[i] <- mean(p>lam[i])/(1-lam[i])
        }
        if(lam.meth=="smoother") {
            remark <- "A smoothing method was used in the calculation of pi0."
            library(modreg)
            spi0 <- smooth.spline(lam,pi0,df=3,w=(1-lam))
            pi0 <- predict(spi0,x=0.95)$y
            pi0 <- min(pi0,1)
        }
        if(lam.meth=="bootstrap") {
            remark <- "A bootstrap method was used in the calculation of pi0."
            minpi0 <- min(pi0)
            mse <- rep(0,length(lam))
            pi0.boot <- rep(0,length(lam))
            for(i in 1:100) {
                p.boot <- sample(p,size=m,replace=T)
                for(i in 1:length(lam)) {
                    pi0.boot[i] <- mean(p.boot>lam[i])/(1-lam[i])
                }
                mse <- mse + (pi0.boot-minpi0)^2
            }
            pi0 <- min(pi0[mse==min(mse)])
            pi0 <- min(pi0,1)
        }    
    }
    if(pi0 <= 0) {
    print("ERROR: Check that you have valid p-values. The estimated pi0 < 0."); return(0)
    }
#The q-values are actually calculated here
    u <- order(p)
    v <- rank(p)
    qvalue <- pi0*m*p/v
    if(robust) {
        qvalue <- pi0*m*p/(v*(1-(1-p)^m))
        remark <- c(remark, "The robust version of the q-value was calculated. See Storey JD (2002) JRSS-B 64: 479-498.")
    }
    qvalue[u[m]] <- min(qvalue[u[m]],1)
    for(i in (m-1):1) {
    qvalue[u[i]] <- min(qvalue[u[i]],qvalue[u[i+1]],1)
    }
#Here the results are returned
    if(!is.null(alpha)) {
        retval <- list(call=match.call(),
                       remarks=remark, pi0=pi0, qvalues=qvalue,
                       significant=(qvalue <= alpha), pvalues=p)
    }
    else {
        retval <- list(call=match.call(),
                       remarks=remark, pi0=pi0, qvalues=qvalue, pvalues=p)
    }

    
    class(retval) <- "qvalue"
    return(retval)
}
