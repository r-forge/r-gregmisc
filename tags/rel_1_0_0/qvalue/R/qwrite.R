
qwrite <- function(qobj, filename="my-qvalue-results.txt") {
#Input
#=============================================================================
#qobj: a q-value object returned by the qvalue functino
#filename: the name of the file where the results are written
#
#Output
#=============================================================================
#A file sent to "filename" with the following:
#First row: the function call used to produce the estimates
#Second row: the estimate of the proportion of false positives, pi0
#Third row and below: the p-values (1st column) and the estimated q-values (2nd column) 
cat(c("Function call:", deparse(qobj$call), "\n"), file=filename, append=F)
cat(c("Estimate of the overall proportion of false positives pi0:", qobj$pi0, "\n"), file=filename, append=T)
for(i in 1:length(qobj$qval)) {
    cat(c(qobj$pval[i], qobj$qval[i], "\n"), file=filename, append=T)
    }
}
