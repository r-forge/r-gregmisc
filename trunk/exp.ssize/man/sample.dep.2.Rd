\name{sample.dep.2}
\alias{sample.dep.2}

\title{ Simulate a sample of groups of dependent normal observations}
\description{
   Given a list of covariance matrices, this function
   simulate normal observation based on the covariance matrix from 
   first until the last one in the list of cov.matrix
}
\usage{
sample.dep.2(ngenes.dep, n, var.ratio, cov.matrix, delta, distrn = "normal")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ngenes.dep}{ integer number of genes to sample the dependent expression  }
  \item{n}{ positive integer number of replicates for each gene each group 
           (control/treatment)}
  \item{var.ratio}{ a positive number for the ratio of variance between 
           treatment and control }
  \item{cov.matrix}{ a list of covariance matrices based on which normal 
	     samples are generated}
  \item{delta}{ effect size for sample size calculation
           the absolute distance from null value for expression values of genes 
           coming from the true alternative hypothesis group}
  \item{distrn}{ distribution of expression data, set to be normal for here }
}
% \details{
%   ~~ If necessary, more details than the __description__  above ~~
% }

\value{
  returns a matrix with ngenes.dep rows and 2*n columns with the first n 
  columns being samples from control group and last n columns being from
  treatment group for each gene (row). each group of genes consists of 
  subgroups of genes that are dependent
}
\author{ Peng Liu \email{peng_liu@groton.pfizer.com}}
% \note{ ~~further notes~~ }

% ~Make other sections like Warning with \section{Warning }{....} ~

% \seealso{ ~~objects to See Also as \code{\link{~~fun~~}}, ~~~ }

\examples{
##---- Should be DIRECTLY executable !! ----
 library(MASS)
# initial values to put in argument
n.dep <- 10; n <- 1000; delta <- 50; var.ratio <- 1;

ngenes <- 7; cov.matrix <- list(ngenes);

for ( i in c(1:ngenes)) {
    cov.matrix[[i]] <- diag(rep(i*0.1, i+1))
    # cov.matrix[[i]] <- diag(rep(i*0.1,4))
}

cov.matrix[[4]][1,1] <- cov.matrix[[5]][1,1] <- cov.matrix[[6]][1,1] <- 1
cov.matrix[[4]][2,1] <- cov.matrix[[4]][1,2] <- 0.15 # corr = 0.15 / (1*0.2) = 0.75
cov.matrix[[5]][2,1] <- cov.matrix[[5]][1,2] <- 0.5 # corr = 0.15 /(1*sqrt(0.5)) = 0.59
cov.matrix[[7]][1,1] <- 10
cov.matrix[[7]][2,1] <- cov.matrix[[7]][1,2] <- 0.6 # corr = 0.67
cov.matrix[[7]][3,1] <- cov.matrix[[7]][1,3] <- 0.5
cov.matrix[[7]][3,2] <- cov.matrix[[7]][2,3] <- 0.4

## begin testing
test.sample.dep <- sample.dep.2( n.dep , n, var.ratio, cov.matrix, delta, distrn = "normal")

}
\keyword{ multivariate }
\keyword{ datagen }
