ci  <-  function(x,...) UseMethod("ci")

ci.lm  <-  function(x,confidence=0.95,alpha=1-confidence)
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
  rownames(retval)  <-  rownames(coef(x))
  retval
}

ci.lme <- function(x,confidence=0.95,alpha=1-confidence)
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
