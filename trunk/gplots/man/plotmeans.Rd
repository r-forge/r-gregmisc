% $Id$
%
% $Log$
% Revision 1.2  2001/08/25 05:46:51  warneg
% Added CVS header.
%
% Revision 1.1  2001/08/25 05:45:10  warneg
% Initial Checkin
%
\name{plotmeans}
\alias{plotmeans}
\title{Plot Group Means and Confidence Intervals}
\description{Plot group means and confidence intervals.}
%\synopsis{
\usage{
plotmeans(formula, data=NULL, subset, na.action,
          bars=T, p=0.95, xlab=names(mf)[2],
          ylab=names(mf)[1], mean.labels=F,
          ci.label=F, n.label=T, digits=getOption("digits"),
          col="black", barwidth=1, barcol="blue",
          connect=T, ccol=col, legends=names(means), ...)
}
%
%\usage{
%  plotmeans( outcome ~ treatment)
%}

\arguments{
  \item{formula}{symbolic expression specifying the outcome and grouping
    variable.  See lm() for details.}

  \item{data}{optional data frame containing the variables in the model.}

  \item{subset}{an optional vector specifying a subset of observations to be
    used in the fitting process.}

  \item{na.action}{a function which indicates what should happen when the data
    contain `NA's.  See lm() for details. }

  \item{bars}{a logical value indicating whether confidence interval
    bars should be plotted. Defaults to TRUE.}

  \item{p}{confidence level for error bars.  Defaults to 0.95.}

  \item{xlab}{x-axis label.}
  \item{ylab}{y-axis label.}

  \item{mean.labels}{ either a logical value indicating whether the circles
    representing the group means should be replaced with text giving the
    actual mean values or a vector containing labels to use
    instead. Defaults to FALSE.}

  \item{ci.label}{ a logical value indicating whether text giving the
    actual interval end values should be placed at the end of each
    confidence interval bar. Defaults to FALSE.}

  \item{n.label}{ a logical value indicating whether text giving the number of
    observations in each group should should be added to the plot. }

  \item{digits}{ number of significant digits to use when displaying
    mean or confidince limit values.}

  \item{col}{ color of cicles marking group means.  Default is "black".}

  \item{barwidth}{ linewidth of interval bars and end marks. Default is
    1.}

  \item{barcol}{ color of interval bars and end marks.  Default is
    "blue".}

  \item{connect}{ either a logical value indicating whether the means of
    each group should be connected by a line, or a list of vectors giving the
    index of bars that should be connected by a line. Defaults to TRUE.}

  \item{ccol}{ color of lines used to connect means. Defaults to the
    same color as "col".}

  \item{legends}{ vector containing strings used to label groups along
    the x axis. Defaults to group names.}

  \item{\dots}{ optional plotting parameters. }
  
  }

%\details{ 
%  
%  
%}


\examples{

  # show comparison with boxplot
  data(state)
  plotmeans(state.area ~ state.region)   

  # show some color and mean labels
  plotmeans(state.area ~ state.region,
             mean.labels=T, digits=-3,
             col="red", connect=F)

  # show how to specify which means should be connected
  plotmeans(state.area ~ state.region, connect=list(1:2, 3:4),
            ccol="red", pch=7 )
}

\author{Gregory R. Warnes \email{Gregory\_R\_Warnes@groton.pfizer.com}}

\seealso{\code{\link{plotCI}}, \code{\link{boxplot}}}

\keyword{hplot}
