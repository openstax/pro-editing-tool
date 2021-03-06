#!/usr/bin/env bash

set -xeo pipefail
rm -rf ./.nyc_output/
rm -rf ./client/dist/
rm -rf ./client/out/
rm -rf ./server/dist/
rm -rf ./server/out/

$(npm bin)/tsc --build
npm run webpack
cp -r ./client/dist/* ./client/out/
cp -r ./client/src/test/data/ ./client/out/test/data/

macos_arg=''
if [[ "$(uname)" == 'Darwin' ]]; then
    macos_arg='-e'
fi

find ./client/out -name *.html -exec sed -i ${macos_arg} -E "s/(script-src.+)[;]/\1 'unsafe-eval';/g" {} \;
nyc instrument --compact=false --source-map --in-place ./client/out/ ./client/out/
