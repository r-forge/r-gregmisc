\name{heatmap.2}
\alias{heatmap.2}
\title{ Draw a Heat Map }
\description{
  A heat map is a false color image (basically
  \code{\link{image}(t(x))}) with a dendrogram added to the left side 
  and/or to the top.  Typically, reordering of the rows and columns
  according to some set of values (row or column means) within the
  restrictions imposed by the dendrogram is carried out.
}
\usage{
heatmap.2 <- function (x,

                     # dendrogram control
                     Rowv=NULL,
                     Colv=if(symm)"Rowv" else NULL,
                     distfun = dist,
                     hclustfun = hclust,
                     dendrogram = c("both","row","column","none"),
                     symm = FALSE,

                     # data scaling
                     scale = c("none","row", "column"),
                     na.rm=TRUE,

                     # image plot
                     revC = identical(Colv, "Rowv"),
                     add.expr,
                     breaks,
                     col="heat.colors",

                     # block sepration
                     colsep,
                     rowsep,
                     sepcolor="white",
                     sepwidth=c(0.05,0.05),

                     # cell labeling
                     cellnote,
                     notecex=1.0,
                     notecol="cyan",
                     na.color=par("bg"),

                     # level trace
                     trace=c("column","row","both","none"),
                     tracecol="cyan",
                     hline=median(breaks),
                     vline=median(breaks),
                     linecol=tracecol,

                     # Row/Column Labeling
                     margins = c(5, 5),
                     ColSideColors,
                     RowSideColors,
                     cexRow = 0.2 + 1/log10(nr),
                     cexCol = 0.2 + 1/log10(nc),
                     labRow = NULL,
                     labCol = NULL,

                     # color key + density info
                     key = TRUE,
                     density.info=c("histogram","density","none"),
                     denscol=tracecol,
                     symkey = TRUE,
                     densadj = 0.25,

                     # plot labels
                     main = NULL,
                     xlab = NULL,
                     ylab = NULL,

                     # extras
                     ...
                     )
               }
