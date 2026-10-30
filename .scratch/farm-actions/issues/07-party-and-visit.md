# 07: Party and visit

**What to build:** Wellbeing's party and visit go through the module. They run only in part in chapters 1 and 2, so the full golden pair is required.

**Blocked by:** farm-actions/03

**Status:** done

**Milestone:** refactor

- [x] Party and visit use the module for button and effect (the bot never plays them, so there is nothing to change there)
- [x] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [x] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 23 Oct 2026. Chores `throw_party` and `visit_friend`; base energy is the number in `rules/55-well.json` (`well.party.energy`, `well.visit.energy`). New data flag `raw` in `rules/46-chores.json`: the energy is the written number and no skill, tool, season or buff changes it (as the old code did; making a party cheaper with skills would be a rule change, not done here). The party's dishes (the cheapest in the store) are the `extra` cost. Requirements and effects are in `well.gd` (`register_chores`); `party_check`, `party`, `visit_check` and `visit_go` are deleted; the well sheet asks `check` and calls `perform`. `visited()` (the scene after the question) stays in the well system: it is the second half of the visit, not a chore. Checks: `actions_test` 15,065 checks, `well_test` 42, `check_all.sh --short` green, full golden seeds 1 and 2 identical. The golden bot never throws a party or visits, so the tests cover these two chores, not the golden run.

Visible difference: too little energy gives the generic "Too tired. Rest a little (tap ⚡)." instead of "Too tired for a party / for a visit".

---

**Feature:** `farm-actions` · **Source:** `.scratch/farm-actions/spec.md` in this folder and the decisions in `.scratch/farm-actions/issues/01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
