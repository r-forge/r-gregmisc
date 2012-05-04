ls.funs <- function (...)
  {
    mycall <- match.call()
    mycall[[1]] <- as.name("ls")
    nameList <- eval.parent(mycall)
    funcFlags <- sapply( nameList, function(x) is.function(get(x)) )
    nameList[funcFlags]
  }
                        
