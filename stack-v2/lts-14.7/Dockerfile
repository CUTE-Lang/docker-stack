# Derived from
# https://github.com/commercialhaskell/stack/blob/master/etc/dockerfiles/stack-build/
FROM cutelang/stack-small:v2-common

ARG LTS_SLUG=lts-14.7

RUN stack -v --resolver="${LTS_SLUG}" --local-bin-path=/usr/local/bin install \
        cabal-install happy alex cpphs hscolour hlint hindent && \
    cd ${STACK_ROOT} && \
    find . -type f -not -path './snapshots/*/share/*' -exec rm '{}' \; && \
    find . -type d -print0 | sort -rz | xargs -0 rmdir 2>/dev/null || true
