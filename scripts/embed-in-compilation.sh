#!/usr/bin/env bash
# Build 5-guess for https://stringlish.com/5-guess/ and copy into my-app-compilation.
# See docs/STRINGLISH_EMBED.md
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMP_DIR="${1:-$ROOT/../my-app-compilation}"
TARGET="$COMP_DIR/public/5-guess"
HOMEPAGE_EMBED="https://stringlish.com/5-guess"

cd "$ROOT"

if [[ ! -d "$COMP_DIR" ]]; then
  echo "Compilation repo not found: $COMP_DIR"
  echo "Usage: $0 [path-to-my-app-compilation]"
  exit 1
fi

cleanup() {
  if [[ -f "$ROOT/package.json.embed.bak" ]]; then
    mv "$ROOT/package.json.embed.bak" "$ROOT/package.json"
    echo "Restored package.json homepage."
  fi
}
trap cleanup EXIT

echo "Backing up package.json and setting homepage to $HOMEPAGE_EMBED"
cp package.json package.json.embed.bak
npm pkg set "homepage=$HOMEPAGE_EMBED"

echo "Building production bundle (CI=false)..."
CI=false npm run build

echo "Syncing build -> $TARGET"
mkdir -p "$TARGET"
rm -rf "${TARGET:?}/"*
cp -R build/. "$TARGET/"

echo ""
echo "Done. Static files are in:"
echo "  $TARGET"
echo ""
echo "Next steps:"
echo "  1. cd \"$COMP_DIR\""
echo "  2. Commit public/5-guess/ and push main"
echo "  3. Deploy the homepage (e.g. CI=false npm run deploy)"
echo "  4. Open https://stringlish.com/5-guess/"
trap - EXIT
cleanup
