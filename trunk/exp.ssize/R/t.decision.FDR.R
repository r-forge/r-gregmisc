# t.decision.FDR.R
# find the decision of t test using Bonferroni mtd as multiple comparison method
FDR <- function (p)
{
    m <- length(p)
    tmp <- sort(p, index.return = T)
    sortp <- tmp$x
    idx <- tmp$ix
    sortp <- sortp * m/(1:m)
    for (i in (m - 1):1) {
        if (sortp[i] > sortp[i + 1])
            sortp[i] <- sortp[i + 1]
    }
    result <- NULL
    result[idx] <- sortp
    result
}

t.decision.FDR <- function(tp, sig.level)
{ temp <- apply(tp, 2, FDR)
  tp <= sig.level
}