# $Id$
#
# $Log$
# Revision 1.2  2001/12/18 21:34:25  warneg
# - Modified to work correctly when obj is of class 'aov' by specifying
#   summary.lm instead of summary.  This ensures that the summary object
#   has the fields we need.
#
# - Moved detailed reporting of results from 'print' to 'summary'
#   function and added a simpler report to 'print'
#
# Revision 1.1  2001/12/18 00:43:23  warneg
#
# Initial checkin.
#
#

glh.test <- function( reg, cm, d=rep(0, nrow(cm)) )
{

  if( !is.matrix(cm) && !is.data.frame(cm) )
    cm <- matrix(cm, nrow=1)

  if ( !( "lm" %in% class(reg) ) )
    stop("Only defined for lm,glm objects")

  Beta <- summary.lm(reg)$coefficients[,1,drop=F]
  XpX <- summary.lm(reg)$cov.unscaled
  df <- reg$df.residual
  msr <- summary.lm(reg)$sigma  # == SSE / (n-p)
  r <- nrow(cm)


  if ( ncol(cm) != length(Beta) ) stop(  
                   paste( "\n Dimension of ",
                         deparse( substitute( cm ) ), ": ",
                         paste( dim(cm), collapse="x" ),
                         ", not compatible with no of parameters in ",
                         deparse( substitute( reg ) ), ": ",
                         length(Beta), sep="" ) )


  #                        -1
  #     (CB - d)' ( C (X'X)   C' ) (CB - d) / r
  # F = ---------------------------------------
  #                 SSE / (n-p)
  #

  Fstat <- t(cm %*% Beta - d) %*% solve((cm %*% XpX %*% t(cm))) %*% (cm %*% Beta - d) / r / msr^2 

  p <- 1-pf(Fstat,r,df)

  retval <- list()
  retval$call <- match.call()
  retval$statistic <- c(F=Fstat)
  retval$parameter <- c(df1=r,df2=df)
  retval$p.value <- p
  retval$conf.int <- NULL
  retval$estimate <- cm%*%Beta
  retval$null.value <- d
  retval$method <- "Test of General Linear Hypothesis"
  retval$data.name <- deparse(substitute(reg))
  retval$matrix <- cm
  colnames(retval$matrix) <- names(reg$coef)
  retval$d <- d
  
  class(retval) <- "glh.test"

  retval
}

print.glh.test <- function(x, digits = 4 )
{
    cat("\n")
    cat("\t",x$method, prefix = "\t")
    cat("\n")
    cat("Call:", x$call, "\n")
    
    if (!is.null(x$statistic)) 
        cat(names(x$statistic), " = ", format(round(x$statistic, 
            4)), ", ", sep = "")
    if (!is.null(x$parameter)) 
        cat(paste(names(x$parameter), " = ", format(round(x$parameter, 
            3)), ",", sep = ""), "")
    cat("p-value =",
        format.pval(x$p.value, digits = digits), 
        "\n")
    cat("\n")
  }


  
summary.glh.test <- function(x, digits = 4 )
{
    cat("\n")
    cat("\t",x$method, prefix = "\t")
    cat("\n")
    cat("Regression: ", x$data.name, "\n")
    cat("\n")
    cat("Null Hypothesis: C %*% Beta-hat = d \n")
    cat("\n")
    cat("C matrix: \n")
    print(x$matrix, digits=digits)
    cat("\n")
    cat("d vector: \n")
    print(x$d, digits=digits)
    cat("\n")
    cat("C %*% Beta-hat: \n")
    print(c(x$estimate))
    cat("\n")
    
    if (!is.null(x$statistic)) 
        cat(names(x$statistic), " = ", format(round(x$statistic, 
            4)), ", ", sep = "")
    if (!is.null(x$parameter)) 
        cat(paste(names(x$parameter), " = ", format(round(x$parameter, 
            3)), ",", sep = ""), "")
    cat("p-value =",
        format.pval(x$p.value, digits = digits), 
        "\n")
    cat("\n")
  }


  
