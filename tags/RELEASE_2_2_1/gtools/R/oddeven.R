# $Id$

# detect odd/even integers
odd <- function(x) x!=as.integer(x/2)*2
even <- function(x) x==as.integer(x/2)*2
