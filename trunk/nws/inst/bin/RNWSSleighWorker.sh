#!/bin/sh

## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

##!!FIXME: Assumes nws library in use is installed in the system ##
## default location.  If it is installed in the system default
## location, but we are using a different one, we'll get cross-version
## issues.

trap exit SIGCHLD

# need to figure out how to get to the correct directory (use a temp dir?)
cd ${RNWSSleighWorkingDirectory:-/tmp}


if test -n "$DEBUG"; then
    echo Running RNWSSleighWorker in DEBUG mode
    ${RPROG:-R} --vanilla <<EOF
	library(nws)
	workerLoop(verbose=TRUE)
EOF
else
    ${RPROG:-R} --vanilla > ${RSleighWorkerOut:-/dev/null} 2>&1 <<EOF
	library(nws)
	workerLoop(verbose=FALSE)
EOF
fi



export RCEPid=$!
export RCEHost=`hostname`

# start sentinel
${RPROG:-R} --vanilla <<EOF > RSleighSentinelLog_${UID}_${RSleighRank} 2>&1

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
