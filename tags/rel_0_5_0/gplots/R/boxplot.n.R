
boxplot.n  <- function( ..., top=F, shrink=1.0, textcolor=NULL )
  {
    box <- match.call()           # get call
    box$top  <- box$shrink  <- box$textcolor  <- NULL
    box[[1]]  <- as.name("boxplot")
    box <- eval(box, parent.frame())

    if(top)
      {
        where  <- par("usr")[4]
        adj  <- c(0.5,1)
      }
    else
      {
        where  <- par("usr")[3]
        adj  <- c(0.5,0)
      }
    cex <- par("cex")
    par(cex=shrink*cex)
    text( x=1:length(box$n), y=where, labels=paste("n=",box$n,sep=""), adj=adj,
         col=textcolor)
    par(cex=cex)

    invisible(box)
  }
