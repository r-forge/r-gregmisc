loadMessage <- function()
{
  cat("\n")
  ver <-packageDescription("SASxport", fields="Version") 
  date <- packageDescription("SASxport", fields="Date") 
  cat("Loaded SASxport version ", ver,  " (", date ,").\n", sep="")
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
