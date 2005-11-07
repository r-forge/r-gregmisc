####
## Figure 1
####
library(gplots)
library(datasets)

data(Titanic)

dframe <- as.data.frame(Titanic) # convert to 1 entry per row format

survived <- dframe[dframe$Survived=="No",]
attach(survived)

pdf("Figure1.pdf")

balloonplot(x=Class, y=list(Age, Sex), z=Freq,
            sort=TRUE, show.zeros=TRUE, cum.margins=FALSE,
            dotcol="white", show.margins=FALSE,
            main="BalloonPlot : Surviving passengers")

dev.off()

detach(survived)



####
## Figure 2
####
library(gplots)
library(datasets)

data(Titanic)

dframe <- as.data.frame(Titanic) # convert to 1 entry per row format

survived <- dframe[dframe$Survived=="No",]
attach(survived)

pdf("Figure2.pdf")

balloonplot(x=Class, y=list(Age, Sex), z=Freq,
            sort=TRUE, show.zeros=TRUE, cum.margins=FALSE,
            main="BalloonPlot : Surviving passengers")

dev.off()

detach(survived)




## colorize: surviors lightblue, non-survivors: grey
attach(dframe)
colors <- ifelse( Survived=="Yes", "green", "magenta")

pdf("Figure3.pdf")

balloonplot(x=Class,
            y=list(Survived,Age,Sex),
            z=Freq,
            zlab="Number of Passengers",
            dotcol = colors,
            show.zeros=TRUE,
            #show.margins=FALSE,
            cum.margins=FALSE
            )

dev.off()

detach(dframe)
