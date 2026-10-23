# 01: Grill and spec: what takes the screen next

**What to build:** Settle candidate 4 of `ARCHITECTURE-REVIEW-2026-10-22.md` with the parent, then write the spec and the build tickets. One interruption queue on the interface side decides what shows, in what order, and what counts as quiet. It would make the story timing issues C2, C7 and C8 a matter of numbers in one place. It pays off mainly if the 166 new story pieces (I15) go in. 

**Blocked by:** None (can start immediately)

**Status:** needs-parent

- [ ] `/grill-with-docs` run with the parent on this candidate; the seams for testing agreed (the highest seam possible, ideally one)
- [ ] `spec.md` written in this folder from the `/to-spec` template
- [ ] Build tickets filed in this folder with `/to-tickets`, blockers set
- [ ] The plan keeps the golden runs identical: this changes no game rule

---

**Feature:** `interruption-queue` · **Source:** `ARCHITECTURE-REVIEW-2026-10-22.md`, Part B, candidate 4 (Worth exploring). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.
