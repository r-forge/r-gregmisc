mixedorder <- function(x)
  {
    # - Split each each character string into an vector of strings and
    #   numbers 
    # - Separately rank numbers and strings
    # - Combine orders so that strings follow numbers


    numeric <- function(x)
      {
        optwarn = options("warn")
        on.exit( options(optwarn) )
        options(warn=-1)
        as.numeric(x)
      }

    nonnumeric <- function(x)
      {
        optwarn = options("warn")
        on.exit( options(optwarn) )
        options(warn=-1)

        ifelse(is.na(as.numeric(x)), x, NA)
      }

    
    x <- as.character(x)

    which.nas <- which(is.na(x))
    which.blanks <- which(x=="")

    x[ which.blanks ] <- -Inf
    x[ which.nas ] <- "\377"

    ####
    # - Convert each character string into an vector containing single
    #   character and  numeric values.
    ####
      
    # find and mark numbers in the form of +1.23e+45.67 
    delimited <- gsub("([+-]{0,1}[0-9\.]+([eE][\+\-]{0,1}[0-9\.]+){0,1})",
                      "$\\1$", x)

    # separate out numbers
    step1 <- strsplit(delimited, "\\$")

    # remove empty elements
    step1 <- sapply( step1, function(x) x[x>""] )

    # create numeric version of data
    step1.numeric <- sapply( step1, numeric )

    # create non-numeric version of data
    step1.character <- sapply( step1, nonnumeric )

    # now transpose so that 1st vector contains 1st element from each
    # original string
    maxelem <- max(sapply(step1, length))
    
    step1.numeric.t <- lapply(1:maxelem,
                              function(i)
                                 sapply(step1.numeric,
                                        function(x)x[i])
                              )
                            
    step1.character.t <- lapply(1:maxelem,
                              function(i)
                                 sapply(step1.character,
                                        function(x)x[i])
                              )
    
    # now order them
    rank.numeric   <- sapply(step1.numeric.t,rank)
    rank.character <- sapply(step1.character.t,
                             function(x) as.numeric(factor(x)))

    # and merge
    rank.numeric[!is.na(rank.character)] <- NA  # mask off string values
    rank.character <- t(t(rank.character) +
                        apply(rank.numeric,2,max,na.rm=T))
    rank.overall <- ifelse(is.na(rank.character),rank.numeric,rank.character)

    order <- do.call("order",as.data.frame(rank.overall))

    return(order)
  }

mixedsort <- function(x) x[mixedorder(x)]


#x <- rev(c("AA 0.50 ml", "AA 1.5 ml", "AA 500 ml", "AA 1500 ml",
#           "EXP 1", "AA 1e3 ml", "A A A", "1 2 3 A", "NA", NA, "1e2",
#           "", "-", "1A", "1 A", "100", "100A"))

#mixedorder(x)

#mixedsort(x)
