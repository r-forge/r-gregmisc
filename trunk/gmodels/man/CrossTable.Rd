% $Id$
%
% $Log$
% Revision 1.1  2002/09/23 13:38:53  warnes
% - Added CrossTable() and barplot2() code and docs contributed by Marc Schwartz.
% - Permit combinations() to be used when r>n provided repeat.allowed=TRUE
% - Bumped up version number
%
%

\name{CrossTable}
\alias{CrossTable}
\title{Cross Tabulation with Tests for Factor Independence}
\description{
  An implementation of a cross-tabulation function with output
  similar to S-Plus crosstabs() and SAS Proc Freq with Chi-square and
  Fisher tests of the independence of table factors.
}
\usage{
CrossTable(x, y, digits = 3, expected = FALSE, correct = TRUE)
}
\arguments{
  \item{x}{A vector in a matrix or a dataframe OR if y not specified,
    a two-dimensional matrix}
  \item{y}{A vector in a matrix or a dataframe}
  \item{digits}{Number of digits after the decimal point for cell
    proportions}
  \item{expected}{If \code{TRUE}, expected cell counts from the Chi^2
    will be included}
  \item{correct}{If \code{TRUE}, the Yates continuity correction will
    be applied in the Chi^2 test}
}
\details{
  A summary table will be generated with cell row, column and table
  proportions and marginal totals and proportions. Expected cell counts
  can be printed if desired.
  Note: Any unused factor levels will be dropped prior to tabulation
}
\value{
  None.  A summary table is output to the console.
}
\author{Marc Schwartz \email{mschwartz@medanalytics.com}. Posted to
   r-devel on Jul 27, 2002.}

\seealso{\code{\link{xtabs}},
         \code{\link{table}},
         \code{\link{prop.table}}}

\examples{

# Simple cross tabulation of education versus prior induced abortions
# using infertility data
data(infert, package = "base")
CrossTable(infert$education, infert$induced, expected = TRUE)

}
\keyword{category}
\keyword{univar}
