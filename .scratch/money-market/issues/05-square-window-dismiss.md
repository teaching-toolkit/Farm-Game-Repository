# 05: Closing the market window in the square does not send the player back to the farm

**What to build:** Dismissing the market window while in the village square leaves the player in the square. Only the Back home button returns to the farm.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Closing any window in the square keeps the player there
- [x] Back home is the only way back (the question it costs is `money-market/04`'s job)
- [x] Smoke test covers open, close, and still in the square

---

**Feature:** `money-market` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.25]. Filed 23 October 2026.

The parent's words:

> [#23.25] dismissing the market window when in the market square shouldn't automatically put you back on thefarm

## Progress (9 Nov 2026)

Found already built when `money-market/06` was worked on: `close_sheet()` in `ui/sheets.gd` reopens the square while the trip phase is `square`, and the smoke test's "square:" line covers open, close, the bag's ✖ and Back home (it passed in this session's runs). The ticket had not been closed. Only the cost of the walk home (one Time Quiz question) is still open, and it belongs to `money-market/04`.
