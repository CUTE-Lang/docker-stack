# Derived from
# https://github.com/commercialhaskell/stack/blob/master/etc/dockerfiles/stack-build/
FROM cutelang/stack-small:common

ARG STACK_VERSION=2.1.3

RUN wget -qO- "https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/stack-${STACK_VERSION}-linux-x86_64-static.tar.gz" | \
        tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack' && \
    mkdir /etc/stack/ && \
    echo "system-ghc: true" >/etc/stack/config.yaml && \
    export STACK_ROOT=/usr/local/lib/stack
