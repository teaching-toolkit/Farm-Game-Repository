# 01: Y1: Key deliveries ask for at least Proper (and the badger's medicine for Fancy)

**What to build:** Some key deliveries accept only goods of at least Proper, and the badger's "really good medicine" needs Fancy. The grade counting already exists (`count_min`); no delivery uses it yet.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] A delivery or goal can name a minimum grade in data, and the interface shows it
- [ ] A handful of key deliveries are chosen and set (listed in this ticket when done)
- [ ] The badger's medicine asks for Fancy
- [ ] The bot makes the grade needed; a test covers refusal and acceptance
- [ ] German through `tools/i18n.py`; the *(planned)* mark in the design document is removed

---

**Id:** Y1 · **Feature:** `skills-quality` · **Moved from** `TODO.md` §8 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **Y1 plan (13 Oct 2026, phase 4.3):** *Grade* (not "quality": a patch already has a `quality` that scales its yield) 0 Lumpy · 1 Proper · 2 Fancy; German Naja / Tiptop / Picobello!, shown as ⭐ ⭐⭐ ⭐⭐⭐. Only crops, ingredients, dishes, crafts and textiles have a grade (`quality.categories`); raw materials, animal products, seeds don't. Inventory batches become `[season, qty, grade]` for graded items; `SAVE_VERSION` 2 gives every old batch of such an item grade Proper. A new system `game/farm/systems/quality.gd` (data `data/farm/rules/47-quality.json`): an expected grade *E* (Proper = 1.0) from **crops:** soil (rested +0.25, tired −0.3), weeds over 2 (−0.1 each, to −0.4), stones, unfinished clearing, field upgrades (a table by node id); **recipes:** the station in use (a table by station id), the grades of the inputs it will use (lowest first, ×0.6 of their distance from Proper), and later the skill rank (4.4). The result is floor(E) plus a coin flip on the fraction, then 7 % one level up and 7 % one down (so mean price stays about 1 at E = 1). Selling pays 60 % / 100 % / 150 %, best grade first. The recipe tile shows what to expect (⭐⭐ Proper, maybe ⭐⭐⭐). Not yet: "at least Proper" for deliveries (needs `inventory.count_min`, comes with the badger's medicine). Bot: unchanged (it sells through `G.trade.sell`). The golden runs change on purpose (one more random number per harvest and batch): re-recorded. New test `tests/quality_test.tscn`.

- **Y1. Quality** ✅ (R2, R3, R5): three levels, **Lumpy / Proper / Fancy**; German **Naja / Tiptop / Picobello!**. Mostly predictable from the tools, the
  ingredients' quality and practice (Y2), with a small chance of one level up or down; the recipe tile shows what to expect before you
  make it; every skill rank raises the chances a bit (Y2). Crops (from soil, weeds, patch level), dishes, crafts and medicine have it; raw materials don't. Lumpy sells for about 60 %,
  Fancy for about 150 %. Some key deliveries ask for at least Proper; the badger's "really good medicine" (`story/game-design-round4.md`
  §C) is simply **Fancy**. ⚠️ Reverses the old decision "Quality stars: no" (log §2.4). Upgrade idea 12 in
  `progression/upgrade-benefits-ideas.md` becomes real.
  **Built 13 Oct 2026 (phase 4.3):** as in the plan above: `game/farm/systems/quality.gd`, `data/farm/rules/47-quality.json`; inventory batches `[season, qty, grade]` (`add_item(k, q, quiet, grade)`, `grades`, `best_first`, `take_best`, `peek_grades`, `count_min`); `SAVE_VERSION` 2 (`upgrade_save_v1`); harvests, batches and selling by grade; *Expect: ⭐⭐ Proper* on recipe tiles and ripe patches, the grades in the store tiles; German Naja / Tiptop / Picobello!. The station card's old practice stars (⭐⭐) now read *practice 2* until Y2 replaces them with ranks. `tests/quality_test.tscn` (31 checks, in `check_all.sh`); golden runs re-recorded on purpose (the bot reaches chapter 5 in 729 / 647 steps instead of 741 / 639). Not yet: *at least Proper* for deliveries.
