
## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

def matlabTranslationCallback(d, v):
    d.callback(v[:-2]) # strip new lines.

def passThroughTranslationCallback(d, v):
    d.callback(v)

babelEngines = {1: ('Python babelfish', passThroughTranslationCallback),
                2: ('Matlab babelfish', matlabTranslationCallback),
                3: ('R babelfish', passThroughTranslationCallback),
                4: ('Perl babelfish', passThroughTranslationCallback),
                5: ('Ruby babelfish', passThroughTranslationCallback)}

