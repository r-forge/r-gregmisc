% $Id$
%
% $Log$
% Revision 1.8  2004/03/26 22:31:09  warnes
% Contents of package 'mva' moveed to 'stats'.
%
% Revision 1.7  2004/01/21 12:06:41  warnes
% - Add ... argument to match generic provided in stats.
%
% Revision 1.6  2003/04/22 15:42:35  warnes
%
% - The stats package (which is part of recommended) now provides a
%   generic 'reorder' function.  Consequently, the 'reorder' function
%   here has been renamed to 'reorder.factor'.
%
% - Removed check of whether the argument is a factor object.
%
% Revision 1.5  2003/03/03 17:48:58  warnes
% - Updated to match reorder.Rd which was exetended to handle factor
%   label names in addition to numeric indices.
%
% Revision 1.4  2002/09/23 13:59:30  warnes
% - Modified all files to include CVS Id and Log tags.
%
% Revision 1.3  2002/04/09 00:51:33  warneg
%
% Checkin for version 0.5.3
%
% Revision 1.2  2002/03/26 21:22:35  warneg
%
% - Changed methods to include '...' to match the generic.
% - Updated for version 0.5.1
%
% Revision 1.1  2002/03/26 15:27:37  warneg
%
% Initial checkin.
%
%


\name{reorder.factor}
\alias{reorder.factor}
\title{Reorder the Levels of a Factor}
\description{
  Reorder the levels of a factor
}
\usage{
\method{reorder}{factor}(x, order, ...)
}
\arguments{
  \item{x}{factor.}
  \item{order}{Vector of indexes or label names for new factor ordering.}
  \item{...}{Optional parameters (ignored.)}
}
\details{
  When \code{order} is a numeric vector, this function is simply a
  convenence wrapper for \code{factor(x,levels=levels(x)[order])}.
  Otherwise this functionis simply a wrapper for
  \code{factor(x,levels=order)}.
  
  I find this function useful for reordering factors so that the default
  treatment contrasts use the appropriate levels for comparison.
}
\value{
  A new factor with the levels ordered as specified.  Note that levels
  not specified \code{order} will become missing values.
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
   # using indexes:
   trt2 <- reorder(trt, c(4,2,3,1))
   summary(trt2)
   # using label names:
   trt2 <- reorder(trt, c("PLACEBO","300 MG", "600 MG", "1200 MG") )
   summary(trt2)


   # drop out the '300 MG' level
   trt3 <- reorder(trt, c("PLACEBO", "600 MG", "1200 MG") )
   summary(trt3)
}  
\keyword{ manip }
