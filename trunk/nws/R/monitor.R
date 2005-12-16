## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# example use:
# s <- sleigh()
#library(fork)
#fork(monitor(s))

makeNWS <- function(ws, host, port)
  {
    ## no nws information is provided, try to get sleigh information from
    ## environment
    if(missing(ws) || class(ws)=="character")
      {
        if(missing(ws))
          {
            wsname <- Sys.getenv( "RSleighNwsName")
            if (is.null(wsname) || wsname == '')
              {
                wsname <- "__default"
                warning("No RSleighNwsName environment variable set, using '__default'.")
              #stop('error: the RSleighNwsName environment variable must be set')
              }
          }
        else
          wsname <- ws

        if(missing(host))
          {
            host <-  Sys.getenv("RSleighNwsHost")
            if (is.null(host) || host == '')
              host <- 'localhost'
          }

        if(missing(port))
          {
            defport <- 8765
            tmpport <- Sys.getenv('RSleighNwsPort')
            if (is.null(tmpport) || tmpport == '') 
              port <- defport
            else 
              port <- tryCatch(as.integer(tmpport), warning=function(x) defport)
          }

      }
    ## sleigh object provided, extract the ws
    else if ( any(c("sleigh","sleighPending") %in% class(ws)) )
      {
        wsname <- ws@nws@wsName
        host <- ws@nws@server@serverHost
        port <- ws@nws@server@port
      }
    else if ( "netWorkSpace" %in% class(ws) )
      {
        wsname <- ws@wsName
        host <- ws@server@serverHost
        port <- ws@server@port
      }
    else
      stop("Invalid object for 'ws'")

    # show what we're doing
    cat("Creating a new netWorkSpace object...\n")
    cat("Host:", host, "\n")
    cat("Port:", port, "\n")
    cat("Name:", wsname, "\n")     
    
    # make a copy so we don't cause problems with the original
    
    ws <- new('netWorkSpace', wsname, host, as.numeric(port))
  }


forkMonitor <- function(ws, host, port)
  {
    ws <- makeNWS(ws=ws, host=host, port=port)
    Sys.putenv('RSleighNwsName'=ws@wsName)
    Sys.putenv('RSleighNwsHost'=ws@server@serverHost)
    Sys.putenv('RSleighNwsPort'=ws@server@port)

  system("echo 'library(nws); x11(); monitor();\n' | R --slave &")
  }

askMonitor <- function(ws, host, port, fork=FALSE)
  {
    ws <- makeNWS(ws=ws, host=host, port=port)
    wsList <- nwsListWss(ws@server)
    sleighFlag <- grep("^sleigh_ride", wsList$Name)
    wsList <- wsList[sleighFlag,1:6,drop=FALSE]
    rownames(wsList) <- 1:nrow(wsList)

    cat("Current Workspaces:\n")
    print(wsList, rownames=F)

    if(nrow(wsList)==0)
      stop("No sleighs are currently available")
    
    which <- select.list(wsList$Name, multiple=fork, preselect=1)

    if (fork)
      sapply(which, forkMonitor)
    else 
      monitor(which)
    
  }

monitor <- function(ws, host, port, mar=c(10.1,4.1,4.1,2.1),...)
  {

    ws <- makeNWS(ws=ws, host=host, port=port)
    oldpar <- par("mar")
    on.exit(par(oldpar))
    par(mar=mar)

    
    col <- c('red', 'orange', 'yellow', 'green', 'blue', 'purple', 'violet')

    nodeInfo <- workerInfo(ws)
    nodes <- rownames(nodeInfo)
    labels <- paste(nodeInfo[,"sysInfo.nodename"],
                    nodeInfo[,"pid"], sep=':')
    
    repeat {
      tasksDone <- c('Total'=0)
      for (node in nodes)
        {
          x <- nwsFindTry(ws, node)
          if (is.null(x)) {
            stop("Unable to retreive 'node'.  Has workspace been destroyed?")
          }
          tasksDone[node] <- as.integer(x)
        }
      tasksDone['Total'] <-  sum(tasksDone)

      tasksTotal <- nwsFindTry(ws, 'totalTasks')
      if (is.null(tasksTotal)) {
            stop("Unable to retreive 'totalTasks'.  Has workspace been destroyed?")
      }
      tasksTotal <- as.numeric(tasksTotal)
      ylim <- c(0, max(tasksTotal, tasksDone['Total'], 10)*1.1)

      tasksLeft <- c(
                     max(0,tasksTotal - tasksDone['Total']),
                     rep(0, length(tasksDone)-1)
                     )
      
      dispmat <- rbind( tasksDone, tasksLeft )
      
      mp <- barplot(
                    dispmat,
                    names.arg=c('Total',labels),
                    #names.arg=names(tasksDone),
                    main='R Sleigh Monitor',
                    ylab='Tasks Executed',
                    xlab='Hosts',
                    ylim=ylim,
                    col=c("green","red"),
                    legend.text=c("Completed","To Do"),
                    las=2,
                    ...
                    )

      text(as.character(tasksTotal), x=mp[1], y=tasksTotal, adj=c(0.5,0),
           col="red")

      text(as.character(tasksDone), x=mp, y=tasksDone, adj=c(0.5,0),
           col="darkgreen" )

      mtext(as.character(Sys.time()), side=3, x=par("usr")[2], adj=c(1,1))
      
      Sys.sleep(3)
    }
  }


workerInfo <- function(object, block=TRUE)
  {
    nodelist <- nwsFindTry(object, 'nodeList')
    if (is.null(nodelist)) {
      stop("Unable to retreive 'nodesList'.  Has workspace been destroyed?")
      }
    nodes <- unlist(strsplit(nodelist, " "))
    

    workerInfoList <- list()

    for(node in nodes)
      {
        if(block)
          tmp <- nwsFind(object, paste(node, 'info'))          
        else
          tmp <- nwsFindTry(object, paste(node, 'info'), "Unknown")
        if (is.null(nodelist)) {
          stop("Unable to retreive", paste(node, 'info'), ".  Has workspace been destroyed?")
        }
        workerInfoList[[node]] <- tmp
      }

    workerInfo <- do.call("rbind", lapply(workerInfoList, unlist))
    workerInfo
  }
