##
## Code originally from Frank Harrell's 'Hmisc' library: 
##   http://biostat.mc.vanderbilt.edu/twiki/bin/view/Main/Hmisc
## Copied with permission on 2007-08-04
##

importConvertDateTime <- 
  function(x, type=c('date','time','datetime'),
           input=c('sas','spss','dataload'), form)
{
  type <- match.arg(type)
  input <- match.arg(input)

  if(input != 'sas' && type != 'date')
    stop('only date variables are support for spss, dataload')
		
 if(.R.) {
    adjdays <- c(sas=3653, spss=141428, dataload=135080)[input]
    ## 1970-1-1 minus 1960-1-1, 1582-10-14, or 1600-3-1
    if(input=='spss') x <- x/86400

    switch(type,
           date = structure(x - adjdays, class='Date'),
           time = {
             ## Don MacQueen 3Apr02
             z <- structure(x, class=c('POSIXt','POSIXct'))
             f <- format(z, tz='GMT')
             z <- as.POSIXct(format(z, tz='GMT'), tz='')
             structure(z, class=c('timePOSIXt','POSIXt','POSIXct'))
           },
           datetime = {
             chron((x - adjdays*86400)/86400,
                   out.format=c(dates='day mon year', times='h:m:s'))
           }
           )
  } else if(.SV4.) 
    switch(type,
           date     = timeDate(julian=x, format=form),
           time     = timeDate(ms=x*1000, format=form),
           datetime = timeDate(julian=x/86400, format=form))
  else
    switch(type,
           date = dates(x, out.format=form),
           time = chron(x/86400, out.format=form),
           datetime = chron(x/86400, out.format=form))
}
