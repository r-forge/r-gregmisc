ci  <-  function(x,...) UseMethod("ci")

ci.summary.lm  <-  function(x,confidence=0.95,alpha=1-confidence) {
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

ci.lm  <-  function(x,...)
{
  x  <-  summary(x)
  return(ci.summary.lm(x))
}

