# Making things: stations, recipes, quality and skills

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 8. Making things: stations and recipes

### 8.1 Stations

A **station** is where recipes are made: 38 of them, added chapter by chapter, most standing inside the kitchen, the
workshop or the barn.

| Ch | Stations |
|---|---|
| 1 | Campfire, Workbench, Chopping Block, Hand Quern, Field Edge & Woods (gathering) |
| 2 | Compost Bin, Compost Heap, Carpenter's Bench, Kiln, Stove, Oven, Prep Table, Butter Churn, Pond bank |
| 3 | Forge, Anvil, Sawbench, Hand Spindle, Hand Loom, Wooden Press, Fermenting Crocks, Cellar Racks, Cheese Vat & Press, Honey Extractor, Stove · iron top, Oven · iron door |
| 4 | Brickworks, Blast Forge, Glass Kiln, Spinning Wheel, Textile Loom, Prep Table · marble top, Grinding Mill (kitchen) |
| 5 | Dye Vat, Master Stove, Master Oven, Cheese Cave, Worm Bin |

Some stations are upgrades of another (Stove → iron top → Master Stove) and keep its recipes.

### 8.2 Recipes

106 recipes. A recipe has inputs, outputs, energy, sometimes water and fuel, and a time in Time Quiz questions (0 = at once).
- **One word on the button** for what it does: *Gather, Pull, Twist, Weave, Cook, Bake, Fry, Grind, Churn, Press, Saw,
  Smelt …* (`verb` in the data).
- **"Any of a kind" inputs.** Many everyday recipes take any flour, fat, grain, sweetener, fodder, cooking oil (`tag:` inputs).
  Signature dishes asked for by deliveries and pets keep fixed ingredients. Different sweeteners make different named dishes
  of one family (honey → Honey Cake, beet sugar → Simple Cake).
- **Keepers.** Some inputs are needed but not used up (the tin pot, the sourdough starter, yogurt and cheese cultures, the
  stone in Stone Soup) — "a culture lives on".
- **Slots and batches.** A station runs one batch at a time; helpers can add a slot. Its recipes wait while it is busy (the
  grey ⏳ shows how many questions). Gathering recipes give at once and refill (§5.5).
- **Skills.** What a station makes trains a skill family; ranks bring fewer inputs, less energy, finer grades (§8.6).
- **Choice slots.** Ten stations or buildings have one slot with two options, of which one works at a time and can be swapped
  freely (the campfire: *Stone Fire Ring* −15 % cooking energy **or** *Cooking Tripod* −30 % firewood).
- **Fuel** comes from the woodpile, which is stoked first (§5.6).
- Each recipe shows what its ingredients would fetch and what it fetches; costs show as cubes: filled = you have it, hollow =
  missing, faint grey = what upgrades, practice and meals save compared with the first time.

### 8.3 The long chains

- **Grain:** wheat → hand quern, later the windmill → flour → flatbread, bread (oven, starter kept), pasta, cakes. Wheat and
  oats also give **straw** → rope, thatch, skeps, bedding, scarecrows, compost.
- **Dairy:** clover → cow → milk → churn → butter; milk + culture → yogurt; milk + culture + salt → fresh cheese → the cellar
  → aged cheese → cheese boards, pesto.
- **Sugar:** beets → press → beet juice → iron-top stove → sugar → cakes, jam, pies.
- **Fermentation:** apples → press → juice → crocks → cider → cellar → vinegar → pickles.
- **Textiles:** sheep → wool → spindle → yarn → loom → wool cloth → sails, scarecrow, blankets. Flax → soak in the pond →
  flax fibre → linen thread → linen cloth.
- **Metal:** logs → kiln → charcoal; iron ore (bought) + charcoal → forge → iron → anvil → nails and iron tools; iron + more
  charcoal → blast forge → steel.
- **Glass:** sand + charcoal → glass kiln → glass → farmhouse windows, greenhouse, lanterns.
- **Colour:** beets, onions, woad → red, yellow, blue → mixed into orange, green, purple → rainbow yarn → the rainbow quilt.
- **Compost loop:** straw, weeds, manure, oilcake, stale food → compost bin → compost → hungry crops and deep beds.

