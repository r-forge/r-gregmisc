% $Id$
%
% $Log$
% Revision 1.6  2002/09/23 13:59:30  warnes
% - Modified all files to include CVS Id and Log tags.
%
%

\name{rename.vars}
\alias{rename.vars}
\title{ Rename variables in a dataframe }
\description{
  Rename a variables in a data frame.
}
\usage{
rename.vars(data, from="", to="", info=TRUE)
}
\arguments{
  \item{data}{ dataframe to be modified.  }
  \item{from}{ character vector containing the current name of each variable to be renamed.}
  \item{to}{ character vector containing the new name of each variable
    to be renamed.}
  \item{info}{ boolean value indicating whether to print details of the
    renaming.  Defaults to TRUE.}
}
%\details{
%  ~~ If necessary, more details than the __description__  above ~~
%}
\value{
  The updated data frame with variables listed in \code{from} renamed to
  the corresponding element of \code{to}.
}
\author{Code by Don MacQueen \email{macq\@llnl.gov}.
  Documentation by Gregory R. Warnes
  \email{gregory\_r\_warnes\@groton.pfizer.com} }
\seealso{ \code{\link{names}},
  \code{\link{colnames}},
  \code{\link{data.frame}}
}

\examples{
data <- data.frame(x=1:10,y=1:10,z=1:10)
names(data)
data <- rename.vars(data, c("x","y","z"), c("first","second","third"))
names(data)

}
\keyword{ manip  }

