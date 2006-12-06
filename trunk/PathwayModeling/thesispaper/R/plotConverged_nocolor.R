`plotConverged_nocolor` <-
function() {
    maxY <- 0.0012
    for (i in 1:8) {
	p <- paste("d",i,sep="")
	plotDensity_nocolor(output12[,i],p,5000,Ylim=maxY,lineType=2)
	par(new=T)
	plotDensity_nocolor(output16[,i],p,5000,Ylim=maxY,lineType=3)
	par(new=T)
	plotDensity_nocolor(output25[,i],p,5000,Ylim=maxY,lineType=4)
    }
    plotDensity_nocolor(output12[,9],'d9',5,Ylim=5.7,lineType=2)
    par(new=T)
    plotDensity_nocolor(output16[,9],'d9',5,Ylim=5.7,lineType=3)
    par(new=T)
    plotDensity_nocolor(output25[,9],'d9',5,Ylim=5.7,lineType=4)
}

