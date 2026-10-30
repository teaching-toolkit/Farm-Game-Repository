# Node map: what the game really has, by chapter

Slice 00, 23 Oct 2026. Purpose: so that every event seed in the run can name a trigger the engine reads today (or say clearly that it cannot). Everything below was read from files on 23 Oct 2026: `godot-prototype/data/farm/nodes/*.json` (467 nodes), `chapters.json`, `recipes.json`, `places.json`, `rules/*.json`, `data/farm/story/*.json` (the 80 shipped pieces), `story/staging/more-ch*.json` (the 166 staged pieces, not in the game), and the engine code `kits/core/conditions.gd`, `game/farm/game.gd` (`counter`, `term`, `chapter`), `game/farm/systems/story.gd`, `game/farm/ui/storybox.gd`. Nothing here is invented; labels 💡 mark my readings and proposals.

Reading the "hooked by" column: **S:** a shipped piece fires on this node; **W:** a staged piece (written, English only, not in the game yet) fires on it; `-` means no piece uses it yet. Those unhooked goal nodes are free trigger slots for new event seeds (the tail of each chapter names the best ones).

## 1. How the engine decides when story shows

- **Clock.** One right Time Quiz answer = one *step*. A season is 30 steps (`rules/10-farming.json` `lengthQuestions`); the order is spring, summer, autumn, winter, and step 0 is spring. `seasons` counts seasons since the start (step ÷ 30). Years are never counted in text (D11), but the engine does cycle: the bot's first chapter alone runs about 8 seasons.
- **Engine chapter.** `chapter() = 1 + the number of pets that are home` (pet order bunny, tortoise, goat, pony, badger; the alpaca ends the game). So chapter 2 begins the moment the bunny comes home. A node's own `chapter` field is only a label, not a gate (consistency-fixes §3). A piece's own `chapter` field is a gate: it cannot show before that engine chapter. The condition `chapter:<n>` is equality (true only while that chapter lasts); `chapter>=n` is the counter and stays true.
- **Rationing** (`systems/story.gd`). Kinds in priority order: frame, beat, discovery, letter, moment, visit, scene, bark. `moment`, `visit` and `letter` are rationed to one per 3 steps. Beats, discoveries, scenes, frames and barks are not. Order inside the ready list: kind, then priority (higher first), then least recently seen, then file order. Barks come back (cooldown 12 steps) unless `once:true`; everything else shows once.
- **Quiet gate** (`ui/storybox.gd`). Nothing shows during the Time Quiz, Rest, a modal, a celebration or a pending gift. A bark waits only for the speech bubble to be free. A discovery may open over a sheet (you just tapped it).
- **Shape of a piece.** `kind, chapter, when[], priority, once, emoji, title, text or pages[{text, picture}], then`. Pages are plain text with `{player}` as the only placeholder. `then` is understood only as `"welcome"`.
- **Pictures.** Painted story scenes are looked up as `assets/story/<id>_p<page>.png` then `<id>.png`. 35 files exist, for 31 pieces (webp): c1_frame0 p1-3, c1_frame1 p1-2, c1_stalk p2-3, c1_book, c1_night, c1_bells, c1_board, c1_bunny, c1_bell_out, c2_barn, c2_hook, c2_lark, c2_stumps, c2_tortoise, c3_bell, c3_dance, c3_goat_out, c4_quill, c4_count, c4_lease, c4_no, c4_pony, c4_quill_out, c4_frame4, c5_cough, c5_page, c6_garden, c6_crisis, c6_fair_letter, c6_ajar, c6_free_garden. A piece with no picture gets an emoji header.

## 2. Trigger vocabulary (all of it that the code reads)

| Form | Meaning | Example in use |
|---|---|---|
| `start` | step is 0 | `c1_frame0`, `c1_stalk` |
| `done:<node>` or `unlocked:<node>` | that node is built / cleared / delivered / learned | `done:ruins_barn` |
| `seen:<id>` | a story piece, or an interface element (`face`, `coins`, `scroll`), has shown | `seen:c1_bunny` |
| `after:<piece>:<n>` | n steps have passed since that piece was seen (needs the piece seen) | `after:c3_letter:6` |
| `chapter:<n>` | engine chapter equals n | `chapter:5` |
| `season:<name>` | now spring, summer, autumn or winter | `season:winter` |
| `has:<item>:<n>` | the store holds n of an item (includes pet gifts and dishes before they are consumed) | `has:honey:1` |
| `tap:<key>` | the player has tapped that place once; keys are spot ids (`home living library kitchen well storage workshop field forest lumber coop cows sheep bees barn windmill compost pond orchard greenhouse pets market bookcart board broker road barn_build barn_cellar barn_ferment barn_hay barn_seeds ws_build ws_bench ws_fire ws_loom ws_tools`) and `patch:<kind>` (what is in the way on a locked patch: `patch:weeds` (thistles and weeds both show as weeds), `patch:rocks`, `patch:stumps`, `patch:scrub` (the second field, the North Field), `patch:marsh` (the third field, the River Meadow); a usable patch gives `patch:field`, `patch:orchard` or `patch:gh`). Only weeds and rocks have pieces so far; scrub and marsh are free hooks | `tap:board` |
| `page:<card>` | that knowledge card's page was opened (87 cards, 14 books, ids in section 5) | `page:k_wheat` |
| `chance:<p>` | deterministic per step and per piece: the same answer all through one step | `chance:0.2` |
| `<counter>>=<n>` | `sidequests, seasons, weeds, cards, harvests, rest_quick, medals, arith_level, sold_kinds, friends, coins, album, chapter, step, items_seen, story_seen, goals, trips, packed, skill_ranks, well_mood, forest_trips, forest_poisoned, forest_checked, lord_owed, lord_paid, lord_shares` | `lord_shares>=3` |

All conditions in `when[]` must hold (AND). There is no OR and no NOT.

## 3. What the engine cannot read or show yet (design limits for seeds)

Cannot read: negation (`not:`; "not yet done"); a pest, rain, frost or drought event; first night as an event (use `step>=2`); energy running out; a wrong quiz answer; a stranger turned away; a crop standing in a field; `open:<node>`; which pet is named what (players rename pets: no `{pet}` placeholder exists, so texts say "the bunny", "the goat"); time of day; the number of sold items by kind; reputation level (`trust` exists in rules but has no counter in `counter()`); the Lord's share *amount* as a story number (only `lord_owed`, `lord_paid`, `lord_shares` counts).

Cannot show: a choice (the ch6 "Sit down / Tell" tap is plain pages); a walking villager (a `visit` is an ordinary box, not a little figure at the gate: story-delivery §7 is still a plan); the village-square pop-up (a `scene` is an ordinary box); a speaker name (the field exists in the data and the box ignores it); a sound or music cue (the melody phrase on each Helper's return has no hook); a `trace` piece (the engine skips kind `trace`: Mumyo's bell sounds and prank props are not wired); a second piece in the same moment (one at a time).

Data-level traps that change what story can promise: the badger needs the card `k_ask_grownup`; `c5_page` waits for `has:healers_chest:1`, but the pet's cost consumes the chest, so the torn-page twist and `c5_collapse` can be missed (code-issues C3); `pet_tortoise` does not require `pond`; `pet_alpaca` does not require `river_meadow_drain` (the night garden), so the ending can precede the garden (C9); `c6_free_*` are after the last pet, so every payoff placed there is optional.

## 4. The pets' ledger (the chapter spine)

