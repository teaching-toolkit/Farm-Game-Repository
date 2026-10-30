# 13: Delete the old duplicated checks

**What to build:** The contract step: no caller multiplies a chore's modifier by hand and no system keeps its own "Too tired" check. The price-match test covers every chore. This is the end of the refactor; the final full golden run for both seeds happens here.

**Blocked by:** farm-actions/04, farm-actions/05, farm-actions/06, farm-actions/07, farm-actions/08, farm-actions/09, farm-actions/10, farm-actions/12

**Status:** done

- [x] Search finds no remaining manual energy multiplier and no remaining "Too tired" copy
- [x] Every chore is in the price-match test
- [x] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [x] The design document and the farm-game session skill describe the actions module
- [x] A row in `PROJECT-LOG.md`; `GLOSSARY.md` still matches the code words
- [x] The spec's "late systems" list was checked and each entry is covered by the full run or a hand test noted here
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 24 Oct 2026. Searched for hand-made energy prices and "too tired" copies. Left in `game/`: the three field cards in `patches.gd` (cut a tree, harvest, weed) worked out their energy by hand; they now show `check`'s cost and base, and the cut-tree button greys by `check`'s `ok`. The only "too tired" text is the module's own (`actions.gd`); `notes.gd` only plays a sound for lines starting with ⚡. The stale German line "Too tired for the walk. Rest first." is removed from `ui-de.json` (no code used it). Not chores, so left on purpose: `pace.node_cost` / `crafting.polish_cost` (goals and polish are priced by category, not chores), `market.gd`'s order card (a goal), `patches.gd` is the last file that read `G.m("energy:field")`. The price-match test now has a `COVERED` list: every chore in the data must be named there. Docs: design document §5.1, the session skill (a paragraph on chores and the pay function, and the `GIT_OPTIONAL_LOCKS=0` correction), the systems README and `GLOSSARY.md` (new entry *Pay function*).

Late systems (spec list): the Lord's share blocking coins from chapter 3 and the pay function: full golden run + `lord_test` + `_pay_function`; Wren's check and the poisoning: `forest_test`; forest trips and the basket: `actions_test`, `forest_test`; medicine recipes and rank gates: `skills_test`, `nature_test`, golden to chapter 6; wellbeing parties and visits: `actions_test`, wellbeing test; pets' blessings: `pets_test`. **Hand test still wanted** (not covered by any run): the pets' WHEN cards in free play, and the look of the new station and forest sheets on the iPad.

Checks: `actions_test` 27,700; `check_all --short` green; full golden seeds 1 and 2 identical.

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
