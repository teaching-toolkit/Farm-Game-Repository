# 12: Goal and building payments use the pay function

**What to build:** The pace system's goal and building payments use the same pay function as the shops.

**Blocked by:** farm-actions/11

**Status:** done

- [x] Goal and building payments use the pay function; the pace system's own Lord's-share check is gone
- [x] The pay test also covers goals and buildings
- [x] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 24 Oct 2026. `pace.pay` (used by goals, buildings, animals, polish, barter, the gate, the well and others) now takes coins with `G.lord.pay_coins`, so coin payments of every kind fire `paid` (the coins fly) and share the one rule. New `G.lord.coin_refusal(amount, exempt)` answers what `pay_coins` would, without paying; `pace.missing_cost` uses it for its `lord` entry, so the pace system has no Lord's-share check of its own any more. Test: `_pay_function` in `actions_test` now also covers `pace.pay` (blocked while owed, free costs unblocked and silent, one signal when paid, too few coins takes nothing). Visible: coins now fly when a goal, animal or building is paid with coins. Checks: `actions_test` 27,681; `check_all --short` green; full golden seeds 1 and 2 identical.

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