| Pet | Node | Requires (besides earlier pets) | Costs (dish, comfort item) | Home reached around (bot step / target hour) | Level-1 bonus |
|---|---|---|---|---|---|
| Bunny (Pip) | `pet_bunny` | `chopping_block, well_3, animal_chicken` | `bunny_bowl` (carrot 3, clover 3), `straw_hutch` | step ~244 / 1 h | +1 carrot per carrot harvest |
| Tortoise (Mossy) | `pet_tortoise` | `prep_table_1, animal_cow` | `garden_platter` (lettuce, tomato, clover), `shell_house` (plank, brick, straw) | ~420 / 4.5 h | +1 water per water trip |
| Goat (Bramble) | `pet_goat` | `oven_2, windmill_1` | `apple_crumble`, `goat_shed` | ~648 / 10 h | weeds -15 %, compost |
| Pony (Hazel) | `pet_pony` | `barn_3, farmhouse` | `apple_carrot_cake`, `saddle_blanket` | ~844 / 17.5 h | +10 % when selling |
| Badger (data says Bramble; canon Silverpaw) | `pet_badger` | `ruins_stillroom, k_ask_grownup` | `healers_chest` (six remedies), `tea_set` | ~905 / 21 h | +1 herb per herb harvest |
| Alpaca (Alfie) | `pet_alpaca` | `oven_3, greenhouse, d_fair_cloth, farmhouse_sunroom` | `golden_honey_cake`, `rainbow_roast`, `rainbow_quilt` | ~1069 / 25.5 h | 1 wool per 4 steps |

Bot steps are from `code-issues-story-timing.md` (chapter lengths: ch1 1-244, ch2 245-420, ch3 422-648, ch4 649-844, ch5 845-905, ch6 906-1069). A human player is slower. Pets work from level 2 on the job board (`rules/54-pets.json`), level = 1 + pets that came home after it, up to 4.

## 5. Systems the story can lean on

