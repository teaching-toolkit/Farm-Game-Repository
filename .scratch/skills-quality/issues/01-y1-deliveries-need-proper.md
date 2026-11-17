# 01: Y1: Key deliveries ask for at least Proper (and the badger's medicine for Fancy)

**What to build:** Some key deliveries accept only goods of at least Proper, and the badger's "really good medicine" needs Fancy. The grade counting already exists (`count_min`); no delivery uses it yet.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** later

- [x] A delivery or goal can name a minimum grade in data, and the interface shows it (`"minGrade"` on the node; ⭐ stars on each graded thing in the price)
- [x] A handful of key deliveries are chosen and set (listed in this ticket when done): the four Harvest Fair tables, see Progress
- [ ] The badger's medicine asks for Fancy (**not set on purpose**: with a beginner starting Lumpy, Fancy is out of reach, see Progress; the parent decides)
- [x] The bot makes the grade needed; a test covers refusal and acceptance (`quality_test`: pie table refuses Lumpy and accepts Proper; the badger is tested with the key set in memory)
- [x] German through `tools/i18n.py` (no new text: stars only; `--check` clean); the *(planned)* mark for the Proper deliveries is removed in the design document, kept for the badger's Fancy

---

## Progress

**Built (Sonnet agent, 16 Nov 2026).** A node can carry `"minGrade": 1` (Proper) or `2` (Fancy). It takes only things of that grade or better, for the things in its price that have a grade (a tea set, a stick: none, always fine).
- **Where it lives:** `pace.node_min(id)`, `missing_cost / cost_check / pay(cost, min_grade)` (`pace.gd`), `can_unlock` and `unlock` (`progression.gd`), `inventory.have / take / take_tag / count_tag (…, min_grade)` and `min_applies` (`inventory.gd`), `trip.can_pack_cost / pack_cost (cost, min_grade)` (the bag counts pieces, the grade is taken from the store at hand-over). Taking uses the **lowest grade that is good enough**, so the better ones stay for selling.
- **What the child sees:** the existing ⭐ on each graded thing in the price (`ui.cost_row` badge, `widgets.costs`), the cubes fill only with good-enough goods, a refusal says "⭐⭐ 1 more", the grey-tap note shows the same. No new words.
- **Bot / quest text:** `tests/bot.gd` counts only good-enough goods for a delivery's price (`_ready_orders`, `_trip`, `_have`/`_min_of` in the needs), so it keeps making the thing until it has the grade. The quest text is the same data, so check, bot and text agree.
- **Which deliveries (💡, the ticket names none):** the four **Harvest Fair tables** in chapter 6 (`d_fair_pies`, `d_fair_cheese`, `d_fair_preserves`, `d_fair_cloth`): a judged ribbon, late in the story (chapter 6, the bot's golden runs stop when it is reached, so chapters 1 to 3 and both golden pairs stay untouched). `check_data.py` checks `minGrade` is 1 up to the top grade and the price has a graded thing.
- **The badger's Fancy is NOT set (decision for the parent).** The Healer's Chest is made at a station, and since skills-quality/03 a beginner's made things start Lumpy (`madeStart` 0). Probe in the game: E about -0.1 to 0.0 for the chest; even with the best station, a Master and Fancy inputs the cap is E about 0.9, so P(Fancy) is about 6 %. A bot, and a child, would make chests for ages. 💡 Before asking Fancy: raise the weight of the inputs' grade above 0.6, or give ranks and stations bigger bonuses, or add a per-recipe bonus for medicine, then set `"minGrade": 2` on `pet_badger` (one line, the code and the test are ready: `quality_test` sets it in memory and checks that Proper is refused and Fancy accepted, and that paying takes the Fancy chest).
- **The bot and the Fair tables (chapter 6):** the golden runs stop when chapter 6 is reached, so they never play the tables. A throwaway `--end --seed=1` run (not recorded) delivers all four tables with the bot making Proper dishes until it has them: it reaches the same 441 unlocked at step 2940, the same run without `minGrade` at step 2760, so about **+180 steps (about 12 % of chapter 6 so far)**. Neither run reaches the end of the story within 1500 iterations (the baseline does not either), so the end of the story was not compared. For a child: a beginner's pie is Proper only about 1 time in 7, so the table asks for a lot of baking: worth a play-test.
- **Checked:** `quality_test` 48 checks, 0 failed (was 31); `trip_test` 58, `skills_test` 31, `market_test` 24, `crops_test` 21, `pets_test` 107 all 0 failed; `ui_smoke` no FAIL; short golden **and the full golden (to chapter 6), seeds 1 and 2, identical** (not recorded: nothing to re-record); `check_data` 0 errors; `i18n --check` clean.

---

**Id:** Y1 · **Feature:** `skills-quality` · **Moved from** `archive/todo-2026-10.md` §8 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **Y1 plan (13 Oct 2026, phase 4.3):** *Grade* (not "quality": a patch already has a `quality` that scales its yield) 0 Lumpy · 1 Proper · 2 Fancy; German Naja / Tiptop / Picobello!, shown as ⭐ ⭐⭐ ⭐⭐⭐. Only crops, ingredients, dishes, crafts and textiles have a grade (`quality.categories`); raw materials, animal products, seeds don't. Inventory batches become `[season, qty, grade]` for graded items; `SAVE_VERSION` 2 gives every old batch of such an item grade Proper. A new system `game/farm/systems/quality.gd` (data `data/farm/rules/47-quality.json`): an expected grade *E* (Proper = 1.0) from **crops:** soil (rested +0.25, tired −0.3), weeds over 2 (−0.1 each, to −0.4), stones, unfinished clearing, field upgrades (a table by node id); **recipes:** the station in use (a table by station id), the grades of the inputs it will use (lowest first, ×0.6 of their distance from Proper), and later the skill rank (4.4). The result is floor(E) plus a coin flip on the fraction, then 7 % one level up and 7 % one down (so mean price stays about 1 at E = 1). Selling pays 60 % / 100 % / 150 %, best grade first. The recipe tile shows what to expect (⭐⭐ Proper, maybe ⭐⭐⭐). Not yet: "at least Proper" for deliveries (needs `inventory.count_min`, comes with the badger's medicine). Bot: unchanged (it sells through `G.trade.sell`). The golden runs change on purpose (one more random number per harvest and batch): re-recorded. New test `tests/quality_test.tscn`.

