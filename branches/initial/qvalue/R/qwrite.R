"qwrite" <- function(qobj, filename) {
  #This function writes the results of the q-value object qobj to a file given in filename
  cat(c("The estimate of pi0 is ", qobj$pi0, "\n"), file=filename, append=F)
  cat(c(qobj$remarks, "\n"), file=filename, append=T)
  for(i in 1:length(qobj$qval)) {
    cat(c(qobj$pval[i], qobj$qval[i], "\n"), file=filename, append=T)
  }
}
