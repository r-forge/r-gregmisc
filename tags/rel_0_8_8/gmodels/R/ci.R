# $Id$
#
# $Log$
# Revision 1.8  2003/08/07 03:49:54  warnes
# - Fixed incorrect denominator in standard error for mean in ci.default.
#
# Revision 1.7  2002/09/23 13:59:30  warnes
# - Modified all files to include CVS Id and Log tags.
#
#

ci  <-  function(x, confidence=0.95,alpha=1-confidence,...)
  UseMethod("ci")

ci.default <- function(x, confidence=0.95,alpha=1-confidence,na.rm=FALSE,...) {
  est <- mean(x, na.rm=na.rm)
  stderr <-  sd(x, na.rm=na.rm)/sqrt(nobs(x));
  ci.low  <- est + qt(alpha/2, nobs(x)-1) * stderr
  ci.high <- est - qt(alpha/2, nobs(x)-1) * stderr
  retval  <- c(
               Estimate=est,
               "CI lower"=ci.low,
               "CI upper"=ci.high,
               "Std. Error"=stderr,
               )

  retval
}
  
ci.lm  <-  function(x,confidence=0.95,alpha=1-confidence,...)
{
  x  <-  summary(x)
  est  <-  coef(x)[,1] ;
  ci.low  <- est + qt(alpha/2, x$df[2]) * coef(x)[,2] ;
  ci.high <- est - qt(alpha/2, x$df[2]) * coef(x)[,2] ;
  retval  <- cbind(Estimate=est,
                   "CI lower"=ci.low,
                   "CI upper"=ci.high,
                   "Std. Error"= coef(x)[,2],
                   "p-value" = coef(x)[,4])

  retval
}

ci.lme <- function(x,confidence=0.95,alpha=1-confidence,...)
  {
  x  <-  summary(x)
  est  <-  x$tTable[,"Value"] ;
  ci.low  <- est + qt(alpha/2, x$tTable[,"DF"]) * x$tTable[,"Std.Error"] ;
  ci.high <- est - qt(alpha/2, x$tTable[,"DF"]) * x$tTable[,"Std.Error"] ;
  retval  <- cbind(Estimate=est,
                   "CI lower"=ci.low,
                   "CI upper"=ci.high,
                   "Std. Error"= x$tTable[,"Std.Error"],
                   "DF" = x$tTable[,"DF"],
                   "p-value" = x$tTable[,"p-value"])
  rownames(retval)  <-  rownames(x$tTable)
  retval
}
