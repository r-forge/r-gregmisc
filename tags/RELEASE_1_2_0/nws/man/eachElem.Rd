\name{eachElem}
\alias{eachElem}
\alias{eachElem,sleigh-method}
\title{Apply a given function with arguments supplied to workers}
\description{
Evaluate the given function with multiple argument sets using the workers in sleigh.
}

\usage{
eachElem(.Object, fun, elementArgs=list(), fixedArgs=list(), eo=NULL)
}

\arguments{
\item{.Object}{a sleigh object}
\item{fun}{function to be evaluated by workers}
\item{elementArgs}{variable arguments}
\item{fixedArgs}{fixed arguments}
\item{eo}{optional arguments, see details}
}

\details{
All vector lengths in elementArgs has to be equal. \cr
For example, \cr
	eachElem(s, function(a, b, c) \{a+b+c\}, elementArgs=list(1:5, 11:15, 21:25))

This invocation of eachElem add five tasks into the sleigh workspace. 
Each task consists of one value from 1:5, one value from 11:15, and one value
from 21:25. Values are paired up based on their indices in the vector. For example,
first pair would be (1, 11, 21), second pair would be (2, 12, 22), and so on. 
When a sleigh worker grabs a task from the workspace, he will evaluate the function fun
with the supplied value mapping to three arguments, a, b, and c.


fixedArgs can be used to pass fixed values to the function. \cr
For example,\cr
	eachElem(s, function(a, b, c) \{a+b+c\}, elementArgs=list(1:5, 11:15), fixedArgs=list(1111))\cr
This invocation of eachElem also adds five tasks to the workspace. This time instead of having varying
value for the third argument, we have fixed value for the third argument. \cr
The ordering of arguments is variable arguments first and then followed by fixed arguments. \cr
If user wants to change such ordering, see optional argument, eo for more details. \cr


eo in eachElem argument can have these fields: argPermute, blocking, and loadFactor.

{\bf argPermute:} a vector of integers used to represent the ordering of arguments. \cr
For example: \cr
   eo = list(argPermute=c(3, 2, 1))\cr
   elemList=list(1:5, 11:15)\cr
   fixedArgs=list(1111)\cr
   reordering = function(x, y, z) \{paste(`(x, y, z) =', x, y, z)\}\cr
   eachElem(s, reordering, elementArgs=elementList, fixedArgs=fixedArgs, eo=eo)

   The original argument pairs without permute argument are (1, 11, 1111), (2, 12, 1111), 
   (3, 13, 1111), (4, 14, 1111), and (5, 15, 1111).
   With permute argument, the pairs would become (1111, 11, 1), (1111, 12, 2), (1111, 13, 3), 
   (1111, 14, 4), and (1111, 15, 5)


{\bf blocking:} set blocking mode to 0 or 1. 
   By default, blocking mode is set to 1, which means eachElem does not return until all tasks
   are finished. If blocking mode is 0, then eachElem returns immediately with a SleighPending 
   object. Users can then use this object to invoke checkSleigh to check how many outstanding
   tasks, or invoke waitSleigh to wait for results. See eachWorker documentation for example 
   on how to set blocking mode. 


{\bf loadFactor:} to restrict the number of tasks put out to the workspace.\cr
   The number of tasks in workspace has to be less than or equal to loadFactor multiply by the number of sleigh workers.
}

\examples{
\dontrun{
# simple hello world
s = sleigh()
hello = function(x) {paste("hello world", x, "from worker", SleighRank)}
eachElem(s, hello, list(1:10))


# matrix addition
A<-matrix(1:6, 3, 3)
B<-matrix(1:6, 3, 3)
elemList = list(1:3)
fixedArgs = list(A, B)
mat_add = function(index, A, B) {
   row = A[index,]+B[index,]
   list(row)
}

result=eachElem(s, mat_add, elementArgs=elemList, fixedArgs=fixedArgs)
print(result)

# clean up sleigh
stopSleigh(s)	
}
}
\keyword{methods}
\keyword{programming}
