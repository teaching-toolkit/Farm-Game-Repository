# 01: The timing and story-pacing numbers move from the scripts into one data file

**What to build:** The parent (or an agent) changes how the game *feels* by editing one data file instead of hunting through scripts: the pauses and rain of the playback after a question, how long notifications stay and how many stack, the story ration and the bark rest, the story picture's height, how long the grown-up lock stays open, the snow cap. The game behaves exactly as now.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** refactor

- [ ] One data file for these "feel" numbers, next to the rule files, each with a short note on what it does and its unit
- [ ] The scripts read them from there; no copy of the number stays in a script
- [ ] Gameplay rules stay in the rule file of the system that owns them (weights, quality, reveal, prices are already in data)
- [ ] `docs/design/README.md` gets a short "Where to change a number" table: topic → data file
- [ ] Golden runs identical; smoke test passes; old saves load

## Why not one file for every number (Claude's push-back, accepted direction)

The game's rule numbers already live in data, one file per system (`rules/45-weight.json`, `47-quality.json`, `60-reveal.json` …), which the
bot and the explorer read. Pulling them all into one big file would make every system depend on it and turn it into thousands of lines.
What is missing is (a) the handful of timing and pacing numbers that are still constants in scripts, and (b) one table that says where
each kind of number lives. This ticket does both.

Coordinate with `interruption-queue`: if that module is built first, the notification and story-pacing numbers move with it.

---
Parent, 30 Oct 2026 (review pass, round 3; `assumptions/05`).
