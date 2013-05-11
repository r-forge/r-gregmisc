library(SASxport)

## manually create a data set
abc.out <- data.frame( x=c(1, 2, NA, NA ), y=c('a', 'B', NA, '*' ) )

## add a data set label (not used by R)
label(abc.out) <- "data set"
SAStype(abc.out) <- "normal"

## add a format specifier (not used by R)
SASformat(abc.out$x) <- 'date7.'

## add a variable label (not used by R)
label(abc.out$y)  <- 'character variable'

# create a SAS XPORT file from our local data frame
write.xport(abc.out,
            file="xxx2.xpt",
            cDate=strptime("28JUL07:21:08:06 ", format="%d%b%y:%H:%M:%S"),
            osType="SunOS",
            sasVer="9.1",
            autogen.formats=FALSE
            )

# read the SAS data back in
abc.in <- read.xport("xxx2.xpt", names.tolower=FALSE)

## Test that the files are otherwise identical
label(abc.out, "missing!")
label(abc.in , "missing!")

SAStype(abc.out, "missing!")
SAStype(abc.in , "missing!")

stopifnot( label(abc.out)==label(abc.in, "missing!") )
stopifnot( SAStype(abc.out)==SAStype(abc.in, "missing!") )


