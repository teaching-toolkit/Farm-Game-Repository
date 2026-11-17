# Making things: stations, recipes, quality and skills

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 8. Making things: stations and recipes

### 8.1 Stations

A **station** is where recipes are made: 43 of them, added chapter by chapter, most standing inside the kitchen, the
workshop, the barn or the still-room.

| Ch | Stations |
|---|---|
| 1 | Campfire, Workbench, Chopping Block, Hand Quern, Field Edge & Woods (gathering) |
| 2 | Compost Bin, Compost Heap, Carpenter's Bench, Kiln, Stove, Oven, Prep Table, Butter Churn, Pond bank |
| 3 | Forge, Anvil, Sawbench, Hand Spindle, Hand Loom, Wooden Press, Fermenting Crocks, Cellar Racks, Cheese Vat & Press, Honey Extractor, Stove · iron top, Oven · iron door |
| 4 | Brickworks, Blast Forge, Glass Kiln, Spinning Wheel, Textile Loom, Prep Table · marble top, Grinding Mill (kitchen) |
| 5 | Drying Rack, Mortar and Pestle, Tea Pot Hearth, Syrup Pan, Salve Pot (the still-room, §5.10) |
| 6 | Dye Vat, Master Stove, Master Oven, Cheese Cave, Worm Bin |

Some stations are upgrades of another (Stove → iron top → Master Stove) and keep its recipes.

**A working station shows it.** While a batch is cooking, baking, firing or forging, its place shows it without the ⏳ sign:
soft grey puffs of smoke rise slowly, straight up, from the chimney, and a warm glow breathes at the fire's mouth. It shows on the farm
map (the house, the workshop, the campfire or stove of the yard) and, the same, on the corner inside the house or the workshop (the stove,
the kiln, the forge). When the batch is done no new puff is made and the ones in the air finish their rise: the smoke thins out and
stops; the finished thing is already in the store. Where the chimney and the fire stand on each picture is data
(`data/farm/places.json` `fires`, fractions of the picture; a picture without an entry, like the thatched cottage, shows nothing).
"Is something running at this place?" is asked in one place, `G.crafting.place_state(sid)` ("working" or "idle", from the saved
`running` batches: no save key of its own); the ⏳ sign, the map and the inside all ask it. The smoke and glow are drawn by the place's
slot (`game/farm/map/work_fx.gd`) from the clock alone, so nothing in the rules or the saves reads them. Not yet shown (they need a
picture each): the thing being made lying on the bench, herbs hanging on the drying rack.

### 8.2 Recipes

131 recipes. A recipe has inputs, outputs, energy, sometimes water and fuel, and a time in Time Quiz questions (0 = at once).
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

- **Grain:** wheat or winter wheat (any millable grain, `crops-and-items/03`) → hand quern, later the windmill → flour → flatbread, bread (oven, starter kept), pasta, cakes. Wheat and
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

182 items. Besides selling and recipes: every dish can be **eaten** for a bonus (§5.1), wood is **firewood**, scraps and
stale food go to the **compost**, grain and fodder **feed animals**, beeswax waxes boots and gloves, wool and linen become
gear, frost stones build the field wall, feathers fill pillows, linseed oil oils tools and looms.

---

### 8.5 Quality — Lumpy, Proper, Fancy

