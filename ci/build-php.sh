#!/bin/bash

set -e

if [ ! -f .gitignore ]; then
    echo 'This script must be run from the repository root'
    exit 1
fi

VERSION="8.4"
EXTENSIONS="apcu,bcmath,calendar,ctype,curl,dba,dom,exif,fileinfo,filter,gd,iconv,intl,mbregex,mbstring,mysqli,mysqlnd,opcache,openssl,pcntl,pdo,pdo_mysql,pdo_pgsql,pdo_sqlite,pgsql,phar,posix,readline,redis,session,simplexml,sockets,sodium,sqlite3,tokenizer,xml,xmlreader,xmlwriter,xsl,zip,zlib"
SPC_URL="https://github.com/crazywhalecc/static-php-cli/releases/download/2.5.2/spc-macos-aarch64.tar.gz"

if ! ( (brew list | grep -q cmake) && (brew list --versions cmake | grep -q '3\.31\.6') ); then
    echo 'cmake is not installed via homebrew or it is not version 3.31.6'
    
    # Special cmake cask to install 3.31.6, the latest version to be supported by spc
    brew reinstall -s ./ci/resources/cmake.rb
fi

brew install autoconf

mkdir -p build/output

cd build

curl -Lo spc.tar.gz "$SPC_URL"

tar -xvzf spc.tar.gz

./spc download "--with-php=$VERSION" --for-extensions "$EXTENSIONS" --prefer-pre-built

./spc spc-config --with-suggested-libs --with-suggested-exts "$EXTENSIONS"

./spc build --debug --build-cli --with-suggested-libs --with-suggested-exts "$EXTENSIONS"

cd ..

cp ./build/buildroot/bin/php ./build/output/php

chmod +x ./build/output/php

./build/output/php-macos -v

(cd ./build/output && zip -9 php-macos.zip php)
