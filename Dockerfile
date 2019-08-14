# Derived from
# https://github.com/commercialhaskell/stack/blob/master/etc/dockerfiles/stack-build/
FROM ubuntu:18.04

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg wget netbase ca-certificates

ARG PID1_VERSION=0.1.2.0

RUN wget -O- "https://github.com/fpco/pid1/releases/download/v${PID1_VERSION}/pid1-${PID1_VERSION}-linux-x86_64.tar.gz" | tar xzf - -C /usr/local && \
    chown root:root /usr/local/sbin && \
    chown root:root /usr/local/sbin/pid1

ARG GHC_VERSION=8.6.5

ENV PATH=/root/.cabal/bin:/root/.local/bin:/opt/ghc/$GHC_VERSION/bin:$PATH

RUN echo "deb http://ppa.launchpad.net/hvr/ghc/ubuntu bionic main" >>/etc/apt/sources.list && \
    echo "deb-src http://ppa.launchpad.net/hvr/ghc/ubuntu bionic main" >>/etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 063DAB2BDC0B3F9FCEBC378BFF3AEACEF6F88286 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ghc-$GHC_VERSION ghc-$GHC_VERSION-htmldocs \
        g++ gcc libc6-dev libffi-dev libgmp-dev make xz-utils zlib1g-dev git gnupg \
        libtinfo-dev && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s ghc /opt/ghc/$GHC_VERSION/share/doc/ghc-$GHC_VERSION

ARG STACK_VERSION=1.9.3

RUN wget -qO- "https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/stack-${STACK_VERSION}-linux-x86_64-static.tar.gz" | \
        tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack' && \
    mkdir /etc/stack/ && \
    echo "system-ghc: true" >/etc/stack/config.yaml && \
    export STACK_ROOT=/usr/local/lib/stack

ARG LTS_SLUG=lts-14.0

RUN stack -v --resolver="${LTS_SLUG}" --local-bin-path=/usr/local/bin install \
        cabal-install happy alex cpphs hscolour hlint hindent && \
    cd ${STACK_ROOT} && \
    find . -type f -not -path './snapshots/*/share/*' -exec rm '{}' \; && \
    find . -type d -print0 | sort -rz | xargs -0 rmdir 2>/dev/null || true

ENTRYPOINT ["/usr/local/sbin/pid1"]
CMD ["bash"]
