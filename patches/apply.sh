#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob

cd -P -- "$(dirname -- "$0")"
for PATCHFILE in *.patch; do
    PLUGIN=${PATCHFILE%.patch}
    (
        cd ../plugged/$PLUGIN
        echo "applying $PATCHFILE"
        git apply "../../patches/${PATCHFILE}" || true
        echo ""
    )
done
