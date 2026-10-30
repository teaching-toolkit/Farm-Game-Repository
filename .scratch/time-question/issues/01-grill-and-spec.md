# 01: Grill and spec: the question that moves time

**What to build:** Settle candidate 2 of `docs/architecture-review-2026-10-22.md` with the parent, then write the spec and the build tickets. The first-try rule (only a right first answer moves farm time) moves out of four near-copies in the interface into one rules function that the bot also calls, so the golden run finally covers it. About one session; a cheap warm-up if a smaller first slice is wanted. 

**Blocked by:** None (can start immediately)

**Status:** needs-parent

**Milestone:** refactor

**Size:** sitting

- [ ] `/grill-with-docs` run with the parent on this candidate; the seams for testing agreed (the highest seam possible, ideally one)
- [ ] `spec.md` written in this folder from the `/to-spec` template
- [ ] Build tickets filed in this folder with `/to-tickets`, blockers set
- [ ] The plan keeps the golden runs identical: this changes no game rule

## Constraint from the parent (30 Oct 2026)

Keep question packs modular: built-in packs and packs the parent pastes in later (`parent-controls/02`) must plug into the Time Quiz the same way, each question with a permanent id (ADR-0007). The module's interface should not care where a pack came from.

## 💡 Recommendation (30 Oct 2026)

Next in the refactor milestone. Run it as `/grill-with-docs` in rounds of three, with the architecture review's Part B §2 as the starting map and the modular-packs constraint above.

---

**Feature:** `time-question` · **Source:** `docs/architecture-review-2026-10-22.md`, Part B, candidate 2 (Strong). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.
