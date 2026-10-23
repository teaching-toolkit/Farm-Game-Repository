#!/usr/bin/env bash
# Golden run: the bot plays the same seeded games (to chapter 6: all five chapters) and every step of time is compared with the
# recorded runs in tests/golden/. A restructuring that changes nothing in the rules leaves them identical.
#   bash tests/golden.sh            compare the main numbers (coins, energy, water, goals, unlocked, store)
#   bash tests/golden.sh --strict   also compare the hash of the whole state (changes when the save layout changes)
#   bash tests/golden.sh --record   record new golden runs (only after a change to the rules or numbers on purpose)
#   bash tests/golden.sh --short    the short pair: play only to the end of chapter 2 (= --chapter=3, ~1/3 of the time)
#   bash tests/golden.sh --chapter=N  play until chapter N is reached (default 6: the full run); files are tests/golden/bot-seed<S>-ch<N>.txt
# Options can be combined (--short --record). Short after every slice; the full run when a slice touches a late system.
# Godot: $GODOT, else ~/godot/Godot_v4*, else /Applications/Godot.app, else `godot` on the PATH.
set -uo pipefail
cd "$(dirname "$0")/.."
G="${GODOT:-}"
if [ -z "$G" ]; then
  for c in "$HOME"/godot/Godot_v4* /Applications/Godot.app/Contents/MacOS/Godot "$(command -v godot 2>/dev/null)"; do
    if [ -n "$c" ] && [ -x "$c" ]; then G="$c"; break; fi
  done
fi
[ -n "$G" ] || { echo "Godot not found (set GODOT=/path/to/godot)"; exit 2; }
MODE=""
CH=6
for A in "$@"; do
  case "$A" in
    --short) CH=3 ;;
    --chapter=*) CH="${A#--chapter=}" ;;
    *) MODE="$A" ;;
  esac
done
OUT="$(mktemp -d)"
FAIL=0
for SEED in 1 2; do
  REF="tests/golden/bot-seed$SEED-ch$CH.txt"
  NEW="$OUT/seed$SEED.txt"
  "$G" --headless --path . res://tests/bot.tscn -- --chapter=$CH --seed=$SEED --golden="$NEW" 2>&1 | grep -E "^DONE|SCRIPT ERROR" | head -3
  if [ "$MODE" = "--record" ]; then cp "$NEW" "$REF"; echo "recorded $REF ($(wc -l < "$REF") steps)"; continue; fi
  [ -f "$REF" ] || { echo "missing $REF (run with --record first)"; FAIL=1; continue; }
  if [ "$MODE" = "--strict" ]; then A="$REF"; B="$NEW"
  else sed 's/ state [0-9a-f]*$//' "$REF" > "$OUT/ref$SEED"; sed 's/ state [0-9a-f]*$//' "$NEW" > "$OUT/new$SEED"; A="$OUT/ref$SEED"; B="$OUT/new$SEED"; fi
  if cmp -s "$A" "$B"; then echo "seed $SEED: same as the golden run ($(wc -l < "$REF") steps)"
  else
    FAIL=1
    echo "seed $SEED: DIFFERENT from the golden run. First difference (golden < > now):"
    diff "$A" "$B" | head -4
  fi
done
rm -rf "$OUT"
exit $FAIL
