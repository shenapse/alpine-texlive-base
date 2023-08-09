ARG DIR='workdir'
ARG latexindent_config=".indentconfig.yaml"
FROM alpine:3.17.0 AS dev-texlive
# load arguments
ARG DIR
ARG latexindent_config
ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /install-tl-unx
RUN set -x
RUN apk add --no-cache --virtual .fetch-deps \
	make \
	perl-app-cpanminus
RUN apk add --no-cache \
	perl
COPY ./texlive.profile ./
RUN wget -nv https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf ./install-tl-unx.tar.gz --strip-components=1
RUN ./install-tl --profile=texlive.profile
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
# tools for writing environment 
RUN tlmgr install \
	latexmk \
	latexindent \
	synctex \
	texcount \
	chktex \
	biblatex \
	biber
# add packages for writing
COPY ${PWD}/script/install-additional-packages.sh /work-tmp/install.sh
RUN sh /work-tmp/install.sh
# create latexindent config file
RUN echo "paths:" > /work-tmp/${latexindent_config} \
	&& echo "  - /${DIR}/.latexindent.yaml" >> /work-tmp/${latexindent_config}
# remove --virtuals
RUN apk del --purge .fetch-deps

# perl requirements for latexindent
FROM alpine:3.17.0 AS dev-perl
RUN apk add --no-cache --virtual .fetch-deps \
	make \
	perl-app-cpanminus
RUN apk add --no-cache \
	perl \
	xz
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
RUN apk del --purge .fetch-deps

FROM alpine:3.17.0
ENV PATH /usr/local/bin/texlive:$PATH
ARG DIR
ARG latexindent_config
COPY --from=dev-texlive /usr/local/texlive /usr/local/texlive 
COPY --from=dev-texlive /work-tmp/${latexindent_config} /root/${latexindent_config}
COPY --from=dev-perl /modules.tar.gz /modules.tar.gz
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
	&& tlmgr update --self --all \
	# remove files
	&& rm -rf /var/cache/apk/* rm modules.tar.gz ./update-tlmgr-latest.sh
WORKDIR /${DIR}
CMD ["bash"]