loadMessage <- function()
{
  cat("\n")
  ver <-packageDescription("SASxport", fields="Version") 
  date <- packageDescription("SASxport", fields="Date") 
  cat("Loaded SASxport version ", ver,  " (", date ,").\n", sep="")
  cat("\n")
  cat("  Updates and technical support available from Random Technologies, LLC\n")
  cat("  <http://random-technologies-llc.com/products/SASxport>\n")
  cat("\n")
  cat("  Type `?SASxport' for usage information.\n")
  cat("\n")
}



.First.lib <- function(lib, pkg) {
  library.dynam("SASxport", pkg, lib)
  loadMessage()
}

.onLoad <- function(lib, pkg) {
  loadMessage()
}
