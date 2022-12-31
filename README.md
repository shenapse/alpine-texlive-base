# shena4746/alpine-texlive-base

A Lightweight TeXLive Docker image. It includes:

- some ready-made collections (written in [texlive.profile](./texlive.profile))
  - collection-basic
  - collection-fontsrecommended
  - collection-latex
  - collection-latexrecommended
- latexmk
- latexindent
- synctex
- texcount
- chktex
- extra packages (written in [install-additional-packages.sh](./script/install-additional-packages.sh))

See [installed-packages.txt](./installed-packages.txt).

## Usage

The following command builds `project-top/tex/master.tex` with lualatex:

```bash
	docker run --rm -v ${PWD}:/workdir shena4746/alpine-texlive-base:0.0.1 \
    sh -c 'cd tex && latexmk -outdir=../out -lualatex -shell-escape -synctex=1 master.tex'
```

## Install

The image is available on Docker Hub.

```bash
# replace tag with your intended version (e.g., 0.0.1)
docker pull shena4746/alpine-textlive-base:tag
```

## Customize

### Add packages via `tlmgr`

If you want to add packages available via `tlmgr`, edit [install-additional-packages.sh](./script/install-additional-packages.sh) and build a new image by running `make build` at the project root. If you want to add collection-xxxx, editing `textlive.profile` would be a better choice.

### Extend the image

To run an additional `apk add`, the Dockerfile must be rewritten.

```dockerfile
# install xetex
FROM shena4746/alpine-texlive-base:tag
RUN apk update \
    && apk add --no-cache fontconfig \
    && tlmgr install collection-xetex
```

If you are concerned about image size, a sensible approach is to rewrite the 'base' image definition for the purpose of exploiting multi-stage builds.

### Test Image

`make test` tries to build and latexindent `./tex/master.tex` by executing `./script/test.sh`. See [Makefile](./Makefile) for detail.

When you use `make xxx`, remember to update variables in the Makefile, such as `USERNAME` and `VERSION`.

## References

This repository is inspired by:

- [Paperist/texlive-ja](https://github.com/Paperist/texlive-ja)
- [reitzig/texlive-docker](https://github.com/reitzig/texlive-docker)
