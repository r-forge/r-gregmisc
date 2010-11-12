library(SASxport)

lookup.xport('puromycin.xpt')

## By default, character variable "STATE" should be converted into a
## factor
x <- read.xport('puromycin.xpt')
str(x)

SASxport:::assert( class(x$STATE)=="factor" )

## When as.is=TRUE, character variable "STATE" should be preserved as
## a character variable.

x <- read.xport('puromycin.xpt',as.is=TRUE)
str(x)

SASxport:::assert( class(x$STATE)=="character" )


