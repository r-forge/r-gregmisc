\name{frameApply}
\alias{frameApply}
\title{Subset analysis on data frames}
\description{Apply a function to row subsets of a data frame. 
}
\usage{
frameApply(x, by = NULL, on = by[1], fun = nrow, subset = TRUE, out.as.list = FALSE, byvar.sep = "\001", ...)
}
\arguments{
  \item{x}{a data frame}
  \item{by}{names of columns in \code{x} specifying the variables to use
    to form the subgroups. 
    None of the \code{by} variables should have
    the name "sep" (you will get an error if one of them does; a bit of
    laziness in the code). Unused levels of 
    the \code{by} variables will be dropped. Use \code{by = NULL} (the
    default) to indicate that all of the data is to be treated as a
    single (trivial) subgroup.}
  \item{on}{names of columns in \code{x} specifying columns over which
    \code{fun} is to be applied. These can include columns specified in
    \code{by}, (as with the default) although that is not usually the case.}
  \item{fun}{a function that can operate on data frames that are row
    subsets of \code{x[on]}. If \code{out.as.list = FALSE},
    the return value of the function should always be either a try-error
    (see \code{\link{try}}), or a vector of
    fixed length (i.e. same length for every subset), preferably with
    named elements (though the default value for \code{fun} ignores this
    advice).}
  \item{subset}{logical vector (can be specified in terms of variables
    in data). This row subset of \code{x} is taken before doing anything
    else.}
  \item{out.as.list}{logical. If FALSE (the default), return value will
    be a data frame including the \code{by} columns and a column for
    each element of the return vector of \code{fun}. Set to TRUE to
    allow for less structured output (see description of return value below).}
  \item{byvar.sep}{character. This can be any character not
    found anywhere in the values of the \code{by} variables. The
    \code{by} variables will be pasted together using this as the
    separator, and the result will be used as the index to form the
    subgroups.  }
  \item{...}{additional arguments to \code{fun}.}
}
\value{a data frame if \code{out.as.list = FALSE} (the default). If
  \code{out.as.list = TRUE} and \code{by} is not NULL, the return value will be a list with two
  elements. The first element, named "by", will be a data frame with the
  unique rows of \code{x[by]}, and the second element, named "result"
  will be a list where the ith 
  component gives the result for the ith row of the "by" element.  
}
\details{This function accomplishes something similar to
  \code{\link{by}}. The main difference is that \code{frameApply} is
  designed to return data frames and lists instead of objects of class
  'by'. Also, \code{frameApply} works only on the unique combinations of
  the \code{by} that are actually present in the data, not on the entire
  cartesian product of the \code{by} variables.}

\examples{

# define two group descriptors
group1 <- sample( c('A','B','C'), size=1000, replace=T) 
group2 <- sample( c('I','II','III'), size=1000, replace=T)

# and some covariates
x1 <- rnorm(1000, mean=10 )
x2 <- runif(1000)
x3 <- rnorm(10, mean=0.01, sd=0.1)

# and a model for the outcome that depends on both groups and the
# covariate
y <- x1 + 2 *(group1=='A') + x2 *(group2=='II') + 10 * x3 + rnorm(1000, sd=0.5)
data <- data.frame(group1, group2, x1, x2, x3, y)


# show number of observations in each group pairing
frameApply(data, by = c("group1", "group2"))

# Fit a statistical model to each group pairing
frameApply(data, on = c("y", "x1", "x2", "x3"), by = c("group1", "group2"),
           fun = function(dat)
                    coef( lm(y ~ x1 + x2 + x3, data=dat) )
           )
}
\author{Jim Rogers \email{james\_a\_rogers@groton.pfizer.com}}
\keyword{manip}

