# 02: Piles of sticks, small stones and big rocks grow beside the basket and the store

**What to build:** Beside the basket (later the store building) stand piles of the bulky things the farmer gathers: sticks, small stones, big rocks. Each pile has four sizes and grows with what is stored. When the store has no room for a thing, the top of its pile tumbles off and the thing bounces back to where it came from.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Which things have a pile, where each stands and the amounts at which a pile grows are data
- [x] A pile shows the size that matches the stored amount, and changes at once when the amount changes
- [x] Gathered things fly to their pile, not to the bar
- [x] When the store is full the bounce of `money-market/08` starts at the pile, with a small tumble
- [x] Stand-in pictures from what the game has; the painted piles join `pictures/15`
- [x] A test sets amounts and checks which size is shown
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

---

**Feature:** `visible-work` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.7]. Filed 14 November 2026.

The parent's words:

> [#14.7] Maybe the stack of sticks and rocks could be next to the basket and later on the building of the storage and we could see it get larger and larger in at some point when there is too much tops over and we get the bouncing off signal.
