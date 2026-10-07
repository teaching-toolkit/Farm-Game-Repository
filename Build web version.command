#!/bin/bash
# ------------------------------------------------------------------
# Build web version.command  -  double-click me on the Mac.
# Re-exports the Godot prototype into ../web-build/ so the web version
# matches the current game. Then upload/push web-build/ to your host.
# ------------------------------------------------------------------

cd "$(dirname "$0")" || exit 1
ROOT="$(pwd)"
PROJECT="$ROOT/godot-prototype"
OUT="$ROOT/web-build"

pause_and_exit() {
  echo
  read -r -p "Press Enter to close this window..." _
  exit "${1:-0}"
}
fail() {
  echo
  echo "❌ $1"
  pause_and_exit 1
}

echo "🌾 Farm Quiz Game: building the web version"
echo "   Project: $PROJECT"
echo

[ -f "$PROJECT/project.godot" ] || fail "Could not find godot-prototype/project.godot next to this file."

# --- 1. Find Godot -------------------------------------------------
G=""
if [ -n "$GODOT" ] && [ -x "$GODOT" ]; then
  G="$GODOT"
else
  for c in \
    /Applications/Godot.app/Contents/MacOS/Godot \
    /Applications/Godot_mono.app/Contents/MacOS/Godot \
    "$HOME/Applications/Godot.app/Contents/MacOS/Godot" \
    /Applications/Godot*.app/Contents/MacOS/Godot \
    "$(command -v godot 2>/dev/null)"; do
    if [ -n "$c" ] && [ -x "$c" ]; then G="$c"; break; fi
  done
fi
[ -n "$G" ] || fail "Godot was not found.
   Install Godot 4.7.x (standard version, not .NET) from godotengine.org and put Godot.app in /Applications,
   or run:  GODOT=/path/to/Godot \"$0\""

VERSION="$("$G" --version 2>/dev/null | head -n 1)"
echo "✔ Godot: $G"
echo "  Version: $VERSION"

# --- 2. Check the web export templates -----------------------------
# Godot keeps them in a folder named after its version, e.g. 4.7.stable or 4.7.2.stable
# (the version text is like "4.7.stable.official.5b4e0cb0f"; we keep everything up to "stable").
TPL_NAME="$(echo "$VERSION" | sed -E 's/^([0-9]+(\.[0-9]+)+\.(stable|beta[0-9]*|rc[0-9]*|dev[0-9]*)).*/\1/')"
TPL_ROOT="$HOME/Library/Application Support/Godot/export_templates"
TPL_DIR="$TPL_ROOT/$TPL_NAME"
if [ ! -f "$TPL_DIR/web_nothreads_release.zip" ]; then
  echo "Looked for: $TPL_DIR/web_nothreads_release.zip"
  echo "Template folders that exist:"
  ls -1 "$TPL_ROOT" 2>/dev/null | sed 's/^/   /'
  fail "The Godot web export templates for $TPL_NAME were not found.
   Open Godot  ->  Editor menu  ->  Manage Export Templates...  and check that the installed version
   matches Godot's own version ($TPL_NAME), then double-click this file again."
fi
echo "✔ Export templates: $TPL_NAME"
echo

# --- 3. Remember how the old build looked --------------------------
mkdir -p "$OUT"
before="none"
if [ -f "$OUT/index.pck" ]; then
  before="$(stat -f '%Sm, %z bytes' "$OUT/index.pck")"
fi

# --- 4. Import and export ------------------------------------------
echo "⏳ Importing project resources (can take a minute the first time)..."
"$G" --headless --path "$PROJECT" --import >/dev/null 2>&1

echo "⏳ Exporting the web version..."
if ! "$G" --headless --path "$PROJECT" --export-release Web "$OUT/index.html"; then
  fail "The export failed. Scroll up for Godot's message. If the Godot editor is open, close it and try again."
fi

# --- 5. Check the result -------------------------------------------
[ -f "$OUT/index.pck" ] || fail "Export finished but web-build/index.pck is missing."
after="$(stat -f '%Sm, %z bytes' "$OUT/index.pck")"
echo
echo "index.pck before: $before"
echo "index.pck now:    $after"
if [ "$before" = "$after" ]; then
  echo "⚠️  index.pck looks unchanged. That is normal only if nothing in the game changed."
else
  echo "✅ Done. web-build/ now matches the current game."
fi
echo
echo "Next: upload the web-build folder (e.g. push it to your public web repo)."
echo "Then on the iPad, open the link; if you still see the old game, close the Home Screen app and reopen it."
pause_and_exit 0
