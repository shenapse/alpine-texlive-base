#!/bin/bash -eux
# test build

# $1 tex file 
# $2 outdir

mkdir -p $2 && latexmk -cd -outdir=$2 -lualatex -synctex=1 $1