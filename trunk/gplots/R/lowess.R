lowess.default  <- get("lowess",pos="package:base")

lowess  <- function(x,...)
  UseMethod("lowess")

"lowess.formula" <-
  function (formula, data = NULL, subset, na.action, f=2/3, ...) 
{
  if (missing(formula) || (length(formula) != 3)) 
    stop("formula missing or incorrect")
  if (missing(na.action)) 
    na.action <- getOption("na.action")
  m <- match.call(expand.dots = FALSE)
  if (is.matrix(eval(m$data, parent.frame()))) 
    m$data <- as.data.frame(data)
  m$...  <- m$f <- NULL
  m[[1]] <- as.name("model.frame")
  mf <- eval(m, parent.frame())
  response <- attr(attr(mf, "terms"), "response")
  lowess(mf[[-response]], mf[[response]], f, ...)
}
