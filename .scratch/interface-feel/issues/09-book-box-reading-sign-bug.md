# 09: Bug: the book box shows the "something to read" sign when there are no new cards

**What to build:** The sign on the book box appears only when a card is waiting to be read.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The sign shows exactly when at least one unread card exists, and disappears after it is read
- [x] A smoke test covers: new game (no sign), card unlocked (sign), card read (no sign)

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.19]. Filed 23 October 2026.

The parent's words:

> [#23.19] the book box displays the reading sign, even though are no new cards to read

## Result (3 Nov 2026)

- **Cause:** the library lists only cards of the chapters reached (`in_chapter`), but the sign on the book box counted every card. A card of a later chapter whose book and earlier cards are there (e.g. *Compost*, chapter 2, in *The Little Farm Book* once *Ash* is learned) made the 📖 sign in chapter 1 while the shelf showed nothing to read.
- **Fix:** one rule, `mapview.card_shown(cid)` (learned, or its chapter reached), now used by the sign (📖 and ❓), the library shelves and the goal bar's "read a card" hint (it could point at the same hidden card). `game/farm/ui/mapview.gd`, `ui/places/market.gd`, `ui/goalbar.gd`.
- **Agent's choice / note:** a new game is not sign-free: the first card (*Wheat*) needs no reading and its quiz waits from the start, so the ❓ sign shows until it is learned. That is a real unread card, so the sign is right; the smoke test checks it as such. The "nothing waiting, no sign" case is tested with all of the chapter's cards learned.
- **Checked:** smoke test line "book box sign: new game (first card's quiz) true, a later chapter's card makes none true (it is readable true), a card to read true, none while reading true, quiz true, gone when learned true"; with the old badge code the same test fails ("a later chapter's card makes none false"). Unit tests and golden runs: see interface-feel/11's run and the final run in the hand-back.
- **Play-test:** in chapter 1, after learning *Ash*, the book box shows no sign once every chapter-1 card is learned.
