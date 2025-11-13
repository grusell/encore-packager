#!/bin/sh
if [ $# -lt 2 ]
then
    echo "USAGE: $0 PLATFORM OUTPUTPATH"
    exit 1
fi
platform=$1
output=$2
case "$platform" in
    linux/arm64*)
        curl -L -o "$output" https://github.com/shaka-project/shaka-packager/releases/download/v3.4.2/packager-linux-arm64
        ;;
    *)
        curl -L -o "$output" https://github.com/shaka-project/shaka-packager/releases/download/v3.4.2/packager-linux-x64
        ;;
esac