\arguments{
  % Dendogram Control
  \item{x}{numeric matrix of the values to be plotted. }
  \item{Rowv}{determines if and how the \emph{row} dendrogram should be
    reordered.	Either a \code{\link{dendrogram}} or a vector of values
    used to reorder the row dendrogram or \code{\link{FALSE}} to
    suppress reordering or by default, \code{\link{NULL}}, see
    \emph{Details} below.}
  \item{Colv}{determines if and how the \emph{column} dendrogram should be
    reordered.	Has the options as the \code{Rowv} argument above and
    \emph{additionally} when \code{x} is a square matrix, \code{Colv =
      "Rowv"} means that columns should be treated identically to the rows.}
  \item{distfun}{function used to compute the distance (dissimilarity)
    between both rows and columns.  Defaults to \code{\link{dist}}.}
  \item{hclustfun}{function used to compute the hierarchical clustering
    when \code{Rowv} or \code{Colv} are not dendrograms.  Defaults to
    \code{\link{hclust}}.}
  \item{dendrogram}{character string indicating whether to draw 'none', 
    'row', 'column' or 'both' dendrograms.  Defaults to 'both'.}
  \item{symm}{logical indicating if \code{x} should be treated
    \bold{symm}etrically; can only be true when \code{x} is a square matrix.}
  % data scaling
  \item{scale}{character indicating if the values should be centered and
    scaled in either the row direction or the column direction, or
    none.  The default is \code{"row"} if \code{symm} false, and
    \code{"none"} otherwise.}
  \item{na.rm}{logical indicating whether \code{NA}'s should be removed.}
  % image plot
  \item{revC}{logical indicating if the column order should be
    \code{\link{rev}}ersed for plotting, such that e.g., for the
    symmetric case, the symmetry axis is as usual.}
  \item{add.expr}{expression that will be evaluated after the call to
    \code{image}.  Can be used to add components to the plot.}
  \item{breaks}{(optional) Either a numeric vector indicating the
    splitting points for binning \code{x} into colors, or a integer
    number of break points to be used, in which case the break points
    will be spaced equally between \code{min(x)} and \code{max(x)}.}
  \item{col}{colors used for the image. Defaults to heat colors
    (\code{heat.colors}).}
  % block separation
  \item{colsep, rowsep, sepcolor}{(optional) vector of integers indicating
    which columns or rows should be separated from the preceding columns
    or rows by a narrow space of color \code{sepcolor}.}
  \item{sepwidth}{(optional)  Vector of length 2 giving the width (colsep) or height (rowsep) the separator box
   drawn by colsep and rowsep as a function of the width (colsep) or
   height (rowsep) of a cell. Defaults to \code{c(0.05, 0.05)}}
  % cell labeling
  \item{cellnote}{(optional) matrix of character strings which will be
    placed within each color cell, e.g. p-value symbols.}
  \item{notecex}{(optional) numeric scaling factor for \code{cellnote}
    items.}
  \item{notecol}{(optional) character string specifying the color for
    \code{cellnote} text.  Defaults to "green".}
  \item{na.color}{Color to use for missing value (\code{NA}). Defaults
    to the plot background color.}
  % level trace
  \item{trace}{character string indicating whether a solid "trace" line
    should be drawn across 'row's or down 'column's, 'both' or 'none'.
    The distance of the line from the center of each color-cell is
    proportional to the size of the measurement. Defaults to 'column'.}
  \item{tracecol}{character string giving the color for "trace"
    line. Defaults to "cyan".}
  \item{hline, vline, linecol}{Vector of values within cells where a
    horizontal or vertical dotted line should be drawn.  The color of
    the line is controlled by \code{linecol}.  Horizontal  lines are only
    plotted if \code{trace} is 'row' or 'both'.  Vertical lines are only
    drawn if \code{trace} 'column' or 'both'.   \code{hline} and
    \code{vline} default to the median of the breaks, \code{linecol}
    defaults to the value of \code{tracecol}.}
  % Row/Column Labeling
  \item{margins}{numeric vector of length 2 containing the margins
    (see \code{\link{par}(mar= *)}) for column and row names, respectively.}
  \item{ColSideColors}{(optional) character vector of length \code{ncol(x)}
    containing the color names for a horizontal side bar that may be used to
    annotate the columns of \code{x}.}
  \item{RowSideColors}{(optional) character vector of length \code{nrow(x)}
    containing the color names for a vertical side bar that may be used to
    annotate the rows of \code{x}.}
  \item{cexRow, cexCol}{positive numbers, used as \code{cex.axis} in
    for the row or column axis labeling.  The defaults currently only
    use number of rows or columns, respectively.}
  \item{labRow, labCol}{character vectors with row and column labels to
    use; these default to \code{rownames(x)} or \code{colnames(x)}, 
    respectively.}
  % Color key and density info
  \item{key}{logical indicating whether a color-key should be shown.}
  \item{density.info}{character string indicating whether to superimpose
    a 'histogram', a 'density' plot, or no plot ('none') on the
    color-key.}
  \item{denscol}{character string giving the color for the density
    display specified by \code{density.info}, defaults to the same value
    as \code{tracecol}.}
  \item{symkey}{Boolean indicating whether the color key should be
    made symmetric about 0. Defaults to \code{TRUE}.}
  \item{densadj}{Numeric scaling value for tuning the kernel width when
    a density plot is drawn on the color key.  (See the \code{adjust}
    parameter for the \code{density} function for details.)  Defaults to
    0.25.}
  % plot labels
  \item{main, xlab, ylab}{main, x- and y-axis titles; defaults to none.}
  \item{\dots}{additional arguments passed on to \code{\link{image}} } %
}
\details{
  If either \code{Rowv} or \code{Colv} are dendrograms they are honored
  (and not reordered).	Otherwise, dendrograms are computed as
  \code{dd <- as.dendrogram(hclustfun(distfun(X)))} where \code{X} is
  either \code{x} or \code{t(x)}.\cr

  If either is a vector (of \dQuote{weights}) then the appropriate
  dendrogram is reordered according to the supplied values subject to
  the constraints imposed by the dendrogram, by \code{\link{reorder}(dd, 
    Rowv)}, in the row case.
  %%
  If either is missing, as by default, then the ordering of the
  corresponding dendrogram is by the mean value of the rows/columns, 
  i.e., in the case of rows, \code{Rowv <- rowMeans(x, na.rm=na.rm)}.
  %%
  If either is \code{\link{NULL}}, \emph{no reordering} will be done for
  the corresponding side.

  If \code{scale="row"} the rows are scaled to have mean
  zero and standard deviation one.  There is some empirical evidence
  from genomic plotting that this is useful.

  The default colors range from red to white (\code{heat.colors}) and
  are not pretty.  Consider using enhancements such
  as the \pkg{RColorBrewer} package, 
  \url{http://cran.r-project.org/src/contrib/PACKAGES.html#RColorBrewer}
  to select better colors.
  
}
\note{
  The original rows and columns are reordered \emph{in any case} to
  match the dendrogram, e.g., the rows by
  \code{\link{order.dendrogram}(Rowv)} where \code{Rowv} is the
  (possibly \code{\link{reorder}()}ed) row dendrogram.

  \code{heatmap.2()} uses \code{\link{layout}} and draws the
  \code{\link{image}} in the lower right corner of a 2x2 layout.
  Consequentially, it can \bold{not} be used in a multi column/row
  layout, i.e., when \code{\link{par}(mfrow= *)} or \code{(mfcol= *)}
  has been called.
}
\value{
  Invisibly, a list with components
  \item{rowInd}{\bold{r}ow index permutation vector as returned by
    \code{\link{order.dendrogram}}.}
  \item{colInd}{\bold{c}olumn index permutation vector.}
}
\author{Andy Liaw, original; R. Gentleman, M. Maechler, W. Huber, 
  G. Warnes, revisions.}

\seealso{\code{\link{image}}, \code{\link{hclust}}}

\examples{
 data(mtcars)
 x  <- as.matrix(mtcars)
 rc <- rainbow(nrow(x), start=0, end=.3)
 cc <- rainbow(ncol(x), start=0, end=.3)
 hv <- heatmap.2(x, col=cm.colors(256), scale="column", 
	       RowSideColors=rc, ColSideColors=cc, margin=c(5, 10), 
	       xlab="specification variables", ylab= "Car Models", 
	       main="heatmap(<Mtcars data>, ..., scale=\"column\")", 
               tracecol="green", density="density")

 str(hv) # the two re-ordering index vectors

%% want example using the `add.exp' argument!

 data(attitude)
 round(Ca <- cor(attitude), 2)
 symnum(Ca) # simple graphic

 # with reorder
 heatmap.2(Ca, 		 symm=TRUE, margin=c(6, 6), trace="none" )

 # without reorder
 heatmap.2(Ca, Rowv=FALSE, symm=TRUE, margin=c(6, 6), trace="none" )

 ## For variable clustering, rather use distance based on cor():
 data(USJudgeRatings)
 symnum( cU <- cor(USJudgeRatings) )

 hU <- heatmap.2(cU, Rowv=FALSE, symm=TRUE, col=topo.colors(16), 
              distfun=function(c) as.dist(1 - c), trace="none")

 ## The Correlation matrix with same reordering:
 hM <- format(round(cU[hU[[1]], hU[[2]]], 2))
 hM

 # now with the correlation matrix on the plot itself

 heatmap.2(cU, Rowv=FALSE, symm=TRUE, col=rev(heat.colors(16)), 
             distfun=function(c) as.dist(1 - c), trace="none", 
             cellnote=hM)

 ## genechip data examples
 \dontrun{
 library(affy)
 data(SpikeIn)
 pms <- SpikeIn@pm

 # just the data, scaled across rows
 heatmap.2(pms, col=rev(heat.colors(16)), main="SpikeIn@pm", 
              xlab="Relative Concentration", ylab="Probeset", 
              scale="row")

 # fold change vs "12.50" sample
 data <- pms / pms[, "12.50"]
 data <- ifelse(data>1, data, -1/data)
 heatmap.2(data, breaks=16, col=redgreen, tracecol="blue", 
               main="SpikeIn@pm Fold Changes\nrelative to 12.50 sample", 
               xlab="Relative Concentration", ylab="Probeset")
 }
}
\keyword{hplot}
