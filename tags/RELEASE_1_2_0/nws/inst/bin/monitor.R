##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##

src = function(...) { source('nws.R') }
tryCatch(library(nws), error=src)

wsname = Sys.getenv('RSLEIGHWS')
if (wsname == '') {
    stop('error: the RSLEIGHWS environment variable must be set')
}

hostname = Sys.getenv('NWSHOSTNAME')
if (hostname == '') {
    hostname = 'localhost'
}

defport = 8765
tmpport = Sys.getenv('NWSPORT')
if (tmpport == '') {
    port = defport
} else {
    port = tryCatch(as.integer(tmpport), warning = function(x) defport)
}

ws = new('netWorkSpace', wsname, hostname, port)

x11()
# On the Mac use:
#quartz()

col = c('red', 'orange', 'yellow', 'green', 'blue', 'purple', 'violet')

repeat {
    nodelist = nwsFind(ws, 'nodeList')
    if (is.null(nodelist)) {
        stop('workspace has been destroyed')
    }
    nodes = unlist(strsplit(nodelist, " "))

    tasks = c(0)
    labels = c('Total')

    for (i in 1:length(nodes)) {
        x = nwsFind(ws, nodes[i])
        if (is.null(nodelist)) {
            stop('workspace has been destroyed')
        }
        tasks[i + 1] = as.integer(x)
        labels[i + 1] = nodes[i]
    }

    tasks[1] = sum(tasks)

    total = nwsFind(ws, 'totalTasks')
    if (is.null(nodelist)) {
        stop('workspace has been destroyed')
    }
    totalTasks = as.integer(total)
    ylim = c(0, max(totalTasks, 1))

    barplot(tasks, names.arg=labels, main='R Sleigh Monitor',
            ylab='Tasks Executed', xlab='Hosts', ylim=ylim,
            legend.text=as.character(tasks), col=col)

    Sys.sleep(3)
}
