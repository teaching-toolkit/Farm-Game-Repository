# 01: The timing and story-pacing numbers move from the scripts into one data file

**What to build:** The parent (or an agent) changes how the game *feels* by editing one data file instead of hunting through scripts: the pauses and rain of the playback after a question, how long notifications stay and how many stack, the story ration and the bark rest, the story picture's height, how long the grown-up lock stays open, the snow cap. The game behaves exactly as now.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** refactor

- [x] One data file for these "feel" numbers, next to the rule files, each with a short note on what it does and its unit
- [x] The scripts read them from there; no copy of the number stays in a script
- [x] Gameplay rules stay in the rule file of the system that owns them (weights, quality, reveal, prices are already in data)
- [x] `docs/design/README.md` gets a short "Where to change a number" table: topic → data file
- [x] Golden runs identical; smoke test passes; old saves load

## Why not one file for every number (Claude's push-back, accepted direction)

The game's rule numbers already live in data, one file per system (`rules/45-weight.json`, `47-quality.json`, `60-reveal.json` …), which the
bot and the explorer read. Pulling them all into one big file would make every system depend on it and turn it into thousands of lines.
What is missing is (a) the handful of timing and pacing numbers that are still constants in scripts, and (b) one table that says where
each kind of number lives. This ticket does both.

Coordinate with `interruption-queue`: if that module is built first, the notification and story-pacing numbers move with it.

## Plan (30 Oct 2026)

- **Goal:** the "feel" numbers in one file, `data/farm/rules/65-feel.json` (key `feel`, read as `G.meta.feel`), each with a note and its
  unit. Same values as now, so nothing changes in play.
- **What moves:** playback (pause 0.8 s, rain 1.2 s, plant flicking 0.9 s, last moment 0.4 s, 0.3 s per plant stage on the map);
  notifications (5 s, hints 3 s, "New" 6 s, at most 4 at a time); story (at most one piece per 3 questions, bark rest 12 questions,
  story picture 520 px high); grown-up lock open 300 s; snow caps 5 % of a picture's height.
- **Files:** `playback.gd`, `iso_field.gd`, `storybox.gd`, `menu.gd`, `notes.gd`, `main.gd` (sets the stack size), `season.gd` (sets
  the snow depth on its material), `systems/story.gd` and `tests/story_test.gd` (reads the bark rest through a function).
- **Left in place on purpose:** the reusable kits (`kits/ui/notifications.gd`, `kits/ui/season.gdshader`) keep their own defaults; the
  game sets its values from the data. Layout and drawing constants (grass scale, cell sizes, avatar pitch) are not "feel" numbers.
- **Old saves:** untouched (no save key). **Bot:** nothing new to learn. **Checks:** `check_all.sh --short` with golden identical,
  the story test, `check_data.py`; the README table in `docs/design/`.

## Done (30 Oct 2026)

Built as planned: `data/farm/rules/65-feel.json` with 13 numbers (value, unit, note), read through `G.feel("group.name")`; the constants
are gone from `playback.gd`, `iso_field.gd`, `storybox.gd`, `menu.gd`, `notes.gd` and `story.gd`; `main.gd` sets the note stack size and
`season.gd` the snow depth from the data. `tools/check_data.py` fails if a number lacks a value, unit or note, or if a script reads a
name the file doesn't have (tested with a misspelt name). `docs/design/README.md` has the "Where to change a number" table.
Checks: `check_all.sh --short` green, short and full golden runs identical, story test passes with `bark_rest()`.

---
Parent, 30 Oct 2026 (review pass, round 3; `assumptions/05`).
