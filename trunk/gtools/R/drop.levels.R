# $Id$


drop.levels <- function (x)  {
  as.data.frame(lapply(x,
                       function(xi) {
                         if (is.factor(xi))
                           xi <- factor(xi)
                         xi
                       }))
}
