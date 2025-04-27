set -e

sudo rm -rf buildroot downloads source 

EXTENSIONS="apcu,bcmath,calendar,ctype,curl,dba,dom,exif,fileinfo,filter,gd,iconv,intl,mbregex,mbstring,mysqli,mysqlnd,opcache,openssl,pcntl,pdo,pdo_mysql,pdo_pgsql,pdo_sqlite,pgsql,phar,posix,readline,redis,session,simplexml,sockets,sodium,sqlite3,tokenizer,xml,xmlreader,xmlwriter,xsl,zip,zlib"

./spc download --with-php=8.4 --for-extensions "$EXTENSIONS" --prefer-pre-built

./spc spc-config --with-suggested-libs --with-suggested-exts "$EXTENSIONS"

./spc build --debug --build-cli --with-suggested-libs --with-suggested-exts "$EXTENSIONS"