
# transform base
#
# This function rewrites regular integer numbers as an array of its digits.
# The base of the numbering scheme may be changed away from 10,
# which defines our decimal system, to any other integer value. For
# b=2, the number is returned in the dual system. The least significant
# digit has the highest index in the array, i.e. it appears on the right.
#
#   v = value of base 10 to be transformed
#   b = new base
#   l = minimal length of returned array (default is 1)
# return value: array of factors, highest exponent first
baseOf<-function(v,b=10,l=1) {
	remainder<-v
	i<-l
	ret<-NULL
	while(remainder>0 || i>0) {
		#print(paste("i=",i," remainder=",remainder))
		m<-remainder%%b
		if (is.null(ret)) {
			ret<-m
		}
		else {
			ret<-c(m,ret)
		}
		remainder <- remainder %/% b
		i<-i-1
	}
	return(ret)
}
                                   
