### runit.trim.R
###------------------------------------------------------------------------
### What: Tests for trim
### $Id$
### Time-stamp: <2006-08-29 14:21:02 ggorjan>
###------------------------------------------------------------------------

### {{{ --- Test setup ---

if(FALSE) {
  library("RUnit")
  library("gdata")
}

### }}}
### {{{ --- trim ---

test.trim <- function()
{
  sTrim <- "    this is an example string    "
  sTrimR <- "this is an example string"

  fTrim <- c(sTrim, sTrim, " A", " B ", "  C ", "D ")
  fTrimR <- c(sTrimR, sTrimR, "A", "B", "C", "D")

  lTrim <- list(s=rep(sTrim, times=6), f=fTrim, i=1:6)
  lTrimR <- list(s=rep(sTrimR, times=6), f=fTrimR, i=1:6)

  dfTrim <- as.data.frame(lTrim)
  dfTrimR <- as.data.frame(lTrimR)

  checkIdentical(trim(sTrim), sTrimR)
  checkIdentical(trim(fTrim), fTrimR)
  checkIdentical(trim(lTrim), lTrimR)
  checkIdentical(trim(dfTrim), dfTrimR)
}

### }}}
### {{{ Dear Emacs
## Local variables:
## folded-file: t
## End:
### }}}

###------------------------------------------------------------------------
### runit.trim.R ends here
