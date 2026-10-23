# 01: Grill and spec: farm actions, one module that prices, checks and pays

**What to build:** Settle candidate 1 of `ARCHITECTURE-REVIEW-2026-10-22.md` with the parent, then write the spec and the build tickets. One module, owned by the rules, answers "what would this cost and can I do it?" and "do it" for every action (plant, harvest, weed, clear snow, cut tree, fetch water, muck out, party, visit, buy, go to the village). The interface's buttons then show the price the rule charges. The review recommends starting here. `fields.plant_plan()` is the working prototype of the first half.

**Blocked by:** None (can start immediately)

**Status:** needs-parent

- [ ] `/grill-with-docs` run with the parent on this candidate; the seams for testing agreed (the highest seam possible, ideally one)
- [ ] `spec.md` written in this folder from the `/to-spec` template
- [ ] Build tickets filed in this folder with `/to-tickets`, blockers set
- [ ] The plan keeps the golden runs identical: this changes no game rule

---

**Feature:** `farm-actions` · **Source:** `ARCHITECTURE-REVIEW-2026-10-22.md`, Part B, candidate 1 (Strong). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.
