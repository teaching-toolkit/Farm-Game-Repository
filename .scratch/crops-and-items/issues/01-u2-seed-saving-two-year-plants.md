# 01: U2: Seed saving for carrots, onions and beets (plants that flower in their second year)

**What to build:** The child can leave a carrot, onion or beet in the ground through one winter, and in spring it gives a lot of seed. Meanwhile the patch grows nothing else. The way is learned from the card *Saving seed* first. Grains already work (the harvest is the seed). Nothing for this exists in the data yet.

**Blocked by:** None (can start immediately)

**Status:** needs-parent

**Milestone:** later

- [ ] The parent looked for the flowering option on carrots and found none ([#23.16]): that is right, it is not built yet; the first visible sign is the "let it flower" choice on a two-year crop's patch
- [x] A short plan is written into this ticket first (goal, files, saves, what the bot must learn, how it is checked; session skill §3)
- [x] A planted two-year crop can be marked to go to seed, stays through one winter, and gives seed in spring; the patch is blocked meanwhile
- [x] It needs the *Saving seed* card to be read first
- [x] Seeds of every unlocked crop can still be bought
- [x] Old saves load (new key in `save_defaults()`; a `SAVE_VERSION` step if a layout changes)
- [x] The bot learns it; golden runs identical or re-recorded on purpose (decided in the plan: the bot learns nothing, it keeps buying seed; golden runs identical)
- [x] German through `tools/i18n.py`

---

## Plan (written before the code; session skill §3)

- **Goal.** After reading the card *Saving seed* (`k_seeds`), a ripe carrot, onion or beet patch has a second choice next to *Harvest*:
  **Let it flower** (a chore, `let_flower`). The plants stay in the ground through one whole winter, the patch is occupied (nothing else
  can be sown: the planting rule already says *occupied*), and in the first spring after that winter the patch is ripe with seed:
  *Harvest* then gives `seedYield` seeds per plant into the seed count (`S["seeds"][crop]`) and the patch is free. Buying seed is untouched.
- **Where.** The patch rules are in `systems/fields.gd` (there is no `crops.gd`): helpers `flowering`, `growing`, `seed_amount`,
  `seed_step_now`, the chore `let_flower` in its `register_chores`, a branch in `_harvest_effect`, `step_crops` and the pests only
  count a patch that is `growing`. Crop data (`data/farm/nodes/`): `seedYear: true` and `seedYield` on carrot, onion, beet. The one rule
  number (the card) in `rules/10-farming.json` `seedSaving`. Base cost in `rules/46-chores.json`. Interface: `ui/patches.gd` (the
  button, the waiting look), `map/iso_field.gd` (a small 🌼 over the plants), no words on the map.
- **Old saves.** One new patch key, `seed_at` (the step the seed is ripe), **absent** on a normal patch like `snow`; so
  `_blank_patch()` and `tests/golden/newgame.json` do not change, old saves load as they are and need no `SAVE_VERSION` step.
- **The bot.** Nothing: it never calls the chore and keeps buying seed. Golden runs must stay identical (they are the proof).
- **Checked by.** `tests/crops_test.gd` (carrot left through the winter: occupied, nothing else sown, seeds in spring, patch free; wheat
  unchanged; old and saved patches load), `tests/actions_test.gd` (the chore is in `COVERED`, price-match), the short golden run,
  `saves_test`, `ui_smoke`, `check_data.py`, `i18n.py --check`.

## Progress

- Built as planned. Logic in `systems/fields.gd` (`flowering`, `growing`, `seed_amount`, `seed_step_now`, `seed_left`, `seed_known`, chore `let_flower`, a seed branch in `_harvest_effect`; `step_crops` and the pests skip a patch that is not `growing`). Data: `seedYear`/`seedYield` (6) on carrot, onion, beet; `seedSaving.card` in `rules/10-farming.json`; base cost of `let_flower` in `rules/46-chores.json` (1 energy, 1 moment). One sparse patch key `seed_at`, absent on normal patches: `newgame.json` and old saves unchanged, no `SAVE_VERSION` step.
- Interface: sheet row "Want seed of your own?" with the 🌼 chore button (only after the card), waiting look 🌼 plus the wait button, ripe patch shows 🌰 on the harvest button; map: small 🌼 (waiting) / 🌰 (ripe) over the plants, no words.
- Checked: `crops_test` (`_seed_saving`: left through the winter, occupied, nothing else sown, seed in spring, patch free, wheat unchanged, old and saved patch loads), `actions_test` (`let_flower` in `COVERED` and price-match), `saves_test`, `ui_smoke` (new `_seed_flowering` block), short golden run `--strict` identical for both seeds, `check_data.py`, `i18n.py --check`.
- 💡 Decisions (all easy to undo): seed is ripe in the first spring after the next whole winter (a winter already going on does not count); 6 seeds per shown plant; seed is counted into `S["seeds"]`, not graded, no weeds' share; the harvest chore is reused for the seed harvest (same cost, "Harvest all" works); the choice is offered only on a ripe patch.
- Left for the parent: the first box (look for the flowering option on a ripe carrot patch after reading the card, in a play-test). Not done: the bot does not use it (on purpose).

---

**Id:** U2 · **Feature:** `crops-and-items` · **Moved from** `archive/todo-2026-10.md` §6 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **U2. Seeds from your own harvest** ✅ (R2, R3, R4):
  - The harvested **grain is the seed** (wheat, oats, beans, peas …): one item you can plant, mill or cook. No conversion step. Medieval
    fields gave about 3–5 grains back per grain sown, so about 5 is honest (an ear has 30–50 grains).
  - **Every crop can make its own seed.** Carrots, onions, beets and other biennials only flower in their second year: a plant left to
    seed must **stay in the ground through one winter**, then gives a lot of seed in spring. Meanwhile the patch grows nothing else.
  - Each way of making seed is **learned from a knowledge card** first (K4).
  - **Seeds of every unlocked crop can always be bought**; buying is mostly for starting a new crop.
  - The **Seed Library** (chapter 5) keeps only its heirloom role. Data: seeds are a separate count today (`S["seeds"]`); grains become
    plantable items; the others get seed items.
