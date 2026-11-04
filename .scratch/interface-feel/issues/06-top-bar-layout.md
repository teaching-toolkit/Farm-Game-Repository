# 06: Top bar: the next goal shows only its symbol and text, and the season row moves under the bars

**What to build:** The next goal shows just the goal symbol and its text (no input information), and the text scales to fit the space. The season row moves right under the water and energy bars; the chapter and question information leaves the top bar, so the season row gets more room.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The next goal shows symbol and text only, with the text auto-scaled to the available space
- [x] The season row sits right under the water and energy bars and uses the freed width
- [x] Chapter and question information is gone from the top bar (still in the album or settings if it was only there)
- [x] The HUD fit test passes at 744 and 834 wide; screenshots checked

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.28], [#23.40]. Filed 23 October 2026.

The parent's words:

> [#23.28] the next goal should just be the goal symbol and text, no input info necessary. And scale the text so it automatically fits the space available.
> [#23.40] for the bronze coin, just take the gold one and shift the color. And the gold and bronze can be stacked over each other in the UI (when the player has both). Also, 1000 Gold coins = 1 diamond, so make the UI adjust to have up to three rows for money. The row with season and chapter can move, so its right under the water and energy bars. We don't need the chapter and question info anymore in the top bar. That gives the season bar more room.

## Result (3 Nov 2026)

- **Built:** the next goal shows "✅/🎯 + its emoji + its name" only (no costs; they are on its place's sheet), and its text takes the
  biggest size from 22 down to 11 px that fits the button, wrapped onto as many lines as the height allows (`goalbar.fit_text`, run on
  every change and when the button is resized). The season row now sits right under the water and energy bars (the purse moved to
  their left, its rows stacked, see 07) and is as wide as the bars: its stripes spread over that width (3–8 px each). The chapter and
  question line is gone from the top bar.
- **Where chapter and question are now:** they were only in the top bar, so ⚙️ Settings shows "📖 Chapter 3 · question 289" under the
  sound buttons (the same translated text).
- **Smoke test (`info_text`):** the J4 playback check reads `D.info_text()` to see when the farm has caught up after the Time Quiz.
  `lbl_info` is kept as a **hidden** label in the season row, still set in `refresh()` (which waits for the playback), so the check
  means the same thing as before; the driver says so. It passed (held, old look while waiting, caught up, a tap skips: all true).
- **Agent's choice:** the ✅ (can do it now) / 🎯 mark stays before the goal's emoji: it is a symbol, not input information, and tells
  the child without reading whether the goal can be done. Easy to drop in `goalbar.update_goal_bar`.
- **Checked:** smoke test without errors; HUD fit test at 834 and 744: true; new smoke check "top bar layout" at both widths: goal
  is name only, season row directly under the bars (2 px gap, 391 of 426 px and 283 of 318 px wide), chapter line not shown. Screenshots
  of the top bar: chapter 3 at 834 (EN) and 744 (DE, the goal wraps on three lines at 16 px), a new game at 744 (EN) and 834 (DE);
  ⚙️ Settings with the chapter line (DE).
- **Play-test:** whether the child misses the goal's cost in the top bar (one tap on the goal opens its place).
