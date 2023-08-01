#!/bin/sh

# $1 docker image
echo "$1\n" > texlive-version.txt
docker run -it --rm -v ${PWD}:/workdir $1 \
       sh -c 'tlmgr -version >> texlive-version.txt'