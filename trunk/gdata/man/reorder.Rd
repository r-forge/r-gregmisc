% $Id$


\name{reorder.factor}
\alias{reorder.factor}
\title{Reorder the Levels of a Factor}
\description{
  Reorder the levels of a factor
}
\usage{
\method{reorder}{factor}(x, order="mixedsort", ...)
}
\arguments{
  \item{x}{factor.}
  \item{order}{The string "mixedsort", a vector of indexes or a vector
  of label names.}
  \item{...}{Optional parameters (ignored.)}
}
\details{
  With \code{order="mixedsort"} the factor levels are sorted so that
  combined numeric and character strings are sorted in according to
  character rules on the character sections (including ignoring case),
  and be numeric rules for the numeric sections.  See \code{mixedsort}
  for details.

  When \code{order} is a numeric vector, this function is simply a
  convenence wrapper for \code{factor(x,levels=levels(x)[order])}.
  I.E., the levels of the factor are rearranged according to the
  specified order.

  When \code{order} is a character vector, this function is simply a
  wrapper for \code{factor(x,levels=order)}.  I.E., the vector provides
  an explicit list of the order of the factors.

  I find this function useful for reordering factors so that the default
  treatment contrasts use the appropriate levels for comparison.
}
\value{
  A new factor with the levels ordered as specified.  Note that levels
  not specified in \code{order} will become missing values.
}

\author{Gregory R. Warnes \email{Gregory\_R\_Warnes@groton.pfizer.com}}

\seealso{ \code{\link{factor}}, \code{\link[stats]{reorder}} }

\examples{
   # Create a 4 level example factor
   trt <- factor( sample( c("PLACEBO","300 MG", "600 MG", "1200 MG"),
                  100, replace=TRUE ) )
   summary(trt)
   # Note that the levels are not in a meaningful order.


   # Change the order to something useful
   # default "mixedsort" ordering
   trt2 <- reorder(trt)
   summary(trt2)
   # using indexes:
   trt3 <- reorder(trt, c(4,2,3,1))
   summary(trt3)
   # using label names:
   trt4 <- reorder(trt, c("PLACEBO","300 MG", "600 MG", "1200 MG") )
   summary(trt4)


   # drop out the '300 MG' level
   trt5 <- reorder(trt, c("PLACEBO", "600 MG", "1200 MG") )
   summary(trt5)
}
\keyword{ manip }
