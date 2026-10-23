# Farm Quiz Game: start here

How to work on this project lives in three skill files in `claude-skills/` (ordinary files; read them like any other):

1. **Always first:** `claude-skills/farm-game-session/SKILL.md`: what to read for which task (not everything), how to plan
   bigger steps, how to keep the log and the to-do list current, and git.
2. **Before saying a change works, and to set up Godot on a fresh cloud machine:** `claude-skills/farm-game-check/SKILL.md`.
3. **For questions, cards, texts and German, numbers, sounds, pictures, the map layout:** `claude-skills/farm-game-content/SKILL.md`.

**Standing rule:** keep `TODO.md`, the tickets in `issues/` and `PROJECT-LOG.md` up to date *as you work*, not just at the end (details: the session
skill, §4). **Story work:** read `story/README.md` first and keep the files in `story/` current as you go.

**Tracker:** open work is one file per ticket in `issues/<feature>/`, with a status (`ready-for-agent`, `needs-parent`, `done`). `issues/README.md` holds the rules (layout, statuses, where specs go) that the skills `to-spec`, `to-tickets` and `tdd` need; `TODO.md` is the index (one line per open ticket).

`web-build/` is **not** in this repo (it is a separate public repo the parent publishes from the Mac), so a cloud session does
not need to export it unless asked.
