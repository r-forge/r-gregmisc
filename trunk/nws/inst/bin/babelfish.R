
## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

## Create pid file If we've been passed a --pidfile argument
argv <- commandArgs()
myarg <- argv[grep("^--pidfile", argv)]
pidfile <- gsub("^--pidfile","", myarg)
if(length(pidfile)!=0)
  cat(Sys.getpid(), file=pidfile)

# load nws library
src = function(...) {
    source('nws.R')
}
tryCatch(library(nws), error=src)

## start up translation services
bws = new('netWorkSpace', 'R babelfish')
while (1) {
  nwsStore(bws, 'doof', paste(capture.output(nwsFetch(bws, 'food')), collapse = '<p>'))
}

## remove pid file
file.remove(pidfile)
