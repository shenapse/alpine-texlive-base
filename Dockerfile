FROM alpine:3.17.0 AS base
ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /install-tl-unx
RUN set -x
RUN apk add --no-cache --virtual .fetch-deps \
	make \
	perl-app-cpanminus
RUN apk add --no-cache \
	perl \
	xz
COPY ./texlive.profile ./
RUN wget -nv https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf ./install-tl-unx.tar.gz --strip-components=1
RUN ./install-tl --profile=texlive.profile
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
# tools for build and text editor 
RUN tlmgr install \
	latexmk \
	latexindent \
	synctex \
	texcount \
	chktex \
	biblatex \
	biber
# install requirements for latexindent
RUN apk add --no-cache \
	perl-yaml-tiny \
	perl-log-dispatch \
	perl-unicode-linebreak \
	perl-log-log4perl
RUN cpanm File::HomeDir
# tar perl modules to resolve symbolic links of copied files
# + some binary files
RUN tar czf /modules.tar.gz \
	/usr/local/share/perl5/site_perl \
	/usr/lib/perl5/vendor_perl \
	/usr/share/perl5/vendor_perl
# add more packages you need
COPY ${PWD}/script/install-additional-packages.sh /work-tmp/install.sh
RUN sh /work-tmp/install.sh
# remove --virtuals
RUN apk del --purge .fetch-deps

FROM alpine:3.17.0
ENV PATH /usr/local/bin/texlive:$PATH
COPY --from=base /usr/local/texlive /usr/local/texlive 
COPY --from=base /modules.tar.gz /modules.tar.gz
RUN apk add --no-cache \
	bash \
	perl \
	git \
	curl \
	&& ln -s /usr/local/texlive/*/bin/* /usr/local/bin/texlive \
	# expand perl modules
	&& tar xzf modules.tar.gz \
	# update tlmgr
	&& wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh \
	&& chmod +x update-tlmgr-latest.sh \
	&& ./update-tlmgr-latest.sh \
	# remove files
	&& rm -rf /var/cache/apk/* rm modules.tar.gz ./update-tlmgr-latest.sh
WORKDIR /workdir
CMD ["bash"]