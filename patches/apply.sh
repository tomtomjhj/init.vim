#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob

# TODO:
# * write in vimL?
cd $(dirname $0)
for PATCHFILE in *.patch; do
    PLUGIN=${PATCHFILE%.patch}
    pushd ../plugged/$PLUGIN
    git apply ../../patches/$PATCHFILE
    popd
done
