is.what <- function(object, verbose=FALSE)
###########################################################################################################################
###                                                                                                                       #
### Function: is.what                                                                                                     #
###                                                                                                                       #
### Purpose:  Run multiple is.* tests on a given object                                                                   #
###                                                                                                                       #
### Args:     object is any R object                                                                                      #
###           verbose is whether negative tests results should be included in output                                      #
###                                                                                                                       #
### Notes:    Based on demo(is.things)                                                                                    #
###                                                                                                                       #
### Returns:  String vector of positive results, or when verbose is TRUE, a data frame containing all test results        #
###                                                                                                                       #
###########################################################################################################################
{
  do.test <- function(test, object)
  {
    ## Performs test(object) and returns the boolean result
    result <- get(test,"package:base")(object)[1]
    return(result)
  }

  is.functions <- ls("package:base", pattern="^is\\.")
  not.using <- c("is.element", "is.empty.model", "is.loaded", "is.mts", "is.na.data.frame", "is.na.POSIXlt", "is.na<-",
                 "is.na<-.default", "is.na<-.factor", "is.pairlist", "is.qr", "is.R", "is.single", "is.unsorted")
  tests <- is.functions[-match(not.using, is.functions)]
  results <- sapply(tests, do.test, object=object)

  if(verbose == FALSE)
    output <- tests[results==TRUE & !is.na(results)]
  else
  {
    results[results==TRUE] <- "T"
    results[results==FALSE] <- "."
    output <- data.frame(is=I(results))
  }

  return(output)
}
