# 08: Forest trips

**What to build:** Each trip in and out of the forest is a chore through the module. Its cost (a Time Quiz question each way) and the basket's room are requirements with reason keys.

**Blocked by:** farm-actions/03

**Status:** done

- [x] Forest trips use the module for button, effect and bot
- [x] The old "Too tired" copy in the forest system is gone
- [x] The basket's room is a requirement with its own reason key
- [x] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [x] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 23 Oct 2026. Chores `forest_find`, `forest_pick`, `forest_dig`, `forest_look`, `forest_enter`, `forest_leave` (data in `rules/46-chores.json`, requirements and effects in `forest.gd`). A task of a spot is `forest_<kind>` with args `{"spot","tid"}` plus `{"option"}` (find) or `{"part"}` (pick). The gathering energy is `forest.pickEnergy` with category `gather`; a look costs none and the two walks cost no energy of their own, as before. The Time Quiz question each way is not a module cost yet: the forest sheet still asks it (like the market trip); it joins the module with `action-budget/01`. The basket's room is the requirement `basket_full`, checked before the energy as the old code did. New in the module: `perform` returns `result` (here `{"good"}`: was the plant or the part right). `forest.gd` lost `can_do`, `do_find`, `do_pick`, `do_gives`, `enter`, `leave`, `pick_energy` and its "Too tired" line. Checks: `actions_test` 17,790 (price match over 108 situations, hair-too-little cases, requirements), `forest_test` 27, short and full golden seeds 1 and 2 identical, i18n complete.

Visible differences: too little energy gives the generic "Too tired. Rest a little (tap ⚡)." (same words as before); the task buttons still show no energy price (a candidate for the grey-button reasons, `interface-feel/02`); a refused task now says why once.

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
