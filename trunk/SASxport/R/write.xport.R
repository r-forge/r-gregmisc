write.xport <- function( ... ,
                        file="",
                        verbose=FALSE,
                        sasVer="7.00",
                        osType,
                        cDate=Sys.time()
                        ) 
  {
    dfList <- list(...)
    dfNames <- names(dfList)

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

      
    ## capture names of data frame, but don't clobber explicitly provided names
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
    dfNames[dfNames==""] <- mc[dfNames==""]
    names(dfList) <- dfNames    

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
        
        df <- dfList[[i]]
        varNames <- colnames(df)
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
        for(i in colnames(dfList[[i]]) )
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
