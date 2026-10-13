#!/bin/bash
# ------------------------------------------------------------------
# Update explorer.command  -  double-click me on the Mac.
# Lets the game's bot play the real rules (a fixed game, to chapter 5) and
# puts its pacing report and the current data into the progression
# explorer (progression/progression-explorer.html, tab "Pacing").
# Takes about a minute. Needs Godot 4.7 (as for "Build web version")
# and python3 (comes with the Mac's command line tools).
# ------------------------------------------------------------------

cd "$(dirname "$0")" || exit 1
ROOT="$(pwd)"
PROJECT="$ROOT/godot-prototype"

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

echo "🌾 Hazelwood Harvest: updating the progression explorer"
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
[ -n "$G" ] || fail "Godot was not found. Install Godot 4.7.x from godotengine.org into /Applications, or run:  GODOT=/path/to/Godot \"$0\""
command -v python3 >/dev/null 2>&1 || fail "python3 was not found. Install the command line tools: open Terminal and type  xcode-select --install"

# --- 2. The bot plays ----------------------------------------------
echo "⏳ The bot plays a fixed game to chapter 5 (about a minute)..."
if ! "$G" --headless --path "$PROJECT" res://tests/bot.tscn -- --chapter=5 --seed=1 --report="$ROOT/progression/pacing-report.json" | grep -E "^DONE|^pacing report|ERROR"; then
  fail "The bot did not finish. Scroll up for Godot's message."
fi
[ -f "$ROOT/progression/pacing-report.json" ] || fail "The bot ran but wrote no report."

# --- 3. Into the explorer -------------------------------------------
(cd "$PROJECT" && python3 tools/sync_progression.py) || fail "Putting the data into the explorer failed."
echo
echo "✅ Done. Open progression/progression-explorer.html and look at the Pacing tab (\"From the real game\")."
pause_and_exit 0
