#! /bin/bash

# Bundles the files in this repository up for release.
#
# Usage: ./scripts/make-release.sh <VERSION> [--update-sources]
#
# The resulting release package will be in release/preview/<PACKAGE>/<VERSION>.

set -euo pipefail

VERSION=${1:-}
UPDATE_SOURCES=${2:-}

if [ -z "$VERSION" ]; then
    echo "You need to specify a version number."
    exit 1
fi

PACKAGE=$(sed -n 's/^name = "\(.*\)"/\1/p' typst.toml | head -n 1)

if [ -z "$PACKAGE" ]; then
    echo "Could not determine package name from typst.toml."
    exit 1
fi

RELEASE_DIR="release/preview/$PACKAGE/$VERSION"

replace_version_refs() {
    local file=$1

    sed -i.bak -E \
        -e "s/@preview\/$PACKAGE:[0-9]+\.[0-9]+\.[0-9]+/@preview\/$PACKAGE:$VERSION/g" \
        -e "s/^version = \".*\"/version = \"$VERSION\"/" \
        -e "s/^(#let lst-template-version = \").*(\")/\1$VERSION\2/" \
        "$file"
    rm -f "$file.bak"
}

if [[ "$UPDATE_SOURCES" == "--update-readme" ]]; then
    UPDATE_SOURCES="--update-sources"
fi

if [[ -n "$UPDATE_SOURCES" && "$UPDATE_SOURCES" != "--update-sources" ]]; then
    echo "Unknown option: $UPDATE_SOURCES"
    echo "Usage: ./scripts/make-release.sh <VERSION> [--update-sources]"
    exit 1
fi

if [[ "$UPDATE_SOURCES" == "--update-sources" ]]; then
    echo "Updating source files to version $VERSION."
    replace_version_refs README.md
    replace_version_refs template/main.typ
    replace_version_refs typst.toml
    replace_version_refs lib.typ
fi

rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR/logos/rgb" "$RELEASE_DIR/template"

cp lib.typ "$RELEASE_DIR/lib.typ"
cp README.md "$RELEASE_DIR/README.md"
cp LICENSE "$RELEASE_DIR/LICENSE"
cp thumbnail.png "$RELEASE_DIR/thumbnail.png"
cp logos/rgb/lst-logo.svg "$RELEASE_DIR/logos/rgb/lst-logo.svg"
cp logos/rgb/uds-logo.svg "$RELEASE_DIR/logos/rgb/uds-logo.svg"
cp template/main.typ "$RELEASE_DIR/template/main.typ"
cp template/custom.bib "$RELEASE_DIR/template/custom.bib"

cp typst.toml "$RELEASE_DIR/typst.toml"

replace_version_refs "$RELEASE_DIR/README.md"
replace_version_refs "$RELEASE_DIR/template/main.typ"
replace_version_refs "$RELEASE_DIR/typst.toml"
replace_version_refs "$RELEASE_DIR/lib.typ"

echo "Package is ready for release in $RELEASE_DIR."
