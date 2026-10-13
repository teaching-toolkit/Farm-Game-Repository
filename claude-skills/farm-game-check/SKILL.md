---
name: farm-game-check
description: Use whenever code, data or texts of the Farm Quiz Game (this project) have changed, before saying anything works or is done, when a check fails or the game misbehaves, and when the web version needs exporting. Covers setting up Godot, the smoke test, the bot and the learner simulation, iPad screenshots, debugging by root cause, an independent review of bigger changes, and the web export.
---

# Farm Quiz Game: check, debug, review, export

Run everything from `godot-prototype/`. `G` is the Godot binary. Every test flag: `godot-prototype/README.md`
("Testing shortcuts", "Automated checks"). Start of a session and keeping the record: `claude-skills/farm-game-session/SKILL.md`.

## 1. Set up Godot (once per session)

```bash
ls $HOME/godot/ 2>/dev/null || bash godot-prototype/tools/setup_godot.sh --screens   # add --web to export, --art for pictures
G=$(ls $HOME/godot/Godot_v4.7.2-stable_linux.* | head -1)
```

The setup script works on x86_64 (cloud) and arm64 (the VM on the parent's Mac). Godot comes from github.com, redirected to
`release-assets.githubusercontent.com`; if the network refuses, say so and stop (don't look for other download sites).

**Cloud session:** run in place. The first time: `cd godot-prototype && $G --headless --path . --import`. `web-build/` is not
in the repo. Harmless messages: "ALSA … ERR_CANT_OPEN" / "All audio drivers failed" (no sound card; `--audio-driver Dummy`
silences them) and "RIDs … leaked" at exit.

**Linked computer (Cowork device shell):** every shell call starts fresh, so set `G` again in each call, and pass the longest
timeout (180 s). Run the checks on a work copy so that Linux Godot's cache stays out of the parent's folder. Refresh the copy
right before every run, so the checks always see the latest edits:

```bash
mkdir -p $HOME/work/proj && rsync -a --delete --exclude .godot "$HOME/mnt/Farm game/godot-prototype/" $HOME/work/proj/
cd $HOME/work/proj && $G --headless --path . --import   # only the first time, or after new pictures or sounds
```

Always edit the real files in the folder, never the copy.

## 2. The checks

After any change to the game, run all three, and read the whole output:

```bash
timeout 178 bash tests/check_all.sh      # smoke test + save fixtures + places and pets + golden run + translations in one go (~120 s)
timeout 170 $G --headless --path . --audio-driver Dummy res://tests/ui_smoke.tscn
timeout 170 $G --headless --path . --audio-driver Dummy res://tests/bot.tscn -- --chapter=5 --iters=1100
timeout 170 $G --headless --path . --audio-driver Dummy -s res://tests/learn_sim.gd     # when Rest or the curriculum changed
```

What a pass looks like:
- **Smoke test:** prints its findings and reports no errors. "leaked" and audio-driver warnings at the end are harmless.
  If it prints **nothing** and stops at the timeout, a script has a parse error: find it with
  `$G --headless --path . --check-only -s res://<the script you changed>`. ("Identifier not found: Sound" from `--check-only`
  is expected.)
- **Bot:** reaches chapter 3 after about 290–530 Time Quiz answers and chapter 5 after about 690–870 (with the first four
  pets; the alpaca is chapter 5's own goal, which the bot stops before). A run takes about 30–75 seconds. It plays randomly
  (7 Oct 2026: 678, 715, 763, 774, 689, 793; 12 Oct 2026 on the Mac's Linux shell: chapter 5 at 686, 866, 850, 690, 771, 858,
  chapter 3 at 362, 526, 329, 326, 289, the spread is wider than first thought); if one run falls outside the range, run it twice more before concluding
  anything. If the change is meant to alter the pace, say by how much and update the numbers here and in the prototype README.
  A new mechanic needs the bot to learn it, or the bot no longer tests the game. `--trace=N` prints the first N questions;
  `--flex` plays with dynamic difficulty; `--accuracy=0.8` misses a share of first tries in the Time Quiz.
- **Golden run** (`tests/golden.sh`, part of `check_all.sh`): the bot plays seeds 1 and 2 to chapter 5 (741 and 639 steps,
  12 Oct 2026) and must match `tests/golden/` step by step. A restructuring that changes it changed the rules: find out why
  before going on. Only a change to rules or numbers made on purpose is recorded anew (`bash tests/golden.sh --record`), and
  the log says so.
- **Save fixtures** (`tests/fixtures_test.tscn`): every save in `tests/fixtures/` loads, plays on and saves unchanged.
- **Save versions** (`tests/saves_test.tscn`, part of `check_all.sh`): a new game has the keys and values of `tests/golden/newgame.json`, every save key has
  one owner, old saves are upgraded, a save from a newer game is kept. A new save key or a new `SAVE_VERSION` step on purpose: add it to the owner's
  `save_defaults()` / `Game.save_steps()`, record the new-game state anew (`… saves_test.tscn -- --seed=1 --record`), and say so in the log.
- **Places and pets** (`tests/places_test.tscn`, part of `check_all.sh`): `data/farm/places.json` and the rules in `game/farm/spots.gd` must
  give the place of every data node, the tables, and the chapter and luck for every set of pets exactly as `tests/golden/places.json`
  recorded (13 Oct 2026, from the code before slice R2). A new place, pet or chapter made on purpose is recorded anew:
  `$G --headless --path . res://tests/places_test.tscn -- --seed=1 --record`, and the log says so.
- **Data checks** (`python3 tools/check_data.py`, part of `check_all.sh`): every id a node, recipe, chapter, place or perk names exists, costs and
  effects use known keys, conditions parse, card questions are well-formed and their ids unique, every node lands at a known place. Errors fail the
  check; warnings are for a look.
- **Texts changed:** `python3 tools/i18n.py --check` exits with 0.
- **Progression data changed:** `python3 tools/check_data.py`, `python3 tools/sync_progression.py`, then the explorer check. From the project root, in one
  call (a server started in the background dies when the call ends):

  ```bash
  cd progression && (python3 -m http.server 8765 >/dev/null 2>&1 &) && sleep 1 && \
    NODE_PATH=$(npm root -g) node ../godot-prototype/tools/explorer_check.js http://localhost:8765/progression-explorer.html; \
    pkill -f "http.server 8765"
  ```

  It prints the playthrough hours, answers, checks and pets; compare them with `00-READ-ME-FIRST.md` §7. **The real game's pace** is the bot's report:
  `bash tools/update_explorer.sh` (about 3 minutes; the parent's double-click `Update explorer.command` does the same) lets the bot play seeds 1 and 2 to chapter 5
  (`--report=FILE`), and writes data and report into the explorer's Pacing tab; use its numbers (Time Quiz and Rest answers and hours per chapter) when a
  change is meant to alter the pace. The explorer's own simulation below it is the older model and is not updated for new systems (TODO T3). It needs Playwright
  (there in cloud sessions; if it is missing on the linked computer, say so rather than skipping silently).

Without `--seed` the bot and the smoke test leave their farm in the default save; with `--seed=N` they leave the device alone.

## 3. Look at it

The checks can't see layout. Take a screenshot of every screen the change touches, as on the iPad (834×1194), in English and,
if texts changed, in German:

```bash
xvfb-run -a -s "-screen 0 1280x1400x24" $G --path . --resolution 834x1194 --rendering-driver opengl3 --audio-driver Dummy \
  -- --newgame --timestep=20 --shot=OUT.png [--spot=kitchen] [--lang=de] [--qid=PIC-004] [--rest] [--menu]
```

Put `--seed=1` first (a fresh farm, the same every time, nothing saved), or `--newgame` / `--player=Shots`, otherwise the screenshot shows the bot's farm. Then open the picture and look:
do texts fit, are there words on the map, are all numbers whole, would an 8-year-old understand it?
On a linked computer, save screenshots to `Farm game/Claude outputs/screens/` and stage them to view (git ignores that
folder; it is for transfers).

## 4. Evidence before claims

Adapted from *verification-before-completion* in obra/superpowers (MIT).

- Don't say "done", "fixed" or "works" unless you ran the check after your last edit, in this session, and read its output.
- Report what you saw, with numbers: "smoke test: no errors; bot: chapter 5 at 731 answers; screenshots of the kitchen in EN and DE".
- A subagent's report of success is not evidence: look at the changed files and run the checks yourself.
- If a check could not run (no Godot, no network, a timeout), say so plainly instead of claiming a result.
- List what the checks can't show (how it feels on the iPad, touch, sound, whether the child gets it) for the parent to test.

## 5. When something fails: find the cause first

Adapted from *systematic-debugging* in obra/superpowers (MIT).

1. Read the whole error and stack trace. Reproduce it with the smallest set of flags (a single `--spot`, `--qid`, `--give`,
   `--unlock` or a bot `--trace`).
2. Look at what changed: `git --no-optional-locks diff`, recent log rows.
3. State one cause you suspect and why. Make the smallest change that tests it, and run again. Don't stack fixes.
4. Fix the cause, not the symptom. No "while I'm here" changes inside a fix.
5. **After three failed fixes, stop.** Write down what you know and talk to the parent about the approach, instead of trying a fourth.

## 6. Independent review of bigger changes

For a new mechanic, a change to the save data, a change to the game rules in `game/farm/game.gd` or `game/farm/systems/`, or more than about 150 changed
lines: start a fresh subagent that did not write the code and give it

- the changed files or the diff, the task text and its plan from `TODO.md`, and the design document's section;
- the parent's rules (`00-READ-ME-FIRST.md` §4.6);
- this brief: "Find concrete problems with file and line: bugs, old saves that would no longer load, texts outside `tr()` or
  missing German, numbers that aren't whole, texts too hard for an 8-year-old, anything that punishes the child, words on the
  map, a mechanic the bot doesn't play. No praise, no summary."

Check each finding yourself before acting on it; reviewers are wrong too. Fix the real ones and rerun the checks.

## 7. Web export

Only when asked, or when the parent is about to test on the iPad. The parent can also do it alone with `Build web version.command`
on the Mac. **Publishing** to the public repo is always the parent's (`Publish web version.command`; it needs their GitHub login).

- **Cloud session:** `web-build/` is not in the repo; don't export unless asked.
- **Linked computer:** needs `setup_godot.sh --web` (about 1 GB). Run it in one foreground call, from the work copy:

```bash
ls -l "$HOME/mnt/Farm game/web-build/index.pck"
cd $HOME/work/proj && timeout 170 $G --headless --path . --export-release Web "$HOME/mnt/Farm game/web-build/index.html"
ls -l "$HOME/mnt/Farm game/web-build/index.pck"    # it must have changed
```

The export filter in `export_presets.cfg` must include every data folder (for example `data/i18n/*.json`). Afterwards, note in
`00-READ-ME-FIRST.md` §5 that `web-build/` matches the code.
