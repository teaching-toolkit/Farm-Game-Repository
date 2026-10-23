# 10: Recipes at stations

**What to build:** A recipe at a station is a chore through the module. Its costs are read from `recipes.json`; there is no second copy. Medicine recipes, the healing skill family and skill rank gates are covered by the full golden pair.

**Blocked by:** farm-actions/03

**Status:** ready-for-agent

- [ ] Recipes at every station use the module for button, effect and bot
- [ ] Costs are read from the recipe data with no second copy
- [ ] Skill rank gates are requirements with reason keys
- [ ] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [ ] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [ ] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
