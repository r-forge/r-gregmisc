# $Id$
#
# $Log$
# Revision 1.3  2002/04/09 00:51:33  warneg
# Checkin for version 0.5.3
#
# Revision 1.2  2002/03/26 21:22:35  warneg
#
# - Changed methods to include '...' to match the generic.
# - Updated for version 0.5.1
#
# Revision 1.1  2002/03/26 15:27:37  warneg
#
# Initial checkin.
#
#


\name{reorder}
\alias{reorder}
\title{Reorder the Levels of a Factor}
\description{
  Reorder the levels of a factor
}
\usage{
reorder(X, order)
}
\arguments{
  \item{X}{ factor. }
  \item{order}{ Vector of indexes specifying the new order of the levels.  }
}
\details{
  This function is simply a convenence wrapper for
  \code{factor(X,levels=levels(X)[order])}.

  I find this useful for reordering factors so that the default
  treatment contrasts use the appropriate levels for comparison.
  
}
\value{
  A new factor with the levels ordered as specified.
}

\author{Gregory R. Warnes \email{Gregory\_R\_Warnes@groton.pfizer.com}}

\seealso{ \code{\link{factor}} }

\examples{
   # Create a 4 level example factor
   trt <- factor( sample( c("PLACEBO","300 MG", "600 MG", "1200 MG"),
                  100, replace=TRUE ) )
   summary(trt)
   # Note that the levels are not in a meaningful order.


   # Change the order to something useful
   trt2 <- reorder(trt, c(4,2,3,1))
   summary(trt2)

   # drop out the '300 MG' level
   trt3 <- reorder(trt, c(4,3,1) )
   summary(trt3)
}  
\keyword{ manip }
