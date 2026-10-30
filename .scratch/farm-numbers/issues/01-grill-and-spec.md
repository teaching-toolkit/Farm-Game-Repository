# 01: Grill and spec: the farm's numbers behind their owners

**What to build:** Settle candidate 5 of `docs/architecture-review-2026-10-22.md` with the parent, then write the spec and the build tickets. Energy, water and coins get an owner with a tiny interface (spend, gain, can I afford) that clamps, signals and keeps a per-step tally. Most of it falls out of farm actions; done alone it is a lot of churn for little gain. It does not reopen the flat save (R7). 

**Blocked by:** the whole `farm-actions` feature (all its tickets done); most of this falls out of it

**Status:** needs-parent

**Milestone:** later

**Size:** sitting

- [ ] `/grill-with-docs` run with the parent on this candidate; the seams for testing agreed (the highest seam possible, ideally one)
- [ ] `spec.md` written in this folder from the `/to-spec` template
- [ ] Build tickets filed in this folder with `/to-tickets`, blockers set
- [ ] The plan keeps the golden runs identical: this changes no game rule

## 💡 Recommendation (30 Oct 2026)

Parked (`later`): grill it only when the prototype stands.

---

**Feature:** `farm-numbers` · **Source:** `docs/architecture-review-2026-10-22.md`, Part B, candidate 5 (Speculative). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.
