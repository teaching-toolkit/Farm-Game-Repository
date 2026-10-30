# 09: The village trip

**What to build:** The trip to the village is a chore through the module. Its errand energy multiplier is in the data entry.

**Blocked by:** farm-actions/03

**Status:** done

**Milestone:** refactor

- [x] The village trip uses the module for button, effect and bot
- [x] The errand multiplier is data, not code
- [x] The old "Too tired" copy in the trip system is gone
- [x] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [x] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 23 Oct 2026. Chore `village_trip` (data in `rules/46-chores.json`, requirements and effect in `trip.gd`, `register_chores`). The errand multiplier (`energy:errand`), the rounding up (`round: up`) and the minimum (`min`, a path to `trip.energy.min`) are data; the base is `trip.energy.base`. What a better road saves is a factor on the base (`_road_factor`: `roadSaving` per level above 1, never below `roadFloor`), read from `49-trip.json` as before. Module change: `raw` no longer switches off `mult` (it only skips skills, tools of the trade, season and buff); new keys `round` and `min`. `trip.gd` lost `energy_cost`, `can_go` and `go`. `arrive` and `leave` are phase changes without a cost and stay. The market sheet shows the price from `check` and calls `perform`; the bot does the same. Checks: `actions_test` 18,443 (price match over 108 situations, with and without the best road, hair-too-little, a second trip refused), `trip_test` 36, short and full golden seeds 1 and 2 identical.

Visible difference: too little energy gives the generic "Too tired. Rest a little (tap ⚡)." instead of "Too tired for the walk. Rest first."

---

**Feature:** `farm-actions` · **Source:** `.scratch/farm-actions/spec.md` in this folder and the decisions in `.scratch/farm-actions/issues/01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
