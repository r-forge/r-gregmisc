library(SASxport)

## Call C-level test routines

.C("doTest",PACKAGE="SASxport")

## Successful completion means all assertions have been met
