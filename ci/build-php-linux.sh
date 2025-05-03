#!/bin/bash

set -e

if [ ! -f .gitignore ]; then
    echo 'This script must be run from the repository root'
    exit 1
fi

source ./ci/vars.sh

sudo add-apt-repository -y ppa:ondrej/php

sudo apt install \
    php8.4-cli \
    php8.4-xml \
    composer \
    zip \
;

git clone https://github.com/crazywhalecc/static-php-cli.git

(
    cd static-php-cli

    composer install

    ./bin/spc download --from-zip=../build/downloads.zip

    ./bin/spc-gnu-docker

    ./bin/spc-gnu-docker build --debug --build-cli --with-suggested-libs --with-suggested-exts "$EXTENSIONS"
)

mkdir -p ./build/output

cp ./static-php-cli/buildroot/bin/php ./build/output/php

chmod +x ./build/output/php

./build/output/php -v

(cd ./build/output && zip -9 "php-linux.zip" php)

