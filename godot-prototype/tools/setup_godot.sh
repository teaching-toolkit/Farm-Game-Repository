#!/usr/bin/env bash
# Sets up Godot for a fresh Linux / cloud session (e.g. Claude Code on the web).
# Usage (from anywhere):  bash godot-prototype/tools/setup_godot.sh [--web] [--art] [--screens]
#   --web      also install the Web export templates (big download, ~1 GB; only needed to export web-build/)
#   --art      also install the Python packages for tools/import_art.py (Pillow, numpy, scipy)
#   --screens  also install Xvfb so screenshots can be taken
# Prints the path of the Godot binary at the end; use it as $G (see 00-READ-ME-FIRST.md §4.2).
set -euo pipefail

VER="4.7.2"
TAG="${VER}-stable"
BASE="https://github.com/godotengine/godot/releases/download/${TAG}"
DEST="${GODOT_HOME:-$HOME/godot}"

WEB=0; ART=0; SCREENS=0
for a in "$@"; do
  case "$a" in
    --web) WEB=1 ;; --art) ART=1 ;; --screens) SCREENS=1 ;;
    *) echo "Unknown option: $a"; exit 2 ;;
  esac
done

case "$(uname -m)" in
  x86_64|amd64) ARCH="x86_64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) echo "Unsupported CPU: $(uname -m)"; exit 1 ;;
esac

mkdir -p "$DEST"
BIN="$DEST/Godot_v${TAG}_linux.${ARCH}"
if [ ! -x "$BIN" ]; then
  echo "Downloading Godot ${TAG} (${ARCH})..."
  curl -fL --retry 3 -o "$DEST/godot.zip" "${BASE}/Godot_v${TAG}_linux.${ARCH}.zip"
  (cd "$DEST" && unzip -oq godot.zip && rm godot.zip)
  chmod +x "$BIN"
fi
echo "Godot: $("$BIN" --headless --version 2>/dev/null | head -n1)"

if [ "$WEB" = 1 ]; then
  TPL="$HOME/.local/share/godot/export_templates/${VER}.stable"
  if [ ! -f "$TPL/web_nothreads_release.zip" ]; then
    echo "Downloading export templates (large)..."
    mkdir -p "$TPL"
    curl -fL --retry 3 -o "$DEST/templates.tpz" "${BASE}/Godot_v${TAG}_export_templates.tpz"
    # Keep only what the Web export needs.
    unzip -oqj "$DEST/templates.tpz" 'templates/web_nothreads_*' 'templates/version.txt' -d "$TPL"
    rm "$DEST/templates.tpz"
  fi
  echo "Web templates: $TPL"
fi

if [ "$ART" = 1 ]; then
  pip install --quiet Pillow numpy scipy 2>/dev/null || pip install --quiet --break-system-packages Pillow numpy scipy
  echo "Python art packages installed."
fi

if [ "$SCREENS" = 1 ] && ! command -v Xvfb >/dev/null; then
  if command -v apt-get >/dev/null; then
    SUDO=""; [ "$(id -u)" != 0 ] && SUDO="sudo"
    $SUDO apt-get update -qq && $SUDO apt-get install -y -qq xvfb >/dev/null
  fi
  command -v Xvfb >/dev/null && echo "Xvfb installed." || echo "Could not install Xvfb; screenshots will not work."
fi

echo
echo "G=$BIN"
