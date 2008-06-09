`print.SII` <-
function (x, digits = 2, ...) 
{
    print(unclass(round(x$sii, digits)))
}
