## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# $Id$

storeTask <- function(
                      nws, fun, args, 
                      by="cell",
                      chunkSize=1,
                      tag = 'anon',
                      barrier = NULL,  ## NULL==No barrier
                      return = TRUE
                      )
  {
  nwsStore(nws,
           'task',
           list(type = 'EXEC',
                barrier = barrier,
                data = list(fun = fun, args = args, return = return),
                tag = tag,
                by=by,
                chunkSize=chunkSize
                ))
}

