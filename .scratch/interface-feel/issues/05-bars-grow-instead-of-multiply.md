# 05: Bars stop showing "x 100" or "x 5"; they grow in rows and columns instead

**What to build:** The multiplier next to a bar goes. A bar that must show more simply gets more rows and columns, scaled in both directions, so the number of boxes is the amount.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] No "x n" label next to any bar
- [x] Bars rescale in x and y to hold more rows and columns; they fit any width from 744 up (the HUD fit test)
- [x] Energy, water and cost bars all use it; screenshots checked

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.30]. Filed 23 October 2026.

The parent's words:

> [#23.30] the x 100 or x 5 or whatever next to bars needs to go. Just rescale the bar in x anx y dimensions to hold more rows and columns.

## Result (3 Nov 2026)

- **Built:** `UI.CubeBar` (`kits/ui/ui.gd`) has no units any more: one cube is one, the "×5 / ×10 / ×100" label is gone. Up to 10
  cubes in a row (20 when there is room), then rows of 10, and beyond 100 tens of columns, about twice as wide as high (200 = 20 × 10,
  450 = 30 × 15); the cubes shrink to the width and, where set, to a height (`max_h`). Very small cubes are drawn flat. The top bar's
  water and energy keep a height of 62 px. One code path, so energy, water, stock bars and every cost row use it.
- **Agent's choice (coins):** a coin cost cannot be one cube per bronze (900 bronze); it counts by the coin: a cube per bronze under
  a gold, per gold from a gold, per diamond from a diamond, in that coin's colour, with the sum in words next to it (as before). The
  old "cubes of 10 bronze" step is gone. `money_test` expects that.
- **Checked:** smoke test without errors; HUD fit test at 834 and 744: true; a new smoke check builds bars of 8, 30, 65, 100, 200 and
  450 at 80 × 62 px: one cube each, all fit (8 = 8×1, 65 = 10×7, 200 = 20×10, 450 = 30×15); money test OK. Screenshots: workbench
  tiles at 744 (EN), quest book at 834 (DE).
- **Play-test:** water 60 and energy 65 make 6–7 rows of small cubes in the top bar: are they still easy to read on the iPad?
