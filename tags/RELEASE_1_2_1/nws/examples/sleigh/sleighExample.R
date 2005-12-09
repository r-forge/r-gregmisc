src = function(...) {
    source('nws.R')
    source('sleigh.R')
}
tryCatch(library(nws), error=src)
s = sleigh()

# create workers on different machines
# s1 = sleigh(c('n5', 'n6', 'n7', 'n7'))

# add one to a list of 10 numbers
eachElem(s, function(x) {x+1}, list(1:10))

# add two numbers
add = function(x, y) {x+y}
elemList = list(1:10, 11:20)
eachElem(s, add, elementArgs=elemList)


# pass fixed argument to the function
sub = function(x, y, z) {x-y-z}
elemList = list(1:10, 11:20)
fixedArgs = list(1111)
eachElem(s, sub, elementArgs=elemList, fixedArgs=fixedArgs)

# permute the order of function parameters
eo = list(argPermute=c(3, 2, 1))
print = function(x, y, z) {paste(x, y, z)}
eachElem(s, print, elementArgs=elemList, fixedArgs=fixedArgs, eo=eo)
eachElem(s, sub, elementArgs=elemList, fixedArgs=fixedArgs, eo=eo)

# non-blocking eachElem
eo = list(blocking=0)
sleep = function(x) {Sys.sleep(x); x}
sp = eachElem(s, sleep, elementArgs=list(11:20), eo=eo)

# check for number of outstanding tasks
checkSleigh(sp)

# get results, if finished. Otherwise, wait for the results to finish
waitSleigh(sp)


# loadFactor
eo = list(loadFactor=2)
eachElem(s, sleep, elementArgs=list(1:20), eo=eo)


# stop sleigh
stopSleigh(s)




