"plotVi" <-
function(Dsamp,input) {
#    attach(as.data.frame(input))
    times <- input[,1]
    CI <- get95CI(2,input,1,Dsamp)
    temp <- fitPaper(paramsML$par,input)[[1]]
    low <-min(CI,input[,3])
    high <- max(CI,input[,3])
    plot(times,input[,3],ylim=c(low,high),xlab="time",ylab="v2")
    par(new=T)
    plot(times,CI[,1],ylim=c(low,high),type="l",lty=2,xlab="",ylab="",col=2)
    par(new=T)
    plot(times,CI[,2],ylim=c(low,high),type="l",lty=2,xlab="",ylab="",col=2)
    par(new=T)
    plot(times,temp,ylim=c(low,high),type="l",xlab="",ylab="",col=2)
    abline(h=0)
    legend(32,2000,c("data","fitted curve","95% CI"),lty=c(0,1,2),pch=c(1,NA,NA),col=c(1,2,2))
    for (i in 3:5) {
        CI <- get95CI(i,input,1,Dsamp)
        temp <- fitPaper(paramsML$par,input)[[i-1]]
        low <-min(CI,-400)
        high <- max(CI,800)
        plot(times,input[,i+1],ylim=c(low,high),
		xlab="time",ylab=paste("v",i,sep=""))
        par(new=T)
        plot(times,CI[,1],ylim=c(low,high),type="l",lty=2,xlab="",ylab="",col=2)
        par(new=T)
        plot(times,CI[,2],ylim=c(low,high),type="l",lty=2,xlab="",ylab="",col=2)
        par(new=T)
        plot(times,temp,ylim=c(low,high),type="l",xlab="",ylab="",col=2)
        abline(h=0)
    }
#    detach(as.data.frame(input))
}

