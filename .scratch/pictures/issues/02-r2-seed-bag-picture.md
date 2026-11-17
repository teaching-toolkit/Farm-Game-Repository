# 02: R2: One seed-bag picture for crops whose seed is bought

**What to build:** Carrot, onion, beet and the other crops that need bought seed show one seed-bag picture with the crop's small picture on it, instead of one picture per crop. This is a 💡 recommendation; the parent says yes or no. Grains, beans and peas need no seed picture (the harvest is the seed).

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** later

**Size:** quick

- [x] The parent has said yes to the seed-bag idea, or chosen another (yes, decided for the parent while away, see Decision)
- [x] One seed-bag picture exists (a bag shape the game draws, see Decision)
- [x] The game draws the crop's picture on it
- [x] Grains, beans and peas are untouched (the grain that is its own seed, `seedItem`, is drawn as before; see Progress for oats and beans)

---

**Id:** R2 · **Feature:** `pictures` · **Moved from** `archive/todo-2026-10.md` §5 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Progress (17 Nov 2026)

- `kits/ui/seed_bag.gd`: `SeedBag.make(pic, emoji, px) -> Control`, a tied cloth pouch drawn in code (polygons, thick dark-brown outline, cord and bow at
  the neck, a round patch on the belly) with the crop's small picture on the patch, or its emoji when there is no picture. No words, no picture files, no credits.
- Used where a bought seed is drawn as a tile: the seeds stall on the village square (`ui/places/market.gd`) and the store's 🌱 Seeds (`ui/places/pantry.gd`),
  both through `widgets.seed_tile(cid, title)` (`tile(..., bag := true)`). The crop-choice tiles on a patch (what to plant) still show the plant.
- Test: `ui_smoke` `_seed_bag` (sized control for a picture, for none with an emoji, and for neither; a bag in the seeds stall and in the store). Looked at
  `--square --spot=market --stall=seeds` at 834x1194: a brown tied pouch with the crop's picture in a cream patch on every tile. Short golden identical.
- 💡 Oats and beans have bought seed in the data today (no `seedItem`), so they show the bag too; once U2 makes them their own seed they leave the stall by themselves.

## Original notes

- **R2. Seeds** [#16]. For grains, beans and peas the harvest *is* the seed (U2), so no seed picture is needed there. For the others
  (carrot, onion, beet …): 💡 one "seed bag" picture with the crop's small picture on it, rather than one picture per crop.

## Decision (17 Nov 2026, parent away, easy to undo)

- [x] Yes to the seed-bag idea, with one plain tied-pouch shape drawn by the game itself: no generated picture, so no credits. The crop's small picture sits on its front. If the parent later wants a painted bag, one picture replaces the shape. Why: it is the cheapest way to see it work, and nothing is lost if the parent prefers another look.
- It shows wherever a bought seed is drawn (store tile, village square, bag). Grains, beans and peas stay as they are (the harvest is the seed).
- A crop without a small picture shows its emoji on the bag; check the result at iPad size.
