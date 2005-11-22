
## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

src = function(...) {
    source('nws.R')
}
tryCatch(library(nws), error=src)

bws = new('netWorkSpace', 'R babelfish')
while (1) {
  nwsStore(bws, 'doof', paste(capture.output(nwsFetch(bws, 'food')), collapse = '<p>'))
}
