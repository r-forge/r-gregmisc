#
# $Id$
#
# $Log$
# Revision 1.2  2002/04/09 00:51:32  warneg
# Checkin for version 0.5.3
#
# Revision 1.1  2002/02/20 21:41:54  warneg
# Initial checkin.
#
#


\name{interleave}
\alias{interleave}
\title{ Interleave Rows of Data Frames or Matrices }
\description{
  Interleave rows of data frames or Matrices.
}
\usage{
interleave(..., append.source=TRUE, sep=": ")
}
\arguments{
  \item{\dots}{ objects to be interleaved }
  \item{append.source}{Boolean Flag.  When \code{TRUE} (the default) the
    argument name will be appended to the row names to show the source of
    each row. }
  \item{sep}{Separator between the original row name and the object name.}
}
\details{
  This function creates a new matrix or data frame from its arguments.
  
  The new object will have all of the rows from the source objects
  interleaved. IE, it will contain row 1 of object 1, followed by row 1
  of object 2, .. row 1 of object 'n', row 2 of object 1, row 2 of
  object 2, ... row 2 of object 'n' ...
}
\value{
  Matrix containing the interleaved rows of the function arguments.
  }
\author{ Gregory R. Warnes \email{gregory\_r\_warnes\@groton.pfizer.com}
  }
\seealso{ \code{\link{cbind}}, \code{\link{rbind}}, \code{\link{combine}} }

\examples{

# Simple example
a <- matrix(1:10,ncol=2,byrow=TRUE)
b <- matrix(letters[1:10],ncol=2,byrow=TRUE)
c <- matrix(LETTERS[1:10],ncol=2,byrow=TRUE)
interleave(a,b,c)

# Useful example:
#
# Create a 2-way table of means, standard errors, and # obs

g1 <- sample(letters[1:5], 1000, replace=TRUE)
g2 <- sample(LETTERS[1:3], 1000, replace=TRUE )
dat <- rnorm(1000)

stderr <- function(x) sqrt( var(x,na.rm=TRUE) / (nobs(x) - 1 ) )

means   <- aggregate.table( dat, g1, g2, mean )
stderrs <- aggregate.table( dat, g1, g2, stderr )
ns      <- aggregate.table( dat, g1, g2, nobs )
blanks <- matrix( " ", nrow=5, ncol=3)

tab <- interleave( "Mean"=round(means,2),
                   "Std Err"=round(stderrs,2),
                   "N"=ns, " " = blanks, sep=" " )

print(tab, quote=FALSE)

}
\keyword{category}
\keyword{array}

