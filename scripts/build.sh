#!/usr/bin/env bash

set -eu

DOCKERHUB_REPO="cutelang/stack"
PROJECT_PATH="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
IMAGE_PATH="${PROJECT_PATH}/images"

function main
{
    local image_tag
    for image_path in "${IMAGE_PATH}"/*
    do
        image_tag="$(make_tag_name "$(basename "${image_path}")")"

        build_image "${image_path}" "${image_tag}"
    done
}

function build_image
{
    local -r path="$1" tag="$2"

    local -ar build_start_messages=(
        "Build \x1b[01;32m${tag}\x1b[00m from"
        "\x1b[01;33m${path}/Dockerfile\x1b[00m"
        "by executing"
        "\x1b[01;32mdocker build -t \"${tag}\" \"${path}\"\x1b[00m"
    )

    print_messages "${build_start_messages[@]}"
    docker build -t "${tag}" "${path}"
}

function make_tag_name
{
    local -r tag="$1"
    echo "${DOCKERHUB_REPO}:${tag}"
}

function print_messages
{
    local -ar messages=("$@")

    local -r edge="$(printf "%80s" "" | sed 's/./#/g')"
    local -r margin="$(echo "${edge}" | sed 's/\(.\).\(.\)/\1 \2/g')"

    echo -e ""
    echo -e "${edge}"
    echo -e ""
    for message in "${messages[@]}"
    do
        echo -e "  ${message}"
    done
    echo -e ""
    echo -e "${edge}"
    echo -e ""
}

main

set +eu
