\name{par.apply.model}
\alias{par.apply.model}
\title{Apply a model function to each row of a matrix}
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
par.apply.model(fun, matrix, covariates, ..., ncpu = numcpu.lsf(),
                nelem, packages = .packages(), cltype = "MPI",
                debug = TRUE, cl = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{fun}{ ~~Describe \code{fun} here~~ }
  \item{matrix}{ ~~Describe \code{matrix} here~~ }
  \item{covariates}{ ~~Describe \code{covariates} here~~ }
  \item{\dots}{ ~~Describe \code{\dots} here~~ }
  \item{ncpu}{ ~~Describe \code{ncpu} here~~ }
  \item{nelem}{ ~~Describe \code{nelem} here~~ }
  \item{packages}{ ~~Describe \code{packages} here~~ }
  \item{cltype}{ ~~Describe \code{cltype} here~~ }
  \item{debug}{ ~~Describe \code{debug} here~~ }
  \item{cl}{ ~~Describe \code{cl} here~~ }
}
\details{
  ~~ If necessary, more details than the __description__  above ~~
}
\value{
  matrix containing the results of each model fit.
}
\author{Gregory R. Warnes \email{gregory\_r\_warnes@groton.pfizer.com}}
\note{ ~~further notes~~ }
\seealso{ \code{\link{parRapply}} }
\examples{
library(Design)
library(Hmisc)
library(gregmisc)

set.seed(1)
age <- rnorm(200,40,12)
sex <- factor(sample(c('female','male'),200,TRUE))
logit <- (sex=='male') + (age-40)/5
y <- ifelse(runif(200) <= plogis(logit), 1, 0)
dataframe <- data.frame(age=age, sex=sex)
fit.lm  <- lm (y ~ age*sex, data=dataframe)
ymat <- matrix(y, nrow=20, ncol=length(y), byrow=T)

fun <- function(y, covariates)
  {
    unmatrix <- function(x)
      {
        vlist <- c(x)
        names(vlist) <- c(outer( rownames(x), colnames(x), paste, sep=":" ))
        return(vlist)
      }

    fit <- lm( y ~ age*sex, data=covariates )
    sum <- summary(fit)
    retval <- unmatrix( coef(sum) )
    retval
  }

ret <- par.apply.model (
                      fun,
                      matrix = ymat,
                      covariates = dataframe,
                      cltype="MPI"
                      )

ret
}
\keyword{ ~kwd1 }% at least one, from doc/KEYWORDS
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
