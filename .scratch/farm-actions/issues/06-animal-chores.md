# 06: Animal chores: muck out and collect

**What to build:** The animals system uses the module for its chores and loses its "Too tired" copy.

**Blocked by:** farm-actions/03

**Status:** done

**Milestone:** refactor

- [x] Animal chores use the module for button, effect and bot
- [x] The old "Too tired" copy in the animals system is gone
- [x] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 23 Oct 2026. Chores `collect_animal` and `muck_out` (args `{"aid"}`); base costs in `rules/46-chores.json` (muck out's base is the one number `muck.energyPerMuck`, the amount of muck scales it; collecting scales `collectEnergy` by the number of animals). Requirements and effects are in `animals.gd` (`register_chores`); wear (`use:animal`) and practice (`animals`) are in the data. The feed and water are the `extra` cost kinds (`feed_cost`); the module now spends any other cost kind as an item (`Doer.take_item`; coins are still not a chore cost). `feed_needs`, `collect_animal`, `muck_out` and the sheet's `_feed_base` are deleted: the animal card asks `check`, the bot calls `perform`. Checks: `actions_test` 13,978 checks, `check_all.sh --short` green, full golden seeds 1 and 2 identical.

Visible differences, none in numbers: (1) too little energy gives the generic "Too tired. Rest a little (tap ⚡)." for collecting and mucking out (collecting used to say "<animals> need ⚡ energy"; feed and water are still named in that sentence); (2) on the collect card the energy now comes first in the cost row, then feed and water (it was last); (3) polish wear and skill practice now run in the order wear, practice (was practice, wear): independent, golden unchanged.

---

**Feature:** `farm-actions` · **Source:** `.scratch/farm-actions/spec.md` in this folder and the decisions in `.scratch/farm-actions/issues/01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
