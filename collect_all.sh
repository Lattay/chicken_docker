#!/bin/bash

version=5.3.0

set -euo pipefail

help() {
    echo "Usage: collect_all.sh [PREFIX]"
    echo "  Compile all compiler flavors with PREFIX and extract archives."

}

case "${1:-}" in
    -h|--help)
        help
        exit
        ;;
    "")
        prefix=/usr/local
        ;;
    *)
        prefix=$1
        ;;
esac

shift

case "${1:-}" in
    -h|--help)
        help
        exit
        ;;
    "")
        prefix_rt=/mingw-chicken-rt
        ;;
    *)
        prefix_rt=$1
        ;;
esac

collect() (
    image=lattay/chicken:${2}-${version}
    echo "Building $image"
    cd $1
    echo docker build . --build-arg PREFIX=$prefix --build-arg PREFIX_RT=$prefix_rt -t $image
    docker build . --build-arg PREFIX=$prefix --build-arg PREFIX_RT=$prefix_rt -t $image
    mkdir -p out
    cp ../extract.sh out

    echo "Extracting chicken-${2}-${version}.tgz"
    echo docker run --env PREFIX=$prefix --env PREFIX_RT=$prefix_rt --mount type=bind,source="$(pwd)"/out,target=/out --rm -it $image /out/extract.sh
    docker run --env PREFIX=$prefix --env PREFIX_RT=$prefix_rt --mount type=bind,source="$(pwd)"/out,target=/out --rm -it $image /out/extract.sh

    cp out/chicken.tgz ../archives/chicken-${2}-${version}.tgz
)

mkdir -p archives

collect glibc linux-gnu
collect muslc linux-musl
collect mingw cross-mingw
