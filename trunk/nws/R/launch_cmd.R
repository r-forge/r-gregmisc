## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# $Id$

sshcmd <- function(user, host, options) {
  wrapper <- file.path(options$scriptDir, 'SleighWorkerWrapper.sh')
  if (file.access(wrapper) == 0) {
    sprintf("%s ssh -f -x -l %s %s", wrapper, user, host)
  }
  else {
    sprintf("ssh -f -x -l %s %s", user, host)
  }
}

rshcmd <- function(user, host, options) {
  sprintf("rsh -l %s %s", user, host)
}

lsfcmd <- function(user, host, options) {
  "bsub"
}

