# $Id$
#
# $Log$
# Revision 1.3  2003/11/17 21:40:15  warnes
# - Fix incorrect handling of glm objects by fit.contrast, as reported
#   by Ulrich Halekoh, Phd <ulrich.halekoh@agrsci.dk>.
#
# - Add regression test code to for this bug.
#
# Revision 1.2  2003/04/22 17:24:29  warnes
#
# - the variable 'df' was used within the lme code section overwriting
#   the argument 'df'.
#
# Revision 1.1  2003/01/30 21:53:06  warnes
#
# - Renamed 'contrast.lm' to 'fit.contrast'.  This new name is more
#   descriptive and makes it easier to create and use methods for other
#   classes, eg lme.
#
# - Enabled fit.contrast for lme object now that Doug Bates has provided
#   the necessary support for contrasts in the nlme package.
#
# - New contrast.lm function which generates a 'depreciated' warning and
#   calls fit.contrast
#
# - Updated help text to match changes.
#
# Revision 1.15  2003/01/02 16:04:42  warnes
#
# - Now will run on objects of class aov (but not aovlist!)
#
# Revision 1.14  2002/10/29 23:00:42  warnes
#
# - Moved make.contrasts to a separate file.
# - Enhanced make contrasts to better label contrast matrix, to give
#   how.many a default value, and to coerce vectors into row matrixes.
# - Added help page for make.contrasts.
# - Added link from contrasts.lm seealso to make.contrasts.
#
# Revision 1.13  2002/10/29 19:55:13  warnes
#
# - Fix bug that prevented contrast.lm() from working on 'aov' objects
# - Add 'aov' examples to documentation for contrast.lm
# - Added note about future support for contrast.lme.
#
# Revision 1.12  2002/09/24 15:55:16  warnes
#
# - Add ability to show confidence intervals when showall=TRUE.
#
# Revision 1.11  2002/08/01 19:37:14  warnes
#
# - Corrected documentation mismatch for ci, ci.default.
#
# - Replaced all occurences of '_' for assignment with '<-'.
#
# - Replaced all occurences of 'T' or 'F' for 'TRUE' and 'FALSE' with
#   the spelled out version.
#
# - Updaded version number and date.
#
# Revision 1.10  2002/04/15 21:28:51  warneg
# - Separated out, then commented out contrast.lme code.  The
#   contrast.lme function will become part of Bates and Pinhiero's NLME
#   library.
#
# Revision 1.9  2002/04/09 00:51:29  warneg
#
# Checkin for version 0.5.3
#
# Revision 1.8  2002/04/05 18:23:17  warneg
#
# - Updated contrast.lm to handle lme objects
# - Modified contrast.lm to compute confidence intervals even when
#   showall is true.
# - Added check and warning if conf.int is outside (0,1).  This will ensuere
#   that conf.int=TRUE does not cause nonsense results.
#
# Revision 1.7  2001/12/10 19:29:21  warneg
# incorrectly put contrast.coeff.R (now estimable.R) here.  Now correctly put contrast.factor.R back here
#
# Revision 1.1  2001/12/07 19:53:49  warneg
# Renamed 'contrast.lm.R' to 'contrast.lm.R' to highlight that this function only works on individual factors.
#
# Revision 1.5  2001/11/13 21:19:22  warneg
# - Fixed error that occured when a factor has 2 levels and only one
#   contrast is specified
#
# Revision 1.4  2001/09/18 14:14:34  warneg
#
# Fixed bug in make.contrasts.  There was leftover code expecting a
# parameter 'x' which is no lonber provided.
#
# Revision 1.3  2001/08/31 23:36:52  warneg
#
# Added make.contrasts() to allow S-Plus so that the remaining
# unspecified df for contrats are filled by contrasts orthogonal to the
# specified ones.  This results in getting the exact same value from
# computing contrasts in a one-way anova as would be obtained by
# directly computing the means and performing the approprial linalg.
#
# Revision 1.2  2001/08/31 20:46:55  warneg
# Previous version did not actually work.  This version now correctly
# computes contrasts.  It will also (in conjunction wiht RSCompat.S)
# work in S-Plus.
#

