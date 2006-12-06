#!/bin/sh
all:
	echo 'Sweave("paper.Snw")' | R --slave --no-save --no-restore
	pdflatex paper.tex
	pdflatex paper.tex
	pdflatex paper.tex

eps:
	echo 'Sweave("paper.Snw")' | R --slave --no-save --no-restore
	latex paper.tex
	latex paper.tex
	latex paper.tex
	dvips paper.dvi
