mixedsort <- function(x, decreasing=FALSE, na.last=TRUE, blank.last=FALSE)
    {
        ord <- mixedorder(x, decreasing=decreasing, na.last=na.last,
                             blank.last=blank.last)
        x[ord]
    }

mixedorder <- function(x,
                       decreasing=FALSE,
                       na.last=TRUE,
                       blank.last=FALSE,
                       type=c('inf',
                              'decimal',
                              'roman',
                              'character'),
                       roman.case=c("both", "lower", "upper"),
                       hex.case=c("both", "lower", "upper")
                       )
  {
    ## - Split each each character string into an vector of strings and
    ##   numbers
    ## - Separately rank numbers and strings
    ## - Combine orders so that strings follow numbers

    TOKEN.TYPES <- c('inf', 'decimal', 'roman', 'hexadecimal', 'octal', 'binary', 'character')
    type <- match.arg(type,
                      choices=TOKEN.TYPES,
                      several.ok=TRUE)

    tokens <- rep('', length=length(TOKEN.TYPES))
    names(tokens) <- TOKEN.TYPES
    tokens[which(TOKEN.TYPES %in% type)] <- chr(1:length(type))


    if(length(x)<1)
        return(NULL)
    else if(length(x)==1)
        return(1)

    if( !is.character(x) )
        return( order(x, decreasing=decreasing, na.last=na.last) )

    toDecimal <- function(x)
      {
        as.numeric(x)
      }

    toRoman <- function(x)
      {
        roman2int(x)
      }

    toString <- function(x)
      {
        ifelse( is.na(as.numeric(x)) || is.na(roman2int(x)), toupper(x), NA)
      }

    x <- as.character(x)

    which.nas <- which(is.na(x))
    which.blanks <- which(x=="")

    ####
    ## Insert delimters bracketing numeric and roman values
    ####

    regex <- list()

    ## numbers in the form of +1.23e+45.67
    regex$decimal <- "(?:(?i)(?:[-+]?)(?:(?=[.]?[0123456789])(?:[0123456789]*)(?:(?:[.])(?:[0123456789]{0,}))?)(?:(?:[eE])(?:(?:[-+]?)(?:[0123456789]+))|))"

    ## +-Inf
    regex$inf    <- "\\b([+-]*Inf)\\b"

    ## Roman numerals
    if(roman.case=="lower")
        regex$roman  <- "\\b([ivxcldm]+)\\b"
    else if(roman.case=="upper")
        regex$roman  <- "\\b([IVXCLDM]+)\\b"
    else if(roman.case=="both")
        regex$roman  <- "\\b([IVXCLDMivxcldm]+)\\b"
    else stop("invalid value for roman.case: ", roman.case)

    ## Hexadecimal
    if(hex.case=="lower")
        regex$hex    <- "\\b([0-9a-f]+)\\b"
    else if(hex.case=="upper")
        regex$hex    <- "\\b([0-9A-F]+)\\b"
    else if (hex.case=="both")
        regex$hex    <- "\\b([0-9A-Fa-f]+)\\b"
    else stop("invalid value for hex.case: ", hex.case)

    ## Octal
    regex$octal  <- "([0-8]+)"

    ## Binary numbers
    regex$binary <- "([01]+)"

    ## Character
    regex$character <- "[A-Za-z]+"

    ## Delimiters
    regex$delim    <- "[\001-\007]"
    regex$nondelim <- "[^\001-\007]+"

    matches <- list()

    ## tokenize...
    delimited <- x
    for( tt in TOKEN.TYPES )
        {
            if(tt %in% type)
                {
                    m <- gregexpr(regex[[tt]], delimited, perl=TRUE, ignore.case=FALSE)
                    matches[[tt]]  <- regmatches(delimited, m)
                    regmatches(delimited, m) <- tokens[tt]


                }
        }

    ## Remove all non-token characters
    delimited <- gsub( regex.nondelim, "", delimited)

    ntokens <- sapply(delimited, nchar)

    ## remove empty elements
    step1 <- lapply( step1, function(x) x[x>""] )

    ## create decimal version of data
    suppressWarnings( step1.decimal <-  lapply( step1, toDecimal ) )

    ## create non-numeric version of data
    suppressWarnings( step1.character <- lapply( step1, toString ) )

    ## now transpose so that 1st vector contains 1st element from each
    ## original string
    maxelem <- max(sapply(step1, length))

    step1.decimal.t <- lapply(1:maxelem,
                              function(i)
                                 sapply(step1.decimal,
                                        function(x)x[i])
                              )

    step1.character.t <- lapply(1:maxelem,
                              function(i)
                                 sapply(step1.character,
                                        function(x)x[i])
                              )

    ## now order them
    rank.decimal   <- sapply(step1.decimal.t, rank)
    rank.character <- sapply(step1.character.t,
                             function(x) as.numeric(factor(x)))

    ## and merge
    rank.decimal[!is.na(rank.character)] <- 0  # mask off string values

    rank.character <- t(
                        t(rank.character) +
                        apply(matrix(rank.decimal),2,max,na.rm=TRUE)
                        )

    rank.overall <- ifelse(is.na(rank.character),rank.decimal,rank.character)

    order.frame <- as.data.frame(rank.overall)
    if(length(which.nas) > 0)
        if(is.na(na.last))
            order.frame[which.nas,] <- NA
        else if(na.last)
            order.frame[which.nas,] <- Inf
        else
            order.frame[which.nas,] <- -Inf

    if(length(which.blanks) > 0)
        if(is.na(blank.last))
            order.frame[which.blanks,] <- NA
        else if(blank.last)
            order.frame[which.blanks,] <- 1e99
        else
            order.frame[which.blanks,] <- -1e99

    order.frame <- as.list(order.frame)
    order.frame$decreasing <- decreasing
    order.frame$na.last <- NA

    retval <- do.call("order", order.frame)

    return(retval)
  }
