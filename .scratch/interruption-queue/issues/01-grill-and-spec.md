# 01: Grill and spec: what takes the screen next

**What to build:** Settle candidate 4 of `docs/architecture-review-2026-10-22.md` with the parent, then write the spec and the build tickets. One interruption queue on the interface side decides what shows, in what order, and what counts as quiet. It would make the story timing issues C2, C7 and C8 a matter of numbers in one place. It pays off mainly if the 166 new story pieces (I15) go in. 

**Blocked by:** None (can start immediately)

**Status:** needs-parent

**Milestone:** refactor

**Size:** sitting

- [ ] `/grill-with-docs` run with the parent on this candidate; the seams for testing agreed (the highest seam possible, ideally one)
- [ ] `spec.md` written in this folder from the `/to-spec` template
- [ ] Build tickets filed in this folder with `/to-tickets`, blockers set
- [ ] The plan keeps the golden runs identical: this changes no game rule

## 💡 Recommendation (30 Oct 2026)

After `condition-language`. It unblocks `story/07` (C2, C7, C8) and decides where the notification and story timings in `tuning/01` live.

---

**Feature:** `interruption-queue` · **Source:** `docs/architecture-review-2026-10-22.md`, Part B, candidate 4 (Worth exploring). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.
