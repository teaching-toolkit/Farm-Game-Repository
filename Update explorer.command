#!/bin/bash
# ------------------------------------------------------------------
# Update explorer.command  -  double-click me on the Mac.
# Refreshes progression/progression-explorer.html from the game as it
# is now: checks the data, lets the test bot play the real game and
# writes what it needed (questions, Rest answers, hours per chapter).
# Needs Godot.app in /Applications and python3. Takes about 4 minutes.
# ------------------------------------------------------------------
cd "$(dirname "$0")/godot-prototype" || exit 1
bash tools/update_explorer.sh
STATUS=$?
echo
read -r -p "Press Enter to close this window..." _
exit $STATUS
