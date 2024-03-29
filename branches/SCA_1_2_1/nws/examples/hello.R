src = function(...) { source('nws.R') }
tryCatch(library(nws), error=src)
host = 'localhost'
port = 8765
wsname = 'hello'

nws = new('netWorkSpace', wsname, host, port)

count = 10
cat('hello: iterations:', count, '\n')
nwsStore(nws, 'hello example', count)

for (i in 1:count) {
    nwsStore(nws, 'hello', i)
    j = nwsFetch(nws, 'hello')
}

nwsFetch(nws, 'hello example')
cat('Success\n')
