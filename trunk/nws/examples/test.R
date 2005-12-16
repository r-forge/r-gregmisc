library(gtools)

## Add the path where the nws library is installed
#.libPaths("/grid/gro/vol/ncstat/warneg/src/R/nws/Rlib")
#Sys.putenv("R_LIB"=paste(.libPaths(),collapse=':'))
library(nws)

## data
x.df <- data.frame(x=1:10,z=11:20)
x    <- cbind(x=1:10, z=11:20)
rowsum <- rowSums(x.df)
colsum <- colSums(x.df)

## Start the sliegh

sparcOnlyLSFcmd <- 
function (user, host, options) 
{
    'bsub -R "gro_sparc" -L /bin/tcsh'
}

anyLSFcmd <-
function (user, host, options) 
{
    'bsub -R "gro_intel || gro_sparc" -L /bin/tcsh'
}

newLSFcmd <-
function (user, host, options) 
{
    'bsub -R "gro_intel_new || gro_sparc" -L /bin/tcsh'
}

gLSFcmd <-
function (user, host, options) 
{
    'bsub -m "gsunk865g" -L /bin/tcsh'
}


Sys.putenv(DEBUG=1)
s <- sleigh(launch=newLSFcmd, nodeList=as.character(1:20))
#s <- sleigh()
#forkMonitor(s)


####
## eachWorker tests
####

# make sure single character values come back right
assert(
       sapply(
              print(
                    eachWorker(s,
                               function(...) system("hostname",intern=TRUE))
                    )
              ,
              class
             )
       ==
       "character"
       )

# make sure single numeric values come back right
assert(
       sapply(
              print(eachWorker(s, function(n) runif(1), n=1 ))
              ,
              class
              )
       ==
       "numeric"
       )

## Make sure we get unique random numbers!!!
assert(
       !duplicated(
                  eachWorker(s, function(n) runif(1), n=1 )
                  )
       )


# check the handling of arguments
eachElem(s,
         function(...) match.call(),
         elementArgs=list(x=1:10,z=11:20),
         fixedArgs=list(y=1)
         )

# check chunking 
eachElem(s,
         function(...) match.call(),
         elementArgs=list(x=1:10,z=11:20),
         fixedArgs=list(y=1),
         chunkSize=2
         )

assert(
       eachElem(s, sum, elementArgs=list(x=1:10,z=11:20),
                fixedArgs=list(y=1), chunkSize=1 )
       ==
       rowsum  + 1
       )

assert(
       eachElem(s, sum, elementArgs=list(x=1:10,z=11:20),
                fixedArgs=list(y=1), chunkSize=3 )
       ==
       rowsum+1
       )

####
## Check handling of matrices
####

## by element
assert(
       print(eachElem(s,
               sum,
               elementArgs=list(x=x),
               fixedArgs=list(y=1),
               by="cell",
               chunkSize=1 ))
       ==
       2:21
       )

## by row
assert(
       eachElem(s,
               sum,
               elementArgs=list(x=x),
               fixedArgs=list(y=1),
               by="row",
               chunkSize=1 )
       ==
       rowsum+1
       )

## in chunks
assert(
       eachElem(s,
                sum,
                elementArgs=list(x),
                fixedArgs=list(y=1),
                chunkSize=7
                )
       ==
       rowsum+1
       )

## by column
assert(
       eachElem(s,
                sum,
                elementArgs=list(x),
                fixedArgs=list(y=1),
                chunkSize=7,
                by="col"
                )
       ==
       colsum+1
       )

####
## Check handling of data frames
####

## by element
assert(
       print(eachElem(s,
               sum,
               elementArgs=list(x=x.df),
               fixedArgs=list(y=1),
               by="cell",
               chunkSize=1 ))
       ==
       2:21
       )

## by row
assert(
       eachElem(s,
               sum,
               elementArgs=list(x=x.df),
               fixedArgs=list(y=1),
               by="row",
               chunkSize=1 )
       ==
       rowsum+1
       )

## in chunks
assert(
       eachElem(s,
                sum,
                elementArgs=list(x.df),
                fixedArgs=list(y=1),
                chunkSize=7
                )
       ==
       rowsum+1
       )

## by column
assert(
       eachElem(s,
                sum,
                elementArgs=list(x.df),
                fixedArgs=list(y=1),
                chunkSize=7,
                by="col"
                )
       ==
       colsum+1
       )

########

bigx <- matrix(rnorm(1e6),ncol=10)

t.eachElem <- unix.time(
                        val.eachElem <- eachElem(s,
                                                 sum,
                                                 elementArgs=list(x=bigx),
                                                 fixedArgs=list(y=1),
                                                 chunkSize=100
                                                 )
                        )


t.apply <- unix.time(
                     val.apply <- apply(bigx, 1, sum) + 1
                     )


assert(
       all.equal(
                  as.numeric(val.eachElem)
                  ,
                  val.apply )
       )


sp <- eachElem(s, sum, elementArgs=list(x=bigx),
               fixedArgs=list(y=1), chunkSize=100,
               eo=list(blocking=FALSE ))

val.sp <- waitSleigh(sp)


assert(
       all.equal(
                  val.eachElem
                  ,
                  val.sp
                 )
       )


slowdown <- t.eachElem[3] / t.apply[3]  #Ha! ~30x slower!
cat("Slowdown: ", round(slowdown,1), " fold\n")

###
## Test something more complicated
##

bigy <- 0.124 + 2.75 * bigx  + rnorm(nrow(bigx)*ncol(bigx), sd=0.25)

f <- function(x,y)
  {
    cf <- coef(summary(lm( y~x )))
    c(est=cf[,1],
      pval=cf[,4])
  }

# test the function
f(x=bigx[1,],y=bigy[1,])


t.eachElem <- unix.time(
                        big.eachElem <- eachElem(s,
                                                 f,
                                                 elementArgs=list(x=bigx,
                                                   y=bigy),
                                                 chunkSize=100
                                                 )

                        )

## This will yield a different answer because apply can only iterate over
## a single matrix, but the timings should be comparable
t.apply <- unix.time(
                     apply( bigx, 1, f, y=bigy[1,])
                     )


speedup <- t.apply[3] / t.eachElem[3]
cat("Speedup: ", round(speedup,1), " fold\n")


close(s)
