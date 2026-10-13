#!/usr/bin/env bash
# All quick checks in one go (about 2 minutes): UI smoke test, save fixtures, save versions, core kit, data checks, places and pets, quality, skills, money, story, trip, golden run, translations.
# Run after every restructuring step:  bash tests/check_all.sh   (Godot as in tests/golden.sh)
set -uo pipefail
cd "$(dirname "$0")/.."
G="${GODOT:-}"
if [ -z "$G" ]; then
  for c in "$HOME"/godot/Godot_v4* /Applications/Godot.app/Contents/MacOS/Godot "$(command -v godot 2>/dev/null)"; do
    if [ -n "$c" ] && [ -x "$c" ]; then G="$c"; break; fi
  done
fi
[ -n "$G" ] || { echo "Godot not found (set GODOT=/path/to/godot)"; exit 2; }
export GODOT="$G"
FAIL=0
LOG="$(mktemp)"
"$G" --headless --path . res://tests/ui_smoke.tscn -- --seed=1 > "$LOG" 2>&1
if grep -q "SCRIPT ERROR" "$LOG" || grep -q "^FAIL" "$LOG" || ! grep -q "^insides: " "$LOG"; then echo "✘ UI smoke test"; grep -m3 -A3 "SCRIPT ERROR" "$LOG"; grep "^FAIL" "$LOG"; FAIL=1
else echo "✔ UI smoke test ($(grep -c . "$LOG") lines; read them against claude-skills/farm-game-check)"; fi
"$G" --headless --path . res://tests/fixtures_test.tscn -- --seed=1 > "$LOG" 2>&1 || FAIL=1
grep -E "^FIXTURES|^FAIL|SCRIPT ERROR" "$LOG" | sed 's/^FIXTURES OK/✔ save fixtures/; s/^FIXTURES FAILED/✘ save fixtures/'
grep -q "^FIXTURES OK" "$LOG" || FAIL=1
"$G" --headless --path . -s res://tests/core_test.gd > "$LOG" 2>&1 || FAIL=1
grep -E "^CORE|^FAIL|SCRIPT ERROR" "$LOG" | sed 's/^CORE OK/✔ core kit/; s/^CORE FAILED/✘ core kit/'
grep -q "^CORE OK" "$LOG" || FAIL=1
"$G" --headless --path . res://tests/saves_test.tscn -- --seed=1 > "$LOG" 2>&1 || FAIL=1
grep -E "^SAVES|^FAIL|^   |SCRIPT ERROR" "$LOG" | sed 's/^SAVES OK/✔ save versions/; s/^SAVES FAILED/✘ save versions/'
grep -q "^SAVES OK" "$LOG" || FAIL=1
"$G" --headless --path . res://tests/places_test.tscn -- --seed=1 > "$LOG" 2>&1 || FAIL=1
grep -E "^PLACES|^FAIL|^   |SCRIPT ERROR" "$LOG" | sed 's/^PLACES OK/✔ places and pets/; s/^PLACES FAILED/✘ places and pets/'
grep -q "^PLACES OK" "$LOG" || FAIL=1
"$G" --headless --path . res://tests/quality_test.tscn -- --seed=1 > "$LOG" 2>&1 || FAIL=1
grep -E "^QUALITY|^FAIL|SCRIPT ERROR" "$LOG" | sed 's/^QUALITY OK/✔ quality/; s/^QUALITY FAILED/✘ quality/'
grep -q "^QUALITY OK" "$LOG" || FAIL=1
"$G" --headless --path . res://tests/skills_test.tscn -- --seed=1 > "$LOG" 2>&1 || FAIL=1
grep -E "^SKILLS|^FAIL|SCRIPT ERROR" "$LOG" | sed 's/^SKILLS OK/✔ skills/; s/^SKILLS FAILED/✘ skills/'
grep -q "^SKILLS OK" "$LOG" || FAIL=1
"$G" --headless --path . res://tests/money_test.tscn -- --seed=1 > "$LOG" 2>&1 || FAIL=1
grep -E "^MONEY|^FAIL|SCRIPT ERROR" "$LOG" | sed 's/^MONEY OK/✔ money/; s/^MONEY FAILED/✘ money/'
grep -q "^MONEY OK" "$LOG" || FAIL=1
"$G" --headless --path . res://tests/story_test.tscn -- --seed=1 > "$LOG" 2>&1 || FAIL=1
grep -E "^STORY|^FAIL|SCRIPT ERROR" "$LOG" | sed 's/^STORY OK/✔ story/; s/^STORY FAILED/✘ story/'
grep -q "^STORY OK" "$LOG" || FAIL=1
"$G" --headless --path . res://tests/trip_test.tscn -- --seed=1 > "$LOG" 2>&1 || FAIL=1
grep -E "^TRIP|^FAIL|SCRIPT ERROR" "$LOG" | sed 's/^TRIP OK/✔ trip and bag/; s/^TRIP FAILED/✘ trip and bag/'
grep -q "^TRIP OK" "$LOG" || FAIL=1
bash tests/golden.sh "$@" || { echo "✘ golden run"; FAIL=1; }
python3 tools/check_data.py > "$LOG" 2>&1 && echo "✔ data checks ($(tail -1 "$LOG"))" || { echo "✘ data checks"; grep ERROR "$LOG" | head -5; FAIL=1; }
python3 tools/i18n.py --check > /dev/null || { echo "✘ translations (python3 tools/i18n.py)"; FAIL=1; }
rm -f "$LOG"
[ $FAIL = 0 ] && echo "ALL CHECKS PASSED" || echo "SOME CHECKS FAILED"
exit $FAIL
