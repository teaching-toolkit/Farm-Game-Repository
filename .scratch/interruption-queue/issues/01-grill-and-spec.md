# 01: Grill and spec: what takes the screen next

**What to build:** Settle candidate 4 of `docs/architecture-review-2026-10-22.md` with the parent, then write the spec and the build tickets. One interruption queue on the interface side decides what shows, in what order, and what counts as quiet. It would make the story timing issues C2, C7 and C8 a matter of numbers in one place. It pays off mainly if the 166 new story pieces (I15) go in. 

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** refactor

**Size:** sitting

- [x] `/grill-with-docs` run with the parent on this candidate; the seams for testing agreed (the highest seam possible, ideally one)
- [x] `spec.md` written in this folder from the `/to-spec` template
- [x] Build tickets filed in this folder with `/to-tickets`, blockers set
- [x] The plan keeps the golden runs identical: this changes no game rule

## 💡 Recommendation (30 Oct 2026)

After `condition-language`. It unblocks `story/07` (C2, C7, C8) and decides where the notification and story timings in `tuning/01` live.

---

**Feature:** `interruption-queue` · **Source:** `docs/architecture-review-2026-10-22.md`, Part B, candidate 4 (Worth exploring). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.

## Grilling (2 Nov 2026)

Round 1 (parent: yes to all three):

1. **What the queue owns:** everything that arrives on its own and wants the screen: the celebration, the postcard, story boxes,
   barks, the notes after a pop-up closes, and the new boxes of `story/13–15`. The screens the child opens herself (Time Quiz, Rest,
   cards, sheets, menus) stay outside and only count as busy; so do the flights to the store and the farm-news playback (animations).
2. **A pure refactor first:** nothing the child sees changes (same order, same quiet rule, same moments). C2, C7 and C8 are fixed
   later in `story/07` as numbers in `rules/65-feel.json`.
3. **Which story piece:** `G.story` keeps deciding which piece is ready and the one-per-3-questions ration; the queue decides only
   whether and when the screen is free and the order between kinds.

Round 2 (parent: yes to all three):

4. **One order list as data:** the order of kinds and what each kind waits for are one list in `rules/65-feel.json`, today's order
   unchanged (notes after a pop-up, postcard, celebration, story box, bark last; a celebration or postcard may come over a sheet, a
   story box waits for it unless it is a Discovery). `story/13–15` each add their line when they are built.
5. **Not saved:** the queue itself is not saved; owners keep what must survive (postcards in the rewards, story readiness in
   `G.story`). A celebration waiting when the game closes stays lost, as today; separate prototype ticket, later.
6. **One test seam:** the queue without drawing (requests in; told when a screen opens or closes), a headless
   `tests/interruption_test` in `check_all.sh` with the real pile-ups; the smoke test and EN/DE screenshots show nothing changed.
   Golden runs untouched (the bot draws no interface).

Shared understanding confirmed by the parent (2 Nov 2026). Glossary: interruption, quiet. Spec `spec.md`; tickets `02`–`04` (refactor) and `05` (later). The seam: the queue without drawing, one headless test. `story/07` (C2, C7, C8) and `story/13–15` (new kinds of box) now wait on `interruption-queue/04`.