- **Y1. Quality** ✅ (R2, R3, R5): three levels, **Lumpy / Proper / Fancy**; German **Naja / Tiptop / Picobello!**. Mostly predictable from the tools, the
  ingredients' quality and practice (Y2), with a small chance of one level up or down; the recipe tile shows what to expect before you
  make it; every skill rank raises the chances a bit (Y2). Crops (from soil, weeds, patch level), dishes, crafts and medicine have it; raw materials don't. Lumpy sells for about 60 %,
  Fancy for about 150 %. Some key deliveries ask for at least Proper; the badger's "really good medicine" (`story/game/game-design-round4.md`
  §C) is simply **Fancy**. ⚠️ Reverses the old decision "Quality stars: no" (log §2.4). Upgrade idea 12 in
  `progression/upgrade-benefits-ideas.md` becomes real.
  **Built 13 Oct 2026 (phase 4.3):** as in the plan above: `game/farm/systems/quality.gd`, `data/farm/rules/47-quality.json`; inventory batches `[season, qty, grade]` (`add_item(k, q, quiet, grade)`, `grades`, `best_first`, `take_best`, `peek_grades`, `count_min`); `SAVE_VERSION` 2 (`upgrade_save_v1`); harvests, batches and selling by grade; *Expect: ⭐⭐ Proper* on recipe tiles and ripe patches, the grades in the store tiles; German Naja / Tiptop / Picobello!. The station card's old practice stars (⭐⭐) now read *practice 2* until Y2 replaces them with ranks. `tests/quality_test.tscn` (31 checks, in `check_all.sh`); golden runs re-recorded on purpose (the bot reaches chapter 5 in 729 / 647 steps instead of 741 / 639). Not yet: *at least Proper* for deliveries.


## Progress (16 Nov 2026, ask-matt pass)

The mechanism (`minGrade` in node data, ⭐ on the things in the price, check, hand-over, packing, bot) and the four Harvest Fair tables (`minGrade` 1) are done. The badger's Fancy is **split off to `skills-quality/04`**: a beginner's medicine can hardly be Fancy (about 6 %), so asking for it would stop the child. Play-test note for the parent: a beginner's pie is Proper about 1 time in 7, so the Fair tables ask for a lot of baking; the number is data (`minGrade` per table).
