#! /bin/bash

# Publishes packages in the release directory as local Typst packages,
# by copying them into the local Typst package cache.
#
# Usage: ./scripts/publish-local.sh

set -euo pipefail

PACKAGE=$(sed -n 's/^name = "\(.*\)"/\1/p' typst.toml | head -n 1)

if [ -z "$PACKAGE" ]; then
    echo "Could not determine package name from typst.toml."
    exit 1
fi

if [ -n "${TYPST_PACKAGE_PATH:-}" ]; then
    LOCAL="$TYPST_PACKAGE_PATH/local"
elif [ "$(uname)" = "Darwin" ]; then
    LOCAL="$HOME/Library/Application Support/typst/packages/local"
else
    LOCAL="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/local"
fi

mkdir -p "$LOCAL"
cp -r "release/preview/$PACKAGE" "$LOCAL/"

echo "Published release/preview/$PACKAGE to $LOCAL/$PACKAGE."
