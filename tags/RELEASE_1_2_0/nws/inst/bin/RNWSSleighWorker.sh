#! /bin/sh

##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##

trap exit SIGCHLD

# need to figure out how to get to the correct directory (use a temp dir?)
cd ${RNWSSleighWorkingDirectory:-/tmp}

${RPROG:-R} --vanilla <<EOF > ${RSleighWorkerOut:-/dev/null} 2>&1 &

scriptDir = Sys.getenv('RSleighScriptDir')
src = function(...) {
    source(sprintf('%s/nws.R', scriptDir))
    source(sprintf('%s/sleigh.R', scriptDir))
}
tryCatch(library(nws), error=src)

workerLoop()
EOF

export RCEPid=$!
export RCEHost=`hostname`

# start sentinel
${RPROG:-R} --vanilla <<EOF > RSleighSentinelLog_$RSleighRank 2>&1

scriptDir = Sys.getenv('RSleighScriptDir')
src = function(...) { source(sprintf('%s/nws.R', scriptDir)) }
tryCatch(library(nws), error=src)

cePid = Sys.getenv('RCEPid');
ceHost = Sys.getenv('RCEHost');

nws = new('netWorkSpace', wsName=Sys.getenv('RSleighNwsName'), serverHost=Sys.getenv('RSleighNwsHost'), port=as.integer(Sys.getenv('RSleighNwsPort')));
nwsStore(nws, sprintf('Worker %s on host %s', cePid, ceHost), 1)

waitForEnd = function(nws) {
 nwsFind(nws, 'Sleigh ride over')
 system(sprintf('kill %s', cePid))
 nwsStore(nws, 'bye', 1)
 quit(save='no')
}

try(waitForEnd(nws))

# hmmm ... looks like the rug was pulled out from under us. wait a
# bit for the shell scripts trap to fire ...
Sys.sleep(3)
# still here (see trap in sh script --- but that's probably not working)?, kill the subjob (still a possible race here...)
system(sprintf('kill %s', cePid))
nwsStore(nws, 'bye', 101)

EOF
