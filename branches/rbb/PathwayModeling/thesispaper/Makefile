#!/bin/sh
all:
	echo 'Sweave("paper.Snw")' | R --no-save --no-restore
	pdflatex paper.tex
	pdflatex paper.tex
	bibtex paper
	pdflatex paper.tex
	pdflatex paper.tex
