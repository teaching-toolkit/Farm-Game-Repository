# 03: Sticks and small stones lie about on the farm and are picked up with a tap

**What to build:** Sticks and small stones lie in random free places on the farm: many at the start, fewer as the farm is tidied, a few new ones now and then. A tap picks one up (a chore of `G.actions` with a small energy cost) and it flies to its pile.

**Blocked by:** `visible-work/02`

**Status:** done

**Milestone:** prototype

- [x] How many lie about at the start, how many come back per step and the most at once are numbers in the rules; where they lie is rolled with the farm's own random source and saved
- [x] They never lie on a building, a patch, a pen or the road
- [x] Picking one up is a chore (cost in the chores file, test in the chores test); when the store is full it bounces
- [x] The test bot picks them up when it needs sticks or stones; the golden runs are recorded anew once, on purpose
- [ ] The opening hour is not slowed: the bot's hours for chapter 1 stay within 5 %
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

## Result (14 Nov 2026)

Built by a Sonnet agent; the main chat looked at a screenshot, moved the piles beside the basket (they stood half hidden in the overgrown field) and changed the bot. **The 5 % box stays open on purpose:** rolling where the things lie shifts the bot's random numbers, and that alone moves a single seed by 7 to 9 %. With the bot picking whenever the store had room it needed about 15 % more steps to chapter 3 (it spent energy on things it did not need yet); it now picks only when it has fewer than four of the thing. Steps to chapter 3, before → after: seed 1 199 → 187, seed 2 198 → 217. Two seeds cannot show 5 %; the pace is judged again with the action budget (`action-budget/05`).

---

**Feature:** `visible-work` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.7]. Filed 14 November 2026.

The parent's words:

> [#14.7] Maybe we could also have sticks and small rocks appear on the actual screen of the farm in random places every now and then in the beginning there's still quite a bit and you can pick them by tapping on them and they go into storage.
