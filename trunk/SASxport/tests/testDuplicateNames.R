library(SASxport)
Sys.setenv("TZ"="GMT")

##tests
example(read.xport)

# Duplicate df names
write.xport("AA"=w$test,"Aa"=w$test,"aA"=w$test,"aa"=w$test, file="dn.a.xpt") #1.a
read.xport("dn.a.xpt")

# Duplicate column names
a = w$test
b = w$test
colnames(b) <- tolower(colnames(b))
write.xport("combined"=cbind(a, b), file="dn.b.xpt")
read.xport("dn.b.xpt")
