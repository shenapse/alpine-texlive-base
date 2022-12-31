USERNAME=shena4746
SOURCE=Dockerfile
VERSION=0.1.0
IMAGE=${USERNAME}/alpine-texlive-base:${VERSION}

ifeq ($(OS),Windows_NT)
	PWD=$(CURDIR)
endif

# build container image
.PHONY: build
build:
	docker image build -f ${SOURCE} -t ${IMAGE} . && make dump-package

.PHONY: dump-package
dump-package:
	sh ./script/dump-package-info.sh ${IMAGE}

# create new container and login to the shell
.PHONY: shell
shell:
	docker run --env IMAGE_VERSION=${VERSION} -it --rm -v ${PWD}:/workdir ${IMAGE}

# run test build
.PHONY: test
test:
	docker run -it --rm -v ${PWD}:/workdir ${IMAGE} sh ./script/test.sh

.PHONY: push
push:
	docker push ${IMAGE}

.PHONY: clear-me
clearme:
	docker image rm ${IMAGE}

.PHONY: release
release:
	git tag "v${VERSION}"; \
	git push origin "v${VERSION}"; \
	gh release create "v${VERSION}" -t "v${VERSION}" -F CHANGELOG.md

.PHONY: unrelease
unrelease:
	gh release delete -y "v${VERSION}"; \
	git tag -d "v${VERSION}"; \
	git push origin ":v${VERSION}"