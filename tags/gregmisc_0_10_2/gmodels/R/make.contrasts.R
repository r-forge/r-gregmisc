# $Id$
#
# $Log$
# Revision 1.2  2003/01/30 14:58:31  warnes
# - Added explicit check to ensure that the number of specified
#   contrasts is less than or equal to the ncol - 1.  Previously, this
#   failed with an obtuse error message when the contrast matrix had row
#   names, and silently dropped contrasts over ncol-1.
#
# Revision 1.1  2002/10/29 23:00:43  warnes
#
# - Moved make.contrasts to a separate file.
# - Enhanced make contrasts to better label contrast matrix, to give
#   how.many a default value, and to coerce vectors into row matrixes.
# - Added help page for make.contrasts.
# - Added link from contrasts.lm seealso to make.contrasts.
#
#


"make.contrasts" <-  function (contr, how.many=ncol(contr)) 
{
  if(!is.matrix(contr))
    contr <- matrix(contr,ncol=length(contr))

  if(nrow(contr)+1 > how.many)
    stop("Too many contrasts specified. Must be less than the number of factor levels (columns).")
  
  value <- as.matrix(ginv(contr))  # requires library(MASS)
  if (nrow(value) != how.many) 
    stop("wrong number of contrast matrix rows")
  n1 <- if (missing(how.many)) 
    how.many - 1
  else how.many
  nc <- ncol(value)
  if (nc < n1) {
    cm <- qr(cbind(1, value))
    if (cm$rank != nc + 1) 
      stop("singular contrast matrix")
    cm <- qr.qy(cm, diag(how.many))[, 2:how.many, drop=FALSE]
    cm[, 1:nc] <- value
  }
  else cm <- value[, 1:n1, drop = FALSE]

  colnames(cm) <- paste( "C", 1:ncol(cm), sep="")
  rownames(cm) <- paste( "V", 1:nrow(cm), sep="")
  
  if(!is.null(rownames(contr)))
    {
      namelist <- rownames(contr)
      colnames(cm)[1:length(namelist)] <- namelist
    }

  if(!is.null(colnames(contr)))
    rownames(cm) <- colnames(contr)

  cm
}
