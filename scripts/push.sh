#!/usr/bin/env bash

set -eu

DOCKERHUB_REPO="cutelang/stack"

docker push "${DOCKERHUB_REPO}"

set +eu
