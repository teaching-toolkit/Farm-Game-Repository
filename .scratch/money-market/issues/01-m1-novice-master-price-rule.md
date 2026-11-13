# 01: M1: Prices follow what a beginner and a master pay to make a thing

**What to build:** A made thing's market price lies between what it costs a beginner to make it (inputs, energy, time) and what it costs a master. Buying then beats making for a beginner, and making pays for a master. The realistic prices and the rescale are built; this rule is not.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The price rule is in place for made things and shown to the child through the usual price displays (option A, see "Built" below: the prices are data, every display reads them)
- [x] The explorer's value-check notes for `rope_straw`, `compost`, `steel` and `jam` are looked at (the report below: jam is fine; rope, compost and steel pay less than they cost)
- [x] Pace re-checked with the bot (the explorer's own browser check was not run); short golden identical, full golden re-recorded on purpose
- [x] Dynamic difficulty (`meta.flex`) re-checked (bot `--flex`, seeds 1 and 2: chapter 5 after 899 and 898 Time Quiz answers)
- [x] The Swiss prices stay the parent's check in W9 (none was changed)


## 💡 Recommendation (13 Nov 2026): one question before anything is repriced

Prepared, not built. New report `python3 godot-prototype/tools/price_rule.py` (changes nothing; `--all`, `--csv`): for each of the 131
recipes it compares what selling the result pays with what a beginner and a master pay to make it (inputs at their own price; energy,
fuel and a question of waiting 7.5 bronze each, water 3, from `pricing`; the master's savings from `rules/48-skills.json`).

**What it shows today:** a master makes a thing only about 11 % cheaper than a beginner, so "between the two" is a narrow band (0.89 to 1.00
of the beginner's cost). Of 119 priced recipes, 20 are in it, **80 pay more than even a beginner spends** (the middle is 1.17 ×: bread 400
against 340, pizza 1500 against 1205, cheese board 2500 against 1580), and **19 never pay, not even for a master**: rope 30 (costs 52),
rope from straw 30 (40), every compost 30–45 (48–69), ash, deadwood, clay, fine flour 135 (178), flatbread 150 (208), fresh cheese 300
(401), tomato sauce 350 (432), cider 300 (383), the healer's chest 900 (1145), glass 180 (198), steel 435 (687). Jam 400 is in the band.

**Why I did not build the rule as written:** taken word for word it lowers about 80 selling prices by 15–25 % and makes cooking and crafting
for sale a loss until the child is a Master (200 batches in a family). That turns the game's main loop (make it, sell it) into a setback
for most of the game, slows the money that the last two pace checks were about, and overrides the Swiss prices of W9. It is hard to undo
(new golden runs, new pace), so it waits for you.

**The question: which price does the rule speak about?**

- **💡 A. The price a merchant asks (buying), not what selling pays.** "Buying beats making for a beginner, making pays for a master" then
  holds for the made things a merchant sells: today only steel (asked 675; making costs a master 687, a beginner 795: buying beats making for
  everyone, so ask about 740) and glass (asked 300; making costs about 200: nobody would buy it, which is fine as a safety valve or goes to
  about 235, the lowest the 1.3 × rule allows). Selling prices stay, except the 19 that never pay: those go up to the master's cost (rope
  30 → 40, steel 435 → 690 …) unless they are meant as by-products (compost, ash: used on the farm, not sold; I would leave those).
  Small, pace about unchanged, about 12 numbers. "Yes" means this.
- **B. Word for word, on selling prices.** About 100 prices move into the band. Realistic ("a beginner should buy bread"), but see above.
- **C. Leave the prices, keep the report.** The report stays as a check when new recipes are added; the ticket closes.

After your answer an agent can build A in one sitting (data only, the bot and the explorer re-run, `meta.flex` re-checked).

## Built (13 Nov 2026): option A, the parent said yes

The rule speaks about what a merchant asks. Six numbers changed, all data:

| What | Was | Now | Why |
|---|---|---|---|
| Steel, the guild merchant's price | 675 | 740 | between a master's cost (687) and a beginner's (795): a beginner buys, a master makes |
| Glass, the guild merchant's price | 300 | 235 | the lowest the no-resale rule allows (1.3 × its worth of 180); making (198–225) still beats buying, so it stays a safety valve |
| Rope, selling | 30 | 45 | rope from straw now pays for a master (40–45); rope from fibre (52–60) still does not |
| Fine flour, selling | 135 | 178 | a master's cost exactly; 180 would push the golden honey cake out of its band |
| Flatbread, selling (each) | 75 | 105 | two for 210, a master's cost is 208 |
| Healer's chest, selling | 900 | 1150 | a master's cost is 1145 |

**Left alone on purpose, still paying less than they cost** (15 recipes in the report): the composts, worm castings and ash (made for the
farm, not for sale); deadwood and clay (gathered, priced against the raw-materials merchant); steel and glass as things to sell (a
merchant sells them, so their worth must stay below 1/1.3 of his price, or buying to resell would pay); rope from fibre; and **fresh
cheese (300, costs 401), cider (300, costs 383) and tomato sauce (350, costs 432): these three are Swiss prices (W9), so I did not
touch them.** If they should pay, the way is cheaper recipes (fewer inputs), which belongs to the recipe audit `crops-and-items/03`.

**Checks.** Report: 24 in the band (was 20), 15 never pay (was 19), 80 pay for everyone. Data checks 0 errors. Short golden identical
(185 / 202 steps): chapters 1 to 3 do not feel it. Full golden differs from chapter 4 on (the guild merchant) and is recorded anew: 564 / 568
steps (were 567 / 540). With dynamic difficulty: chapter 5 after 899 / 898 answers. Every system test green; the smoke test's old
failure is `interface-feel/13`.

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
