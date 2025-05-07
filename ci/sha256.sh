if [ "$(uname)" == 'Darwin' ]; then
    SHA256_COMMAND='shasum -a 256'
else
    SHA256_COMMAND='sha256sum'
fi

cat "$1" | "$SHA256_COMMAND" | cut -d" " -f1