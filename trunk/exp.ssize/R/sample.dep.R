"sample.dep" <-
function( ngenes.dep , n, var.ratio, cov.matrix, ngenes.matrix, delta, distrn = "normal")
{ ## start of the fn sample.null.dep
  sum.genes <- 0;
  sample <- matrix(0, nr = ngenes.dep, nc = 2*n)

  cov.ctrl <- sampling.cov.matrix (cov.matrix, ngenes.matrix)	# get covariance for control for the 1st set of genes
 											# ngenes.matrix is the # of cov matrices for cov.matrix
  ndep <- length(cov.ctrl[1,])						# get # genes per dependent group


  while ( (sum.genes+ndep) <= ngenes.dep)
  {  # start of while

     temp.sample <- sample.genes.dep(n, delta, cov.ctrl, var.ratio)
											# delta = 0 for null group
     sample[(sum.genes+1) : (sum.genes+ndep), ] <- temp.sample	# combine this group with previous genetated groups

     sum.genes <- ndep + sum.genes		# update the sum

     cov.ctrl <- sampling.cov.matrix (cov.matrix, ngenes.matrix)	# get covariance for next dependent group
     ndep <- length(cov.ctrl[1,])						# get # genes for next dependent group

  }  # end of while

     remainder <- ngenes.dep - sum.genes    # remaining number of gene samples to generate after while loop
     if (remainder != 0){

	temp.sample <- sample.genes.dep(n, delta, cov.ctrl = cov.ctrl[(1:remainder) , (1:remainder)], var.ratio)
	sample [(sum.genes+1) : (sum.genes + remainder), ] <- temp.sample		# finish the last part
	cat("finished LAST sampling \n")
	}
sample

} ## the end of the function sample.null.dep
