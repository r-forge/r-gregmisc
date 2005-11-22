
## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

def doTranslationCallback(d, v):
    m = v.split('\n', 8)
    stxt = '"%s"'%m[-1][:-1]
    d.callback(eval(stxt))

babelNwsName = 'R babelfish'
