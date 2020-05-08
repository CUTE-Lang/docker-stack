FROM fpco/stack-build-small:lts-15.11

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-client && \
    rm -rf /var/lib/apt/lists/*
