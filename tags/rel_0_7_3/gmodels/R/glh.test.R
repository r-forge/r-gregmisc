# $Id$
#
# $Log$
# Revision 1.8  2002/09/24 19:12:42  warnes
# - Fixed a typo.
#
# Revision 1.7  2002/04/09 00:51:29  warneg
#
# Checkin for version 0.5.3
#
# Revision 1.6  2002/03/26 21:22:26  warneg
#
# - Changed methods to include '...' to match the generic.
# - Updated for version 0.5.1
#
# Revision 1.5  2002/01/17 23:42:39  warneg
#
# - Fixed typo in code that resulted in an syntax error.
#
# Revision 1.4  2002/01/10 17:35:41  warneg
#
# - print.glh.test() was using cat() to printing the call.  This didn't work and
# generated an error.
#
# Revision 1.3  2001/12/19 20:05:27  warneg
#
# - Removed extra element of return object.
#
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

  bhat <- summary.lm(reg)$coefficients[,1,drop=FALSE]
  XpX <- summary.lm(reg)$cov.unscaled
  df <- reg$df.residual
  msr <- summary.lm(reg)$sigma  # == SSE / (n-p)
  r <- nrow(cm)


  if ( ncol(cm) != length(bhat) ) stop(  
                   paste( "\n Dimension of ",
                         deparse( substitute( cm ) ), ": ",
                         paste( dim(cm), collapse="x" ),
                         ", not compatible with no of parameters in ",
                         deparse( substitute( reg ) ), ": ",
                         length(bhat), sep="" ) )


  #                        -1
  #     (Cb - d)' ( C (X'X)   C' ) (Cb - d) / r
  # F = ---------------------------------------
  #                 SSE / (n-p)
  #

  Fstat <- t(cm %*% bhat - d) %*% solve((cm %*% XpX %*% t(cm))) %*% (cm %*% bhat - d) / r / msr^2 

  p <- 1-pf(Fstat,r,df)

  retval <- list()
  retval$call <- match.call()
  retval$statistic <- c(F=Fstat)
  retval$parameter <- c(df1=r,df2=df)
  retval$p.value <- p
  retval$conf.int <- NULL
  retval$estimate <- cm%*%bhat
  retval$null.value <- d
  retval$method <- "Test of General Linear Hypothesis"
  retval$data.name <- deparse(substitute(reg))
  retval$matrix <- cm
  colnames(retval$matrix) <- names(reg$coef)
  
  class(retval) <- c("glh.test","htest")

  retval
}

print.glh.test <- function(x, digits = 4, ... )
{
    cat("\n")
    cat("\t",x$method, prefix = "\t")
    cat("\n")
    cat("Call:\n")
    print(x$call)
    
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


  
summary.glh.test <- function(object, digits = 4, ... )
{
    cat("\n")
    cat("\t",object$method, prefiobject = "\t")
    cat("\n")
    cat("Regression: ", object$data.name, "\n")
    cat("\n")
    cat("Null Hypothesis: C %*% Beta-hat = d \n")
    cat("\n")
    cat("C matrix: \n")
    print(object$matrix, digits=digits)
    cat("\n")
    cat("d vector: \n")
    print(object$null.value, digits=digits)
    cat("\n")
    cat("C %*% Beta-hat: \n")
    print(c(object$estimate))
    cat("\n")
    
    if (!is.null(object$statistic)) 
        cat(names(object$statistic), " = ", format(round(object$statistic, 
            4)), ", ", sep = "")
    if (!is.null(object$parameter)) 
        cat(paste(names(object$parameter), " = ", format(round(object$parameter, 
            3)), ",", sep = ""), "")
    cat("p-value =",
        format.pval(object$p.value, digits = digits), 
        "\n")
    cat("\n")
  }


  
