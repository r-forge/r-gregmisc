"sample.alt.ind" <-
function( ngenes.alt.ind , n, var.ratio, delta, shape = 1, scale = 10, distrn = "normal")
				
{ ## start of the fn sample.alt.ind

  sd.ctrl <- sapply(rgamma(ngenes.alt.ind, shape, scale), get.sd)
  
  delta <- sign(runif(ngenes.alt.ind, 0, 1) -0.5) * delta
  sample <- sample.genes.ind( ngenes.alt.ind , n, sd.ctrl, var.ratio, delta)

sample
} ## the end of the function sample.alt.ind
