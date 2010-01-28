set TARGET=Compress-Raw-Zlib-2.024
set SHELL=
cd %TARGET%
perl Makefile.PL PREFIX=../../inst/perl LIB=../../inst/perl 
dmake
dmake install
