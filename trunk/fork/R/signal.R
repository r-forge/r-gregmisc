# $Id: kill.R 340 2004-05-25 19:12:32Z warnes $

signal <- function(signal, action=c("ignore","restore") )
  {
    action=match.args(action)
    
    if(is.character(signal))
      sig=sigval(signal)$val
    else (is.numeric(signal) && !is.na(signal))
      sig=signal
    else
      stop("Illegal value for signal")
    
    act <- switch(
                  action,
                  "ignore"=0,
                  "restore"=1
                  )

    msg1 = 
    
    .C(
       "Rfork_signal",
       as.integer(signal),
       as.integer(act),
       PACKAGE="fork"
       )
    invisible()
  }

