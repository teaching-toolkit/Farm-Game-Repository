# 04: Small rocks and big rocks are different things

**What to build:** The game tells small stones from big rocks, as it mostly does for sticks and logs. Today there is only one stone item. Big rocks are heavier, need more effort or a tool, and are used for different things.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] A plan is written into this ticket first: items, weights, tools, where each comes from
- [x] Small stones and big rocks exist as separate items with weight classes
- [x] Patch stones and forest-edge stones use the right one; recipes that need stone are checked
- [x] Data checker, bot and golden runs pass (re-recorded on purpose if needed)

---

**Feature:** `nature` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.34]. Filed 23 October 2026.

The parent's words:

> [#23.34] the game should differentiate between small rocks and big rocks. I think it mostly does that for sticks and logs already, if not, that needs implementing.

## Plan (written before building, 10 Nov 2026)

- **Items.** `stone` stays and becomes the **small stone** (light, 0.5 load; German *Kleiner Stein*). New item `boulder`, the **big rock** (heavy, 4 load, the weight the old stone had; German *Felsbrocken*). (Id `boulder`, not `rock`: `rock` is already the first hammering tool.)
- **Where each comes from.** Small stones: the stones picked out of a patch (`pick_stones` chore, frost stones, pets), the "pick out the stones" steps of clearing thistles, weeds and stumps, *Pick stones* at the forest edge, the last step of clearing a rocky patch or a ruin, and the 3 the farm starts with. Big rocks: *Dig out big rocks* at the forest edge (shovel, same numbers as before: 3 for 5 ⚡), the first two steps of clearing the rocks and of every ruin, 6 of the 10 stones of the North Field. Both stay in the forest edge's "loose stones" pool (`rules/56-nature.json` unchanged).
- **Where each is used.** Big rocks: roads, wells, walls, paved yard, kiln, oven, stove, forge, hearth, water trough, quern, grindstone, barns, chimney, windmill, farmhouse, orchard, cellar, bridge, cottage and workshop (the "walls and foundations" jobs). Small stones: campfire, fire ring, workbench, tools and their polish, spindle, whetstone, salt lick, garden bench, mortar, patch edging and channel, drain gutter, prep table. Counts are unchanged, so a big build weighs exactly what it did.
- **The Raw Materials Merchant** sells both: small stone 15, big rock 45 (the old stone price).
- **Old saves.** `SAVE_VERSION` 6: what was stone in the store and the bag becomes big rock one to one (the farmer carried it for building, nothing is lost); the first small stones come back from the patches.
- **Bot.** It reads the data (costs and sources), nothing new to teach it. **Check:** data checker, save step test, trip and smoke tests (they used stone as the heavy example), short run and the bot's pace; goldens are re-recorded once after the chain with `money-market/08`.

## What was built

- Items, weights, 39 nodes and `dig_stones` changed as in the plan; `dig_stones` keeps its id (the forest edge's pool counts recipes by id) and is now named *Dig out big rocks*. Feedback sound, cube colour and German texts for both items; `docs/design/farming.md`, `building-and-upgrading.md` and `store-and-materials.md` describe it.
- Tests: `trip_test` and `ui_smoke` use the big rock as the heavy example (the smoke test needs 6 of them to fill the bag, because the farm's starting stones are light now); `saves_test` has a version 5 → 6 case.
- No picture for the big rock yet: it shows its emoji ⛰️ (the stone's picture stays with the small stone). Added to the picture wishes below.

## 💡 Decisions to confirm (all easy to undo: data only, the save step aside)

- A small stone is **light** (0.5), not normal; the big rock keeps the old stone's weight 4. Undo: `rules/45-weight.json`.
- Small stone 15, big rock 45 at the Raw Materials Merchant. Undo: `nodes/02-main-path-chapter-1.json`, `raw_1`.
- Which builds use which (list in the plan): quern, hearth, water trough, grindstone and the oven/stove count as big-rock jobs; mortar, drain gutter, prep table and fire ring as small-stone jobs. Undo: swap `stone`/`boulder` in that node's cost.
- The big rock's emoji ⛰️ until a picture exists (`pictures`: one sprite for `assets/items/boulder.png`).
- Old saves turn all their stone into big rocks (they keep their building stock, but have no small stones for tools until they pick some).

## Pace

Bot, steps to chapter 5 (seeds 1/2/3), together with `money-market/08`: 912 / 885 / 887; the wave-1 tree gave 1091 / 1090 / 1099 (same bot). `nature/04` alone (before 08) gave 1091 / 1290 / 1214, about the wave-1 pace. Goldens re-recorded once after both tickets.

The parent decided on 11 Nov 2026 to keep this pace (see `money-market/08`).
