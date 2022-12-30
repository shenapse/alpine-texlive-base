#!/bin/sh

# $1 docker image
echo "$1\n" > installed-packages.txt
docker run -it --rm -v ${PWD}:/workdir $1 \
       sh -c 'tlmgr info --only-installed >> installed-packages.txt'