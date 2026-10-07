# Farm Quiz Game: start here

Before doing anything, read `00-READ-ME-FIRST.md` fully. It explains the project, the folder, how to run and test
the game, the rules the parent has set, and the to-do list (§6).

**Standing rule:** keep `PROJECT-LOG.md` and the to-do list in `00-READ-ME-FIRST.md` §6 up to date *as you work*,
not just at the end (details at the top of `00-READ-ME-FIRST.md`).

## In a cloud session (fresh Linux machine)

```bash
bash godot-prototype/tools/setup_godot.sh              # Godot only (enough for the tests)
bash godot-prototype/tools/setup_godot.sh --screens --art --web   # + screenshots, art import, web export
G=$HOME/godot/Godot_v4.7.2-stable_linux.x86_64          # the script prints the exact path
cd godot-prototype && $G --headless --path . --import    # first time: import resources
```

Then run the checks in `00-READ-ME-FIRST.md` §4.2. `web-build/` is **not** in this repo (it is a separate public repo
the parent publishes from the Mac), so a cloud session does not need to export it unless asked.
