# $Id$
#
# $Log$
# Revision 1.1  2001/12/10 19:26:52  warneg
# renamed from contrast.coeff.R to estimable.R (incorrectly via contrast.lm.R)
#
# Revision 1.6  2001/12/10 19:20:57  warneg
# Renamed back to estimable
#
# Revision 1.3  2001/12/07 20:32:13  warneg
# - If cm is not matrix, coerce it into a single-row matrix.
#
# Revision 1.2  2001/12/07 20:07:22  warneg
#
# Substantial enhancements to initial version:
#
#  - Added StdErr, t-value, p-value, and DF columns to output.
#  - Modified to use t distribution rather than normal distribution for
#    confidence intervals.
#
#

estimable <- function( obj, cm=NULL, alpha=0.05 )
{

  if( !is.matrix(cm) && !is.data.frame(cm) )
    cm <- matrix(cm, nrow=1)
  
  # Function to compute arbitrary contrasts with c.i.
  # from a linear model ( lm, glm or nlme )
  # Original version by BXC (Bendix Carstensen) 12/01.
  # Modified by Gregory R. Warnes 2001-12-06 and subsequent
  if ( "lme" %in% class( obj ) ) 
    {
      cf  <- summary(obj)$tTable
      rho <- summary(obj)$cor  
      vcv <- rho * outer(cf[,2],cf[,2])
      tmp <- cm
      tmp[tmp==0] <- NA
      df.all <- t(abs( t(tmp) * obj$fixDF$X))
      df <- apply( df.all, 1, min, na.rm=T)
      problem <- apply( df.all != df, 1, any, na.rm=T)
      if( any(problem) )
        warning(paste("Degrees of freedom vary among parameters used to ",
                      "construct linear contrast(s): ",
                      paste((1:nrow(tmp))[problem],collapse=","),
                      ". Using the smallest df among the set of parameters.",
                      sep=""))
    }
  else if ( "lm" %in% class( obj ) )
    {
      cf  <- summary(obj)$coefficients
      vcv <- summary(obj)$cov.unscaled * summary(obj)$sigma^2
      if ("glm" %in% class( obj ) ) 
        vcv <- summary(obj)$cov.scaled
      df <- obj$df.residual
    }
  else
    {
      stop("obj must be of class 'lm', 'glm', 'lme', or 'nlme'")
    }
  

  if ( is.null( cm ) ) cm <- diag( dim( cf )[1] )
  if ( !dim( cm )[2]==dim( cf )[1] ) stop(  
                   paste( "\n Dimension of ",
                         deparse( substitute( cm ) ), ": ",
                         paste( dim(cm), collapse="x" ),
                         ", not compatible with no of parameters in ",
                         deparse( substitute( obj ) ), ": ",
                         dim(cf)[1], sep="" ) )
  ct <- cm %*% cf[,1]
  vc <- sqrt( diag( cm %*% vcv %*% t(cm) ) )
  retval <- cbind(est=ct,
                  stderr=vc,
                  t.value=ct/vc,
                  df=df,
                  prob= 2 * (1 - pt(abs(ct/vc), df) ),
                  lower=ct - vc * qt(1-alpha/2, df),
                  upper=ct + vc * qt(1-alpha/2, df) )
  if (is.null(rownames(cm)))
    rn <- paste("(",apply(cm,1,paste,collapse=" "),")",sep="")
  else
    rn <- rownames(cm)
  dimnames(retval) <- list( rn, c("Estimate","Std. Error", 
                                  "t value",
                                  "DF",
                                  "Pr(>|t|)",
                                  "Lower CI",
                                  "Upper CI") )
  retval
}


