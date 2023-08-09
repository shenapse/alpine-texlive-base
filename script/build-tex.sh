#!/bin/sh
# test build

# $1 tex file 
# $2 outdir

DIR_PARENT=$(dirname $1)
cd ${DIR_PARENT} && mkdir -p $2 && latexmk -outdir=$2 -lualatex -synctex=1 $1