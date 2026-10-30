# 03: The actions module, with one chore: fetch water

**What to build:** The first end-to-end slice of the new farm system `actions`: check and perform, the data entry for a chore (base cost, energy modifier, skill family), effect registration, the report with a reason key and child-friendly sentence, and the doer as an input. Fetch water is the first chore: its button, its "Too tired" copies, the bot and the end-of-chore follow-ups (polish wear, skill practice, save, redraw signal) go through the module.

**Blocked by:** farm-actions/02

**Status:** done (23 Oct 2026)

**Milestone:** refactor

- [x] The module exists with `check(chore, who, args)` and `perform(chore, who, args)`; check changes nothing
- [x] Cost is an open dictionary of kinds; a requirement has a reason key and a sentence
- [x] Fetch water (field and well) uses the module in the button, in the effect and in the bot; its two old "Too tired" copies are gone
- [x] A chore works with exactly its cost in energy
- [x] The price-match test harness exists and covers fetch water across season, tools, skill ranks, buffs
- [x] The doer is an input and nothing in the module reads the farmer directly
- [x] Golden runs are identical (short and, because the well is shared with late systems, the full pair once)
- [x] New child-facing text is in German through `tools/i18n.py`
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

**Built:** `game/farm/systems/actions.gd` (`G.actions`: `check`, `perform`, `register`, the `Doer`), data `data/farm/rules/46-chores.json` (fetch_water: base energy points to `water.fetchEnergy`, which the progression explorer reads), effect and requirement in `fields.gd` (`register_chores`). The button in the water place and in the "No water left" window, the bot and the smoke test call `G.actions`; `fields.fetch_water` and `fetch_cost` are gone. Test: `tests/actions_test.tscn` (108 situations: season, tools, skills, buffs; part of `check_all.sh`). The "Too tired" sentence for water is now the generic one ("⚡ Too tired. Rest a little (tap ⚡).", already translated). Follow-ups: the data may name `wear` and `practice`; fetch water has neither, as before.

---

**Feature:** `farm-actions` · **Source:** `.scratch/farm-actions/spec.md` in this folder and the decisions in `.scratch/farm-actions/issues/01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
