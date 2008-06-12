`print.SII` <-
function (x, digits = 2, ...) 
{
  cat("\n")
  cat("SII:", round(x$sii, digits), "\n")
  cat("\n")  
}
