#!/bin/sh
# test build

WORKDIR=/workdir
OUTDIR=${WORKDIR}/out
TARGET_TEX=${WORKDIR}/tex/master.tex

set -eu
function finally {
  find ${OUTDIR} -type  f -not -name '*.pdf' -not -name '*.log' -not -name '*.synctex.gz'| xargs rm -f
}
trap finally EXIT

cd ${WORKDIR}
echo -e "\n-------test build $(basename ${TARGET_TEX})------\n"
sh ${WORKDIR}/script/build-tex.sh ${TARGET_TEX} ${OUTDIR}
echo -e "\n-------test run latexindent-------\n"
latexindent ${WORKDIR}/tex/test.tex
echo -e "\n-------TEST SUCCESSFULLY DONE-------"