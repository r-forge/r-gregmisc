lowess  <- function(x,...)
  UseMethod("lowess")

lowess.default  <- get("lowess",pos=NULL, mode="function")

"lowess.formula" <-  function (formula,
                               data = parent.frame(), subset, na.action, 
                               f=3,  iter=3,
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
