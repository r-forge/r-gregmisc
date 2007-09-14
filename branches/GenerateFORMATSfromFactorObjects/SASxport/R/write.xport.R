write.xport <- function(...,
                        list=base::list(),
                        file = stop("'file' must be specified"), 
                        verbose=FALSE,
                        sasVer="7.00",
                        osType,
                        cDate=Sys.time()
                        ) 
  {
    list <- c(base::list(...), list)
    dfNames <- names(list)

    if(missing(osType))
      osType <- paste("R ", R.version$major, ".", R.version$minor, sep="")

    oldDebug <- getOption("DEBUG")
    if(verbose)
      {
        options(DEBUG=TRUE)
      }
    else
      {
        options(DEBUG=FALSE)
      }
    on.exit( options(DEBUG=oldDebug) )

      
    ## capture names of data frames from function call, but don't
    ## clobber explicitly provided names 
    mc <- match.call()
    mc$file <- NULL
    mc$verbose <- NULL
    mc$sasVer <- NULL
    mc$osType <- NULL
    mc$cDate <- NULL
    mc[[1]] <- NULL
    
    mc <- as.character(mc)
    if(is.null(dfNames))
      {
        dfNames <- mc
      }
    if(length(dfNames) < length(list))
      {
        warning("Fewer names than datasets.  Creating default names.")
        dfNames[length(dfNames):length(list)] = "NONAME"
      }
    
    dfNames[dfNames==""] <- mc[dfNames==""]
    names(list) <- dfNames    


#    #######
#    ## If no file argument is found, check if there is a single string
#    ## argument.  If so, assume that it is the destation filename
#    if(missing(file))
#      {
#        string.arg <- which(sapply(list,is.character))
#        if(length(string.arg)==1)
#          {
#            file <- list[[string.arg]]
#            list[[string.arg]] <- NULL
#            dfNames <- dfNames[-string.arg]
#          }
#      }
#    ##
#    #######

    #######
    ##
    scat("Ensure all objects to be stored are data.frames...\n")
    not.df <- which(!sapply(list,is.data.frame))
    if(any(not.df))
      if(length(not.df)==1)
        stop(paste("'", dfNames[not.df], "'"),
             " is not a data.frame object.")
      else 
        stop(paste("'", dfNames[not.df], "'", sep="", collapse=", "),
             " are not data.frame objects.")
    ##
    #######


    #######
    ##
    scat("Check length of object names...\n")
    long.names <- which(nchar(dfNames)>8)
    if(length(long.names)>0)
      {
        old.names <- dfNames[long.names]
        new.names <- substr(old.names, 1, 8 )
        
        warning("Truncating object names with more than 8 characters. ",
                paste(long.names,
                      ":'",
                      old.names,
                      "' --> '",
                      new.names,
                      "'",
                      sep="",
                      collapse=", " ))
        
        dfNames[long.names] <- new.names
      }

    scat("Ensure object names are valid and unique...\n")
    dfNames <- substr(make.names(dfNames, unique=TRUE),1,8)
    if( all(names(list)!=dfNames))
      warning("Data frame names modified to obey SAS rules")
    names(list) <- dfNames

    
    
    scat("opening file ...")
    if (is.character(file)) 
      if (file == "") 
        file <- stdout()
      else {
        file <- file(description=file, open="wb")
        on.exit(close(file))
      }
    scat("Done")

    if(file==stdout())
      out <- function(...)
        {
          cat("ASCII: ", rawToDisplay(...), "")
          cat("HEX:   ", ..., "")
        }
    else
      out <- function(...) writeBin( ..., raw(), con=file)

    scat("Write file header ...")
    out( xport.file.header( cDate=cDate, sasVer=sasVer, osType=osType ) )
    scat("Done.")
    
    for(i in dfNames)
      {
        
        df <- list[[i]]

        if(is.null(colnames(df)))
           colnames(df) <- list(length=ncol(df))

        emptyFlag <- ( colnames(df)=="" | is.na(colnames(df)) )
        if(any(emptyFlag))
          {
            warning("Unnamed variables detected. Creating defalut variable names.")
            colnames(df)[emptyFlag] = "NONAME"
            list[[i]] <- df
          }

        varNames <- substr(make.names(colnames(df), unique=TRUE),1,8)
        if( any(colnames(df)!=varNames))
          {
            warning("Variable names modified to obey SAS rules")
            colnames(df) <- varNames
            list[[i]] <- df
          }

        offsetTable <- data.frame("name"=varNames, "len"=NA, "offset"=NA )
        rownames(offsetTable) <- offsetTable[,"name"]

        scat("Write data frame header ...")
        out( xport.member.header(dfName=i, cDate=cDate, sasVer=sasVer, osType=osType ) )
        scat("Done.")

        scat("Write variable informaton block header ...")
        out( xport.namestr.header( nvar=ncol(df) ) )
        scat("Done.")
        
        scat("Write entries for variable information block ...")
        lenIndex <- 0
        varIndex <- 1
        spaceUsed <- 0
        for(i in colnames(list[[i]]) )
          {
            scat("", i , "...")
            var <- df[[i]]

            # get attribute information before any transformations!"
            varLabel <- attr(var, "label")
            varFormat <- attr(var, "format")
            varIFormat <- attr(var, "iformat")

            # Convert R object to SAS object
            df[[i]] <- var <- toSAS(var)

            # compute variable length
            if(is.character(var))
              varLen <- max(8, max( nchar(var) ) )
            else
              varLen <- 8

            # fill in variable offset and length information
            offsetTable[i, "len"]    <- varLen
            offsetTable[i, "offset"] <- lenIndex


            

            # parse format and iformat
            formatInfo  <- parseFormat( varFormat)
            iFormatInfo <- parseFormat( varIFormat)
            
            
            
            # write the entry
            out(
                xport.namestr(
                              var=var,
                              varName=i,
                              varNum=varIndex,
                              varPos=lenIndex,
                              varLength=varLen,
                              varLabel=varLabel,        
                              fName = formatInfo$name,
                              fLength = formatInfo$len,
                              fDigits = formatInfo$digits,
                              iName = iFormatInfo$name,
                              iLength = iFormatInfo$len,
                              iDigits = iFormatInfo$digits,
                              )
                )

            # increment our counters
            lenIndex <- lenIndex + varLen
            varIndex <- varIndex + 1
            spaceUsed <- spaceUsed + 140
          }
        scat("Done.")

        # Space-fill to 80 character record end
        fillSize <- 80 - (spaceUsed %% 80)
        if(fillSize==80) fillSize <- 0        
        out( xport.fill( TRUE, fillSize ) ) 

        scat("Write header for data block ...")
        out( xport.obs.header() )
        scat("Done")

        scat("Write data ... ");
        spaceUsed <- 0
        for(i in 1:nrow(df) )
          for(j in 1:ncol(df) )
          {
            val <- df[i,j]
            valLen <- offsetTable[j,"len"]

            #scat("i=", i, " j=", j, " value=", val, " len=", valLen, "");

            if(is.character( val ))
              out(xport.character(val, width=valLen ) )
            else
              out( xport.numeric( val ) )

            spaceUsed <- spaceUsed + valLen
          }
        
        fillSize <- 80 - (spaceUsed %% 80)
        if(fillSize==80) fillSize <- 0
        out( xport.fill(TRUE, fillSize ) )
        
        scat("Done.")
      }

    scat("Closing file ...")
    if (is.character(file)) 
      if (file != "")
        {        
          close(file)
          on.exit()
        }
    scat("Done")

  }
