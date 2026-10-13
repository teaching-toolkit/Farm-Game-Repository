#!/usr/bin/env bash
# Refreshes the progression explorer from the game as it is now: checks the data, lets the test bot play the real rules engine
# (seeds 1 and 2, to the end of the story) and write its pacing report, and puts data and report into progression/progression-explorer.html.
#   bash tools/update_explorer.sh        (from the godot-prototype folder; the double-click "Update explorer.command" calls it)
# Needs Godot (set GODOT=/path/to/Godot, or it is looked for in ~/godot, /Applications, the PATH) and python3. About 12 minutes.
set -uo pipefail
cd "$(dirname "$0")/.."
G="${GODOT:-}"
if [ -z "$G" ]; then
  for c in "$HOME"/godot/Godot_v4* /Applications/Godot.app/Contents/MacOS/Godot /Applications/Godot_mono.app/Contents/MacOS/Godot \
           "$HOME/Applications/Godot.app/Contents/MacOS/Godot" /Applications/Godot*.app/Contents/MacOS/Godot "$(command -v godot 2>/dev/null)"; do
    if [ -n "$c" ] && [ -x "$c" ]; then G="$c"; break; fi
  done
fi
[ -n "$G" ] || { echo "❌ Godot was not found (set GODOT=/path/to/Godot)"; exit 2; }
echo "Godot: $G"
OUT="$(mktemp -d)"
echo "1/4 checking the data …"
python3 tools/check_data.py | tail -3 || { echo "❌ the data has errors: fix them first"; exit 1; }
echo "2/4 importing the project (only needed after new pictures or scripts) …"
"$G" --headless --path . --import > /dev/null 2>&1
for SEED in 1 2; do
  echo "3/4 the bot plays seed $SEED to the end of the story (about five minutes) …"
  "$G" --headless --path . --audio-driver Dummy res://tests/bot.tscn -- --end --iters=3000 --seed=$SEED --report="$OUT/report$SEED.json" 2>&1 | grep -E "^DONE|SCRIPT ERROR"
  [ -s "$OUT/report$SEED.json" ] || { echo "❌ the bot wrote no report for seed $SEED"; exit 1; }
done
echo "4/4 writing the explorer …"
python3 tools/sync_progression.py --report "$OUT/report1.json" "$OUT/report2.json"
rm -rf "$OUT"
echo "✔ Done: open progression/progression-explorer.html (tab Pacing)."
