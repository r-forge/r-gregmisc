##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##

# found on web, but where ...?

FILTER=''.join([(len(repr(chr(x)))==3) and chr(x) or '.' for x in range(256)])

def hexDump(src, length=8):
    N=0; result=''
    while src:
       s,src = src[:length],src[length:]
       hexa = ' '.join(["%02X"%ord(x) for x in s])
       s = s.translate(FILTER)
       result += "%04X   %-*s   %s\n" % (N, length*3, hexa, s)
       N+=length
    return result
