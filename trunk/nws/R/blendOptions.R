## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# $Id$

# We side effect options here. at invocation, we generated a new env
# if desired.
blendOptions <- function(options, new) {
  if (! is.null(new)) {
    names <- names(new)
    for (i in seq(along = new))
      assign(names[i], new[[i]], env = options)
  }
  options
}
