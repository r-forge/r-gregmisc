library(SASxport)


##tests
example(read.xport)
write.xport(w$test,file="a.xpt")
lookup.xport("a.xpt")

b <- w$test
write.xport(b,file="a.xpt")
lookup.xport("a.xpt")

write.xport(test=w$test,file="a.xpt")
lookup.xport("a.xpt")

write.xport(test=w$test,z=w$z,file="a.xpt")
lookup.xport("a.xpt")

write.xport(w$test,w$z,file="a.xpt")
lookup.xport("a.xpt")

write.xport(w$test,z=w$z,file="a.xpt")
lookup.xport("a.xpt")

write.xport(list=w,file="a.xpt")
lookup.xport("a.xpt")

names(w) <- NULL
write.xport(w[[1]],w[[2]],file="a.xpt")
lookup.xport("a.xpt")

names(w) <- NULL
write.xport(list=w,file="a.xpt")
lookup.xport("a.xpt")

### Check that we catch invalid parameters
failure <- try( write.xport(5,"a.xpt") )
SASxport:::assert( "try-error" %in% class(failure) )

failure <- try( write.xport(list(a=5,b=6),"a.xpt") )
SASxport:::assert( "try-error" %in% class(failure) )


# Check with different list construction function *name*
example(read.xport)
write.xport(list=base::list(w$test,w$z),file="a.xpt")
lookup.xport("a.xpt")

# remove names
example(read.xport)
names(w) <- NULL
write.xport(list=w,file="a.xpt")
lookup.xport("a.xpt")

# remove variable names
example(read.xport)
colnames(w[[2]]) <- rep("", length=ncol(w[[2]]))
write.xport(list=w,file="a.xpt")
lookup.xport("a.xpt")
