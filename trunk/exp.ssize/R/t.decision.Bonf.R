# t.decision.Bonf.R
# find the decision of t test using Bonferroni mtd as multiple comparison method

t.decision.Bonf <- function(tp, sig.level)
{ alpha <- sig.level/dim(tp)[1]
  tp <= alpha
}