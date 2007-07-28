`xport.file.header` <-
  function( cDate=Sys.time(), mDate=cDate, sasVer="7.00", osType="Unknown" )
  {
    .C("fill_file_header",
       cDate = xport.dateFMT(cDate),           # creation date
       mDate = xport.dateFMT(mDate),           # modification date
       sasVer = toupper(as.character(sasVer)), # SAS version number
       osType = toupper(as.character(osType)), # operating system
       PACKAGE="SASxport"
       )

    .Call("getRawBuffer", PACKAGE="SASxport")

  }

