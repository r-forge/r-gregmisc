src = function(...) { source('nws.R') }
tryCatch(library(nws), error=src)
host = 'localhost'
port = 8765
wsname = 'ping-pong'

nws = new('netWorkSpace', wsname, host, port)

nwsStore(nws, 'game', 0)

cat('Ping-pong server ', wsname, ' starting\n')
while (TRUE) {
    pong = nwsFetch(nws, 'ping')
    cat('Got a ping from ', pong, '\n')
    nwsStore(nws, pong, 'pong')
}
