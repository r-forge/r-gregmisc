# $Id$
#
# $Log$
# Revision 1.8  2003/03/07 15:43:44  warnes
# - Add 'NULL' as the last element of if statement that defines
#   lowess.default so that when the file is sourced, S-Plus doesn't
#   display the function definition.
#
# Revision 1.7  2003/03/07 15:41:44  warnes
#
# - Specify where the defualt lowess function should be found.
# - Use getFunction in S-Plus instead of 'get'
#
# Revision 1.6  2003/01/02 16:07:35  warnes
#
# - Added wrapper code so that R-specific fiddling won't be executed
#   under S-Plus.
#
# Revision 1.5  2002/09/23 13:59:30  warnes
# - Modified all files to include CVS Id and Log tags.
#
#

if(is.R())
  {
    # make original lowess into the default method
    lowess.default  <- get("lowess",pos="package:base", mode="function")

    lowess  <- function(x,...)
      UseMethod("lowess")

    # add "..." to the argument list to match the generic
    formals(lowess.default) <- c(formals(lowess.default),alist(...= ))

    NULL

  } else
  {

    # make original lowess into the default method
    lowess.default  <- getFunction("lowess",where="main")

    lowess  <- function(x,...)
      UseMethod("lowess")

    NULL
  }



"lowess.formula" <-  function (formula,
                               data = parent.frame(), subset, na.action, 
                               f=2/3,  iter=3,
                               delta=.01*diff(range(mf[-response])), ... )
{
  if (missing(formula) || (length(formula) != 3)) 
    stop("formula missing or incorrect")
  if (missing(na.action)) 
    na.action <- getOption("na.action")
  m <- match.call(expand.dots = FALSE)
  if (is.matrix(eval(m$data, parent.frame()))) 
    m$data <- as.data.frame(data)
  m$...  <- m$f <- m$iter <- m$delta <- NULL
  m[[1]] <- as.name("model.frame")
  mf <- eval(m, parent.frame())
  response <- attr(attr(mf, "terms"), "response")
  lowess.default(mf[[-response]], mf[[response]], f=f, iter=iter, delta=delta)
}