The deepest item is the Rainbow Quilt (about eight steps from the field); the Golden Honey Cake draws on seven buildings.

### 8.4 Every item has more than one use

141 items. Besides selling and recipes: every dish can be **eaten** for a bonus (§5.1), wood is **firewood**, scraps and
stale food go to the **compost**, grain and fodder **feed animals**, beeswax waxes boots and gloves, wool and linen become
gear, frost stones build the field wall, feathers fill pillows, linseed oil oils tools and looms.

---

### 8.5 Quality — Lumpy, Proper, Fancy

Grown and made things come in three **grades**: ⭐ **Lumpy** (German *Naja*), ⭐⭐ **Proper** (*Tiptop*), ⭐⭐⭐ **Fancy** (*Picobello!*). Crops, ingredients, dishes,
crafts and cloth have a grade; raw materials (sticks, stones, logs …), animal products and seeds do not. The store keeps each grade apart
(a tile says ⭐⭐⭐ 2 ⭐⭐ 5), and a recipe that needs something uses the **lowest grade first**, so the good ones are kept for selling.

- **How a grade is decided** (once, when the thing is made; numbers in `data/farm/rules/47-quality.json`): from an *expected grade E*, where
  Proper is 1.0. The result is the whole part of E plus a coin flip on the fraction, then a 7 % chance of one grade more and 7 % of one less —
  so with E = 1.0 a thing is Proper 86 % of the time and the average price stays at 100 %.
  - **Crops**: rested soil +0.25, tired soil −0.3; weeds beyond two −0.1 each (at most −0.4); stones −0.05 each (at most −0.3); a patch not cleared
    completely −1.5 × what is missing; field upgrades (raised beds, stone borders, deep beds, shovels, compost) add 0.05–0.15 each. A patch's whole
    harvest has one grade.
  - **Recipes**: the station in use (a campfire −0.1, an oven +0.1 … a Master Oven +0.2, a marble prep table +0.15) and the grades of the inputs it will
    use (0.6 × their average distance from Proper: Fancy flour makes better bread). *(planned, with skills (Y2):* every rank adds a bit.)
- **What the player sees:** *Expect: ⭐⭐ Proper* on every recipe tile and on a ripe patch, with *· maybe ⭐⭐⭐* when another grade is a real chance
  (a quarter or more); the grade after each harvest and each batch ("✨ Porridge ready: 🥣1 ⭐⭐").
- **Saves.** A store from before the grades counts as Proper.
- *(planned)* Some key deliveries ask for at least Proper; the badger's "really good medicine" is simply Fancy.

### 8.6 Skills and ranks

The farmer gets better at what is done again and again. **Eight skill families:** 🌱 planting and harvesting · 🐄 animal tending · 🍲 cooking and baking ·
🧶 fibre and weaving · 🪚 woodwork and construction · 🏺 pottery and glass · ⚒️ smithing · 🌿 healing and preserving. Every **batch** at one of a family's
stations, every planting and every harvest of a patch and every collecting from animals counts one for its family (gathering at the field edge trains
nothing). Practice is counted from the very first batch, even though it is not shown yet (§13.2b).

| Rank | Batches | Also needs | Brings |
|---|---|---|---|
| Beginner | 0 | – | – |
| **Handy** | 10 | – | less energy (−8 %); crafts need 4 % fewer inputs, food 2 % |
| **Skilled** | 30 | a knowledge card (e.g. *Cooking on a stove*) | 8 % / 4 % fewer inputs |
| **Expert** | 80 | a tool (e.g. the iron knife) | 11 % / 6 % |
| **Master** | 200 | a station or building (e.g. the Master Oven) | 14 % / 8 % fewer inputs, **faster** (80 % of the time) |

Every rank also raises the **chance of a finer grade** (+0.05 on the expected grade per rank, §8.5). So grinding cheap recipes cannot make a master early,
and it pays to **specialise**: a master carpenter saves more than a master cook, and what you do not master you buy (planned with the new prices, M1).
Farm jobs save no inputs. From the first rank-up on, the album lists the skills with what each next rank still asks for, and a station's card shows
its family's rank. *(planned: construction jobs count for woodwork and save materials; healing when medicine exists.)*
