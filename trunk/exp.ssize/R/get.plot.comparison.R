"get.plot.comparison" <-
function(power.est, power.real, nrep.simu,
                       xlab="Sample Size (per group)",
                       ylab="Proportion of Genes with Power >= 80%")

  {
    plot(nrep.simu, power.real$propn.80, type="s",
         xlab=xlab, ylab=ylab, yaxt="n")
    lines(nrep.simu,power.est[[1]]$propn.80, lty = 2, col = "blue")
    lines(nrep.simu,power.est[[2]]$propn.80, lty = 2, col = "red")
    lines(nrep.simu,power.est[[1]]$propn.80, lty = 2, col = "green")

  }