Grown and made things come in three **grades**: ⭐ **Lumpy** (German *Naja*), ⭐⭐ **Proper** (*Tiptop*), ⭐⭐⭐ **Fancy** (*Picobello!*). Crops, ingredients, dishes,
crafts and cloth have a grade; raw materials (sticks, stones, logs …), animal products and seeds do not. The store keeps each grade apart
(a tile shows a coloured dot for each grade there is; the thing's window says ⭐⭐⭐ 2 ⭐⭐ 5), and a recipe that needs something uses the **lowest grade first**, so the good ones are kept for selling.

- **How a grade is decided** (once, when the thing is made; numbers in `data/farm/rules/47-quality.json`): from an *expected grade E*, where
  Lumpy is 0, Proper 1.0 and Fancy 2.0. The result is the whole part of E plus a coin flip on the fraction, then a 7 % chance of one grade more and 7 % of one less —
  so with E = 1.0 a thing is Proper 86 % of the time and the average price stays at 100 %.
  - **Crops**: rested soil +0.25, tired soil −0.3; weeds beyond two −0.1 each (at most −0.4); stones −0.05 each (at most −0.3); a patch not cleared
    completely −1.5 × what is missing; field upgrades (raised beds, stone borders, deep beds, shovels, compost) add 0.05–0.15 each. A patch's whole
    harvest has one grade.
  - **Recipes**: everything made at a station (crafts, tools, cooking, baking) **starts Lumpy** for a beginner (E = 0, `madeStart`; parent,
    30 Oct 2026, skills-quality/03: the first wicker basket is wonky), so a beginner's batch is Lumpy about 93 % of the time. Crops start Proper
    (above); animal products have no grade; things bought or given are Proper. Then the station in use (a campfire −0.1, an oven +0.1 … a Master Oven +0.2, a marble prep table +0.15) and the grades of the inputs it will
    use (0.6 × their average distance from Proper: Fancy flour makes better bread, Lumpy flour worse bread), and every rank of the
    family's skill (+0.05 each, §8.6).
- **What the player sees:** *Expect: ⭐⭐ Proper* on every recipe tile and on a ripe patch, with *· maybe ⭐⭐⭐* when another grade is a real chance
  (a quarter or more); the grade after each harvest and each batch ("✨ Porridge ready: 🥣1 ⭐⭐").
- **Saves.** A store from before the grades counts as Proper.
- **A goal can ask for a grade.** A goal or delivery with `"minGrade": 1` (Proper) or `2` (Fancy) in its data takes only things of that grade or better —
  the things in its price that have a grade; a tea set or a stick has none and counts as always. The goal shows it with stars on each such thing in its
  price (⭐⭐ = at least Proper; no new words), the cubes fill only with things of that grade, and a refusal says "⭐⭐ 1 more". Handing over takes the lowest grade
  that is good enough, so the better ones stay. The bag only counts pieces; the grade is taken from the store. The four **Harvest Fair tables** (chapter 6)
  ask for at least Proper (a judged ribbon). *(planned: the badger's "really good medicine", the Healer's Chest, as Fancy — not set yet: with a beginner
  starting Lumpy a made thing can hardly reach Fancy, see the ticket skills-quality/01.)*

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
and it pays to **specialise**: a master carpenter saves more than a master cook, and what you do not master you buy.
Farm jobs save no inputs. From the first rank-up on, the album lists the skills with what each next rank still asks for, and a station's card shows
its family's rank. The still-room's stations (the cellar, the fermenter, the drying rack, the mortar, the tea pot, the syrup pan, the salve pot) train 🌿
healing, and so do the forest's gathering chores.

**Building is a job of its own** (skills-quality/02). A building, a station, a helper or the clearing of ruins (`rules/48-skills.json` `builds`) counts one batch
for 🪚 woodwork and construction for every paid build, or every paid step of one, and that rank lowers the next build: what it uses up (materials, not
coins) by the same shares as a recipe of a craft (4 / 8 / 11 / 14 %), and its energy (−8 % from Handy). A cook's or a healer's rank does not make a
build cheaper, so a carpenter saves more than they do. One function prices it: `G.pace.node_cost`, which the button, the price row, the bot and
unlocking all read; the faint grey cubes of the price row show what the rank saved, a muted line on the card says why ("🪚 Handy: building costs less now."),
and the rank-up note adds "cheaper building". Tools, gear, patches, deliveries and cards are not builds. About 250 paid builds and steps in the whole
game, so a builder reaches Handy in chapter 1, and the higher ranks still need their card, tool and Master Workshop.
