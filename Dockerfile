FROM alpine:3.17.0 AS base
ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /install-tl-unx
RUN set -x
RUN apk add --no-cache --virtual .fetch-deps \
    make \
    perl-app-cpanminus
RUN apk add --no-cache \
    perl \
    tar \
    wget \
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
    chktex
# install requirements for latexindent
RUN apk add --no-cache \
    perl-yaml-tiny \
    perl-log-dispatch \
    perl-unicode-linebreak \
    perl-log-log4perl
RUN cpanm File::HomeDir
# tar perl modules to resolve symbolic links of copied files
RUN tar czf /perls.tar.gz \
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
COPY --from=base /perls.tar.gz /perls.tar.gz
RUN apk add --no-cache \
    bash \
    perl \
    wget \
    && ln -s /usr/local/texlive/*/bin/* /usr/local/bin/texlive\
    # expand perl modules
    && tar xzf perls.tar.gz \
    # remove tar 
    && rm perls.tar.gz \
    && rm -rf /var/cache/apk/*
WORKDIR /workdir
CMD ["bash"]