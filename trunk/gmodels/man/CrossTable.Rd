% $Id$
%
% Revision 1.4  2004/03/01 schwartz
%
% - Thanks to Gabor Grothendieck for providing ideas and
%   comments on the following updates
% - Modified function to allow a single vector to be
%   tabulated in 'x'
% - Added 'chisq' argument to disable the generation and
%   printing of the chi-square tests, producing a simple
%   table with no tests. Default value = FALSE.
% - Removed restriction on minimum 2 x 2 tables (ie. can do a
%   1 x n table, but no stats will be generated
% - Added code to create generic row/col names if argument 'x'
%   is a matrix without dimnames
% - Added 'max.width' argument to enable wrapped output for
%   1 x n tables. If n > max.width, table will wrap to next
%   line
% - Separated functions to print m x n table and 1 x n vector
%   to enable flexibility in vector output formats and to faciliate
%   future creation and separation of table generation and print methods.


% $Log$
% Revision 1.6  2005/01/14 21:40:35  nj7w
% Updated the manual to reflect prop.chisq change in its R file.
%
% Revision 1.5  2004/12/23 19:32:31  nj7w
% Split the function print.CrossTable.vector in two parts - for SAS behaiour and SPSS behaviour. Also put the code of printing statistics in a function 'print.statistics'
%
% Revision 1.4  2004/05/25 02:57:01  warnes
% Updates from Mark Schwartz.
%
% Revision 1.3  2003/01/30 21:41:38  warnes
%
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
  similar to S-Plus crosstabs() and SAS Proc Freq (or SPSS format)
  with Chi-square, Fisher and McNemar tests of the independence
  of all table factors.
  }
\usage{
CrossTable(x, y, digits=3, max.width = 5, expected=FALSE, prop.r=TRUE, prop.c=TRUE,
           prop.t=TRUE, prop.chisq=TRUE, chisq = FALSE, fisher=FALSE, mcnemar=FALSE,
           resid=FALSE, sresid=FALSE, asresid=FALSE,
           missing.include=FALSE,
format=c("SAS","SPSS")),...
}
\arguments{
  \item{x}{A vector or a matrix. If y is specified, x must be a vector}
  \item{y}{A vector in a matrix or a dataframe}
  \item{digits}{Number of digits after the decimal point for cell
    proportions}
	\item{max.width}{In the case of a 1 x n table, the default will be
		to print the output horizontally. If the number of columns exceeds
		max.width, the table will be wrapped for each successive increment
		of max.width columns. If you want a single column vertical table,
		set max.width to 1}
  \item{expected}{If \code{TRUE}, chisq will be set to \code{TRUE} and
		expected cell counts from the \eqn{\chi^2}{Chi-Square} will be
		included}
  \item{prop.r}{If \code{TRUE}, row proportions will be included}
  \item{prop.c}{If \code{TRUE}, column proportions will be included}
  \item{prop.t}{If \code{TRUE}, table proportions will be included}
  \item{prop.chisq}{If \code{TRUE}, chi-square contribution of each cell will be included}
  \item{chisq}{If \code{TRUE}, the results of a chi-square test will
		be included}
  \item{fisher}{If \code{TRUE}, the results of a Fisher Exact test will
     be included}
  \item{mcnemar}{If \code{TRUE}, the results of a McNemar test will
     be included}
   \item{resid}{If \code{TRUE}, residual (Pearson) will be included}
   \item{sresid}{If \code{TRUE},  standardized residual will be included}
   \item{asresid}{If \code{TRUE}, adjusted standardized residual will be included}
   \item{missing.include}{If \code{TRUE}, then remove any unused factor levels}
  \item{format}{Either SAS (default) or SPSS, depending on the type of
  output desired.}

 }
\details{
  A summary table will be generated with cell row, column and table
  proportions and marginal totals and proportions. Expected cell counts
  can be printed if desired (if 'chisq = TRUE'). In the case of a 2 x 2
	table, both corrected and uncorrected values will be included for
	appropriate tests. In the case of tabulating a single vector, cell
	counts and table proportions will be printed.

  Note: If 'x' is a vector and 'y' is not specified, no statistical tests
	will be performed, even if any are set to \code{TRUE}.
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

  resid/sresid/asresid: Pearson Residuals (from chi-square tests).
}
\author{Marc Schwartz \email{mschwartz@medanalytics.com}. Original
        version posted to r-devel on Jul 27, 2002.}

\seealso{\code{\link{xtabs}},
         \code{\link{table}},
         \code{\link{prop.table}}}

\examples{

# Simple cross tabulation of education versus prior induced abortions
# using infertility data
data(infert, package = "datasets")
CrossTable(infert$education, infert$induced, expected = TRUE)
CrossTable(infert$education, infert$induced, expected = TRUE, format="SAS")
CrossTable(infert$education, infert$induced, expected = TRUE, format="SPSS")
}
\keyword{category}
\keyword{univar}
