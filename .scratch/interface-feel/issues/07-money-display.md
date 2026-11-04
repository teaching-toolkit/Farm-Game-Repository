# 07: Money display: a recoloured gold coin for bronze, gold stacked over bronze, diamonds above 1000 gold

**What to build:** The bronze coin is the gold coin picture with its colour shifted. When the player has both, gold and bronze stack over each other. 1000 gold = 1 diamond, so the money area can have up to three rows (diamond, gold, bronze).

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Bronze picture is a colour shift of the gold coin picture
- [x] Gold and bronze rows stack when both exist; a diamond row appears from 1000 gold
- [x] Coins stay stored in bronze; the rounding rule (stocks down, costs up) is unchanged
- [x] A diamond picture exists (placeholder until the parent makes one)
- [x] `money_test` extended for the diamond split; German; screenshots checked

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.40]. Filed 23 October 2026.

The parent's words:

> [#23.40] for the bronze coin, just take the gold one and shift the color. And the gold and bronze can be stacked over each other in the UI (when the player has both). Also, 1000 Gold coins = 1 diamond, so make the UI adjust to have up to three rows for money. The row with season and chapter can move, so its right under the water and energy bars. We don't need the chapter and question info anymore in the top bar. That gives the season bar more room.

## Result (3 Nov 2026)

- **Built:** the purse in the top bar is a new `UI.Purse` (`kits/ui/ui.gd`): up to three rows stacked, diamonds over gold over
  bronze, each "number + coin picture", numbers right-aligned so the coins line up; a row shows only when there is at least one of
  that coin (nothing at all: "0" bronze); one row is drawn at 22 px, two at 18, three at 15, so it stays inside the bar's height.
  The bronze coin is `assets/ui/coin_gold.png` with its colour shifted at run time (`Art.shifted`, hue −0.055, darker; made once and
  kept). `G.coins_split(bronze)` gives [diamonds, gold, bronze]; `G.money` writes diamonds from 1000 gold (`1 💎 234 🟡 56 🟤`).
  Coin costs: one cube per bronze / gold / diamond in that coin's colour (see 05), and the cost row shows the gold coin picture.
- **Pictures:** there was no gold coin picture, so both `assets/ui/coin_gold.png` (a gold coin with a wheat ear) and
  `assets/ui/diamond.png` are **placeholders drawn by code** (128 px). Replace either file with a real picture of the same name; no code change.
- **Unchanged:** coins are stored in bronze; the rounding rule (stocks down, costs up) is the same; `purse_text()` still notes that
  a gold has been seen (now the purse's tooltip). Agent's choices: `goldPerDiamond` (1000) and the 💎 symbol are code defaults that the
  data (`currency` in `40-economy.json`) may override; the data file is not changed. New screenshot flag `--coins=N`.
- **Checked:** `money_test` 29 checks OK (new: the diamond split, text with diamonds, rounding at the diamond, the purse's rows for
  0, 40, 200, 235, 100000 and 123456 bronze, a 1500-gold cost in diamond cubes); smoke test without errors (the reveal check still sees
  the purse); all unit tests OK. Screenshots: purse at 1 💎 234 🟡 56 🟤 (834, EN), 2 🟡 35 🟤 (744, DE), 40 🟤 (744, EN); a coin
  cost row of 3 gold with 250 bronze in the purse (EN).
- **Play-test:** does the child see the bronze coin as "the same coin, less worth"? Are the three stacked rows readable?
