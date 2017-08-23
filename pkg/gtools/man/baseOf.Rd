\name{baseOf}
\alias{baseOf}
\title{Transform integer to new base}
\description{
Transforms a given base-10 integer to an array of digits of another base.
}
\usage{
baseOf(v,b=10,l=1)
}
\arguments{
  \item{v}{
    A single integer value to be transformed.
    }
  \item{b}{
    The base to which to transform to.
    }
  \item{l}{
    The minimal length of the returned array.
    }
}
\details{
 This function rewrites regular integer numbers as an array of its digits.
 The base of the numbering scheme may be changed away from 10,
 which defines our decimal system, to any other integer value. For
 b=2, the number is returned in the dual system. The least significant
 digit has the highest index in the array, i.e. it appears on the right.
 The highest exponent is at position 1, i.e. left.
}
\author{Steffen Moeller \email{moeller@debian.org} }
\examples{
# decimal representation
baseOf(123)
# dual representation
baseOf(123,b=2)
# octal representation
baseOf(123,b=8)
# hexadecimal representation
baseOf(123,b=16)
# hexadecimal with more typical letter-notation
c(0:9,LETTERS)[baseOf(123,16)]
# hexadecimal again, now showing a single string
paste(c(0:9,LETTERS)[baseOf(123,16)],collapse="")
# decimal representation but filling leading zeroes
baseOf(123,l=5)
}
\keyword{base}

