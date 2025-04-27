#!/bin/bash

set -e

VERSION="8.4"
EXTENSIONS="apcu,bcmath,calendar,ctype,curl,dba,dom,exif,fileinfo,filter,gd,iconv,intl,mbregex,mbstring,mysqli,mysqlnd,opcache,openssl,pcntl,pdo,pdo_mysql,pdo_pgsql,pdo_sqlite,pgsql,phar,posix,readline,redis,session,simplexml,sockets,sodium,sqlite3,tokenizer,xml,xmlreader,xmlwriter,xsl,zip,zlib"
SPC_URL="https://github.com/crazywhalecc/static-php-cli/releases/download/2.5.2/spc-macos-aarch64.tar.gz"

# Special cmake cask to install 3.31.6, the latest version to be supported by spc
brew reinstall -s ./cmake.rb

brew install autoconf

mkdir -p build/output

cd build

curl -Lo spc.tar.gz "$SPC_URL"

tar -xvzf spc.tar.gz

./spc download "--with-php=$VERSION" --for-extensions "$EXTENSIONS" --prefer-pre-built

./spc spc-config --with-suggested-libs --with-suggested-exts "$EXTENSIONS"

./spc build --debug --build-cli --with-suggested-libs --with-suggested-exts "$EXTENSIONS"

cd ..

cp ./build/buildroot/bin/php ./build/output/php-macos

chmod +x ./build/output/php-macos

./build/output/php-macos -v