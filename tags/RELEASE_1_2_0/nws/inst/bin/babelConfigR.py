##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##

def doTranslationCallback(d, v):
    m = v.split('\n', 8)
    stxt = '"%s"'%m[-1][:-1]
    d.callback(eval(stxt))

babelNwsName = 'R babelfish'
