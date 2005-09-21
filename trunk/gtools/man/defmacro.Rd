\name{defmacro}
\alias{defmacro}
\title{Define a macro}
\description{
  Define a macro.
}
\usage{
defmacro(..., expr)
}
\arguments{
  \item{\dots}{ macro argument list }
  \item{expr}{ macro body }
}
\details{
  \code{defmacro} creates a macro from the expression given in
  \code{expr}, with formal arguments given by the other elements of the
  argument list.  When evaluated, the macro first substitutes its
  arguments into the macro body (\code{expr}), and then evaluates the results. 

  The special argument name \code{DOTS} is will be replaced by
  \code{...} in the formal argument list of the macro so that \code{...}
  in the body of the expression can be used to obtain any additional
  arguments passed to the macro. [NB: This is necessary because of R's
  parsing rules.}

  Macros differ from functions in how the arguments are handled.  In a
  function, formal arguments are simply variables that contains the
  result of evaluating the expressions provided to the function call.
  Macros, instead, modify the macro body by \code{replacing} the formal
  arguments by expressions provided to the macro call.

  \code{defmacro} is particularly useful for programmatically
  creating new functions.
}
\note{
  "Note that because [the defmacro code] works on the parsed expression,
  not on a text string, defmacro avoids some of the problems with C
  preprocessor
  macros. In
\preformatted{
  mul <- defmacro(a, b, expr={a*b})
}
  a C programmer might expect
  \code{mul(i, j + k)} to expand (incorrectly) to \code{i*j + k}. In fact it
  expands correctly, to the equivalent of \code{i*(j + k)}."
  (From the reference below.)
  
  For a more complete description of the differences between functions
  and macros, please see the reference below.
}
\value{
  A macro function.
}
\references{
  The code for this function is directly taken from:

  Lumley T. "Programmer's Niche: Macros in {R}", R News, 2001, Vol 1,
  No. 3, pp 11--13, \url{http://CRAN.R-project.org/doc/Rnews/}
}
\author{ Thomas Lumley.  Packaged and enhanced by Gregory R. Warnes
  \email{gregory.r.warnes@pfizer.com} }
\seealso{
  \code{\link[base]{function}}
  \code{\link[base]{substitute}},
  \code{\link[base]{eval}},
  \code{\link[base]{parse}},
  \code{\link[base]{source}},
  \code{\link[base]{parse}},
}
\examples{

####
# macro for replacing a specified missing value indicator with NA
# within a dataframe
###
setNA <- defmacro(df, var, values,
                  expr={
                         df$var[df$var \%in\% values] <- NA
                       })

###
# create example data, 999 is missing value indicator
###
d <- data.frame(
   Grp=c("Trt", "Ctl", "Ctl", "Trt", "Ctl", "Ctl", "Trt", "Ctl", "Trt", "Ctl"),
   V1=c(1, 2, 3, 4, 5, 6, 999, 8,   9,  10),
   V2=c(1, 1, 1, 1, 1, 2, 999, 2, 999, 999)
               )
d

###
# Try it out
###
setNA(d, V1, 999)
setNA(d, V2, 999)
d


###
# Macro for creating a plotting function
###
plotit <- defmacro( df, var, DOTS, col="red", title="", expr=
  {
    plot( df$var ~ df$Grp, type="b", col=col, main=title, ... )
  } )

# Notes:
# 1 - The macro expansion of 'col' will correctly replaces the
# object name 'col' (right hand side of col=col) and not the argument
# name (left hand side of col=col) in the function call to plot
# 2 - The plot's y axis label will have the proper label
# 3 - Note the use of 'DOTS' in place of '...'

plotit( d, V1)
plotit( d, V1, col="blue" )
plotit( d, V1, lwd=4)  # use optional 'DOTS' argument

# works with variables too
color <- "cyan"
plotit( d, V1, col=color, title="Crazy Plot")

  # An equivalent function is somewhat messier, since it must either explicitly
  # construct the y axis label, duplicating some of the work of the plot
  # function:
  plotit <- function( df, var, ..., col="red", title="" )
  {
      dname <- deparse(substitute(df))
      vname <- deparse(substitute(var))
      plot( df[[vname]] ~ df$Grp, type="b", col=col, title=title,
            ylab=paste( dname, "$", vname, sep='' ), ... )
  }
  # or we explicitly construct the call and then call eval.  The code for
  # the latter approach is # omiited since this is quite messy and
  # requires a lot of work.

}
\keyword{programming}
