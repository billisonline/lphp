#!/bin/bash

set -e

if [ ! -f .gitignore ]; then
    echo 'This script must be run from the repository root'
    exit 1
fi

VERSION="8.4"
EXTENSIONS="apcu,bcmath,calendar,ctype,curl,dba,dom,exif,fileinfo,filter,gd,iconv,intl,mbregex,mbstring,mysqli,mysqlnd,opcache,openssl,pcntl,pdo,pdo_mysql,pdo_pgsql,pdo_sqlite,pgsql,phar,posix,readline,redis,session,simplexml,sockets,sodium,sqlite3,tokenizer,xml,xmlreader,xmlwriter,xsl,zip,zlib"

sudo add-apt-repository -y ppa:ondrej/php

#sudo apt update

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

    run-spc-download() {
        ./bin/spc download --shallow-clone "--with-php=$VERSION" --for-extensions "$EXTENSIONS" --prefer-pre-built
    }

    # Retry the downloads with exponential backoff bc there are often transient failures.
    run-spc-download || (sleep 120 && run-spc-download) || (sleep 240 && run-spc-download) || (sleep 480 && run-spc-download)

    ./bin/spc-gnu-docker

    ./bin/spc-gnu-docker build --debug --build-cli --with-suggested-libs --with-suggested-exts "$EXTENSIONS"
)

mkdir -p ./build/output

cp ./static-php-cli/buildroot/bin/php ./build/output/php

chmod +x ./build/output/php

./build/output/php -v

(cd ./build/output && zip -9 "php-$OS_CURRENT.zip" php)

