library(SASxport)
Sys.setenv("TZ"="GMT")


cars <- read.table(file="cars.sas", skip=3, nrows=26,
                   col.names=c("MAKE","PRICE","MPG","REP78","FOREIGN"),
                   header=F)

head(cars, n=5)

summary(cars)

write.xport(cars,
            file="cars2.xpt",
            cDate=strptime("28JUL07: 20:59:49", format="%d%b%y:%H:%M:%S"),
            osType="SunOS",
            sasVer="9.1",
            autogen.formats=FALSE            
)


## Load both files back in as raw data
a.1 <- readBin( con="cars.xpt",  what=raw(), n=1e5)
a.2 <- readBin( con="cars2.xpt", what=raw(), n=1e5)

## Test that the files are identical
SASxport:::assert( all(a.1 == a.2) )
