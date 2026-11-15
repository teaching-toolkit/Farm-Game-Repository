# 10: The village square can fill the whole screen, like the farm

**What to build:** On the village square the scene fills the screen, as the farm does. A stall's window opens over it only when a stall is tapped and can be closed again, back to the full scene. Today the window always takes the lower 60 % of the screen.

**Blocked by:** `money-market/09`

**Status:** done

**Milestone:** prototype

- [x] On arrival the square fills the screen; no window is open (if the farmer came for one stall, that stall's window opens)
- [x] A tap on a stall opens its window from below; ✖ or a tap on the scene closes it
- [x] The walk home and the bag's bars stay reachable without a window open (the 🏠 sign and a small bag bar on the scene)
- [x] The test bot and the smoke test still buy, sell, hand over an order and walk home
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

## 💡 Decision taken for the parent (14 Nov 2026)

The window becomes an ordinary sheet over the scene (closable), instead of a fixed lower part. This undoes `money-market/05`'s "no ✖" on the square on purpose: with the scene as the home view, closing a window no longer leaves an empty screen. Easy to undo (one number and one flag).

## Progress (14 Nov 2026)

Not started. The first agent's brief listed too few files: this ticket also needs the sheets part (closing a window, the ✖ on the square), the Time Quiz's arrival on the square and a comment in the main screen. The agent's design, ready to build: the square gets an `arrive()` that opens only the stall the farmer came for, a flag for "a window is open", a scene that takes the full height when no sheet shows, and a tap on the scene's background closes the window; closing a window on the square syncs the square instead of reopening the market; a stall window that was open under the bag comes back when the bag closes. The bag bar in the top bar already counts the carried load on the square, so no second bar is needed on the scene. `money-market/11` also needs the places data, the farm map's gate cart and the place sheet's book cart case.

---

**Feature:** `money-market` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.5]. Filed 14 November 2026.

The parent's words:

> [#14.5] village square should be able to take up the whole screen just like the farm

## Progress

Done: `square.arrive()` (timequiz `_to_square`), `window` flag, full-height scene without a sheet, bare-scene tap closes, `sheets.close_sheet` syncs the square. Bag bar = the top bar's. Not done: German (no new text), `docs/design/`, `check_all.sh` (the parent).
