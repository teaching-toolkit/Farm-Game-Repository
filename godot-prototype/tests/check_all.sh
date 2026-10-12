#!/usr/bin/env bash
# All quick checks in one go (about 2 minutes): UI smoke test, save fixtures, golden run, translations.
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
if grep -q "SCRIPT ERROR" "$LOG" || ! grep -q "^insides: " "$LOG"; then echo "✘ UI smoke test"; grep -m3 -A3 "SCRIPT ERROR" "$LOG"; FAIL=1
else echo "✔ UI smoke test ($(grep -c . "$LOG") lines; read them against claude-skills/farm-game-check)"; fi
"$G" --headless --path . res://tests/fixtures_test.tscn -- --seed=1 > "$LOG" 2>&1 || FAIL=1
grep -E "^FIXTURES|^FAIL|SCRIPT ERROR" "$LOG" | sed 's/^FIXTURES OK/✔ save fixtures/; s/^FIXTURES FAILED/✘ save fixtures/'
grep -q "^FIXTURES OK" "$LOG" || FAIL=1
bash tests/golden.sh "$@" || { echo "✘ golden run"; FAIL=1; }
python3 tools/i18n.py --check > /dev/null || { echo "✘ translations (python3 tools/i18n.py)"; FAIL=1; }
rm -f "$LOG"
[ $FAIL = 0 ] && echo "ALL CHECKS PASSED" || echo "SOME CHECKS FAILED"
exit $FAIL
