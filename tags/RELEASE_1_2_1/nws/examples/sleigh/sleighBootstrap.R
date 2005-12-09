# parallel bootstrapping

src = function(...) {
    source('nws.R')
    source('sleigh.R')
}
tryCatch(library(nws), error=src)
s = sleigh()
eachWorker(s, function() {
           f = paste(scriptDir, 'nuclearBootstrapInit.R', sep='/')
           source(f)
           set.seed(SleighRank)		# set seed for each worker
           })


# Divide tasks
R<-20000
partition<-200
chunk = R/partition
cat('\n\nTotal number of iterations for bootstrapping: ',R,'\n') 
cat('Each task consists of ', chunk, 'iterations of resampling\n\n')

# setup arguments for eachElem
elemList = list(rep(chunk, partition))
f <- function(y) {
	nuke.boot<-boot(nuke.data, nuke.fun, R=y, m=1, fit.pred=new.fit, x.pred=new.data)
	list(nuke.boot)
	}

elapsed_time<-system.time(
	result<-eachElem(s, f, elementArgs=elemList))[3]

cat("Elapsed time (sleigh bootstrap): ", elapsed_time, "\n\n")

# Control when monitor exits
cat('Press enter to exit\n')
c = scan("", n=1, quiet=TRUE) 
if (!is.null(c))  {
  # clean up
  cat("*************** clean up sleigh workers ***************\n")
  stopSleigh(s)
}
