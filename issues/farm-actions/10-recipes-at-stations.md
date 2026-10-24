# 10: Recipes at stations

**What to build:** A recipe at a station is a chore through the module. Its costs are read from `recipes.json`; there is no second copy. Medicine recipes, the healing skill family and skill rank gates are covered by the full golden pair.

**Blocked by:** farm-actions/03

**Status:** done

- [x] Recipes at every station use the module for button, effect and bot
- [x] Costs are read from the recipe data with no second copy
- [x] Skill rank gates are requirements with reason keys
- [x] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [x] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 23 Oct 2026. One chore, `recipe`, args `{"rid"}` (and `{"n"}`: how many loads; without it a tap makes the biggest load the farmer can pay for, at most `recipe_batch`, as before). Registered in `crafting.gd` (`register_chores`). Costs are read from the recipe: the energy through the chore's **profile** (new, optional: the chore's data for this call: base, category, station), the inputs (with the skill family's saving) and the water as extra costs; `rules/46-chores.json` only says `recipe` is a chore. The fuel is the woodpile's, not an item: a requirement (`fuel`), taken in the new **`before`** hook, which runs once nothing is in the way, before anything is spent. `before` also fixes the loads in args (what is taken changes what could be paid), lets the forest's poison strike (the farmer collapses, nothing else spent; the woodpile's fuel is gone first, as the old code did) and starts the grade tracking of the inputs. Requirement keys, in the old order: `locked` (the recipe's station and cards: this is the recipe's gate), `refill`, `busy`, `keeps`, `missing`, `fuel`, then `energy` from the module. Skill rank gates are not a requirement of a recipe: a rank changes what a recipe costs (inputs, energy, time, grade), and a rank's own gate is a card, tool or station, so there was no rank requirement to move. The recipe check let a hair less energy through than the other chores (0.0001, not 0.001); the full golden run (seed 2) caught it, so the chore's profile carries `slack: 0.0001` (the module reads it; default 0.001). Unifying the two numbers is a tiny rule change for a later decision. Grade roll, skill practice and polish wear stay in the effect: a rank gained now makes this batch quicker, so the module's follow-ups (after the effect) would change the time. `crafting.gd` lost `start_recipe`, `recipe_cost` and `recipe_cost_base`. The station sheet shows the price of the whole load (`check` with `n` = the batch) and calls `perform`; the button is grey only for what check says is lacking (a missing kept thing is still told on the tap). Checks: `actions_test` 27,671 (price match over all recipes in 18 situations: energy, water, inputs and fuel taken equal what check says; a hair too little energy takes nothing; a smaller load when the big one cannot be paid; requirements), `forest_test` (the poison through the real recipe), `skills_test`, `nature_test`, `ui_smoke`, short and full golden seeds 1 and 2 identical.

Visible differences: the cost row on a recipe shows the energy first (as on the field cards); too little energy says the generic "Too tired. Rest a little (tap ⚡)." instead of "Missing: ⚡ n more"; when both something is missing and energy is short the missing thing is told.

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
