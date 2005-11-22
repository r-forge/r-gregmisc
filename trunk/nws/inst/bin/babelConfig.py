##
## Copyright (c) 2005, Scientific Computing Associates, Inc.
##
## This code is provided to you under the terms of the CDDL License version 1.0.   
##
## Please see the file COPYING or http://www.opensource.org/licenses/cddl1.php 
## for details.
##

def matlabTranslationCallback(d, v):
    d.callback(v[:-2]) # strip new lines.

def passThroughTranslationCallback(d, v):
    d.callback(v)

babelEngines = {1: ('Python babelfish', passThroughTranslationCallback),
                2: ('Matlab babelfish', matlabTranslationCallback),
                3: ('R babelfish', passThroughTranslationCallback),
                4: ('Perl babelfish', passThroughTranslationCallback),
                5: ('Ruby babelfish', passThroughTranslationCallback)}

