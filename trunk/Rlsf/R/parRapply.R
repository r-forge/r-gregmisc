# $Id$

parRapply <- function (cl, x, fun, join.method=cbind, ...)
  docall(join.method,
         clusterApplyLB(cl,                                   
                        splitRows(x, length(cl)*10),
                        apply, 1, fun, ...))