fit.contrast.lm <- function(model, varname, coeff, showall=FALSE,
                            conf.int=NULL, df=FALSE, ...)
{
  # check class of model
  if( !("lm" %in% class(model) ||
        "aov" %in% class(model) ||
        "lme" %in% class(model) ) )
    stop("contrast.lm can only be applied to objects inheriting from 'lm'",
         "and 'lme' (eg: lm,glm,aov,lme).")
  
  # make sure we have the NAME of the variable
  if(!is.character(varname))
     varname <- deparse(substitute(varname))

  # make coeff into a matrix 
  if(!is.matrix(coeff))
    {
       coeff <- matrix(coeff, nrow=1)
     }

  # make sure columns are labeled
  if (is.null(rownames(coeff)))
     {
       rn <- vector(length=nrow(coeff))
       for(i in 1:nrow(coeff))
          rn[i] <- paste(" c=(",paste(coeff[i,],collapse=" "), ")")
       rownames(coeff) <- rn
     }

  # now convert into the proper form for the contrast matrix
  cmat <- make.contrasts(coeff, ncol(coeff) )
  cn <- paste(" C",1:ncol(cmat),sep="")
  cn[1:nrow(coeff)] <- rownames(coeff)
  colnames(cmat) <- cn

  # recall fitting method with the specified contrast
  m <- model$call
  if(is.null(m$contrasts))
    m$contrasts <- list()
  m$contrasts[[varname]] <- cmat 
  if(is.R())
    r <- eval(m, parent.frame())
  else
    r <- eval(m)

  # now return the correct elements ....
  if( 'lme' %in% class(model) )
    {
      est <- r$coefficients$fixed
      se  <- sqrt(diag(r$varFix))
      tval <- est/se
      df.lme   <- r$fixDF$X
      retval <- cbind(
                      "Estimate"= est,
                      "Std. Error"= se,
                      "t-value"= tval,
                      "Pr(>|t|)"=  2 * (1 - pt(abs(tval), df.lme)),
                      "DF"=df.lme
                      )

    }
  else if('glm' %in% class(model))
    {
      smodel <- summary.glm(r)
      retval <- cbind(coef(smodel), "DF"=smodel$df[2])
    }
  else # lm, aov
    {
      smodel <- summary.lm(r)
      retval <- cbind(coef(smodel), "DF"=smodel$df[2])
    }

  if( !showall )
    {
      if( !is.R() && ncol(cmat)==1 )
        {
          retval <- retval[varname,,drop=FALSE]
          rownames(retval) <- rn
        }
      else
        {
          rn <- paste(varname,rownames(coeff),sep="")
          ind <- match(rn,rownames(retval))
          retval <- retval[ind,,drop=FALSE]
        }

    }

  if(!is.null(conf.int)) # add confidence intervals
    {
      alpha <- 1-conf.int
      retval <- cbind( retval,
                      "lower CI"=retval[,1] -
                      qt(1-alpha/2,retval[,5])*retval[,2],
                      "upper CI"=retval[,1] +
                      qt(1-alpha/2,retval[,5])*retval[,2] )
    }

  if(!df)
    return(retval[,-5,drop=FALSE])
  else
    return(retval)
}

# fit.contrast.lme is necessary because 'lme' objects do not inherit
# from 'lm'.
#
# **Make sure that the argument list *exactly* matches the one
# for fit.contrast.lm() above.**
#
fit.contrast.lme <- function(model, varname, coeff, showall=FALSE,
                            conf.int=NULL, df=FALSE, ...)
  {
    require(nlme)
    fit.contrast.lm(model, varname, coeff, showall, conf.int, df)
  }


fit.contrast <- function(model, varname, coeff, ...)
  UseMethod("fit.contrast")

