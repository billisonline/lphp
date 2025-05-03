#!/bin/bash

set -e

if [ ! -f .gitignore ]; then
    echo 'This script must be run from the repository root'
    exit 1
fi

source ./ci/vars.sh

mkdir -p build

(
    cd build

    rm -f spc.tar.gz spc

    curl -Lo spc.tar.gz "$SPC_URL_LINUX"

    tar -xvzf spc.tar.gz

    ./spc download --shallow-clone "--with-php=$VERSION" --for-extensions "$EXTENSIONS" --retry=3

    (
        cd downloads

        zip -r downloads.zip .

        mv downloads.zip ..
    )
)