"plotMSD16" <-
function () {
    temp1 <- getMSDvsEvals(OneComp.MSD.dat,20,250)
    temp2 <- getMSDvsEvals(AllComp.MSD.dat,20,1)
    temp3 <- getMSDvsEvals(NKC.MSD.dat1,2,20)
    for (i in 2:10) {
        file <- sub('#',as.character(i),'NKC.MSD.dat#')
	temp3 <- temp3 + getMSDvsEvals(eval(as.name(file)),2,20)
    }
    temp3 <- temp3/10
    plot(log10(temp1[,1]),temp1[,2],type='l',ylim=c(5000,max(temp1[,2],temp2[,2],temp3[,2])),xlim=c(0,7),xlab="log10(#evals)",ylab="mean squared residual")
    par(new=T)
    plot(log10(temp2[,1]),temp2[,2],type='l',ylim=c(5000,max(temp1[,2],temp2[,2],temp3[,2])),xlim=c(0,7),col=2,lty=2,xlab="",ylab="")
    par(new=T)
    plot(log10(temp3[,1]),temp3[,2],type='l',ylim=c(5000,max(temp1[,2],temp2[,2],temp3[,2])),xlim=c(0,7),col=3,lty=3,xlab="",ylab="")
    legend(4.5,14000,c("1-comp","all-comp","NKC"),lty=1:3,col=1:3)
}

