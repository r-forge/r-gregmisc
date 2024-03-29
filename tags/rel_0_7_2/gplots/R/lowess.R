# $Id$
#
# $Log$
# Revision 1.5  2002/09/23 13:59:30  warnes
# - Modified all files to include CVS Id and Log tags.
#
#

lowess  <- function(x,...)
  UseMethod("lowess")

# make original lowess into the default method
lowess.default  <- get("lowess",pos=NULL, mode="function")

# add "..." to the argument list to match the generic
formals(lowess.default) <- c(formals(lowess.default),alist(...= ))


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
