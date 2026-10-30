# 01: Grill and spec: one condition language

**What to build:** Settle candidate 3 of `docs/architecture-review-2026-10-22.md` with the parent, then write the spec and the build tickets. One condition module owns the grammar (with `not:` and `<`), a registry in which each system registers its own words, and a way to list the vocabulary for the checker. The pets' WHEN cards become ordinary conditions. This is what the story timing issues C5 and C6 wait for (and probably C3). 

**Blocked by:** None (can start immediately)

**Status:** needs-parent

**Milestone:** refactor

**Size:** sitting

- [ ] `/grill-with-docs` run with the parent on this candidate; the seams for testing agreed (the highest seam possible, ideally one)
- [ ] `spec.md` written in this folder from the `/to-spec` template
- [ ] Build tickets filed in this folder with `/to-tickets`, blockers set
- [ ] The plan keeps the golden runs identical: this changes no game rule

## 💡 Recommendation (30 Oct 2026)

After `time-question`. It unblocks `story/07` (C5, C6); start from the review's Part B §3.

---

**Feature:** `condition-language` · **Source:** `docs/architecture-review-2026-10-22.md`, Part B, candidate 3 (Strong). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.
