# $Log$
# Revision 1.3  2003/01/30 21:41:35  warnes
# - Removed argument 'correct' and now print separate corrected values
#   for 2 x 2 tables.
# - Added arguments 'prop.r', 'prop.c' and 'prop.t' to toggle printing
#   of row, col and table percentages. Default is TRUE.
# - Added argument 'fisher' to toggle fisher exact test. Default is
#   FALSE.
# - Added McNemar test to statistics and argument 'mcnemar' to toggle
#   test. Default is FALSE.
# - Added code to generate an invisible return list containing table
#   counts, proportions and the results of the appropriate statistical tests.
#
# Revision 1.3  2003/01/26
# Updates from Marc Schwartz:
#
# - Removed argument 'correct' and now print separate corrected values for 2 x 2 tables.
# - Added arguments 'prop.r', 'prop.c' and 'prop.t' to toggle printing of row, col
#   and table percentages. Default is TRUE.
# - Added argument 'fisher' to toggle fisher exact test. Default is FALSE.
# - Added McNemar test to statistics and argument 'mcnemar' to toggle test.
#   Default is FALSE.
# - Added code to generate an invisible return list containing table counts, proportions
#   and the results of the appropriate statistical tests.
#
#
# $Log$
# Revision 1.3  2003/01/30 21:41:35  warnes
# - Removed argument 'correct' and now print separate corrected values
#   for 2 x 2 tables.
# - Added arguments 'prop.r', 'prop.c' and 'prop.t' to toggle printing
#   of row, col and table percentages. Default is TRUE.
# - Added argument 'fisher' to toggle fisher exact test. Default is
#   FALSE.
# - Added McNemar test to statistics and argument 'mcnemar' to toggle
#   test. Default is FALSE.
# - Added code to generate an invisible return list containing table
#   counts, proportions and the results of the appropriate statistical tests.
#
# Revision 1.2  2002/11/04 14:13:57  warnes
#
# - Moved fisher.test() to after table is printed, so that table is
#   still printed in the event that fisher.test() results in errors.
# ------------------------------------------------------------------------
#


CrossTable <- function (x, y,
                        digits = 3,
                        expected = FALSE,
                        prop.r = TRUE,
                        prop.c = TRUE,
                        prop.t = TRUE,
                        fisher = FALSE,
                        mcnemar = FALSE)
{
  # require(ctest)  # included in base and loaded automatically

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

  # Perform Chi-Square Tests
  if (all(dim(t) == 2))
    CSTc <- chisq.test(t, correct = TRUE)

  CST <- chisq.test(t, correct = FALSE)


  # Print Cell Layout

  cat(rep("\n", 2))
  cat("   Cell Contents\n")

  cat("|-----------------|\n")
  cat("|               N |\n")
  if (expected)
    cat("|      Expected N |\n")
  if (prop.r)
    cat("|   N / Row Total |\n")
  if (prop.c)
    cat("|   N / Col Total |\n")
  if (prop.t)
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

    if (prop.r)
      cat(SpaceSep1, formatC(c(CPR[i, ], RS[i] / GT), width = CWidth, digits = digits, format = "f"), sep = " | ", collapse = "\n")
    if (prop.c)
      cat(SpaceSep1, formatC(CPC[i, ], width = CWidth, digits = digits, format = "f"), SpaceSep2, sep = " | ", collapse = "\n")
    if (prop.t)
      cat(SpaceSep1, formatC(CPT[i, ], width = CWidth, digits = digits, format = "f"), SpaceSep2, sep = " | ", collapse = "\n")

    cat(RowSep1, rep(RowSep, ncol(t) + 1), sep = "|", collapse = "\n")
  }

  # Print Column Totals
  cat(ColTotal, formatC(c(CS, GT), width = CWidth), sep = " | ", collapse = "\n")
  if (prop.c)
    cat(SpaceSep1, formatC(CS / GT, width = CWidth, digits = digits, format = "f"), SpaceSep2, sep = " | ", collapse = "\n")
  cat(RowSep1, rep(RowSep, ncol(t) + 1), sep = "|", collapse = "\n")

  # Print Statistics

  cat(rep("\n", 2))
  cat("Statistics for All Table Factors\n\n\n")

  cat(CST$method,"\n")
  cat("------------------------------------------------------------\n")
  cat("Chi^2 = ", CST$statistic, "    d.f. = ", CST$parameter, "    p = ", CST$p.value, "\n\n")

  if (all(dim(t) == 2))
  {
    cat(CSTc$method,"\n")
    cat("------------------------------------------------------------\n")
    cat("Chi^2 = ", CSTc$statistic, "    d.f. = ", CSTc$parameter, "    p = ", CSTc$p.value, "\n")
  }

  # Perform McNemar tests
  if (mcnemar)
  {
    McN <- mcnemar.test(t, correct = FALSE)
    cat(rep("\n", 2))
    cat(McN$method,"\n")
    cat("------------------------------------------------------------\n")
    cat("Chi^2 = ", McN$statistic, "    d.f. = ", McN$parameter, "    p = ", McN$p.value, "\n\n")

    if (all(dim(t) == 2))
    {
      McNc <- mcnemar.test(t, correct = TRUE)
      cat(McNc$method,"\n")
      cat("------------------------------------------------------------\n")
      cat("Chi^2 = ", McNc$statistic, "    d.f. = ", McNc$parameter, "    p = ", McNc$p.value, "\n")
    }
  }


  # Perform Fisher Tests
  if (fisher)
  {
    cat(rep("\n", 2))
    FTt <- fisher.test(t, alternative = "two.sided")

    if (all(dim(t) == 2))
    {
      FTl <- fisher.test(t, alternative = "less")
      FTg <- fisher.test(t, alternative = "greater")
    }

    cat("Fisher's Exact Test for Count Data\n")
    cat("------------------------------------------------------------\n")

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
  }

  cat(rep("\n", 2))

  # Create list of results for invisible()

  if (all(dim(t) == 2))
  {
    CT <- list(t, CPR, CPC, CPT, CST, CSTc)
    Tnames <- c("t", "prop.col", "prop.row", "prop.tbl", "chisq", "chisq.corr")

    if (fisher)
    {
      CT <- c(CT, list(FTt, FTl, FTg))
      Tnames <- c(Tnames, "fisher.ts", "fisher.lt", "fisher.gt")
    }

    if (mcnemar)
    {
      CT <- c(CT, list(McN, McNc))
      Tnames <- c(Tnames, "mcnemar", "mcnemar.corr")
    }
  }
  else
  {
    CT <- list(t, CPR, CPC, CPT, CST)
    Tnames <- c("t", "prop.col", "prop.row", "prop.tbl", "chisq")

    if (fisher)
    {
      CT <- c(CT, list(FTt))
      Tnames <- c(Tnames, "fisher.ts")
    }

    if (mcnemar)
    {
      CT <- c(CT, list(McN))
      Tnames <- c(Tnames, "mcnemar")
    }
  }

  # Set names for CT
  names(CT) <- Tnames

  # return list(CT)
  invisible(CT)
}

