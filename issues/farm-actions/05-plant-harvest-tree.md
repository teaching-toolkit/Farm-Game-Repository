# 05: Plant, harvest and cut tree

**What to build:** The three chores with the most rules go through the module. Planting checks the total effective cost of the whole plan, as the working planting check does. Harvest keeps the roll order of luck, then grade, then per item. Cutting a tree reproduces the orchard energy multiplier as it is now (changing it is ticket 16).

**Blocked by:** farm-actions/04

**Status:** done

- [x] Plant (the plan total), harvest and cut tree use the module for button, effect and bot
- [x] The order of random rolls is unchanged: luck, grade, per item
- [x] Job progress, perk checks, luck rolls and statistics stay in the effect code
- [x] The orchard tree multiplier is reproduced exactly
- [x] The dead seed-buying path in planting is left alone (ticket 15)
- [x] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [x] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 23 Oct 2026. Effects and requirements for `plant`, `harvest` and `cut_tree` are in `fields.gd` (`register_chores`); their base costs in `rules/46-chores.json`. The module got two optional hooks: `extra` (planting's water, merged into cost and base) and `no_mult` (orchard trees skip the second `energy:field`, as before). Planting recomputes its plan in the effect with the water added back, because the module has already taken it. Wear and practice are in the data (`wear`, `practice`). Whole-field and area harvest are batches. Cutting a tree used `orchard.cutEnergy` from the data, which does not exist: the default 3 is now the written base (ticket 16 decides whether it changes). Dead seed-buying path kept in the effect. Checks: `check_all.sh --short` green, full golden seeds 1 and 2 identical (see log).

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
