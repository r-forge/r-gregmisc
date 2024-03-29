% $Id$
%
% $Log$
% Revision 1.6  2003/04/22 16:00:27  warnes
% - Fixed tpyo in example that allowed combinations(500,2) to run when
%   it should have been ignred for testing..
%
% Revision 1.5  2003/04/10 16:22:29  warnes
%
% - Added note about the need to increase options("expressions") to use
%   large values for 'n'.  Prompted by bug report from Huan Huang
%   <huan.huang@bnpparibas.com
%
% Revision 1.4  2002/09/23 13:59:30  warnes
% - Modified all files to include CVS Id and Log tags.
%
% Revision 1.3  2002/04/09 00:51:32  warneg
%
% Checkin for version 0.5.3
%
% Revision 1.2  2001/08/25 05:50:58  warneg
% Fixed a typo and a syntax error.
%
% Revision 1.1  2001/06/29 13:24:08  warneg
%
% Initial revision.
%

\name{combinations}
\alias{combinations}
\alias{permutations}
\title{Enumerate the Combinations or Permutations of the Elements of a Vector}
\description{
  \code{combinations} enumerates the possible combinations of a
  specified size from the elements of a vector.  \code{permutations}
  enumerates the possible permutations.
}
\usage{
combinations(n, r, v=1:n, set=TRUE, repeats.allowed=FALSE)
permutations(n, r, v=1:n, set=TRUE, repeats.allowed=FALSE)
}
%- maybe also `usage' for other objects documented here.
\arguments{
  \item{n}{ Size of the source vector }
  \item{r}{ Size of the target vectors }
  \item{v}{ Source vector. Defaults to \code{1:n}}
  \item{set}{ Logical flag indicating whether duplicates should be
    removed from the source vector \code{v}. Defaults to \code{TRUE}.}
  \item{repeats.allowed}{ Logical flag indicating whether the
    constructed vectors nay include duplicated values.  Defaults to
    \code{FALSE}.  }
}
\details{
  Caution: The number of combinations and permutations increases rapidly
  with \code{n} and \code{r}!.

  To use values of \code{n} above about 45, you will need to increase
  R's recursion limit.  See the \code{expression} argument to the
  \code{options} command for details on how to do this.
}
\value{
  Returns a matrix where each row contains a vector of length \code{n}.
}
\references{Venables, Bill.  "Programmers Note", R-News, Vol 1/1,
  Jan. 2001. \url{http://cran.r-project.org/doc/Rnews} }
\author{ Original versions by Bill Venables
  \email{Bill.Venables@cmis.csiro.au}.  Extended to handle
  \code{repeats.allowed} by Gregory R. Warnes
  \email{Gregory\_R\_Warnes\@groton.pfizer.com}.
  }
%\note{ ~~further notes~~ }

% ~Make other sections like WARNING with \section{WARNING }{....} ~

\seealso{ \code{\link[base]{choose}}, \code{\link[base]{options}} }

\examples{
combinations(3,2,letters[1:3])
combinations(3,2,letters[1:3],repeats=TRUE)

permutations(3,2,letters[1:3])
permutations(3,2,letters[1:3],repeats=TRUE)

# To use large 'n', you need to change the default recusion limit
\dontrun{
options(expressions=1e5)
cmat <- combinations(500,2)
dim(cmat) # 44850 by 2 
}
}
\keyword{ manip }
