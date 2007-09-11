##
## Code originally from Frank Harrell's 'Hmisc' library: 
##   http://biostat.mc.vanderbilt.edu/twiki/bin/view/Main/Hmisc
## Copied with permission on 2007-08-04
##

read.xport <- function(file,
                       force.integer=TRUE,
                       formats=NULL,
                       name.chars=NULL,
                       names.tolower=FALSE,
                       keep=NULL,
                       drop=NULL,
                       as.is=0.95, # Prevent factor conversion if 95% or more unique
                       verbose=FALSE,
                       as.list=FALSE
                       )
  {
    sasdateform <-
      toupper(c("date","mmddyy","yymmdd","ddmmyy","yyq","monyy",
                "julian","qtr","weekdate","weekdatx","weekday","month"))
    sastimeform     <- toupper(c("hhmm","hour","mmss","time"))
    sasdatetimeform <- toupper(c("datetime","tod"))

    if(verbose)
      {
        oldOptions <- options("DEBUG")
        options(DEBUG=TRUE)
        on.exit(options(oldOptions))
      }

    if(length(grep('http://', file))>0 || length(grep('ftp://', file))>0 )
      {
        scat("Downloading file...")        
        tf <- tempfile()
        download.file(file, tf, mode='wb', quiet=TRUE)
        file <- tf
      }

    scat("Checking if the specified file has the appropriate header")
    xport.file.header <- "HEADER RECORD*******LIBRARY HEADER RECORD!!!!!!!000000000000000000000000000000  "
    file.header <- readBin( file, what=character(0), n=1, size=nchar(xport.file.header) )
    file.header <- substr(file.header, start=1, stop=nchar(xport.file.header) )
    if( !identical(xport.file.header, file.header) )
      stop("The specified file does not start with a SAS xport file header!")
           
    scat("Extracting data file information...")
    dsinfo <- foreign:::lookup.xport(file)

    if(length(keep))
      whichds <- toupper(keep)
    else

      whichds <- setdiff(names(dsinfo), c(toupper(drop),'_CONTENTS_','_contents_'))

    scat("Reading the data file...")
    ds <- foreign:::read.xport(file)

    if(any(duplicated(names(dsinfo))))  # only true if file contains has more than one data set
       {
         warning("Duplicate data set names in file.  Data set names have been made unique.")
         names(dsinfo) <- make.unique(names(dsinfo))
         names(ds) <- make.unique(names(ds))
       }

    
    if( (length(keep)>0 || length(drop)>0) )
      ds <- ds[whichds]

    scat("Processing contents...")
    ## PROC FORMAT CNTLOUT= dataset present?
    fds <- NULL
    if(!length(formats)) {
      fds <- sapply(dsinfo, function(x)
                    all(c('FMTNAME','START','END','MIN','MAX','FUZZ')
                        %in% x$name))
      fds <- names(fds)[fds]
      if(length(fds) > 1) {
        warning('transport file contains more than one PROC FORMAT CNTLOUT= dataset; using only the first')
        fds <- fds[1]
      }
    }
  
    finfo <- NULL
    if(length(formats) || length(fds)) {
      if(length(formats))
        finfo <- formats
      else
        finfo <- ds[[fds]]

      ## Remove leading $ from char format names
      ##  fmtname <- sub('^\\$','',as.character(finfo$FMTNAME))
      fmtname <- as.character(finfo$FMTNAME)
      finfo <- split(finfo[c('START','END','LABEL')], fmtname)
      finfo <- lapply(finfo,
                      function(f)
                      {
                        rb <- function(a)
                        {  # remove leading + trailing blanks
                          a <- sub('[[:space:]]+$', '', as.character(a))
                          sub('^[[:space:]]+', '', a)
                        }

                        st <- rb(f$START)
                        en <- rb(f$END)
                        lab <- rb(f$LABEL)
                        ##j <- is.na(st) | is.na(en)
                        ##  st %in% c('','.','NA') | en %in% c('','.','NA')
                        j <- is.na(st) | is.na(en) | st == '' | en == ''
                        if(any(j)) {
                          warning('NA in code in FORMAT definition; removed')
                          st <- st[!j]; en <- en[!j]; lab <- lab[!j]
                        }

                        if(!all(st==en))
                          return(NULL)

                        list(value = all.is.numeric(st, 'vector'),
                             label = lab)
                      })
    }

    ## Number of non-format datasets
    nods <- length(whichds)
    nds  <- nods - (length(formats) == 0 && length(finfo) > 0)
    which.regular <- setdiff(whichds, fds)
    dsn <- tolower(which.regular)


    ## Handle lowercase name conversions
    if(names.tolower)
      names.tolower <- tolower
    else
      names.tolower <- function(x) x
    
    res <- vector('list', nds)
    names(res) <- gsub('_','.',dsn)


    possiblyConvertChar <- (is.logical(as.is) && !as.is) ||
    (is.numeric(as.is) && as.is > 0)
    j <- 0
    for(k in which.regular) {
      j   <- j + 1
      scat('Processing SAS dataset', k)
      w   <-
        if(nods==1)
          ds
        else ds[[k]]

      scat('.')
      
      if(!length(w)) {
        scat('Empty dataset', k, 'ignored\n')
        next
      }

      nam      <- names.tolower(makeNames(names(w), allow=name.chars))
      names(w) <- nam
      dinfo    <- dsinfo[[k]]
      fmt      <- sub('^\\$','',dinfo$format)
      lab      <- dinfo$label
      ndinfo   <- names.tolower(makeNames(dinfo$name, allow=name.chars))
      names(lab) <- names(fmt) <- ndinfo
      for(i in 1:length(w)) {
        changed <- FALSE
        x  <- w[[i]]
        fi <- fmt[nam[i]]; names(fi) <- NULL
        if(fi != '' && length(finfo) && (fi %in% names(finfo))) {
          f <- finfo[[fi]]
          if(length(f)) {  ## may be NULL because had a range in format
            x <- factor(x, f$value, f$label)
            attr(x, 'format') <- fi
            changed <- TRUE
          }
        }

        if(is.numeric(x)) {
          if(fi %in% sasdateform) {
            x <- importConvertDateTime(x, 'date', 'sas')
            changed <- TRUE
          } else if(fi %in% sastimeform) {
            x <- importConvertDateTime(x, 'time', 'sas')
            changed <- TRUE
          } else if(fi %in% sasdatetimeform) {
            x <- importConvertDateTime(x, 'datetime', 'sas')
            changed <- TRUE
          } else if(force.integer) {
            if(all(is.na(x))) {
              storage.mode(x) <- 'integer'
              changed <- TRUE
            } else if(max(abs(x),na.rm=TRUE) <= (2^31-1) &&
                      all(floor(x) == x, na.rm=TRUE)) {
              storage.mode(x) <- 'integer'
              changed <- TRUE
            }
          }
        } else if(possiblyConvertChar && is.character(x)) {
          if((is.logical(as.is) && !as.is) || 
             (is.numeric(as.is) && length(unique(x)) < as.is*length(x))) {
            x <- factor(x, exclude='')
            changed <- TRUE
          }
        }

        lz <- lab[nam[i]]
        if(!is.null(lz) && length(lz)>0 && !is.na(lz) && lz != '') {
          names(lz) <- NULL
          label(x)  <- lz
          changed   <- TRUE
        }

        fmt <- fmt[nam[i]]; 
        if( !is.null(fmt) && length(fmt)>0 && !is.na(fmt) && fmt > '') {
          names(fmt) <- NULL
          formats(x) <- fmt
          changed <- TRUE
        }
        
        if(changed)
          w[[i]] <- x
      }

      scat('.')

      res[[j]] <- w
    }

    scat("Done")
    
    if(nds > 1 || as.list)
      res
    else
      w
  }
