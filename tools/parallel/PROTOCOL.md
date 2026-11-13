# Protocol for parallel ticket agents (Hazelwood Harvest, 9 Nov 2026)

You build one or two tickets of a Godot 4.7 (GDScript) game for an 8-year-old, in your own private copy of the project, while other agents
work on other tickets at the same time in their own copies. The orchestrator merges your patch into the real project afterwards and
re-checks everything. **The parent (the game's designer) is away: never ask questions, never wait for an answer.**

S = the scratch folder named in your task (the same one the orchestrator used with `tools/parallel/mkcopy.sh`)
NAME = the short name your task gives you.

## 1. Where you work (this matters; a mistake here can destroy the parent's saves)

- **Your copy:** `$S/w/NAME/work` (the whole project: `godot-prototype/`, `docs/`, `.scratch/`, `story/`, `tools/`, ...). Edit ONLY here.
  `$S/w/NAME/base` is the pristine original: never touch it. The real project (the folder the orchestrator
  copied from) and other agents' folders under `$S/w/` are off limits for writing. `archive/`, `art-inbox/`, `sound-inbox/`, `reference-art/` in your copy are
  symlinks to the real ones: read only, never write through them.
- **Godot:** `G=/Applications/Godot.app/Contents/MacOS/Godot` (4.7). **Every Godot command must run with `HOME=$S/w/NAME/home`** (a throwaway
  user folder). Without it the tests overwrite the parent's real saves in `~/Library/Application Support/Godot/`. The smoke test and the bot
  also always get `-- --seed=1` (or another `--seed=N`).
  Example: `cd $S/w/NAME/work/godot-prototype && HOME=$S/w/NAME/home $G --headless --path . --audio-driver Dummy res://tests/ui_smoke.tscn -- --seed=1`
- **First step:** `cd $S/w/NAME/work/godot-prototype && HOME=$S/w/NAME/home $G --headless --path . --import` (about 35 s; again after you add assets).
- macOS has no `timeout`: use the Bash tool's own timeout, or `perl -e 'alarm shift; exec @ARGV' 170 <command>`.
- Every Bash call starts in a fresh shell: `cd` with absolute paths in each command. Never `cd` into the real project.
- Other agents run Godot at the same time, so runs are slower than the documented times.
- **Checks** (from `$S/w/NAME/work/godot-prototype`, always with the HOME above): `bash tests/check_all.sh --short` (about 2 to 4 minutes: smoke test, save
  fixtures, the system tests, short golden runs, data checks, translations, the docs check), `python3 tools/i18n.py --check`, `python3 tools/check_data.py`,
  from `$S/w/NAME/work`: `python3 tools/check_docs.py`. The bot: `... res://tests/bot.tscn -- --chapter=5 --iters=1100 --seed=1`. How to read the output:
  `.claude/skills/farm-game-check/SKILL.md` (written for another machine: skip its Linux and xvfb parts).
- **Screenshots:** the Godot window pops up on the parent's screen for a few seconds. Take few (at most 6), only to check a layout, without xvfb:
  `HOME=... $G --path . --resolution 834x1194 --audio-driver Dummy -- --seed=1 --timestep=20 --shot=$S/w/NAME/shot1.png [--spot=...] ...` (flags: `godot-prototype/README.md`,
  "Testing shortcuts"; `--give` before `--pack` before `--square`). Then look at the PNG with the Read tool.

## 2. What to read first

`CLAUDE.md`, `00-READ-ME-FIRST.md` (§3 are the parent's standing rules: they win over everything), `ROADMAP.md`, `.claude/skills/farm-game-session/SKILL.md`,
`.claude/skills/farm-game-check/SKILL.md`, `.claude/skills/farm-game-content/SKILL.md` (when you touch texts, data, pictures, sounds), `GLOSSARY.md` (say *chore*,
not *action*), the ADRs your change touches (`docs/adr/`), your ticket(s) in `.scratch/`, the `docs/design/` file(s) it changes, `godot-prototype/README.md` and the README of
the systems you touch. Use `grep -n '^#'` and `grep -n '^func'` instead of reading long files whole. Never edit `archive/`.
Work test-first where it fits (a failing test, then the code, then green); keep the diff focused: no refactors and no "while I'm here" changes.

## 3. Rules for decisions

- The ticket is decided: build it. If a detail is not decided and is **easy to undo** (a number in data, a wording, a layout choice), take the simplest sensible 💡 and
  record it in the ticket under `## 💡 Decisions to confirm` with how to undo it.
- If something is **hard to undo** or changes a lasting design (breaks old saves, removes a mechanic, contradicts an ADR or the parent's rules): do not build that part,
  write it into the ticket as a `## Progress` note and report it as BLOCKED. Build what you can without it.
- Old saves must keep loading (a new key goes into its system's `save_defaults()`; a changed layout needs a `SAVE_VERSION` step in `Game.save_steps()`). Numbers live in
  data (`godot-prototype/data/farm/`), never in scripts. Texts go through `tr()` and get German through `tools/i18n.py` (see farm-game-content): German with "ss", never "ß".
  Whole numbers on screen, no words on the map, short simple texts, an effect the child should notice is *shown* (a picture, an animation, a number changing), text only backs it up.
- A new mechanic needs the bot to learn it. A rule change needs a test.
- **Never delete files** (stop referencing them instead). No git write commands. Never download or install anything. Never touch `PROJECT-LOG.md` or `ROADMAP.md` (the
  orchestrator does that). Do not record golden runs, save fixtures or the places golden (`--record`): if your change alters them on purpose, say so with the new numbers and
  which golden files would change; if they change unexpectedly, find the cause.

## 4. Finish

1. Update your ticket(s): tick the boxes, `**Status:** done` only if every box is ticked and the checks are green (otherwise leave `ready-for-agent` and add a `## Progress` note), plus a short `## What was built`.
2. Update the `docs/design/` file(s) your change touches (describe the game as it now is); `GLOSSARY.md` or an ADR only if a lasting decision was made.
3. Run all the checks in your copy, read the whole output. Do not say "works" without running them after your last edit.
4. Clean up your copy (no stray logs, `.orig` or temp files), then run `S=$S python3 <your copy>/tools/parallel/export_patch.py NAME` and read `$S/out/NAME/summary.txt`: it must list only
   files you meant to change. A DELETED line means you deleted something: restore it.
5. **Final report** (the orchestrator reads only this; at most about 60 lines, plain and concrete):
   - what changed and where (files), in a few lines
   - what the checks showed, with numbers; every failure verbatim
   - 💡 decisions to confirm; BLOCKED items
   - golden runs and pace: unchanged, or the new step counts and which golden files would change
   - a ready-to-paste PROJECT-LOG row: `| 9 Nov 2026 | game | ... |` naming the tickets as `feature/NN`
   - what the parent should play-test; known caveats; files the merge may conflict on (shared files such as `main.gd`, `ui_smoke.gd`, `ui_driver.gd`, `ui-de.json`)
