# 15: Decide: the unused seed-buying path in planting

**What to build:** Planting has a seed-buying path that never runs (the amount to buy is always zero). Decide: remove it, or make it a real feature.

**Blocked by:** farm-actions/13

**Status:** done

**Milestone:** refactor

- [x] A 💡 recommendation is written in this ticket
- [x] The parent decided (✅ 30 Oct); the code and the ticket match
- [x] If removed: golden runs identical

## 💡 Recommendation (30 Oct 2026)

**Remove it.** Seeds are bought at the market or from the merchant (trade system, which works), and a second hidden way to buy seeds
in the planting window would go round the trip and the Lord's share. Golden runs stay identical, because the path never runs.

Other option: make it a feature ("buy the missing seeds while planting"). It saves the child a trip, but it undoes the reason for the
first trip to the village (ADR-0006 and the trip rules) and needs its own design.

## ✅ Parent's answer (30 Oct 2026)

Yes: remove the path. Golden runs must stay identical.

## Done (30 Oct 2026)

The path is gone from planting: the plan no longer carries seeds to buy or their coins, and the planting effect no longer buys. Seeds
are bought only on the village square. Checked with only this change applied: short golden runs seeds 1 and 2 identical; all checks of
`check_all.sh --short` pass.

---

**Feature:** `farm-actions` · **Source:** `.scratch/farm-actions/spec.md` in this folder and the decisions in `.scratch/farm-actions/issues/01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
