##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##

library(nws) # fail if not available

## Create pid file If we've been passed a --pidfile argument
argv <- commandArgs()
myarg <- argv[grep("^--pidfile", argv)]
pidfile <- gsub("^--pidfile","", myarg)
if(length(pidfile)!=0)
  cat(Sys.getpid(), file=pidfile)

## start up translation services
bws = new('netWorkSpace', 'R babelfish')
while (1) {
  nwsStore(bws, 'doof', paste(capture.output(nwsFetch(bws, 'food')), collapse = '<p>'))
}

## remove pid file
file.remove(pidfile)
