# 15: The picture run: Claude generates, downloads, picks and imports with the OpenArt connector

**What to build:** The pictures the prototype needs are generated in OpenArt by Claude (project "Farm Quiz Game", Nano Banana 2 Lite at 1K, 3 versions per sheet, an earlier sheet as the style reference, two generations at a time), downloaded into `art-inbox/`, cut and imported. The parent only looks at a contact sheet and overrules picks.

**Blocked by:** `pictures/14` (for the full list; the first sheets below can start before it)

**Status:** needs-parent

**Size:** quick

**Milestone:** prototype

- [x] The parent has said yes to Claude picking (14 Nov 2026): up to 2000 credits, no waiting for the parent
- [ ] Sheet A (small things): the book cart, the travelling merchant's own cart [#14.8], an **empty** workbench and the workbench with tools [#14.9], the wilting leaf for stale things (`pictures/07`), the three pen fence stages (`pictures/13`), the piles in four sizes (`visible-work/02`)
- [ ] The workbench shows the empty picture when first built and the one with tools once a tool has been made
- [ ] Sheet B: straw, flour, hay, winter wheat (`pictures/01`), the herb pastes and dried herbs (`crops-and-items/03`)
- [ ] Sheet C: the painted village square without stalls, and the stalls on their own (`pictures/04`); the three merchants' figures and faces (`pictures/06`) wait for `people/05`
- [ ] Then by the priority of `pictures/14`: windows (`pictures/09`), building stages (`pictures/05`), season pictures (`pictures/12`)
- [ ] Each downloaded file is listed with its prompt and creation time (the `openart-sidecar-lean` skill); credits and the art list's status column are updated
- [ ] Every version that was not picked is kept in `art-inbox/alternatives/<sheet>/` beside a contact sheet with the pick marked, so the parent can swap later

## Download tried (14 Nov 2026)

It works: the connector lists the project's pictures with their addresses, and one existing 1024 × 1024 picture was fetched from `cdn.openart.ai` without the parent's help (no new generation, no credits used). The standing rule against it was removed from `00-READ-ME-FIRST.md` by the parent.

## ✅ Parent's answer (14 Nov 2026)

> you can use up to 2000 credits and no need for me to wait and overrule, but you can put alternatives in a folder somewhere so that I can go back later and swap if necessary. Also if you notice that your prompts are not generating the kind of thing you want, adapt your prompting.

How it is done: the project skill `openart-pictures` (`.claude/skills/openart-pictures/SKILL.md`). Credits used are counted in `art-inbox/openart-runs.csv`.

**Found 14 Nov 2026:** the empty workbench picture and the book cart picture already exist (`map/workbench_empty`, `map/bookcart`), so neither needs generating; the workbench showing a hammer at first is a game matter, `interface-feel/16`.

## Progress (14 Nov 2026): 90 of 2000 credits used

- **`sheet54-piles`** (version 1 picked): sticks, small stones and big rocks, each in four sizes → `assets/piles/stick_1…4`, `stone_1…4`, `boulder_1…4` (for `visible-work/02`).
- **`sheet55-cart-stale-loose`** (version 1 picked): the travelling merchant's wagon in three fill levels → `assets/map/merchant_cart_1…3` [#14.8]; the stale marks → `assets/ui/stale_leaf`, `stale_flower` (`pictures/07`); loose sticks and stones → `assets/deco/loose_stick_1…2`, `loose_stone_1…2` (`visible-work/03`).
- Both are cut and in `tools/art_sheets.json`; the other versions are in `art-inbox/alternatives/<sheet>/` with a `contact.html`. **Not yet used by the game:** the wagon replaces the merchant's cart picture and the stale leaf replaces 🍂 in the tickets that own them.
- The pen fence stages (`pictures/13`) may need no new picture: `fences/stick_broken`, `stick_fence` and `picket_fence` exist; `upgrades/02` tries them first.
- Next: sheet B (straw, flour, hay, winter wheat, herb pastes, dried herbs), then by the list of `pictures/14`.

---

