plot.dendrogram <- stats:::plot.dendrogram
environment(plot.dendrogram) <- .GlobalEnv

plotNodeLimit <- stats:::plotNodeLimit
environment(plotNodeLimit) <- .GlobalEnv

.memberDend <- stats:::.memberDend
environment(.memberDend) <- .GlobalEnv

.midDend <- stats:::.midDend
environment(.midDend) <- .GlobalEnv

unByteCode <- function(fun)
    {
        FUN <- eval(parse(text=deparse(fun)))
        environment(FUN) <- environment(fun)
        FUN
    }

plotNode <- unByteCode(stats:::plotNode)
environment(plotNode) <- .GlobalEnv
