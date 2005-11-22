##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##

src = function(...) {
    source('nws.R')
}
tryCatch(library(nws), error=src)

bws = new('netWorkSpace', 'R babelfish')
while (1) {
  nwsStore(bws, 'doof', paste(capture.output(nwsFetch(bws, 'food')), collapse = '<p>'))
}
