# 01: M1: Prices follow what a beginner and a master pay to make a thing

**What to build:** A made thing's market price lies between what it costs a beginner to make it (inputs, energy, time) and what it costs a master. Buying then beats making for a beginner, and making pays for a master. The realistic prices and the rescale are built; this rule is not.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** prototype

- [ ] The price rule is in place for made things and shown to the child through the usual price displays
- [ ] The explorer's value-check notes for `rope_straw`, `compost`, `steel` and `jam` are looked at
- [ ] Pace re-checked with the bot and the explorer (the playthrough stays about 20 hours); golden runs identical or re-recorded on purpose
- [ ] Dynamic difficulty (`meta.flex`) re-checked
- [ ] The Swiss prices stay the parent's check in W9

---

**Id:** M1 · **Feature:** `money-market` · **Moved from** `archive/todo-2026-10.md` §7 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **M1. The economy, rebuilt on realistic prices** [#6] ✅ (R1, R2). Today pizza costs 166 coins because the pricing rule
  (`meta.pricing`) multiplies the mark-up again at every stage (porridge 4, omelette 16, honey cake 49, apple pie 72, pizza 166,
  cheese board 212). New: prices from D3 (Swiss prices for familiar goods, old-world ratios for the rest), then adjusted so the game
  works; the formula's mark-up for dishes made from dishes made smaller, or added instead of multiplied. Include the explorer's
  value-check notes for `rope_straw`, `compost`, `steel` and `jam` (was "Later 4"). 💡 The rule from Y2: for a made thing, the market's
  price lies between what it costs a beginner to make (inputs + energy + time) and what it costs a master, so buying beats making for a
  beginner and making pays for a master. Re-run the explorer and the bot; re-check dynamic difficulty (`meta.flex`).

- **M1/M2/D3 plan (13 Oct 2026, phase 4.5):** **1 coin today = 15 bronze** (egg 4 → 60, carrot 2 → 30, porridge 4 → 60: the same ratios, so the pace holds; a few familiar goods are set to the real Swiss price, D3). `tools/rescale_prices.py` multiplies every coin number in the data once (items' `value`, `cost.coins` incl. steps, `price.coins`, `seedCost`, merchants' `sells` and `barter` coins, start coins, the luck coin, the job reward, `meta.flex` pace and `minWorth`), guarded by `meta.currency.rescaled`; the table before/after is `docs/sources/price-table.md`. Saves: `SAVE_VERSION` 4 turns old coins into bronze (×15). Code: `G.money(bronze)` writes `35 🟤` or `2 🟡 35 🟤` (gold from 100 up; the purse shows both once the child has had 100); coin costs in the cost rows are cubes of a gold (or of 10 bronze) with the sum as text; the 18 places that wrote 🪙 amounts use it; `meta.pricing` stops multiplying the mark-up for dishes made from dishes (tools/econ check only). The bot's coin thresholds scale with it. Checks: golden runs must reach chapter 5 in about the same number of steps as before the rescale (a pure rescale changes no ratios); smoke test; a new money test; the data checker warns when a merchant sells below 1.3 × an item's value. Not done here: the explorer's own simulation (T3).

- **M1/M2/D3 built 13 Oct 2026 (phase 4.5):** `tools/rescale_prices.py` ran once (guard: `meta.currency.rescaled` in `rules/40-economy.json`): every coin amount ×15 (items' value, 120 cost amounts, 18 seed prices, 11 merchant prices, the lost coin, the job reward, `meta.flex.basePace`/`minWorth`, start coins), 22 familiar goods set to Swiss prices (egg 65, carrot 30, bread 200, honey portion 150, pizza 1500, cheese board 2500 …): the table is `docs/sources/price-table.md` (D3 ✅). `G.money / money_up / purse_text`, `meta.currency` (symbols 🟤 🟡, gold from 100), coin costs as cubes of 10 bronze or a gold with the sum in words (`UI.cost_row(…, money)`, `CubeBar.unit_min`), `SAVE_VERSION` 4 (`upgrade_save_v3`: coins ×15), the luck coin and the job reward read from the data, the bot's coin thresholds ×15, a data check (merchants sell above 1.3 × worth, whole-bronze values). `tests/money_test.tscn` (17 checks). Pace (4 seeds, steps to chapter 5): 603 / 741 / 612 / 684 = 660 on average, against 640 / 620 / 1076 / 598 = 733 before, and about 700–2200 bronze left over at the end (before ≈ 50 coins): money is no longer the bottleneck at the planned pace. Not done: the explorer's own simulation (T3), the *novice/master* price rule (a made thing between what a beginner and a master pay to make it; buying beats making for a beginner), prices that change by season (M12), **verifying the Swiss prices** (my best knowledge: W9 asks the parent to look at `docs/sources/price-table.md`).
