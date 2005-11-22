# print n number of hello world from workers

src = function(...) {
    source('nws.R')
    source('sleigh.R')
}
tryCatch(library(nws), error=src)
s = sleigh()
cat('\nType a positive number: \n');
index<-scan("", n=1, quiet=TRUE);

elemList=list(1:index)
greetings=eachElem(s, function(x) {
	paste("hello world", x, "from worker", SleighRank)}, elementArgs=elemList)

print(greetings)

cat('\n************* stop sleigh workers **************\n')
stopSleigh(s)
