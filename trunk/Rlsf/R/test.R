# $Id$

##
## EXAMPLE TEST CODE
##
test <- function(nrow=300)
  {
    library(Rlsf)
    library(gdata);
    library(gmodels);
    library(gplots);
    library(gtools)

    set.seed(1)
    age <- rnorm(200,40,12)
    sex <- factor(sample(c('female','male'),200,TRUE))
    logit <- (sex=='male') + (age-40)/5
    y <- ifelse(runif(200) <= plogis(logit), 1, 0)
    dataframe <- data.frame(age=age, sex=sex)
    fit.lm  <- lm (y ~ age*sex, data=dataframe)
    ymat <- matrix(y, nrow=nrow, ncol=length(y), byrow=T)

    fun <- function(y, covariates)
      {

        fit <- lm( y ~ age*sex, data=covariates )
        sum <- summary(fit)
        retval <- unmatrix( coef(sum) )
        retval
      }
    
    unmatrix <- function(x)
      {
        vlist <- c(x)
        names(vlist) <- c(outer( rownames(x), colnames(x), paste, sep=":" ))
        return(vlist)
      }
    
    ret <- lsf.apply.model (
                            fun,
                            matrix = ymat,
                            covariates = dataframe,
                            savelist="unmatrix"
                          )

    ret
  }
