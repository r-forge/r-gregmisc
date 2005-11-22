# matrix multiplication
# each worker works on a row of the result matrix
#
# entire matrix B is sent as a fixed argument and one row of
# matrix A is sent to worker for computing one row of the result matrix
#

src = function(...) {
    source('nws.R')
    source('sleigh.R')
}
tryCatch(library(nws), error=src)
s = sleigh()		# create a sleigh object with default options

cat('\n\n')
# enter row and column dimension (separate by space)
cat('Matrix A row and column size:', '\n')
A_dim<-scan("", n=2, quiet=TRUE)

# construct a matrix A of size given by the user input
A<-matrix(1:(A_dim[1]*A_dim[2]), A_dim[1], A_dim[2])
cat('Matrix B row and column size:', '\n')
B_dim<-scan("", n=2, quiet=TRUE)
B<-matrix(1:(B_dim[1]*B_dim[2]), B_dim[1], B_dim[2])

# TODO 
# simple error handling to check inner dimension are the same

cat('********** Matrix A ***********\n')
print(A)
cat('\n********** Matrix B ***********\n')
print(B)

# parse matrix A into n number of elements in a list. 
# n = # of rows in matrix A.
varArg=NULL
for (i in 1:A_dim[1])
  varArg=c(varArg, list(A[i,]))

elemList=list(varArg)
fixedArgs=list(B)

# send A as variable args, and send B as fixed arg
result=eachElem(s, function(x, y) {
	dim = dim(y)[2]
	row_result = NULL
	row = unlist(x)		# convert list x to vector, so we can do binary operator		
	row_len = length(row)
	row_matrix = matrix(row, 1, row_len)   	# convert vector to a 1xrow_len matrix

	# multiply each row of matrix A with one column of matrix B 
	for (i in 1:dim) {
	   row_result=c(row_result, sum(as.numeric(row*y[,i])));
	}
	row_result
    }, elementArgs=elemList, fixedArgs=fixedArgs)


# collapse list of results into a matrix
formatted_result = rbind(matrix(unlist(result), A_dim[1], B_dim[2], byrow=TRUE))

cat('\n*********** Result ************\n')
print(formatted_result)

stopSleigh(s)
