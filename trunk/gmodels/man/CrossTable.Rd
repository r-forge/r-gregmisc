% $Id$
%
% $Log$
% Revision 1.3  2003/01/30 21:41:38  warnes
% - Removed argument 'correct' and now print separate corrected values
%   for 2 x 2 tables.
% - Added arguments 'prop.r', 'prop.c' and 'prop.t' to toggle printing
%   of row, col and table percentages. Default is TRUE.
% - Added argument 'fisher' to toggle fisher exact test. Default is
%   FALSE.
% - Added McNemar test to statistics and argument 'mcnemar' to toggle
%   test. Default is FALSE.
% - Added code to generate an invisible return list containing table
%   counts, proportions and the results of the appropriate statistical tests.
%
% Revision 1.2  2002/09/23 14:27:16  warnes
%
% - Fixed syntax errors in barplot2.Rd and CrossTable.Rd
% - Fixed incorrect translation of 'F' (distribution) to 'FALSE' in glh.test.Rd
%
% Revision 1.1  2002/09/23 13:38:53  warnes
%
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
  similar to S-Plus crosstabs() and SAS Proc Freq with Chi-square,
  Fisher and McNemar tests of the independence of all table factors.
}
\usage{
CrossTable(x, y, digits=3, expected=FALSE, prop.r=TRUE, prop.c=TRUE,
           prop.t=TRUE, fisher=FALSE, mcnemar=FALSE)
}
\arguments{
  \item{x}{A vector in a matrix or a dataframe OR if y not specified,
    a two-dimensional matrix}
  \item{y}{A vector in a matrix or a dataframe}
  \item{digits}{Number of digits after the decimal point for cell
    proportions}
  \item{expected}{If \code{TRUE}, expected cell counts from the
    \eqn{\chi^2}{Chi-Square} will be included}
  \item{prop.r}{If \code{TRUE}, row proportions will be included}
  \item{prop.c}{If \code{TRUE}, column proportions will be included}
  \item{prop.t}{If \code{TRUE}, table proportions will be included}
  \item{fisher}{If \code{TRUE}, the results of a Fisher Exact test will
     be included}
  \item{mcnemar}{If \code{TRUE}, the results of a McNemar test will
     be included}
}
\details{
  A summary table will be generated with cell row, column and table
  proportions and marginal totals and proportions. Expected cell counts
  can be printed if desired. In the case of a 2 x 2 table, both
  corrected and uncorrected values will be included for appropriate
  tests.

  Note: Any unused factor levels will be dropped prior to tabulation.
}
\value{
  A list with multiple components including key table data and
  statistical test results, where performed.

  t:            An n by m matrix containing table cell counts

  prop.col:     An n by m matrix containing cell column proportions

  prop.row:     An n by m matrix containing cell row proportions

  prop.tbl:     An n by m matrix containing cell table proportions

  chisq:        Results from the Chi-Square test. A list with class
                'htest'. See ?chisq.test for details

  chisq.corr:   Results from the corrected Chi-Square test. A list with
                class 'htest'. See ?chisq.test for details. ONLY
                included in the case of a 2 x 2 table.

  fisher.ts:    Results from the two-sided Fisher Exact test. A list
                with class 'htest'. See ?fisher.test for details. ONLY
                included if 'fisher' = TRUE.

  fisher.lt:    Results from the Fisher Exact test with HA = "less". A
                list with class 'htest'. See ?fisher.test for details.
                ONLY included if 'fisher' = TRUE and in the case of a
                2 x 2 table.

  fisher.gt:    Results from the Fisher Exact test with HA = "greater".
                A list with class 'htest'. See ?fisher.test for details.
                ONLY included if 'fisher' = TRUE and in the case of a
                2 x 2 table.

  mcnemar:      Results from the McNemar test. A list with class
                'htest'. See ?mcnemar.test for details. ONLY included
                if 'mcnemar' = TRUE.

  mcnemar.corr: Results from the corrected McNemar test. A list with
                class 'htest'. See ?mcnemar.test for details. ONLY
                included if 'mcnemar' = TRUE and in the case of a
                2 x 2 table.

}
\author{Marc Schwartz \email{mschwartz@medanalytics.com}. Original
        version posted to r-devel on Jul 27, 2002.}

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
