# $Log$
# Revision 1.5  2004/09/03 17:27:44  warneg
# initial bundle checkin
#

CrossTable <- function (x, y,
                        digits = 3,
                        max.width = 5,
                        expected = FALSE,
                        prop.r = TRUE,
                        prop.c = TRUE,
                        prop.t = TRUE,
                        chisq = FALSE,
                        fisher = FALSE,
                        mcnemar = FALSE)
{

  # Ensure that max.width >= 1
  if (max.width < 1)
    stop("max.width must be >= 1")
  # Set 'x' vector flag
  vector.x <- FALSE
  # Ensure that if (expected), a chisq is done
  if (expected)
    chisq <- TRUE

  if (missing(y))
  {
    # is x a vector?
    if (is.null(dim(x)))
    {
      # Remove any unused factor levels
      x <- factor(x)
      t <- t(as.matrix(table(x)))
      vector.x <- TRUE
    }
    # is x a matrix?
    else if (length(dim(x) == 2))
    {
      if(any(x < 0) || any(is.na(x)))
        stop("all entries of x must be nonnegative and finite")

      # Add generic dimnames if required
      # check each dimname separately, in case user has defined one or the other
      if (is.null(rownames(x)))
        rownames(x) <- paste("[", 1:nrow(x), ",]", sep = "")
      if (is.null(colnames(x)))
        colnames(x) <- paste("[,", 1:ncol(x), "]", sep = "")

      t <- x
    }
    else
      stop("x must be either a vector or a 2 dimensional matrix, if y is not given")
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

    # Generate table
    t <- table(x, y)
  }

  # if t is not at least a 2 x 2, do not do stats
  # even if any set to TRUE. Do not do col/table props
  if (any(dim(t) < 2))
  {
    prop.c <- prop.r <- chisq <- expected <- fisher <- mcnemar <- FALSE
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
  # Needs to be before the table output, in case (expected = TRUE)
  if (chisq)
  {
    if (all(dim(t) == 2))
      CSTc <- chisq.test(t, correct = TRUE)

    CST <- chisq.test(t, correct = FALSE)
  }

  # Default print function for n x m table
  print.CrossTable.default <- function()
  {
    # Print Column headings
    if (exists("RowData"))
    {
      cat(SpaceSep1, "|", ColData, "\n")
      cat(formatC(RowData, width = RWidth, format = "s"), formatC(dimnames(t)[[2]], width = CWidth, format = "s"),
          RowTotal, sep = " | ", collapse = "\n")
    }
    else
      cat(SpaceSep1, formatC(dimnames(t)[[2]], width = CWidth, format = "s"), RowTotal,
          sep = " | ", collapse = "\n")

    cat(RowSep1, rep(RowSep, ncol(t) + 1), sep = "|", collapse = "\n")

    # Print table cells
    for (i in 1:nrow(t))
    {
      cat(FirstCol[i], formatC(c(t[i, ], RS[i]), width = CWidth), sep = " | ", collapse = "\n")

      if (expected)
        cat(SpaceSep1, formatC(CST$expected[i, ], digits = digits, format = "f", width = CWidth), SpaceSep2,
            sep = " | ", collapse = "\n")

      if (prop.r)
        cat(SpaceSep1, formatC(c(CPR[i, ], RS[i] / GT), width = CWidth, digits = digits, format = "f"),
            sep = " | ", collapse = "\n")

      if (prop.c)
        cat(SpaceSep1, formatC(CPC[i, ], width = CWidth, digits = digits, format = "f"), SpaceSep2,
            sep = " | ", collapse = "\n")

      if (prop.t)
        cat(SpaceSep1, formatC(CPT[i, ], width = CWidth, digits = digits, format = "f"), SpaceSep2,
            sep = " | ", collapse = "\n")

      cat(RowSep1, rep(RowSep, ncol(t) + 1), sep = "|", collapse = "\n")
    }

    # Print Column Totals
    cat(ColTotal, formatC(c(CS, GT), width = CWidth), sep = " | ", collapse = "\n")

    if (prop.c)
      cat(SpaceSep1, formatC(CS / GT, width = CWidth, digits = digits, format = "f"), SpaceSep2,
          sep = " | ", collapse = "\n")

    cat(RowSep1, rep(RowSep, ncol(t) + 1), sep = "|", collapse = "\n")
  }

  # Print function for 1 x n vector
  print.CrossTable.vector <- function()
  {
    if (length(t) > max.width)
    {
      # set breakpoints for output based upon max.width
      final.row <- length(t) %% max.width
      max <- length(t) - final.row
      # Define breakpoint indices for each row
      start <- seq(1, max, max.width)
      end <- start + (max.width - 1)
      # Add final.row if required
      if (final.row > 0)
      {
         start <- c(start, end[length(end)] + 1)
         end <- c(end, end[length(end)] + final.row)
      }
    }
    else
    {
      # Each value printed horizontally in a single row
      start <- 1
      end <- length(t)
    }

    SpaceSep3 <- paste(SpaceSep2, " ", sep = "")

    for (i in 1:length(start))
    {
      # print column labels
      cat(SpaceSep2, formatC(dimnames(t)[[2]][start[i]:end[i]], width = CWidth, format = "s"),
          sep = " | ", collapse = "\n")

      cat(SpaceSep3, rep(RowSep, (end[i] - start[i]) + 1), sep = "|", collapse = "\n")
      cat(SpaceSep2, formatC(t[, start[i]:end[i]], width = CWidth), sep = " | ", collapse = "\n")
      cat(SpaceSep2, formatC(CPT[, start[i]:end[i]], width = CWidth, digits = digits, format = "f"),
          sep = " | ", collapse = "\n")
      cat(SpaceSep3, rep(RowSep, (end[i] - start[i]) + 1), sep = "|", collapse = "\n")
      cat("\n\n")
    }
  }

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

  if (!vector.x)
    print.CrossTable.default()
  else
    print.CrossTable.vector()

  # Print Statistics
  if (chisq)
  {
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

  CT <- list(t = t, prop.row = CPR, prop.col = CPC, prop.tbl = CPT)

  if (any(chisq, fisher, mcnemar))
  {
    if (all(dim(t) == 2))
    {
      if (chisq)
        CT <- c(CT, list(chisq = CST, chisq.corr = CSTc))

      if (fisher)
        CT <- c(CT, list(fisher.ts = FTt, fisher.tl = FTl, fisher.gt = FTg))

      if (mcnemar)
        CT <- c(CT, list(mcnemar = McN, mcnemar.corr = McNc))
    }
    else
    {
      if (chisq)
        CT <- c(CT, list(chisq = CST))

      if (fisher)
        CT <- c(CT, list(fisher.ts = FTt))

      if (mcnemar)
        CT <- c(CT, list(mcnemar = McN))
    }
  }

  # return list(CT)
  invisible(CT)
}

