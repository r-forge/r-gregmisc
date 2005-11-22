# matrix addition
# each worker works on one row at a time
# matrix A and B are passed to worker as fixed arguments

src = function(...) {
    source('nws.R')
    source('sleigh.R')
}
tryCatch(library(nws), error=src)
s = sleigh()

# Take user inputs for matrix A and B dimensions
cat('\n\n');
cat('Enter matrix A dimension: \n');
A_dim<-scan("", n=2, quiet=TRUE);
A<-matrix(1:(A_dim[1]*A_dim[2]), A_dim[1], A_dim[2])
cat('Enter matrix B dimension: \n')
B_dim<-scan("", n=2, quiet=TRUE)
B<-matrix(1:(B_dim[1]*B_dim[2]), B_dim[1], B_dim[2])


cat('********** Matrix A ***********\n')
print(A)
cat('\n********** Matrix B ***********\n')
print(B)


elementArguments = list(1:A_dim[1])
fixedArguments = list(A, B)
f = function(index, A, B) {A[index,] + B[index,]}

# each worker works one row at a time
result=eachElem(s, f, elementArguments, fixedArguments); 

# collapse list of results into a matrix
formatted_result = rbind(matrix(unlist(result), A_dim[1], A_dim[2], byrow=TRUE))
cat('\n*********** Result ************\n')
print(formatted_result);

stopSleigh(s)
