# $Id$
#
# $Log$
# Revision 1.3  2003/11/10 22:11:13  warnes
# - Add files contributed by Arni Magnusson
#   <arnima@u.washington.edu>. As well as some of my own.
#
# Revision 1.2  2003/04/04 13:45:21  warnes
#
# - Allow optional arguments to sprint to be passed to print
#
# Revision 1.1  2003/04/02 22:28:32  warnes
#
# - Added file 'capture.R' containing capture() and sprint().
#
#

capture <- function( expression, collapse="\n")
  {
    warning("Depreciated.  Use capture.output() from base instead.")
    
    resultText <- capture.output( expression )

    return( paste( c(resultText, ""), collapse=collapse, sep="" ) )
    # the reason for c(result, "") is so that we get the line
    # terminator on the last line of output.  Otherwise, it just shows
    # up between the lines.
  }


sprint <- function(x,...)
  {
    capture(print(x,...))
  }
