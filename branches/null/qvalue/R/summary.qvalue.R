summary.qvalue <- function(object,
                           ...)
  {
    print(object, ...)
  }


print.qvalue <- function (x,
                          cut=c(0.0001, 0.001, 0.01, 0.025, 0.05,
                                     0.10, 1),
                          digits=getOption("digits"),
                          ...)

{
    cat("\nCall:\n", deparse(x$call), "\n\n", sep = "")

    cat("pi0:",format(x$pi0, digits=digits),"\n", sep="\t")
    cat("\n")

    cat("Cumulative number of significant calls:\n")
    cat("\n")
    counts <- sapply(cut, 
                     function(x) c( "p-value"=sum(tmp$pvalues < x),
                                   "q-value"=sum(tmp$qvalues < x)) )
    colnames(counts) <- paste("<", cut, sep="")
    print(counts)
    cat("\n")
    invisible(x)
}

