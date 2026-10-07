# Upgrades that do more than save energy — ideas to choose from (task H1)

Written 7 Oct 2026 for the parent to pick from. **Nothing here is in the game or the data yet.**

## Where we stand

Of about 240 upgrade effects in `farm-progression.json`, **119 only make a job cost less energy**. 48 upgrades do nothing
else: 14 tools, 15 helpers, 10 pieces of gear, 8 polish jobs and the flying shuttle (list at the bottom). Saving energy is
useful but invisible: the child never *sees* a sharper knife do anything.

## Kinds of benefit

✅ = the game already has this kind of effect (only data needs to change) · 🆕 = needs new code.

| # | Benefit | What the child notices | Engine |
|---|---|---|---|
| 1 | **More of the thing** (bigger harvest, an extra egg, 5 planks instead of 4) | more cubes fly to the store | ✅ `mult out`, `mult yield` |
| 2 | **Faster** (cooks, grows, dries, rises in fewer questions) | the ⏳ number is smaller | ✅ `mult time`, `mult grow` |
| 3 | **Worth more** (sells for more at the market) | more coins per sale | ✅ `sellBonusPct` (today for everything; per item is 🆕) |
| 4 | **Keeps longer** (food goes stale later) | fewer 🍂 signs | ✅ `shelfLife` |
| 5 | **More at once** (another slot at a station, bigger loads, more room) | two pots on the fire | ✅ `slots`, `carry`, `storageCap` |
| 6 | **Something extra now and then** (chopping sometimes gives a bonus stick, weeding a seed, digging an old coin or a pretty stone for the album) | a little surprise flies out | 🆕 small "lucky find" table per job (`luck` exists) |
| 7 | **Less of something else** (less water, firewood, feed or wear) | the bars last longer | ✅ `mult water`, `fuel`, `feed`, `wear` |
| 8 | **Fewer pests and weeds** | fewer birds and weeds on the fields | ✅ `mult pests`, `mult weeds`, `scare` |
| 9 | **A new thing to make or do** (a knife lets you carve wooden spoons to sell; a saw makes a bird box) | a new button | ✅ `requires` on a new recipe |
| 10 | **Helps in a season** (boots: no mud penalty in spring rain; gloves: winter work costs the same as summer) | winter doesn't feel slower | 🆕 season modifiers (`winterGrow` is a start); work costs the same in every season today, so a small season penalty would have to come first |
| 11 | **Does a small job by itself** (the hand cart brings in the eggs; the seed drill re-sows a harvested patch) | things happen without tapping | 🆕 small automatic actions (`autoMill`, `produces` are a start) |
| 12 | **Better quality** (⭐ items: a sharp knife makes ⭐ dishes; ⭐ fetch double at the market and count double for orders) | a little star on the item | 🆕 quality stars, a bigger change |
| 13 | **More energy from rest or food** | energy fills faster | ✅ `energyPerRest`, `energyMax` |
| 14 | **Learning bonuses** (read faster; a card review gives a seed or a coin) | rewards for reading | ✅ `mult read`; 🆕 card-review rewards |
| 15 | **Something to see** (the farmer wears the boots; the tool hangs on the rack; with G "the farmer as an actor", the tool is in the farmer's hand) | it shows on the map | 🆕 with G1/G2; a good rule for *every* upgrade |

## Suggested rule

- In every **tool line** (shovel, hoe, knife, hammer, saw), the *first* tier keeps saving energy and every *later* tier adds a
  different benefit (more, faster, a new thing to make).
- **Gear** helps with a season or comfort (10) instead of plain −5 %, and is seen on the farmer (15).
- **Helpers** in the kitchen make food better or keep it longer (2, 4, 12) rather than cheaper.
- **Polish** stays about energy (it is the one "endless" upgrade), but each polish job also gives a tiny bonus when fully
  polished (a sharp axe sometimes gives an extra stick, 6).
- Re-check the pace with the explorer and the bot after any change: energy savings are part of why chapter 5 comes after
  about 700 questions.

## A concrete idea for each of the 48 energy-only upgrades

| Upgrade | Today | Idea (keep the energy saving unless said) | Kind |
|---|---|---|---|
| Hand Axe (`stone_axe`) | gathering −15 % | keep as is (first tier) | — |
| Wooden Shovel | field work −10 % | keep (first tier) | — |
| Iron Shovel | field work −20 % | digging sometimes finds a stone, a flint or an old coin | 6 |
| Steel Shovel | field work −30 % | new patches are cleared one step faster | 2 |
| Stick Hoe | weeding −25 % | keep (first tier) | — |
| Iron Hoe | weeding −45 % | weeds come back 20 % slower | 8 |
| Steel Hoe | weeding −60 % | rooting out gives an extra fibre; sometimes a wild seed | 1, 6 |
| Iron Knife | prep −20 % | new recipe: carve wooden spoons to sell | 9 |
| Steel Knife | prep −35 % | prepared food sells for +10 % | 3 |
| Iron Hammer | building −20 % | keep (first tier) | — |
| Smith's Hammer | building −35 % | buildings finish one wait shorter | 2 |
| Saw | wood work −25 % | keep (already 1 log → 4 planks) | — |
| Master Saw | wood work −40 % | 1 log → 5 planks | 1 |
| Wheelbarrow | harvesting −25 % | harvest +1 piece per patch | 1 |
| Stone Fire Ring | cooking −15 % | cooking uses 1 less firewood | 7 |
| Whetstone | cutting −10 % | polish wears off half as fast | 7 |
| Pot Shelf & Clay Pots | cooking −15 % | cooked food keeps 2 days longer | 4 |
| Dough Trough | prep −15 % | bread rises one question faster | 2 |
| Milking Stool & Pail | animals −20 % | +1 milk now and then | 1, 6 |
| Scaffolding | building −15 % | lets two buildings be built at once | 5 |
| Tool Rack | crafting −10 % | the tools hang on it, visible on the map; repairs cost less | 7, 15 |
| Grindstone | cutting −15 % | polish jobs cost less | 7 |
| Hand Cart | harvest −15 % | brings in eggs and milk by itself each morning | 11 |
| Iron Pans | cooking −15 % | a second cooking slot | 5 |
| Seed Drill | planting −40 % | re-sows a harvested patch by itself (if seeds are there) | 11 |
| Proofing Baskets | baking −15 % | bread and cakes sell for +10 % | 3 |
| Master Tool Chest | crafting −15 % | every tool wears more slowly | 7 |
| Paved Yard | several −10 % | no mud penalty in spring and autumn | 10 |
| Herb Drying Loft | cooking −10 % | dried herbs make every dish keep longer | 4 |
| Flying Shuttle | weaving −20 % | cloth is woven one question faster | 2 |
| Straw Sandals | walking jobs −5 % | keep (first tier) | — |
| Wooden Clogs | walking jobs −10 % | no mud penalty in rain | 10 |
| Hobnail Boots | walking jobs −15 % | gathering sometimes gives an extra stick or stone | 6 |
| Waxed Boots | walking jobs −20 % | winter jobs cost the same as summer ones | 10 |
| Fibre Mitts | weeding −10 % | keep (first tier) | — |
| Wool Gloves | weeding −15 % | winter: building and weeding cost the same as summer | 10 |
| Waxed Gloves | weeding −25 % | rooting out thistles gives fibre +1 | 1 |
| Woven Bag | gathering −10 % | carries one more piece per gathering trip | 5 |
| Linen Apron | cooking −10 % | a cooked dish now and then turns out ⭐ special (sells double) | 6 |
| Waxed Apron | cooking −15 % | dairy and pressing give +10 % | 1 |
| Polish (8 jobs) | energy | keep; at full polish a small bonus (an extra stick for the axe, an extra fibre for the hoe …) | 6 |

## What the parent decides

1. Which kinds of benefit are welcome (the table at the top), and which not.
2. Whether to follow the suggested rule, or pick upgrade by upgrade from the last table.
3. Whether the 🆕 ones (lucky finds, season help, helpers that work by themselves, ⭐ quality) are worth new code now, or
   later.
