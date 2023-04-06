#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob

cd -P -- "$(dirname -- "$0")"
for PATCHFILE in *.patch; do
    PLUGIN=${PATCHFILE%.patch}
    if [ -d "../plugged/$PLUGIN" ]; then (
        cd "../plugged/$PLUGIN"
        echo "applying $PATCHFILE"
        git apply "../../patches/${PATCHFILE}" || true
        echo ""
    ) fi
done
