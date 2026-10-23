# 05: Plant, harvest and cut tree

**What to build:** The three chores with the most rules go through the module. Planting checks the total effective cost of the whole plan, as the working planting check does. Harvest keeps the roll order of luck, then grade, then per item. Cutting a tree reproduces the orchard energy multiplier as it is now (changing it is ticket 16).

**Blocked by:** farm-actions/04

**Status:** ready-for-agent

- [ ] Plant (the plan total), harvest and cut tree use the module for button, effect and bot
- [ ] The order of random rolls is unchanged: luck, grade, per item
- [ ] Job progress, perk checks, luck rolls and statistics stay in the effect code
- [ ] The orchard tree multiplier is reproduced exactly
- [ ] The dead seed-buying path in planting is left alone (ticket 15)
- [ ] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [ ] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [ ] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
