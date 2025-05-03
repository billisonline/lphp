#!/bin/bash

set -e

if [ ! -f .gitignore ]; then
    echo 'This script must be run from the repository root'
    exit 1
fi

source ./ci/vars.sh

if ! ( (brew list | grep -q cmake) && (brew list --versions cmake | grep -q '3\.31\.6') ); then
    echo 'cmake is not installed via homebrew or it is not version 3.31.6'

    # Special cmake cask to install 3.31.6, the latest version to be supported by spc
    brew reinstall -s ./ci/resources/cmake.rb
fi

brew install autoconf

mkdir -p build/output

(
    cd build

    rm -f spc.tar.gz spc

    curl -Lo spc.tar.gz "$SPC_URL_MACOS"

    tar -xvzf spc.tar.gz

    ./spc download --from-zip=downloads.zip

    ./spc spc-config --with-suggested-libs --with-suggested-exts "$EXTENSIONS"

    ./spc build --debug --build-cli --with-suggested-libs --with-suggested-exts "$EXTENSIONS"
)

cp ./build/buildroot/bin/php ./build/output/php

chmod +x ./build/output/php

./build/output/php -v

(cd ./build/output && zip -9 php-macos.zip php)