- **The Lord's share** (`rules/53-lord.json`, `systems/lord.gd`): starts in chapter 3; fraction of what the Lord *assumes* the farm gives: ch3 0.10, ch4 0.20, ch5 0.33, ch6 0.50. Pieter (night watchman, lantern in daylight) comes to the gate at each season's end and waits until it is paid; while something is owed, everything that costs coins is blocked (selling, making, farming; trips and barter go on). Unpaid shares pile up to 2 seasons. `eased` lowers it to 0.10 but nothing sets `eased` yet (F-075); the fix is `G.story.seen("c6_quill_answer")`. Counters: `lord_shares` (seasons charged), `lord_paid`, `lord_owed`.
- **Trust** (`rules/51-trust.json`): the village distrusts the farm at first; reputation (main goals done) and each trader's deeds (deliveries) lower prices only; nobody is ever angry. This is the mechanical "village warms" ladder; there is no counter for story to read.
- **The travelling merchant at the gate** (`rules/50-gate.json`): needs road level 2; 7 % chance per step, +3 % per better road; stays 3 steps; buys at 85 %. A he, per the ladder; the seller who first passes is a she.
- **Friends and postcards** (`rules/50-rewards.json`): people helped through favours count as `friends`; at milestones (a pet home, library level, every 12 goals) a friend may send a postcard with a gift card. Seven golden acorns (energy +3 each; the squirrel's) hide in the game.
- **Nature pools** (`rules/56-nature.json`): sticks, stones, clay, deadwood, trees (felled tree becomes stump, sapling, tree). The first time a pool runs low there is advice text.
- **Wellbeing face** appears in chapter 2 (`reveal.face`); tapping the farmer opens the dashboard.
- **The forest** (chapter 5, `rules/57-forest.json`): entered from the forest edge; in and out each cost one step; basket of 6 (+4 with `gathering_basket`); spots `glade, stream, oak, moonstone, hedge, meadow, clearing, floor, willow` with seasonal find / pick / dig / look tasks (look-alike pairs: chamomile v mayweed, yarrow v hemlock). The oak spot has a squirrel's stash (autumn); the moonstone "hums" and gives quartz. Wren checks your basket for 30 coins' worth of dish or remedy; skipping a needed check poisons you for 6 steps at double energy cost and takes all coins.
- **Pictures as rewards.** Every favour ends in an album picture (text in the node), which the story pieces can echo. The picture text is the closest thing the game has to a canon description of each favour's happy ending.

## 6. Cards that carry Berit's margin notes (staged `page:` triggers)

Little Farm Book (free, the only book that can plausibly be Berit's): `k_wheat k_fire k_roots k_rope k_tools k_weeds k_water k_soil k_ash k_chickens k_birds k_compost k_seeds k_hay k_winter_wheat`. Bought at the Book Cart: Village Crafts `k_grinding k_market k_timber k_clay k_charcoal k_building k_thatch`; Grandma's Kitchen `k_bread k_stove k_butter k_honey k_salt`; Animals & Bees `k_cows k_bees k_mucking k_feed k_pests`; Soil & Seasons `k_rotation k_seasons k_frost k_pond k_trees k_double_dig k_regrow k_kale`; Body and Mind `k_sleep k_food k_strength k_friends k_calm k_play`; Smith's Book `k_iron k_smithing k_nails k_wind k_irrigation`; From Fleece to Fabric `k_wool k_weaving k_flax`; Cellar & Larder `k_press k_sugar k_ferment k_cheese k_cellar k_pickling`; Fire, Glass & Steel `k_steel k_glass k_greenhouse k_masonry`; Orchard & Oils `k_orchard k_olives k_pasta k_hardwood k_deep_soil k_mulch`; The Healer's Herbal `k_plant_parts k_drying k_teas k_syrup_salve k_lookalikes k_foxglove k_willow k_skin_only k_ask_grownup`; Colours of the Earth `k_dyes k_colour_mixing`; The Master Farmer `k_worms k_seed_saving k_saffron k_master_baking k_wind_pump k_living_soil`. Book titles that clash with canon voice: "Grandma's Kitchen" (the word *Grandma* is reserved for nobody in the frame, D14; here it names a book) and a favour still called "Fix the chapel roof" (`sq_chapel_roof`, no religion, D15).


---

## Chapter 1: Ashes

**Engine chapter 1** lasts until `pet_bunny` is done: bot steps 1-244 (about 8 seasons, spring to spring twice), target about 1 hour of play. Shipped 17 pieces, staged 51.

**Critical path (never missable, so beats may hang here):** `campfire` (needs card `k_fire`), `d_porridge` (the seller), `workbench` + `ruins_workshop` (the burnt ledger page, Q3) + `clear_weeds` + `clear_rocks`, `stone_axe`, `wooden_shovel` (card `k_tools`), `chopping_block`, `road_1b`, `road_2` (opens `seed_2`, the cart), `well_1..3`, `coop_1`, `animal_chicken` (card `k_chickens`), `book_basics` (card `k_wheat`, the first card), `pet_bunny`. **Optional (a bark may never be seen):** `clear_thistles` (so the first bell, Q2, `c1_bells`, is optional and the bot never needs it), `clear_stumps`, the whole village strand except the porridge.

**Pieces on non-node triggers (shipped):** `c1_frame0`, `c1_stalk` (`start`), `c1_book` (`page:k_wheat`), `c1_night` (`step>=2`), `c1_board` (`tap:board`), `c1_bell_out` (`seen:c1_bunny` + `after:c1_bunny:1`), `c1_frame1` (`seen:c1_bell_out`), barks keyed on steps and seasons. The first player action is the name prompt ("Who is playing?"), then `c1_frame0` (3 pages), `c1_stalk` (3 pages), the welcome hint box, the first card.

**Dishes:** `porridge` (campfire; the seller), `veg_soup` (village), `roast_carrots`, `flatbread`, `stone_soup`, `bunny_bowl` (carrot 3 + clover 3, chopping block, the bunny's dish), `straw_hutch` (the bunny's comfort item). Merchants: `seed_1` (carrot seeds, from the start), `seed_2` cart, `raw_1`, `book_cart`, `seed_3` stall, `spice_1`.

**Free hooks worth using:** `sq_twins_porridge` (Lotte and Linus, no piece yet), `road_1b`, `road_2` (a road tier the seller's cart needs), `patch_dug/edged/raised` (the garden taking shape), `present_onion`, `library_box` (the box with the book), `seed_3`, `spice_1`, `tap:forest`, `tap:road`, `tap:pond` (the wild pond with the bucket; no piece), `tap:well`, `tap:kitchen`, `tap:living` (the tent), `tap:storage`.


**Land jobs and ruins** (6). `id | name | requires | hooked by (S shipped, W staged)`

- `ruins_workshop` | Clear the old workshop | campfire | S: c1_ledger
- `land_start` | One cleared patch | - | -
- `clear_thistles` | Clear the thistles (2 patches) | - | S: c1_bells; W: c1_cleared
- `clear_weeds` | Pull the weeds (2 patches) | - | W: c1_cleared
- `clear_rocks` | Clear the rocks (2 patches) | wooden_shovel | W: c1_tower, c1_cleared
- `clear_stumps` | Clear the stumps (2 patches) | stone_axe | W: c1_cleared

**Pet** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `pet_bunny` | Bunny comes home | chopping_block, well_3, animal_chicken | S: c1_bunny

**Deliveries (dishes handed over)** (3). `id | name | requires | hooked by (S shipped, W staged)`

- `d_porridge` | Feed the travelling merchant | campfire | S: c1_seller, c1_k_seller
- `present_onion` | A present for the seed cart | seed_2 | -
- `d_veg_soup` | Soup for the village | seed_2, well_2 | W: c1_soup

**Favours (side quests)** (4). `id | name | requires | hooked by (S shipped, W staged)`

- `sq_cold_shepherd` | Little shepherd Tom is freezing | campfire | W: c1_tom
- `sq_lost_goat` | Granny Maud's goat ran off | clear_weeds | W: c1_maud, c3_maud_goat
- `sq_twins_porridge` | Porridge for the hungry twins | d_porridge | -
- `sq_miller_basket` | The miller's daughter needs a basket | workbench | W: c1_ella

**Merchants** (6). `id | name | requires | hooked by (S shipped, W staged)`

- `seed_1` | Seed Merchant | - | -
- `seed_2` | Seed Merchant · cart | d_porridge, road_2 | -
- `raw_1` | Raw Materials · timber & stone | d_porridge, road_2 | -
- `seed_3` | Seed Merchant · stall | d_veg_soup | -
- `spice_1` | Spice Merchant | d_veg_soup | -
- `book_cart` | Book Cart | d_porridge, road_2 | -

**Stations** (5). `id | name | requires | hooked by (S shipped, W staged)`

- `campfire` | Campfire | k_fire | W: c1_fire
- `workbench` | Workbench | campfire, clear_weeds, ruins_workshop | W: c1_bench
- `chopping_block` | Chopping Block | stone_axe | -
- `quern` | Hand Quern | workbench, clear_rocks, k_grinding | W: c1_quern
- `wild_edge` | Field Edge & Woods | - | -

**Buildings** (12). `id | name | requires | hooked by (S shipped, W staged)`

- `tent` | Tent | - | -
- `well_1` | Old Bucket | - | -
- `road_1` | Muddy track | - | -
- `road_1b` | Lay brushwood over the mud | road_1 | -
- `road_2` | Fill the potholes | road_1b | -
- `basket` | Basket | - | -
- `well_2` | Dig a well | well_1, k_water | W: c1_well2
- `well_3` | Well · winch | well_2, clear_rocks, k_water | W: c1_winch
- `coop_1` | Chicken Coop | stone_axe, seed_2, k_chickens | W: c1_coop
- `scarecrow_1` | Stick Scarecrow | workbench, clear_stumps, k_birds | W: c1_scarecrow
- `library_box` | Book box in the tent | - | -
- `stick_fence` | Rickety Stick Fence | workbench, k_birds | W: c1_fence

**Tools** (7): `hands` (Hands); `rock` (Rock); `bucket` (Watering Scoop); `stone_knife` (Stone Knife); `stone_axe` (Hand Axe) [W: c1_axe]; `wooden_shovel` (Wooden Shovel); `stick_hoe` (Stick Hoe)

**Patches and animals** (4): `animal_chicken` (Chickens) [S: c1_k_hens; W: c1_hens]; `patch_dug` (Dug beds); `patch_edged` (Stick edging); `patch_raised` (Raised log beds)

**Crops** (6): `crop_wheat` (Wheat); `crop_carrot` (Carrot); `crop_clover` (Clover); `crop_onion` (Onion); `crop_hay` (Meadow hay); `crop_winter_wheat` (Winter wheat)

**Helpers (small upgrades, many of them gifts from favours)** (11): `gathering_basket` (Gathering Basket); `fire_ring` (Stone Fire Ring); `straw_bed` (Straw Bed); `nest_boxes` (Nest Boxes); `whetstone` (Whetstone); `carrying_yoke` (Carrying Yoke); `hand_cart` (Hand Cart); `lucky_horseshoe` (Tom's lucky horseshoe); `brass_bell` (Ella's brass bell); `cooking_tripod` (Cooking Tripod); `perches` (Roosting Perches)

**Gear** (5): `straw_hat` (Straw Hat); `straw_sandals` (Straw Sandals); `fiber_mitts` (Fibre Mitts); `fiber_bag` (Woven Bag); `straw_pillow` (Straw Pillow)

**Books and cards** (2): `book_basics` (The Little Farm Book); `book_village` (Village Crafts)

**Knowledge cards** (16; `page:<id>` triggers fire when the card's page has been read): `k_wheat`, `k_fire`, `k_roots`, `k_rope`, `k_tools`, `k_weeds`, `k_water`, `k_soil`, `k_ash`, `k_chickens`, `k_birds`, `k_grinding`, `k_market`, `k_seeds`, `k_hay`, `k_winter_wheat`


---

## Chapter 2: Homestead

**Engine chapter 2**: bot steps 245-420, target about 4.5 hours (cumulative). Shipped 13 pieces, staged 29. Chapter 2 begins when the bunny is home; the first letter fires on `chapter:2`.

**Critical path:** `road_2b`, `road_3` (Lark's arrival, `c2_lark`), `tent` (listed as a requirement of the cottage), `shed`, `cottage_walls`, `cottage_roof`, `cottage`, `workshop_1`, `carpenter_bench`, `prep_table_1`, `ruins_barn` (the low scorch, Q5), `barn_frame`, `barn_1`, `animal_cow`, `crop_clover`, `d_stone_soup`, `d_veg_soup`, `seed_3`, `raw_2`, `book_cart`, books `book_village`, `book_animals`, `pet_tortoise`. **Optional clue nodes:** `ruins_lumber` (stumps, Q4), `ruins_compost` (the tidy pit, Q6), `pond` (the pond; the tortoise's text says it fills but the pet does not require it), `orchard`. Q4 and Q6 can be missed completely.

**Non-node triggers (shipped):** `c2_letter` (`chapter:2`), `c2_berit_note` (`seen:face`; the face appears at chapter 2), `c2_k_rest` bark, `c2_hook` (`seen:c2_tortoise`), `c2_frame2` (`seen:c2_hook`).

**Dishes and wants of the village:** `stone_soup` (quarry folk), `pancakes` (seed stall), `bread` (Culture Specialist), `hearty_stew` (miners), `tomato_soup` (Old Jan), `garden_platter` + `shell_house` (the tortoise). Ruins in the chapter: `ruins_lumber` (burnt woodshed), `ruins_barn`, `ruins_compost`, `orchard` (old orchard), `pond`.

**Favours (all need the bunny home):** `sq_washing_line` (Hilde), `sq_sick_neighbour` (Old Jan), `sq_bridge` (Otto), `sq_healer_honey` (Wren; no piece yet), `sq_stray_kitten` (Ginger).

**Free hooks:** `cottage_roof`, `compost_bin` (+ `compost_bin_2`), `oven_1` (bread), `churn`, `coop_2`, `cap_bees_1`, `woodlot`, `library_shelf`, `patch_stone`, `wattle_fence`, `d_pancakes`, `d_hearty_stew`, `culture_1` (the Culture Specialist, no piece), `seed_4` (shop), `raw_3` (iron ore), `tap:bees`, `tap:cows`, `tap:compost`, `tap:lumber`, `tap:orchard`.


**Land jobs and ruins** (5). `id | name | requires | hooked by (S shipped, W staged)`

- `ruins_lumber` | Clear the burnt woodshed | shed, k_trees | S: c2_stumps
- `ruins_barn` | Clear the burnt barn | carpenter_bench, k_building | S: c2_barn
- `ruins_compost` | Clear the old compost corner | workbench, seed_3, k_compost | S: c2_compost
- `orchard` | Clear the old orchard | stone_axe, seed_4, k_trees | W: c3_swing
- `pond` | Dig out the pond | wooden_shovel, cottage, k_pond | S: c3_stream; W: c2_pond, c3_pond_sun

**Pet** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `pet_tortoise` | Tortoise comes home | prep_table_1, pet_bunny, animal_cow | S: c2_tortoise

**Deliveries (dishes handed over)** (6). `id | name | requires | hooked by (S shipped, W staged)`

- `present_lettuce` | Soup for the seed stall | seed_3 | -
- `present_beet` | Pancakes for the seed stall | seed_3, d_pancakes | -
- `d_stone_soup` | Stone Soup for the quarry folk | seed_3 | S: c2_greenstem
- `d_bread` | Sourdough for the Culture Specialist | oven_1 | W: c2_greenstem_hands
- `d_pancakes` | Pancake breakfast for the seed stall | stove_1 | -
- `d_hearty_stew` | Hearty Stew for the miners | spice_1, stove_1 | -

**Favours (side quests)** (5). `id | name | requires | hooked by (S shipped, W staged)`

- `sq_washing_line` | The washerwoman's line snapped | carpenter_bench, pet_bunny | W: c2_hilde
- `sq_sick_neighbour` | Soup for a sick neighbour | stove_1, crop_tomato, pet_bunny | W: c2_jan
- `sq_bridge` | Mend the footbridge | carpenter_bench, pet_bunny | W: c2_otto
- `sq_healer_honey` | Honey for the healer | animal_bees, pet_bunny | -
- `sq_stray_kitten` | A stray kitten keeps visiting | animal_cow, pet_bunny | W: c2_kitten, c2_k_kitten

**Merchants** (4). `id | name | requires | hooked by (S shipped, W staged)`

- `raw_2` | Raw Materials · clay | d_stone_soup, road_3 | -
- `culture_1` | Culture Specialist | d_bread | -
- `seed_4` | Seed Merchant · shop | d_pancakes, road_3 | -
- `raw_3` | Raw Materials · iron ore | d_hearty_stew, road_3 | -

**Stations** (9). `id | name | requires | hooked by (S shipped, W staged)`

- `compost_bin` | Compost Bin | workbench, seed_3, k_compost, ruins_compost | -
- `carpenter_bench` | Carpenter's Bench | workshop_1, k_timber | W: c2_bench
- `kiln` | Kiln | workshop_1, raw_2, k_clay | W: c2_kiln
- `stove_1` | Stove | cottage, raw_2, k_stove | W: c2_stove
- `oven_1` | Oven | cottage, kiln, k_bread | -
- `prep_table_1` | Prep Table | cottage, carpenter_bench | -
- `churn` | Butter Churn | barn_1, carpenter_bench, k_butter | -
- `compost_bin_2` | Compost Heap | compost_bin, carpenter_bench | -
- `pond_station` | Pond bank | pond | -

**Buildings** (16). `id | name | requires | hooked by (S shipped, W staged)`

- `road_2b` | Dig a ditch for the puddles | road_2, wooden_shovel | -
- `road_3` | Gravel road | road_2b, wooden_shovel | S: c2_lark
- `cottage_walls` | Cottage · log walls | tent, shed, k_building | S: c2_walls
- `cottage_roof` | Cottage · thatched roof | cottage_walls, k_thatch | -
- `cottage` | Cottage | cottage_roof, raw_2 | S: c2_cottage; W: c2_snug, c2_k_roof
- `workshop_1` | Carpenter's Shed | workbench, shed, k_timber | -
- `woodlot` | Woodlot | shed, k_trees, ruins_lumber | -
- `shed` | Log Shed | stone_axe, k_building | -
- `barn_frame` | Barn · frame | carpenter_bench, k_building, ruins_barn | W: c2_barn_frame
- `barn_1` | Barn | barn_frame, k_cows | W: c2_barn_done
- `cap_bees_1` | Bee Yard | seed_3, crop_clover, k_bees | -
- `market_stall` | Market Stall | carpenter_bench | W: c2_stall
- `coop_2` | Bigger Coop | coop_1, carpenter_bench | -
- `cap_bees_2` | Wooden Hives | animal_bees, carpenter_bench | -
- `library_shelf` | Bookshelf | carpenter_bench, library_box | -
- `wattle_fence` | Woven Wattle Fence | carpenter_bench, stick_fence | -

**Tools** (1): `wheelbarrow` (Wheelbarrow)

**Patches and animals** (3): `animal_cow` (Cows) [W: c2_cow, c2_k_cow]; `animal_bees` (Bees (straw skeps)) [W: c2_bees]; `patch_stone` (Stone borders & paths)

**Crops** (7): `crop_potato` (Potato); `crop_lettuce` (Lettuce); `crop_beans` (Beans); `crop_beet` (Beet); `crop_tomato` (Tomato); `crop_kale` (Winter kale); `crop_apple` (Apple Tree)

**Helpers (small upgrades, many of them gifts from favours)** (23): `pot_shelf` (Pot Shelf & Clay Pots); `dough_trough` (Dough Trough & Rolling Pin); `milking_stool` (Milking Stool & Pail); `water_trough` (Water Trough); `hay_rack` (Hay Rack); `salt_lick` (Salt Lick); `bee_smoker` (Bee Smoker); `scaffolding` (Scaffolding); `hearth` (Brick Hearth); `compost_fork` (Compost Fork); `tool_rack` (Tool Rack); `willow_whistle` (Willow Whistle); `garden_bench` (Bench by the Pond); `wind_chime` (Hilde's wind chime); `bird_feeder` (Otto's bird feeder); `lavender_bunch` (Wren's lavender); `barn_cat` (Ginger the farm cat); `oven_tray` (Second Baking Tray); `tall_chimney` (Tall Kiln Chimney); `glaze_shelf` (Extra Kiln Shelf); `worm_starter` (Worm Starter); `drain_gutter` (Barn Drain Gutter); `flower_strip` (Wildflower Strip)

**Gear** (3): `wooden_clogs` (Wooden Clogs); `wicker_pack` (Wicker Pack Basket); `clay_flask` (Clay Water Flask)

**Books and cards** (4): `book_kitchen` (Grandma's Kitchen); `book_animals` (Animals & Bees); `book_soil` (Soil & Seasons); `book_body` (Body and Mind)

**Knowledge cards** (28; `page:<id>` triggers fire when the card's page has been read): `k_timber`, `k_clay`, `k_charcoal`, `k_building`, `k_thatch`, `k_compost`, `k_bread`, `k_stove`, `k_cows`, `k_butter`, `k_bees`, `k_honey`, `k_salt`, `k_mucking`, `k_feed`, `k_rotation`, `k_seasons`, `k_frost`, `k_pond`, `k_trees`, `k_sleep`, `k_food`, `k_strength`, `k_friends`, `k_calm`, `k_play`, `k_regrow`, `k_kale`


---

## Chapter 3: Smallholding

**Engine chapter 3**: bot steps 422-648, target about 10 hours. Shipped 12 pieces, staged 29. **The Lord's share begins here** (`lord_shares>=1` fires `c3_pieter`; fraction 0.10).

**Critical path:** `kiln`, `stove_1`, `oven_1`, `oven_2` (card `k_bread`), `forge`, `anvil`, `iron_hammer`, `workshop_2` + `smithy_chimney`, `windmill_tower`, `windmill_1`, `ruins_windmill` (the small bell, Q8), `d_hearty_stew`, `raw_3`, `spice_1`, books `book_kitchen`, `book_smith`, `pet_goat`. **Optional:** `pond` (the miller's nod at `c3_stream` is optional), `sq_harvest_dance` (the dance, `c3_dance`), `sq_baby_blanket`, `sq_apprentice`, `sq_chapel_roof`, `orchard`, the whole cloth and cellar strand.

**Non-node triggers (shipped):** `c3_pieter` (`lord_shares>=1`), `c3_pieter_paid` (`lord_paid>=1`), `c3_k_pieter`, `c3_letter` (`chapter:3`), `c3_miller` bark (`chapter:3`), `c3_goat_out` (`seen:c3_goat`), `c3_frame3` (`seen:c3_goat_out`). Staged: `lord_shares>=3`, `>=6` (Pieter's gate visits), `after:c3_letter:6/16` (dread).

**Dishes:** `honey_oat_cake` (the forester), `simple_cake` (the seed merchant's birthday), `apple_crumble` + `goat_shed` (the goat), `cider` (the dance), `honey_oat_cake`. Mill: node `windmill_1` (sails; the picture decision "mill type" is open).

**Favours (need the tortoise home):** `sq_apprentice` (Bo, nails), `sq_baby_blanket`, `sq_harvest_dance` (Rosa), `sq_chapel_roof` (still a chapel in the data; Ansel the bell-ringer).

**Free hooks:** `road_3b`, `road_4` (cobbles), `road_4b` (trees along the road: the road to Hazelwood becoming the Hazelwood Minena knows), `well_4`, `cheese_vat`, `fermenter`, `press`, `sheep_pen`, `spindle`, `rain_barrel`, `honey_extractor`, `cottage_loft` (needed for the farmhouse), `patch_double`, `patch_channel` (needs `pond`), `raw_4`, `seed_5` (nursery), `present_flax`, `tap:windmill`, `tap:sheep`, `tap:workshop`, `ws_*` corners.


**Land jobs and ruins** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `ruins_windmill` | Clear the old mill | workshop_2, iron_hammer, k_wind | S: c3_bell

**Pet** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `pet_goat` | Goat comes home | pet_tortoise, oven_2, windmill_1 | S: c3_goat

**Deliveries (dishes handed over)** (3). `id | name | requires | hooked by (S shipped, W staged)`

- `present_flax` | A cake for the seed shop | seed_4, d_honey_oat_cake | -
- `d_honey_oat_cake` | Honey Oat Cake for the forester | oven_2 | -
- `d_simple_cake` | Cake for the seed merchant's birthday | oven_2 | -

**Favours (side quests)** (4). `id | name | requires | hooked by (S shipped, W staged)`

- `sq_apprentice` | The smith's apprentice is short of nails | anvil, pet_tortoise | -
- `sq_baby_blanket` | A blanket for the newborn | hand_loom, animal_sheep, pet_tortoise | W: c3_baby
- `sq_harvest_dance` | Cider for the harvest dance | fermenter, press, pet_tortoise | S: c3_dance
- `sq_chapel_roof` | Fix the chapel roof | sawbench, pet_tortoise | -

**Merchants** (2). `id | name | requires | hooked by (S shipped, W staged)`

- `raw_4` | Raw Materials · hardwood & sand | d_honey_oat_cake, road_4 | -
- `seed_5` | Seed Merchant · nursery | d_simple_cake, road_4 | -

**Stations** (12). `id | name | requires | hooked by (S shipped, W staged)`

- `forge` | Forge | workshop_2, k_iron | S: c3_forge; W: c3_k_forge
- `anvil` | Anvil | forge, k_smithing | -
- `sawbench` | Sawbench | saw, workshop_2, k_nails | -
- `cellar` | Cellar Racks | barn_2, k_cellar | W: c3_cellar
- `fermenter` | Fermenting Crocks | barn_1, kiln, k_ferment | -
- `cheese_vat` | Cheese Vat & Press | barn_2, culture_1, k_cheese | -
- `spindle` | Hand Spindle | workshop_1, seed_4, k_wool | -
- `hand_loom` | Hand Loom | spindle, k_weaving | W: c3_loom
- `honey_extractor` | Honey Extractor | workshop_2, animal_bees | -
- `press` | Wooden Press | carpenter_bench, seed_4, k_press | -
- `stove_2` | Stove · iron top | stove_1, anvil | -
- `oven_2` | Oven · iron door | oven_1, anvil | -

**Buildings** (16). `id | name | requires | hooked by (S shipped, W staged)`

- `road_3b` | Edge the road with kerbstones | road_3 | -
- `road_4` | Cobbled road | road_3b | -
- `road_4b` | Plant trees along the road | road_4, k_trees | -
- `smithy_chimney` | Smithy · chimney | workshop_1, kiln, raw_3, k_iron | -
- `workshop_2` | Smithy | smithy_chimney | -
- `well_4` | Well · brick lining & pulley | well_3, iron_hammer | -
- `rain_barrel` | Rain Barrel | sawbench, animal_bees | -
- `barn_2` | Barn · cellar | barn_1, sawbench, k_cellar | W: c3_goat_shed
- `sheep_pen` | Sheep Pen | barn_1, iron_hammer, k_wool | -
- `windmill_tower` | Windmill · stone tower | workshop_2, iron_hammer, k_wind, ruins_windmill | W: c3_tower
- `windmill_1` | Windmill | windmill_tower | W: c3_sails, c3_k_wind
- `scarecrow_2` | Dressed Scarecrow | scarecrow_1, hand_loom | W: c3_scarecrow2
- `lumbermill` | Lumbermill | woodlot, saw | -
- `cottage_loft` | Cottage · loft & second room | cottage, sawbench | -
- `library_bookcase` | Bookcase & reading chair | carpenter_bench, library_shelf | -
- `picket_fence` | Stake Fence | sawbench, wattle_fence, k_pests | -

**Tools** (7): `iron_shovel` (Iron Shovel) [W: c3_iron]; `iron_knife` (Iron Knife); `iron_hammer` (Iron Hammer); `saw` (Saw); `watering_can` (Watering Can); `shears` (Shears); `iron_hoe` (Iron Hoe)

**Patches and animals** (3): `animal_sheep` (Sheep) [W: c3_sheep]; `patch_double` (Double-dug beds); `patch_channel` (Irrigation channels)

**Crops** (3): `crop_sunflower` (Sunflower); `crop_flax` (Flax); `crop_oats` (Oats)

**Helpers (small upgrades, many of them gifts from favours)** (18): `bellows` (Bellows); `grindstone` (Grindstone); `shearing_table` (Shearing Table); `wool_mattress` (Wool Mattress) [W: c3_blanket]; `cheese_moulds` (Cheese Moulds); `oak_barrels` (Oak Barrels); `insect_hotel` (Insect Hotel); `iron_pans` (Iron Pans); `weeder_geese` (Weeder Geese); `sketchbook` (Sketchbook & Charcoal); `retting_trough` (Retting Trough); `owl_box` (Owl Box); `duck_house` (Duck House); `quench_trough` (Quench Trough); `canvas_sails` (Linen Sails); `sack_hoist` (Sack Hoist); `flying_shuttle` (Flying Shuttle); `wide_beam` (Wide Loom Beam)

**Gear** (7): `hobnail_boots` (Hobnail Boots); `wool_gloves` (Wool Work Gloves); `canvas_rucksack` (Canvas Rucksack); `stoneware_jug` (Sealed Stoneware Jug); `felt_hat` (Felt Hat); `linen_apron` (Linen Apron); `feather_pillow` (Feather Pillow)

**Books and cards** (3): `book_smith` (The Smith's Book); `book_cloth` (From Fleece to Fabric); `book_cellar` (Cellar & Larder)

**Knowledge cards** (16; `page:<id>` triggers fire when the card's page has been read): `k_iron`, `k_smithing`, `k_nails`, `k_wind`, `k_irrigation`, `k_wool`, `k_weaving`, `k_flax`, `k_press`, `k_sugar`, `k_ferment`, `k_cheese`, `k_cellar`, `k_pickling`, `k_double_dig`, `k_pests`


---

## Chapter 4: Village Trade

**Engine chapter 4**: bot steps 649-844, target about 17.5 hours. Shipped 9 pieces (the thinnest chapter in the game), staged 19. Master Quill arrives on `done:farmhouse_base`. The Lord's share is 0.20.

**Critical path:** `barn_2`, `barn_3`, `cottage_loft`, `farmhouse_base`, `farmhouse_walls`, `farmhouse` (needs `glass_kiln` and, through `farmhouse_walls`, `smiths_hammer`, which comes from `forge_2` and the steel card), `road_3b`, `road_4`, `sawbench`, `d_honey_oat_cake`, `raw_4`, books `book_cellar`, `book_glass`, `pet_pony`. **Note:** `ruins_greenhouse` (the old lease in the tin, Q9) is NOT on the pony's path; the alpaca needs `greenhouse`, which needs it, so the lease can be found as late as chapter 6. Quill's "The Lord will want to know" (`c4_quill_out`, after the pony) can therefore fire before the player has seen the lease. **Optional:** `north_field_clear`, `north_field` (the field Quill finds "resting"), `d_pizza`, `library_room`, all four favours.

**Non-node triggers (shipped):** `c4_quill_out` (`seen:c4_pony`), `c4_frame4` (`seen:c4_quill_out`). Staged: `lord_shares>=9`, `>=11` (Pieter's receipt), `season:spring + chapter:4` (the bucket).

**Dishes:** `pizza` (builders), `berry_cake`, `apple_pie`, `pickles` (Mei's voyage), `apple_carrot_cake` + `saddle_blanket` (the pony), `candle` + `glass` + `iron` (Pieter's lantern).

**Favours (need the goat home):** `sq_school_window` (Teacher Ines), `sq_wedding_cake` (Anna and Ben), `sq_night_watch` (Pieter; the tiny light), `sq_long_voyage` (Captain Mei; a mother's letter).

**Free hooks:** `road_5` (paved road and a bridge: where the miller stood), `kiln_2`, `smiths_hammer`, `warehouse`, `workshop_3`, `greenhouse_frame`, `well_5`, `steel_*`, `patch_deep`, `patch_cloche`, `textile_loom`, `spinning_wheel`, `food_processor`, `present_berries`, `raw_5`, `lumbermill_2`, `stone_wall`, `tap:greenhouse`, `tap:home` (the farmhouse).


**Land jobs and ruins** (3). `id | name | requires | hooked by (S shipped, W staged)`

- `ruins_greenhouse` | Clear the old glasshouse | smiths_hammer, k_greenhouse | S: c4_lease
- `north_field_clear` | North Field · clear the scrub | iron_hoe, barn_2 | W: c3_north
- `north_field` | North Field | north_field_clear, sawbench | -

**Pet** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `pet_pony` | Pony comes home | pet_goat, barn_3, farmhouse | S: c4_pony; W: c4_k_pony

**Deliveries (dishes handed over)** (2). `id | name | requires | hooked by (S shipped, W staged)`

- `present_berries` | A cake for the nursery | seed_5 | -
- `d_pizza` | Pizza night for the builders | oven_2, cheese_vat | S: c4_pizza

**Favours (side quests)** (4). `id | name | requires | hooked by (S shipped, W staged)`

- `sq_school_window` | The schoolroom window is broken | glass_kiln, pet_goat | W: c4_window, c4_k_school
- `sq_wedding_cake` | A wedding needs a cake | oven_2, crop_berries, pet_goat | W: c4_wedding
- `sq_night_watch` | A lantern for the night watchman | glass_kiln, anvil, pet_goat | W: c4_watch
- `sq_long_voyage` | Pickles for a long voyage | cellar, pet_goat | W: c4_mei

**Merchants** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `raw_5` | Raw Materials · guild stock | d_pizza, road_5 | -

**Stations** (7). `id | name | requires | hooked by (S shipped, W staged)`

- `kiln_2` | Brickworks | kiln, iron_hammer, raw_4, k_masonry | -
- `forge_2` | Blast Forge | forge, raw_4, k_steel | -
- `glass_kiln` | Glass Kiln | kiln, forge, raw_4, k_glass | W: c4_glass
- `prep_table_2` | Prep Table · marble top | prep_table_1, master_saw, farmhouse | -
- `food_processor` | Grinding Mill (kitchen) | quern, windmill_1, farmhouse | -
- `spinning_wheel` | Spinning Wheel | spindle, master_saw | -
- `textile_loom` | Textile Loom | hand_loom, workshop_3 | -

**Buildings** (14). `id | name | requires | hooked by (S shipped, W staged)`

- `road_5` | Paved road & bridge | road_4b | -
- `farmhouse_base` | Farmhouse · foundation | cottage_loft, raw_4, k_masonry | S: c4_quill
- `farmhouse_walls` | Farmhouse · brick walls | farmhouse_base, smiths_hammer | S: c4_count
- `farmhouse` | Farmhouse | farmhouse_walls, glass_kiln | S: c4_no
- `warehouse` | Warehouse | shed, iron_hammer | -
- `workshop_3` | Master Workshop | workshop_2, smiths_hammer | -
- `greenhouse_frame` | Greenhouse · frame | smiths_hammer, k_greenhouse, ruins_greenhouse | -
- `greenhouse` | Greenhouse | greenhouse_frame, glass_kiln | W: c4_greenhouse, c4_k_winter
- `well_5` | Well · hand pump | well_4, smiths_hammer | -
- `barn_3` | Barn · stable | barn_2, smiths_hammer | -
- `scarecrow_3` | Guardian Scarecrow | scarecrow_2, iron_hammer | W: c4_scarecrow3
- `lumbermill_2` | Lumbermill · hardwood grove | lumbermill, master_saw, k_hardwood | -
- `library_room` | Library room | farmhouse, library_bookcase | S: c4_library
- `stone_wall` | Field Stone Wall | iron_hammer, picket_fence | -

**Tools** (6): `steel_shovel` (Steel Shovel); `steel_knife` (Steel Knife); `smiths_hammer` (Smith's Hammer); `master_saw` (Master Saw); `drip_line` (Drip Line); `steel_hoe` (Steel Hoe)

**Patches and animals** (2): `patch_deep` (Deep-worked beds); `patch_cloche` (Glass cloches)

**Crops** (5): `crop_pumpkin` (Pumpkin); `crop_berries` (Berry Bush); `crop_herbs` (Herbs); `crop_walnut` (Walnut Tree); `crop_olive` (Olive Tree)

**Helpers (small upgrades, many of them gifts from favours)** (7): `linen_bedding` (Linen Bedding) [W: c6_quilt]; `lanterns` (Lanterns); `seed_drill` (Seed Drill); `proofing_baskets` (Bread Peel & Proofing Baskets); `rotary_churn` (Rotary Churn); `mulch_spreader` (Straw Mulch); `fiddle` (Little Fiddle)

**Gear** (7): `waxed_boots` (Waxed Walking Boots); `waxed_gloves` (Waxed Linen Gloves); `frame_rucksack` (Frame Rucksack); `glass_bottle` (Glass Bottle & Sling); `linen_sunhat` (Wide Linen Sunhat); `canvas_apron` (Waxed Canvas Apron); `down_pillow` (Wool & Down Pillow)

**Books and cards** (2): `book_glass` (Fire, Glass & Steel); `book_orchard` (Orchard & Oils)

**Knowledge cards** (10; `page:<id>` triggers fire when the card's page has been read): `k_steel`, `k_glass`, `k_greenhouse`, `k_masonry`, `k_orchard`, `k_olives`, `k_pasta`, `k_hardwood`, `k_deep_soil`, `k_mulch`


---

## Chapter 5: Healing

**Engine chapter 5**: bot steps 845-905 (only about 60 steps), target about 21 hours. Shipped 11 pieces, staged 14. The Lord's share is 0.33 and no shipped piece mentions the share in this chapter (the Lord's seal arrives only at the end, `c5_letter`). The shortest chapter in play and the only one with its own system (the forest and the remedies).

**Critical path (11 nodes):** `ruins_stillroom` (needs `pet_pony`, `crop_herbs`; the torn page, Q10), `crop_herbs`, `road_4b`, `d_simple_cake`, `seed_5`, books `book_herbal`, `book_soil`, cards `k_ask_grownup`, `k_seasons`, `k_trees`, `pet_badger` (cost: `healers_chest` + `tea_set`). The six remedies in the chest come from `tea_pot` (chamomile, peppermint, sage), `syrup_pan` (thyme), `mortar` (plantain), `salve_pot` (marigold), plus plants gathered in the forest (`forest_trips`). **Optional:** `sq_lamp_maker`, `sq_healer_garden`, `copper_still`, `drying_rack`, `mortar`, `syrup_pan`.

**Non-node triggers (shipped):** `c5_cough` (`chapter:5`), `c5_wren_check` (`forest_trips>=1`), `c5_conch` (`forest_trips>=3`), `c5_poison` (`forest_poisoned>=1`), `c5_page` (`has:healers_chest:1`, see the trap in section 3), `c5_collapse` (`seen:c5_page` + `after:c5_page:2`), `c5_letter` (`seen:c5_badger` + `after:c5_badger:1`), `c5_frame5`. Staged: `forest_trips>=2/7`, `page:k_lookalikes/k_foxglove/k_ask_grownup`, `has:tea_set:1`, `seen:c5_badger + after:c5_badger:3`.

**Dishes and remedies:** `chamomile_tea`, `peppermint_tea`, `elder_tea`, `willow_tea`, `sage_gargle` (tea_pot), `thyme_syrup` (syrup_pan), `plantain_paste`, `yarrow_paste` (mortar), `marigold_salve`, `arnica_salve`, `lavender_water` (salve_pot), `healers_chest`, `tea_set` (kiln, 4 clay). Forest spots and tasks: section 5 of the head. Fixed real cast: Wren (heals, checks baskets), Greenstem (becomes her pupil at `done:tea_pot`).

**Free hooks:** `mortar`, `syrup_pan`, `drying_rack` (staged), `sq_healer_garden` (Wren's garden), `copper_still` (Herb Drying Loft), `tap:kitchen` (the still-room is placed there), `tap:forest`, forest spot `moonstone`, spot `oak` (squirrel stash), `page:k_plant_parts/k_drying/k_teas/k_syrup_salve/k_willow/k_skin_only`. There is nothing in chapter 5 that is not Wren, the forest or the remedies.


**Land jobs and ruins** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `ruins_stillroom` | Clear Berit's still-room | pet_pony, crop_herbs | S: c5_stillroom; W: c5_k_still

**Pet** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `pet_badger` | Badger comes home | pet_pony, ruins_stillroom, k_ask_grownup | S: c5_badger

**Favours (side quests)** (2). `id | name | requires | hooked by (S shipped, W staged)`

- `sq_lamp_maker` | Oil for the old lamp-maker | crop_olive, press, pet_pony | W: c5_lamp
- `sq_healer_garden` | Herbs for the healer's garden | crop_herbs, pet_pony | -

**Stations** (5). `id | name | requires | hooked by (S shipped, W staged)`

- `drying_rack` | Drying Rack | ruins_stillroom, k_drying | W: c5_dry
- `mortar` | Mortar and Pestle | ruins_stillroom, k_plant_parts | -
- `tea_pot` | Tea Pot Hearth | ruins_stillroom, k_teas | S: c5_first_tea; W: c5_k_tea
- `syrup_pan` | Syrup Pan | ruins_stillroom, k_syrup_salve | -
- `salve_pot` | Salve Pot | ruins_stillroom, k_syrup_salve | W: c5_salve

**Helpers (small upgrades, many of them gifts from favours)** (1): `copper_still` (Herb Drying Loft)

**Books and cards** (1): `book_herbal` (The Healer's Herbal)

**Knowledge cards** (9; `page:<id>` triggers fire when the card's page has been read): `k_plant_parts`, `k_drying`, `k_teas`, `k_syrup_salve`, `k_lookalikes`, `k_foxglove`, `k_willow`, `k_skin_only`, `k_ask_grownup`


---

## Chapter 6: Master Farm

**Engine chapter 6**: bot steps 906-1069, target about 25.5 hours, then free play (every pet at level 4). Shipped 18 pieces (6 of them free-play favours after the last pet), staged 24. The Lord's share is 0.50 from the first step of the chapter.

**Critical path:** `import_broker` (arrives with the badger; sells nothing, only barters), `ruins_greenhouse`, `greenhouse_frame`, `greenhouse`, `workshop_3`, `road_5`, `cellar` + `cellar_2` (Cheese Cave), `dye_vat`, `oven_3`, `d_fair_pies` -> `d_fair_cheese` -> `d_fair_cloth` (the three Fair tables that are required; `d_fair_preserves` is optional), `farmhouse_sunroom`, books `book_cloth`, `book_colours`, `book_master`, `pet_alpaca`. **NOT on the path:** `river_meadow_drain` (the night garden, Q12) and its pictures; `orchard_2`; every `sq_*` favour. The ending can be reached without ever seeing the garden.

**Non-node triggers (shipped):** `c6_lord` (`chapter:6`), `c6_fair_letter` (`done:d_fair_cheese`), `c6_fair_tables` (`seen:c6_fair_letter`), `c6_crisis` (`done:d_fair_cloth`), `c6_bend` (`seen:c6_crisis`), `c6_quill_answer` (`done:farmhouse_sunroom`; not ordered against the bend), `c6_supper` (`seen:c6_alpaca`), `c6_ajar` (`seen:c6_supper`), `c6_frame6` (`seen:c6_ajar`). Free play (after the alpaca): `sq_free_family`, `_quill`, `_greenstem`, `_miller`, `_lark`, `_garden`; the reconciliation with the cousin, Quill's smile, the sails turning and the squirrel's name live only here and are optional.

**Dishes:** `pumpkin_pie` + `apple_pie` (pie table), `cheese_board` + `tapenade` (cheese table), `pickles` + `jam` + `cured_olives` (preserves), `rainbow_yarn` + `linen_cloth` (weaving table), `golden_honey_cake`, `rainbow_roast`, `rainbow_quilt` (the alpaca), `tapenade` + `pumpkin_soup` + `bread` (the elders' feast).

**Favours (need the pony home, so they can be done in chapter 6 or earlier):** `sq_poet_scarf` (Kit), `sq_painter_saffron` (Lucia), `sq_school_garden`, `sq_theatre_cheese`, `sq_orphanage_jam` (Matron Elsie), `sq_elders_feast` (Agnes), `sq_festival_flags` (Mayor Juno), `sq_village_well` (Young Sami), `sq_telescope` (Vega).

**Free hooks:** `d_fair_pies`, `d_fair_preserves` (the first and the optional Fair tables), `cellar_2`, `windmill_2`, `stove_3`, `greenhouse_2`, `cap_bees_3`, `worm_bin`, `patch_master`, `river_meadow` (after the drain), `scarecrow_4`, `hedge_row`, `seed_library`, `wind_pump`, `tap:marsh` (patch:marsh, the River Meadow before the drain), `tap:broker`, the crops `crop_saffron/rainbow_carrot/golden_beet/woad`.


**Land jobs and ruins** (3). `id | name | requires | hooked by (S shipped, W staged)`

- `orchard_2` | Orchard terraces | orchard, steel_shovel, import_broker | W: c6_terraces
- `river_meadow_drain` | River Meadow · drain the marsh | north_field, import_broker, steel_hoe | S: c6_garden
- `river_meadow` | River Meadow | river_meadow_drain, kiln_2 | -

**Pet** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `pet_alpaca` | Alpaca comes home | pet_badger, oven_3, greenhouse, d_fair_cloth, farmhouse_sunroom | S: c6_alpaca; W: c6_k_alpaca

**Deliveries (dishes handed over)** (4). `id | name | requires | hooked by (S shipped, W staged)`

- `d_fair_pies` | Harvest Fair · pie table | import_broker | -
- `d_fair_cheese` | Harvest Fair · cheese table | d_fair_pies, cellar_2 | S: c6_fair_letter
- `d_fair_preserves` | Harvest Fair · preserves table | d_fair_pies | -
- `d_fair_cloth` | Harvest Fair · weaving table | d_fair_cheese, dye_vat | S: c6_crisis

**Favours (side quests)** (15). `id | name | requires | hooked by (S shipped, W staged)`

- `sq_poet_scarf` | A rainbow scarf for the little poet | dye_vat, pet_pony | W: c6_poet
- `sq_painter_saffron` | Golden paint for the painter | crop_saffron, pet_pony | W: c6_painter
- `sq_school_garden` | Seeds for the school garden | crop_rainbow_carrot, pet_pony | -
- `sq_theatre_cheese` | Cheese for the travelling theatre | cellar, pet_pony | W: c6_theatre
- `sq_orphanage_jam` | Jam for the orphanage | crop_berries, stove_2, pet_pony | W: c6_orphanage
- `sq_elders_feast` | A feast for the village elders | food_processor, pet_pony | W: c6_agnes
- `sq_festival_flags` | Dye the festival flags | dye_vat, pet_pony | W: c6_flags
- `sq_village_well` | Rebuild the village well | smiths_hammer, pet_pony | W: c6_well
- `sq_telescope` | The astronomer's telescope | glass_kiln, master_saw, pet_pony | W: c6_telescope
- `sq_free_family` | A table for the family | pet_alpaca | S: c6_free_family
- `sq_free_quill` | Everything to count for Quill | pet_alpaca | S: c6_free_quill
- `sq_free_greenstem` | A chest for Greenstem | pet_alpaca | S: c6_free_greenstem
- `sq_free_miller` | Flour for the miller | pet_alpaca | S: c6_free_miller
- `sq_free_lark` | A name for the squirrel | pet_alpaca | S: c6_free_lark
- `sq_free_garden` | A bowl of milk for the night garden | pet_alpaca | S: c6_free_garden

**Merchants** (1). `id | name | requires | hooked by (S shipped, W staged)`

- `import_broker` | Import Broker | pet_badger, road_5 | S: c6_broker

**Stations** (5). `id | name | requires | hooked by (S shipped, W staged)`

- `dye_vat` | Dye Vat | workshop_3, import_broker, k_dyes | W: c6_dye
- `oven_3` | Master Oven | oven_2, farmhouse, k_master_baking | W: c6_oven
- `stove_3` | Master Stove | stove_2, farmhouse | -
- `cellar_2` | Cheese Cave | cellar, import_broker | -
- `worm_bin` | Worm Bin | compost_bin_2, import_broker, k_worms | -

**Buildings** (8). `id | name | requires | hooked by (S shipped, W staged)`

- `seed_library` | Seed Library | import_broker, warehouse, k_seed_saving | W: c6_seed_library
- `windmill_2` | Windmill · stone grinders | windmill_1, master_saw | -
- `wind_pump` | Wind Pump | windmill_2, k_wind_pump | W: c6_whirligig
- `greenhouse_2` | Greenhouse · extension | greenhouse, crop_saffron | -
- `cap_bees_3` | Bee Garden | cap_bees_2, crop_herbs, import_broker | -
- `farmhouse_sunroom` | Farmhouse · sun room | farmhouse, import_broker | S: c6_quill_answer
- `scarecrow_4` | Whirligig Scarecrow | scarecrow_3, windmill_2 | -
- `hedge_row` | Hedgerow | crop_berries, stone_wall | -

**Patches and animals** (1): `patch_master` (Living-soil beds)

**Crops** (4): `crop_saffron` (Saffron Crocus); `crop_rainbow_carrot` (Rainbow Carrot); `crop_golden_beet` (Golden Beet); `crop_woad` (Woad)

**Helpers (small upgrades, many of them gifts from favours)** (2): `master_tool_chest` (Master Tool Chest); `paved_yard` (Paved Yard)

**Gear** (1): `insulated_flask` (Wool-wrapped Flask)

**Books and cards** (2): `book_colours` (Colours of the Earth); `book_master` (The Master Farmer)

**Knowledge cards** (8; `page:<id>` triggers fire when the card's page has been read): `k_dyes`, `k_colour_mixing`, `k_worms`, `k_seed_saving`, `k_saffron`, `k_master_baking`, `k_wind_pump`, `k_living_soil`


---

## 7. Seed slots at a glance (💡 my count)

Goal-type nodes with no piece at all, shipped or staged: chapter 1: 27 · chapter 2: 27 · chapter 3: 36 · chapter 4: 25 · chapter 5: 3 · chapter 6: 13. Chapter 5 has the fewest hooks because it has the fewest nodes (20 in all), not because nobody tried: any extra chapter-5 event has to hang on `forest_trips`, `page:` cards, `after:`/`seen:` chains, the Lord's share counters, or `tap:` keys. Chapters 3 and 4 hold the most unused hooks (roads, smithy, glass, steel, farmhouse parts).

Hooks that no piece uses yet and that would carry story without any new code: `tap:patch:scrub`, `tap:patch:marsh`, `tap:pond`, `tap:well`, `tap:kitchen`, `tap:living`, `tap:storage`, `tap:home`, `tap:orchard`, `tap:cows`, `tap:bees`, `tap:greenhouse`, `tap:broker`; `goals>=n`; `skill_ranks>=1`; `sold_kinds>=n`; `coins>=n`; `lord_owed>=1` (no piece reacts to a share that is owed and unpaid); `forest_checked>=1`; `has:<item>:1` for the pet items no piece uses (`garden_platter`, `apple_crumble`, `goat_shed`, `apple_carrot_cake`, `saddle_blanket`, `healers_chest`, `golden_honey_cake`, `rainbow_roast`, `rainbow_quilt`; staged pieces use `straw_hutch`, `bunny_bowl`, `shell_house`, `tea_set`); the free-play favours `sq_free_*`.

For "the village goes on without you": `season:<name>` repeats every four seasons, so an almanac event (a festival at the same season each year) needs `seasons>=n` to pick a particular year, or it fires in the first matching season and never again (pieces show once).