**Feature:** `pictures` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.8], [#14.9] and the parent's request to try the download again. Filed 14 November 2026.

The parent's words:

> [#14.8], [#14.9] and the parent's request to try the download again Traveling merchant needs a different cart than the book cart · The workbench should be empty at first when it is built first (right now it still has a hammer on it)

14 Nov 2026, second run: sheets 56–59 (45 item and plant pictures) are in; 300 credits used. Next: the badger, the five friends' stamps and six album pictures of chapter 6, then the window pictures (58).

## Progress (15 Nov 2026, third run): 1980 of 2000 credits used

- **Credits:** 360 this run (1620 → 1980): seven story pictures 105, sheets 62–64 135, sheet 65 45, sheet 66 45, sheet 67 30 (two versions only, to stay under the 1990 ceiling).
- **Part A, story pictures** (one try each, no retries, all trimmed of the cream margin with 3 % inset, mapped in `tools/story_pictures.json`, imported to `assets/story/<id>.webp`; originals in `art-inbox/alternatives/story-<id>/`): `c1_maud` (Granny Maud and a collar-less animal in a village lane), `c2_pieter` (Pieter at the gate, book under his arm), `c3_pieter2` (Pieter reading the book, worried), `c4_pieter4` (Pieter at the gate looking toward the farm), `c6_cups` (long table of cups at dusk, Lark small and from behind), `c2_reply_none` (table with pen, candle and letter, empty barge in the window), `c4_mei` (Captain Mei with pickle jars and a sealed letter). `story_test`: STORY OK, 50 checks, 0 failed.
- **Part B, sheets** (picked version cut into `assets/interior/` or `assets/helpers/`, names in `tools/art_sheets.json`, all versions in `art-inbox/alternatives/<sheet>/`):
  - `sheet62-interior-e` (v2): chopping_block, prep_table_1/2, oven_1/2/3, quern, food_processor, mortar (9).
  - `sheet63-interior-f` (v2): churn, cheese_vat, honey_extractor, spindle, drying_rack, salve_pot, syrup_pan, tea_pot (8).
  - `sheet64-interior-g` (v2): compost_bin, compost_bin_2, worm_bin, clay_pit, wild_edge, pond_station (6).
  - `sheet65-tools` (v1): watering_can, bucket (watering scoop), shears, wheelbarrow, iron and steel hoe/shovel/knife, smiths_hammer, master_saw (12).
  - `sheet66-wearables` (v1): straw_sandals, wooden_clogs, hobnail_boots, waxed_boots, fiber_mitts, wool_gloves, waxed_gloves, felt_hat, linen_sunhat, linen_apron, canvas_apron, fiber_bag (12).
  - `sheet67-gear` (v1): clay_flask, stoneware_jug, glass_bottle, insulated_flask, wicker_pack, canvas_rucksack, frame_rucksack, drip_line, straw_pillow, feather_pillow, down_pillow, whetstone (12). All three versions of sheet 67 had captions under the objects in row 3 (v2 under all rows); credits were too few for a retry, so the captions of v1 were painted over with white (`art-inbox/sheet67-gear.png`; the original is `alternatives/sheet67-gear/sheet67-gear-v1.jpg`).
- 59 pictures cut in all (23 interior, 36 helpers); the `ART_LIST.csv` rows of these are set to `done` (202 rows still say missing: cards 87 `k_*`, helpers 56, windows 58 of which 41 already exist as files and only the rows are stale, square 1).
- Still without a picture (helpers): carrying_yoke, cooking_tripod, fire_ring, gathering_basket, hand_cart, nest_boxes, perches, straw_bed, barn_cat, bee_smoker, compost_fork, dough_trough, drain_gutter, flower_strip, garden_bench, glaze_shelf, hay_rack, hearth, jans_donkey, milking_stool, oven_tray, pot_shelf, salt_lick, scaffolding, tall_chimney, tool_rack, water_trough, willow_whistle, worm_starter and 27 more (bellows … paved_yard in the list).
- **Not yet seen in a running game:** the new pictures were checked by importer (found N objects, N names), by pasting the cuts on green, `--import`, `ui_smoke` (no FAIL, no SCRIPT ERROR), `story_test` and `check_data` (0 errors); no screenshot was taken. `celebrations.gd` looks up `helpers/<id>`; interior sprites are found by id in the interior scripts. Sprites with an enclosed loop (clay_flask, insulated_flask cords) keep a little white inside the loop.

**Square sheets (15 Nov 2026, `money-market/12`; credits 1980 → 2025 of the ceiling 2100 after the parent's "+100"):** `sheet68-square-tiles` (one version, 15), `sheet69-square-tiles-2` (three versions, 45) and `sheet70-square-deco` (three versions, 45), all kept in `art-inbox/alternatives/`, all in `art_sheets.json` and `ART_LIST.csv` as done. 28 ground tiles in `assets/square_tiles/`, 12 decorations in `assets/deco/`. Lessons (for the skill's list): "numbered" in a prompt prints numbers under the objects (paint them white); a row of tiles that touches the next row cuts as one object (paint a white band between rows, then 16 objects match 16 names); OpenArt draws a white slab under every deco object when "diamond footprint" is in the prompt: `tools/strip_footprint.py` takes it out (or leave the footprint out of the prompt next time). **What is left:** 75 credits under the ceiling (one two-version sheet); the 202 rows still marked missing wait for the parent's next allowance. Everything the square needs is placed; `bunting`, `hay_bales`, `fountain` and `picnic_table` are cut but not placed.

💡 **For the parent (to go on):** the ceiling of 2100 credits is almost reached (2025 used, 75 left: one two-version sheet). Everything the game uses today has a picture. 202 `ART_LIST.csv` rows still say missing: 56 helpers (carrying_yoke, hay_rack, tool_rack, milking_stool, …), 87 `k_*` cards, windows and one square. **Recommendation: allow +250 credits** (about five sheets of 12 helpers each, three versions, 45 credits a sheet) and Claude does the helpers first; the cards need your word on whether they should have pictures at all. Without more credits nothing is blocked: the game shows emoji where a picture is missing.
