"sample.null.ind" <-
function( ngenes.null.ind , n, var.ratio, shape = 1, scale = 10, distrn = "normal")
{
   sd.ctrl <- sapply(rgamma(ngenes.null.ind, shape, scale), get.sd) # mean(var) = 0.1, var(var)= 0.01

   sample <- sample.genes.ind(ngenes.null.ind , n, sd.ctrl, var.ratio, delta = 0)

   sample
} ## the end of the function sample.null.ind
