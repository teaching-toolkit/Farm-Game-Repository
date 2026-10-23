# 07: Money display: a recoloured gold coin for bronze, gold stacked over bronze, diamonds above 1000 gold

**What to build:** The bronze coin is the gold coin picture with its colour shifted. When the player has both, gold and bronze stack over each other. 1000 gold = 1 diamond, so the money area can have up to three rows (diamond, gold, bronze).

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] Bronze picture is a colour shift of the gold coin picture
- [ ] Gold and bronze rows stack when both exist; a diamond row appears from 1000 gold
- [ ] Coins stay stored in bronze; the rounding rule (stocks down, costs up) is unchanged
- [ ] A diamond picture exists (placeholder until the parent makes one)
- [ ] `money_test` extended for the diamond split; German; screenshots checked

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`planning/2026-10-23-parent-notes-playtest.md`), [#23.40]. Filed 23 October 2026.

The parent's words:

> [#23.40] for the bronze coin, just take the gold one and shift the color. And the gold and bronze can be stacked over each other in the UI (when the player has both). Also, 1000 Gold coins = 1 diamond, so make the UI adjust to have up to three rows for money. The row with season and chapter can move, so its right under the water and energy bars. We don't need the chapter and question info anymore in the top bar. That gives the season bar more room.
