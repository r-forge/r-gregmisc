# $Id$
#
# $Log$
# Revision 1.1  2003/04/02 22:28:32  warnes
# - Added file 'capture.R' containing capture() and sprint().
#
#

capture <- function( expression, collapse="\n")
  {
    resultConn <- textConnection("resultText", open="w")
    sink(resultConn)
    on.exit( function() { sink(); close(resultConn) } )

    expression

    on.exit( NULL )
    sink()
    close(resultConn)

    return( paste( c(resultText, ""), collapse=collapse, sep="" ) )
    # the reason for c(result, "") is so that we get the line
    # terminator on the last line of output.  Otherwise, it just shows
    # up between the lines.
  }


sprint <- function(x)
  {
    capture(print(x))
  }
