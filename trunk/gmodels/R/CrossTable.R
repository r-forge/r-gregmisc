# $Id$
#
# $Log$
# Revision 1.1  2002/09/23 13:38:53  warnes
# - Added CrossTable() and barplot2() code and docs contributed by Marc Schwartz.
# - Permit combinations() to be used when r>n provided repeat.allowed=TRUE
# - Bumped up version number
#
#

CrossTable <- function (x, y, digits = 3, expected = FALSE, correct = TRUE)
{
  require(ctest)

#   Syntax <- paste("Syntax: CrossTable(x, y, digits = 3, expected = FALSE, correct = TRUE)",
#                   "x:        A vector in a matrix or a dataframe OR if y not specified, a two-dimensional matrix",
#                   "y:        A vector in a matrix or a dataframe.",
#                   "digits:   Number of digits after the decimal point for cell proportions",
#                   "expected: If TRUE, expected cell counts from the Chi^2 will be included.",
#                   "correct:  If TRUE, the Yates continuity correction will be applied in the Chi^2 test.", sep = "\n")
# 
#   # Do error checking
#   if (missing(x))
#     stop(Syntax)

  if (missing(y))
  {
    # if only x is specified, it must be a 2 dimensional matrix
    if (length(dim(x)) != 2)
      stop("x must be a 2 dimensional matrix if y is not given")
    if(any(dim(x) < 2))
      stop("x must have at least 2 rows and columns")
    if(any(x < 0) || any(is.na(x)))
      stop("all entries of x must be nonnegative and finite")
    else
      t <- x
  }
  else
  {
    if(length(x) != length(y))
      stop("x and y must have the same length")

    # Create Titles for Table From Vector Names
    RowData <- deparse(substitute(x))
    ColData <- deparse(substitute(y))

    # Remove unused factor levels from vectors
    x <- factor(x)
    y <- factor(y)

    if((nlevels(x) < 2) || (nlevels(y) < 2))
      stop("x and y must have at least 2 levels")

    # Generate table
    t <- table(x, y)
  }

  # Generate cell proportion of row
  CPR <- prop.table(t, 1)

  # Generate cell proportion of col
  CPC <- prop.table(t, 2)

  # Generate cell proportion of total
  CPT <- prop.table(t)

  # Generate summary counts
  GT <- sum(t)
  RS <- rowSums(t)
  CS <- colSums(t)

  # Column and Row Total Headings
  ColTotal <- "Column Total"
  RowTotal <- "Row Total"

  # Set consistent column widths based upon dimnames and table values
  CWidth <- max(digits + 2, c(nchar(t), nchar(dimnames(t)[[2]]), nchar(RS), nchar(CS), nchar(RowTotal)))
  RWidth <- max(c(nchar(dimnames(t)[[1]]), nchar(ColTotal)))

  # Adjust first column width if Data Titles present
  if (exists("RowData"))
    RWidth <- max(RWidth, nchar(RowData))

  # Create row separators
  RowSep <- paste(rep("-", CWidth + 2), collapse = "")
  RowSep1 <- paste(rep("-", RWidth + 1), collapse = "")
  SpaceSep1 <- paste(rep(" ", RWidth), collapse = "")
  SpaceSep2 <- paste(rep(" ", CWidth), collapse = "")

  # Create formatted Names
  FirstCol <- formatC(dimnames(t)[[1]], width = RWidth, format = "s")
  ColTotal <- formatC(ColTotal, width = RWidth, format = "s")
  RowTotal <- formatC(RowTotal, width = CWidth, format = "s")

  # Perform Chi-Square Test
  CST <- chisq.test(t, correct = correct)

  # Perform Fisher Tests
  FTt <- fisher.test(t, alternative = "two.sided")

  if (all(dim(t) == 2))
  {
    FTl <- fisher.test(t, alternative = "less")
    FTg <- fisher.test(t, alternative = "greater")
  }

  # Print Cell Layout

  cat(rep("\n", 2))
  cat("|-----------------|\n")
  cat("|               N |\n")
  if (expected)
    cat("|      Expected N |\n")
  cat("|   N / Row Total |\n")
  cat("|   N / Col Total |\n")
  cat("| N / Table Total |\n")
  cat("|-----------------|\n")
  cat(rep("\n", 2))
  cat("Total Observations in Table: ", GT, "\n")
  cat(rep("\n", 2))

  # Print Column headings

  if (exists("RowData"))
  {
    cat(SpaceSep1, "|", ColData, "\n")
    cat(formatC(RowData, width = RWidth, format = "s"), formatC(dimnames(t)[[2]], width = CWidth, format = "s"), RowTotal, sep = " | ", collapse = "\n")
  }
  else
    cat(SpaceSep1, formatC(dimnames(t)[[2]], width = CWidth, format = "s"), RowTotal, sep = " | ", collapse = "\n")

  cat(RowSep1, rep(RowSep, ncol(t) + 1), sep = "|", collapse = "\n")

  # Print table cells
  for (i in 1:nrow(t))
  {
    cat(FirstCol[i], formatC(c(t[i, ], RS[i]), width = CWidth), sep = " | ", collapse = "\n")

    if (expected)
      cat(SpaceSep1, formatC(CST$expected[i, ], digits = digits, format = "f", width = CWidth), SpaceSep2, sep = " | ", collapse = "\n")

    cat(SpaceSep1, formatC(c(CPR[i, ], RS[i] / GT), width = CWidth, digits = digits, format = "f"), sep = " | ", collapse = "\n")
    cat(SpaceSep1, formatC(CPC[i, ], width = CWidth, digits = digits, format = "f"), SpaceSep2, sep = " | ", collapse = "\n")
    cat(SpaceSep1, formatC(CPT[i, ], width = CWidth, digits = digits, format = "f"), SpaceSep2, sep = " | ", collapse = "\n")

    cat(RowSep1, rep(RowSep, ncol(t) + 1), sep = "|", collapse = "\n")
  }

  # Print Column Totals
  cat(ColTotal, formatC(c(CS, GT), width = CWidth), sep = " | ", collapse = "\n")
  cat(SpaceSep1, formatC(CS / GT, width = CWidth, digits = digits, format = "f"), SpaceSep2, sep = " | ", collapse = "\n")
  cat(RowSep1, rep(RowSep, ncol(t) + 1), sep = "|", collapse = "\n")

  # Print Statistics

  cat(rep("\n", 2))
  cat("Tests for Independence of All Table Factors\n\n\n")

  cat(CST$method,"\n\n")
  cat("Chi^2 = ", CST$statistic, "    d.f. = ", CST$parameter, "    p = ", CST$p.value, "\n")

  cat(rep("\n", 2))
  cat("Fisher's Exact Test for Count Data\n\n")

  if (all(dim(t) == 2))
  {
    cat("Sample estimate odds ratio: ", FTt$estimate, "\n\n")

    cat("Alternative hypothesis: true odds ratio is not equal to 1\n")
    cat("p = ", FTt$p.value, "\n")
    cat("95% confidence interval: ", FTt$conf.int, "\n\n")

    cat("Alternative hypothesis: true odds ratio is less than 1\n")
    cat("p = ", FTl$p.value, "\n")
    cat("95% confidence interval: ", FTl$conf.int, "\n\n")

    cat("Alternative hypothesis: true odds ratio is greater than 1\n")
    cat("p = ", FTg$p.value, "\n")
    cat("95% confidence interval: ", FTg$conf.int, "\n\n")
  }
  else
  {
    cat("Alternative hypothesis: two.sided\n")
    cat("p = ", FTt$p.value, "\n")
  }

  cat(rep("\n", 2))
}

