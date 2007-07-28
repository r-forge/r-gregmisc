`xport.member.header` <- 
function( dfName, cDate=Sys.time(), mDate=cDate, sasVer="7.00", osType="Unknown" )
  {
    .C("fill_member_header",
       dfName = toupper(as.character(dfName)), # Name of data set
       sasVer = toupper(as.character(sasVer)), # SAS version number
       osType = toupper(as.character(osType)), # Operating System
       cDate = xport.dateFMT(cDate),           # Creation date
       mDate = xport.dateFMT(mDate),           # modification date
       PACKAGE="SASxport"       
       )

    .Call("getRawBuffer", PACKAGE="SASxport")
  }

