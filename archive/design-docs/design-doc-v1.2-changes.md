# Farm Quiz Game — Design Document v1.2 (changes)

**Status:** draft · 2 October 2026 · goes with progression data v0.2
**How to use this file:** these are the additions and changes since v1.1. Merge them into `farm-quiz-game-master-design-document.md`. Each section says what it replaces. Every number comes from `progression/farm-progression.json` v0.2 and its pacing check in `progression-explorer.html`. Change a number in the JSON, drop it on the explorer, and the check runs again.

---

## 1. Decisions now settled

Replaces the matching items under "Open questions".

| Topic | Decision |
|---|---|
| Manure | Becomes compost (Compost Bin: 1 manure + 1 straw → 3 compost in 3 questions). Compost is fertilizer (see §5). |
| Bees | Never fed sugar. They need flowering crops nearby (clover, sunflower, flax, berries, herbs, fruit trees) and a water dish. |
| "Extra" building slot | Becomes the **Lumbermill** (Ch3), upgraded to the **hardwood grove** in Ch4. |
| Silk | Removed. Replaced by **linen** (flax → retting at the pond → linen cloth) and **plant-dyed wool** (woad, madder, weld at the Dye Vat in Ch5). |
| Import Broker | Arrives with the **4th pet** (Pony) and opens Chapter 5. |
| Fifth pet | **Alpaca.** |
| Pet names | The player names each pet. If they skip naming, each pet has a default: **Pip** (bunny), **Mossy** (tortoise), **Bramble** (goat), **Hazel** (pony), **Alfie** (alpaca). The name is saved with the game; the data's `defaultName` field holds the default. |
| Quiz content | The game architect swaps question packs in and out. The packs cover what the child is learning in real life (continents, times tables, spelling, and so on). See §2. |
| Amount of Training | Kept as it is. About 1,980 Training answers in a playthrough, roughly 77 an hour. Per hour it falls from 113 in Ch1 to 58 in Ch5 as the home improves (see §3). The setting to tune is `energyPerTraining` on the home buildings and beds. |

---

## 2. Time Quiz question packs

New section. Replaces "Time Quiz has a fixed 4-question bank".

- Questions now live in **`farm-quiz-questions.js`**, next to `farm-quiz-engine.html`. Content can change without touching game code.
- A **pack** is `{ id, title, subject, questions: [...] }`. Each question has `q`, 2–4 `answers`, `correct` (position of the right answer, 0 = first), and optional `right` / `wrong` feedback.
- **`QUIZ_SETTINGS`** sets which packs are on (`activePacks`) and how wrong answers work:
  - `"retry"` — try again until right (the prototype's behaviour; guessing always gets there in the end);
  - `"reveal"` — show the right answer and move on **without** advancing farm time.
- Answers are shuffled each time a question is shown, and a question doesn't come back within `avoidRepeatWithin` questions.
- If the file is missing or broken, the engine falls back to one built-in question so the game still runs.
- Two packs ship as examples: *Farm basics* (the original 4) and *Continents* (12).
- **How many questions?** A playthrough is about **2,040 correct Time Quiz answers**. With 16 questions, each one comes up about 130 times. A live set of **40–80 questions**, swapped as the child learns (one pack per school topic or term), keeps it fresh.
- **Godot:** the same structure saved as one `.json` file per pack in a `quiz_packs/` folder, loaded with `JSON.parse_string`. The settings become an exported `Resource`.

---

## 3. Energy: every job costs effort, and later jobs cost more

New section. Replaces the per-action energy notes in "Core loop" and "Training".

**Rule:** anything the player *does* costs energy in proportion to how much work it is: building, crafting, smithing, baking, cooking, milking, weeding, gathering, planting, harvesting and deliveries. Every recipe and build has a **category**, and tools, home and helpers reduce the cost per category.

Categories: `field` (digging), `plant`, `harvest`, `weed`, `gather`, `wood`, `build`, `craft`, `smith`, `kiln`, `cook`, `prep`, `mill`, `process`, `textile`, `animal`, `errand`.

**How big jobs get.** Build energy = number of material units × a chapter factor (0.5 / 0.6 / 0.75 / 0.9 / 1.0), +20% for tools. It is capped at 20 / 30 / 30 / 40 / 50 so one job always fits the energy bar of the home the player has by then. Examples from the data:

| | Ch1 | Ch2 | Ch3 | Ch4 | Ch5 |
|---|---|---|---|---|---|
| Building | Workbench ⚡3 · Well winch ⚡7 | Kiln ⚡13 · Barn ⚡18 | Forge ⚡17 · Barn cellar ⚡30 | Warehouse ⚡40 · Barn stable ⚡40 | Master Oven ⚡28 · Sun room ⚡34 |
| Baking / cooking | Porridge ⚡2 | Bread ⚡2 · Pancakes ⚡4 | Simple cake ⚡6 · Honey oat cake ⚡7 | Apple-carrot cake ⚡11 | Golden honey cake ⚡12 |
| Materials | Rope, ash ⚡2 | Bricks ⚡3 | Iron bar ⚡4 | Steel bar ⚡5 · Glass ⚡4 | — |

**Getting more energy.** The home sets the energy bar and how much each Training answer restores. Beds and a few helpers add to it:

| Home | Energy max | Energy per Training answer | Add-ons |
|---|---|---|---|
| Tent (Ch1) | 20 | 5 | Straw Bed +1 per answer |
| Cottage (Ch2) | 30 | 6 | Brick Hearth +5 max |
| Cottage loft (Ch3) | 40 | 7 | Wool Mattress +2 per answer (replaces Straw Bed) |
| Farmhouse (Ch4) | 50 | 8 | Linen Bedding +3 per answer · Lanterns +5 max |
| Farmhouse sun room (Ch5) | 65 | 9 | — |

**What the simulation shows.** "Bare hands" is the cost of a chapter's goals with no tools, home upgrades or helpers. "With upgrades" is the cost for a player who builds them as they come.

| Chapter | Energy per goal, bare hands | With upgrades | Saved | Training answers | Training per hour |
|---|---|---|---|---|---|
| 1 · Ashes | 26 | 22 | 14% | 110 | 113 |
| 2 · Homestead | 71 | 57 | 20% | 376 | 105 |
| 3 · Smallholding | 111 | 83 | 25% | 506 | 99 |
| 4 · Village Trade | 210 | 135 | 36% | 500 | 67 |
| 5 · Master Farm | 453 | 238 | 47% | 485 | 58 |

Raw effort per goal grows about 17× from Ch1 to Ch5. Upgrades cut the Ch5 cost almost in half. Even so, the arithmetic per hour falls because each answer restores more. A player who skips upgrades feels it: by Ch5 the same goals cost nearly twice the energy, and each Training answer restores less.

---

## 4. Basic materials, any time

New section.

- **Wild Edge** (always open, 3 slots): *Gather sticks* (2 sticks), *Pick stones* (1 stone), *Pull wild weeds* (2 plant fiber). Each takes 1 question and 1–2 energy.
- With the Wooden Shovel: *Dig out stones* (3 stones, 5 energy).
- At the pond (Ch2): *Dig clay* (2 clay).
- Sticks, stones and fiber sell for **0 coins**, so gathering is never a money farm. They are always there as a way out when a recipe is one stick short.
- Weeding field patches (§6) also gives fiber, so the perpetual chore feeds rope and compost.
- Gathering Basket (−25% gathering energy), Hand Axe, Saw and Master Saw make gathering cheaper.

---

## 5. Patch levels and fertilizer

New section. Replaces "patch upgrades" in "Farm grid".

Patches improve in **9 levels**: 3 in Chapter 1, then at least one per chapter through Chapter 5. Some levels let more plants of **the same crop** share one patch (1 → 6). Others cut weeds, water or effort. Each level is bought **per patch** (cost shown is for one patch), so upgrading a whole field is a project of its own. Higher levels need better tools and more energy.

| Ch | Level | Needs | Cost per patch | Effect |
|---|---|---|---|---|
| 1 | Dug beds | Wooden Shovel | ⚡4 | Loosen the soil: 2 plants of the same crop fit in one patch. |
| 1 | Stick edging | Dug beds, Stone Knife | 3 stick, 1 rope, ⚡2 | A woven stick border keeps weeds out: weeds grow 20% slower. |
| 1 | Raised log beds | Stick edging, Hand Axe | 1 log, 2 stick, ⚡5 | 3 plants per patch. Every plant beyond 2 needs 1 fertilizer point per planting (wood ash at first). |
| 2 | Stone borders & paths | Raised log beds, Log Shed | 4 stone, ⚡6 | Weeds −15%, and paths make harvesting −10% energy. |
| 3 | Double-dug beds | Stone borders & paths, Iron Shovel | 2 compost, ⚡9 | 4 plants per patch (2 fertilizer points per planting). |
| 3 | Irrigation channels | Double-dug beds, Dig out the pond | 3 stone, 2 plank, ⚡8 | Water flows from the pond to the roots: field water −15%. |
| 4 | Deep-worked beds | Irrigation channels, Steel Shovel | 3 compost, ⚡12 | 5 plants per patch (3 fertilizer points per planting). |
| 4 | Glass cloches | Deep-worked beds, Glass Kiln | 1 glass, 2 plank, ⚡8 | Little glass hats keep seedlings warm: crops grow 15% faster. |
| 5 | Living-soil beds | Glass cloches, Worm Bin | 2 worm castings, 1 hardwood, ⚡15 | 6 plants per patch (4 fertilizer points per planting). The weeds love it too. |

**Fertilizer.** The first 2 plants in a patch need nothing. **Each plant beyond 2 needs 1 fertilizer point every time it's planted.**

| Fertilizer | Points | Made from |
|---|---|---|
| Wood Ash (Ch1) | 1 | Campfire: 2 fiber + 1 stick → 2 ash |
| Compost (Ch2) | 2 | Compost Bin: 3 straw or 3 fiber → 2 (4 questions); 1 manure + 1 straw → 3 (3 questions); oilcake → compost |
| Worm Castings (Ch5) | 4 | Worm Bin: 1 compost + 2 straw → 1 (4 questions) |

Fertilizer is the trade-off: **more plants per patch, but weeds grow faster** (§6). Higher densities also need more fertilizer per planting, so the compost chain grows with the farm. The Goat pet adds 1 compost every 4 questions. The Compost Fork makes compost 25% faster.

---

## 6. Perpetual tasks

New section.

### 6.1 How Factorio does it, and what carries over

| What Factorio does | How it carries over to the farm |
|---|---|
| **The pressure comes from your own growth.** Your machines make the pollution that wakes the biters, so a bigger factory means more pressure. | Weeds grow **on every field patch**. They grow faster with more plants per patch and more fertilizer. More fields means more weeding. |
| **It ratchets up.** Biter evolution rises over time and never goes back. | **Weed tier per chapter**: dandelions → docks → thistles → brambles → bindweed (×1 → ×2.5 growth). |
| **Every pressure has a tech answer that is a project in itself.** Walls, turrets and efficiency modules. | Stick edging, stone borders, hoes (stick → iron → steel), Weeder Geese, the Goat, Insect Hotel, Straw Mulch. |
| **The answer is automation, not more clicking.** Once turrets are supplied, defence looks after itself and attention moves on. | The late answers must cut **taps**, not only energy. Geese, Goat and Mulch slow weed growth. Proposal: one Ch5 helper that weeds one field on its own (§6.4). |
| **It's visible and announced in advance.** The pollution cloud, attack alerts. | Weeds sprout visibly on patches, with a small weed meter per field. |
| **You can opt out.** Peaceful mode. | A **"gentle weeds"** setting for the youngest players (weeds ×0.3, no slowdown). |
| **Losses are recoverable but hurt.** | For an 8-year-old, **nothing is ever lost** (§6.3). |

### 6.2 What is in the data now

- **Weeds:** per field patch, per Time Quiz answer, planted or not: `0.15 × chapter weed tier × (1 + 0.4 × fertilizer points the patch density needs) × weed multipliers`. One weeding tap clears 3 weeds. Each weed costs 1 energy (less with hoes) and gives 1 fiber. Orchard spots grow half as many.
- **Fertilizer** per planting for density above 2 (§5).
- **Bedding straw** for animals: chickens 0.5, cows 1, sheep 1 per feeding. So wheat and oats stay needed for their straw.
- **Water for every animal product** (§7).
- **Simulated weeding share of all energy:** 12% · 12% · 10% · 12% · 20% (Ch1–Ch5). It stays a steady background chore and peaks at the end, when patches are dense and the field count is highest.

### 6.3 Rules that keep it kind

1. **Farm time only moves when a Time Quiz answer is correct**, so chores never pile up while the child is away.
2. Weeds **cap** (proposal: 6 per patch). A weedy patch grows **slower** (proposal: −10% per weed above 3, never below half speed). Crops never die.
3. Missing fertilizer never blocks planting. The patch just takes 2 plants that time.
4. Animals without water, feed or bedding **pause** production. They never get sick or leave.
5. One new chore per chapter at most, introduced with a short helper message, the way Factorio introduces one new threat at a time.

### 6.4 More ideas (not in the data yet)

Recommended next, because each one teaches something real and reuses things that already exist:

- **A. Crop rotation and tired soil.** The same crop twice in a row in one patch needs +1 fertilizer point or grows 20% slower. Following with clover or beans (legumes) resets it. This scales with the number of patches and teaches a real farming idea.
- **B. Tool sharpening.** Tools lose their energy bonus after about 40 uses. The Whetstone or Grindstone restores it for a little stone and energy. This gives the two helpers a lasting job.
- **C. Mucking out.** Manure piles up in sheds and needs mucking out (energy). Since manure → compost, the chore feeds the fertilizer loop, like Factorio's by-products becoming inputs.
- **D. Ch5 automation helper:** *Weeding Rota* (village children weed one field each 10 questions for a jam-sandwich wage). This is the Factorio "turret" moment for weeds.

Also possible, parked for now:

- **Scarecrow re-stuffing.** One scarecrow per field (already true), refilled with straw every ~80 questions.
- **Thatch upkeep.** Straw roofs need re-thatching. Brick or tile roof upgrades remove the chore: an upgrade that works like automation.
- **Well silting.** Output drops slowly; cleaning restores it; the brick lining slows silting.
- **Market saturation.** Selling a lot of one item lowers its price for a while. This rewards a varied farm (the Pony and the Market Stall soften it).
- **Village growth and standing orders.** Bread for the bakery and milk for the school, growing each chapter.
- **Weather forecasts.** A dry spell is announced 10 questions ahead. The Rain Barrel, pond, channels and Drip Line are the defence.
- **Firewood for the home.** Warmth keeps the per-answer energy bonus. The Woodlot and Lumbermill automate it.

Adding A–C, one in each of Ch2, Ch3 and Ch4, would give one new perpetual chore per chapter without overwhelming anyone.

---

## 7. Water for animal products

Change to "Animals".

Every animal product now needs water as well as feed:

| Animal | Feed per collection | Water | Gives |
|---|---|---|---|
| Chickens | 2 wheat, 0.5 straw | 1 | 1 egg per question |
| Cows | 3 clover, 1 straw | 3 | 1 milk + 1 manure every 2 questions |
| Bees | none (need flowering crops) | 1 (water dish) | 1 honeycomb every 2 questions |
| Sheep | 2 clover, 1 straw | 2 | 2 wool + 1 manure every 3 questions |

More water comes from the well ladder (2 → 4 → 6 → 8 → 11 per question), the pond (+2), the Tortoise (+1), the Rain Barrel (+1), the Wind Pump (+4) and River Meadow (+2). Less is used with the Water Trough (animals −20%), Watering Can and Drip Line (plants −25% / −50%), Irrigation channels (−15%), the Carrying Yoke and Straw Mulch (−5% each).

---

## 8. Optional helpers: things that make life cheaper

New section. None of these is required for anything. Each makes some build, craft, recipe or chore cheaper for good. There are 36 in the data: 6 / 11 / 10 / 6 / 3 by chapter, most of them in Ch2–3 while the farm is building up.

| Ch | Helper | Needs | Costs | Effect |
|---|---|---|---|---|
| 1 | 🧺 Gathering Basket | Workbench | 4 plant fiber, 2 stick, ⚡3 | Carry more per trip: gathering −25% energy. |
| 1 | 🔥 Stone Fire Ring | Campfire, Clear the rocks (2 patches) | 8 stone, ⚡4 | Holds the heat: cooking −15% energy. |
| 1 | 🛏️ Straw Bed | Workbench | 8 straw, 4 plant fiber, 4 stick, ⚡8 | Sleep better: +1 energy per Training answer. |
| 1 | 🪺 Nest Boxes | Chicken Coop | 4 straw, 4 stick, ⚡4 | Calm hens lay more: +25% eggs. |
| 1 | 🪨 Whetstone | Stone Knife, Hand Axe | 3 stone, ⚡2 | Sharp blades: cutting and wood work −10% energy. |
| 1 | 🪣 Carrying Yoke | Workbench, Well · deeper shaft | 4 stick, 2 rope, ⚡3 | Two buckets at once, less spilled: planting −10% energy, field water −5%. |
| 2 | 🏺 Pot Shelf & Clay Pots | Stove, Kiln | 6 plank, 3 clay jar, ⚡5 | Everything in reach: cooking −15% energy. |
| 2 | 🥖 Dough Trough & Rolling Pin | Oven | 4 plank, 1 log, ⚡3 | Prep work −15% energy. |
| 2 | 🪣 Milking Stool & Pail | Cows | 3 plank, 1 clay jar, ⚡2 | Animal work −20% energy. |
| 2 | 🚰 Water Trough | Barn | 6 plank, 8 stone, ⚡8 | No spilled buckets: animals use 20% less water. |
| 2 | 🌾 Hay Rack | Barn | 4 plank, 3 rope, ⚡4 | Less trampled fodder: cows and sheep eat 15% less. |
| 2 | 🧂 Salt Lick | Cows, Spice Merchant | 6 salt, 3 stone, ⚡5 | Healthy cows: +20% milk and manure. |
| 2 | 💨 Bee Smoker | Bees (straw skeps), Kiln | 3 clay, 4 plant fiber, ⚡4 | Calm bees: +25% honeycomb. |
| 2 | 🪜 Scaffolding | Carpenter's Bench | 8 plank, 6 rope, 3 log, ⚡10 | Building −15% energy. |
| 2 | 🧱 Brick Hearth | Cottage, Kiln | 12 brick, 8 stone, ⚡12 | A warm room: energy max +5. |
| 2 | 🔱 Compost Fork | Compost Bin, Carpenter's Bench | 1 plank, 3 stick, ⚡2 | Turned heaps rot faster: compost −25% time. |
| 2 | 🧰 Tool Rack | Carpenter's Shed | 6 plank, 1 log, ⚡4 | No searching: crafting −10%, field work −5% energy. |
| 3 | 🌬️ Bellows | Forge | 5 plank, 2 wool cloth, 3 nails, ⚡8 | Hotter fire: the forge needs half the charcoal. |
| 3 | ⚙️ Grindstone | Whetstone, Sawbench | 16 stone, 3 plank, 3 nails, ⚡17 | Replaces the whetstone: cutting and wood work −15% energy. |
| 3 | ✂️ Shearing Table | Sheep | 6 plank, 3 nails, ⚡7 | Cleaner fleeces: +25% wool. |
| 3 | 🛏️ Wool Mattress | Straw Bed, Hand Loom | 3 wool cloth, 6 straw, ⚡7 | Replaces the straw bed: +2 energy per Training answer. |
| 3 | 🧀 Cheese Moulds | Cheese Vat & Press | 3 plank, 3 nails, 2 linen cloth, ⚡6 | Less spilled curd: cheese needs 25% less milk. |
| 3 | 🛢️ Oak Barrels | Fermenting Crocks, Raw Materials · hardwood & sand | 3 hardwood, 2 iron bar, 3 nails, ⚡6 | Fermenting −25% time, aging −15% time. |
| 3 | 🛒 Hand Cart | Sawbench | 10 plank, 3 iron bar, 6 nails, ⚡14 | Haul more at once: harvesting −15%, building −10% energy. |
| 3 | 🐞 Insect Hotel | Bees (straw skeps), Sawbench | 3 plank, 6 straw, 6 stick, ⚡11 | Wild bees and beetles move in: +20% honeycomb, weeds −5%. |
| 3 | 🍳 Iron Pans | Stove · iron top | 3 iron bar, ⚡2 | Cooking −15% energy. |
| 3 | 🪿 Weeder Geese | Dig out the pond, Sawbench | 6 plank, 300 coins, ⚡5 | Geese graze between the rows: weeds −20%. (Real old practice.) |
| 4 | 🛏️ Linen Bedding | Wool Mattress, Textile Loom | 5 linen cloth, 2 wool cloth, ⚡6 | Replaces the mattress: +3 energy per Training answer. |
| 4 | 🏮 Lanterns | Glass Kiln, Anvil | 3 glass, 2 iron bar, 6 candle, ⚡10 | Work into the evening: energy max +5. |
| 4 | 🌱 Seed Drill | Master Saw | 5 hardwood, 2 steel bar, 6 nails, ⚡12 | Sows a whole row in one pass: planting −40% energy. |
| 4 | 🧺 Bread Peel & Proofing Baskets | Farmhouse | 3 hardwood, 2 linen cloth, ⚡5 | Cooking and baking −15% energy. |
| 4 | 🧈 Rotary Churn | Butter Churn, Smith's Hammer | 3 hardwood, 2 steel bar, ⚡5 | Butter needs 25% less milk. |
| 4 | 🌾 Straw Mulch | Deep-worked beds, Warehouse | 30 straw, 125 coins, ⚡27 | A straw blanket on every bed: weeds −15%, field water −5%. |
| 5 | 🧰 Master Tool Chest | Master Workshop, Import Broker | 10 hardwood, 3 steel bar, 3 linen cloth, ⚡16 | Crafting −15%, field and wood work −10% energy. |
| 5 | 🧱 Paved Yard | Warehouse, Import Broker | 50 stone, 16 brick, ⚡50 | Dry feet everywhere: harvesting and animal work −10% energy. |
| 5 | 🌿 Herb Drying Loft | Farmhouse · sun room | 10 plank, 3 linen cloth, 10 herbs, ⚡23 | Dried herbs on hand: cooking and prep −10% energy. |

**Things already in the tree that work the same way** (on the main path but also cost cutters):

- **Tools** replace each other and cut a category: Wooden → Iron → Steel Shovel (field −10/−20/−30%), Rock → Iron Hammer → Smith's Hammer (build −20/−35%), Hand Axe → Saw → Master Saw (wood −25/−40%), Stone → Iron → Steel Knife (prep −20/−35%), Stick → Iron → Steel Hoe (weeding −25/−45/−60%), Wheelbarrow (harvest −25%), Bucket → Watering Can → Drip Line (plant water −25/−50%).
- **Scarecrows**: Stick (planting −50%), Dressed (−75%), Guardian (also harvest −40%). One per field.
- **Home**: energy max and energy per Training answer (§3).
- **Water**: well levels, pond, Rain Barrel, Wind Pump.
- **Automation**: Windmill (mills by itself), Woodlot and Lumbermill (logs over time), Compost Bin, Worm Bin.
- **Market**: Market Stall +10%, Pony +10%, Harvest Fair ribbons +5% each.
- **Pets**: Bunny (+1 carrot per harvest), Tortoise (+1 water per question), Goat (weeds −15%, compost), Pony (+10% sales), Alpaca (wool).
- **Patch levels**: Stick edging, Stone borders, Irrigation channels, Glass cloches (§5).
- **Seed Library** (Ch5): heirloom crops give 1 seed back per harvest, so they no longer have to be bought.

---

## 9. Side quests

New section.

Self-contained favours for villagers. They **unlock nothing** and never block the main path. The player hands over things they made or spends energy. The **reward is a picture for the farm album** of a happy person holding what the player made for them. Ch1 quests open as soon as the building they need exists. Later ones open once the previous chapter's pet has arrived, so they never crowd out a new chapter's first goals.

There are 27: 4 each in Ch1–Ch4 and **11 in Ch5**. Simulated cost is about 2.3 hours of play if the player does them all, 70 minutes of that in Ch5.

| Ch | Favour | Needs built | Hand over | Album picture |
|---|---|---|---|---|
| 1 | 🧒 Little shepherd Tom is freezing | Campfire | 6 stick, ⚡6 | Little Tom, grinning and warm, holding up a bundle of your firewood |
| 1 | 👵 Granny Maud's goat ran off | Pull the weeds (2 patches) | ⚡10 | Granny Maud laughing, hugging her muddy goat on the rope you found it with |
| 1 | 👧 Porridge for the hungry twins | Feed the travelling merchant | 3 porridge, ⚡2 | The twins beaming, each holding a bowl of your porridge (some on their noses) |
| 1 | 🧺 The miller's daughter needs a basket | Workbench | 6 plant fiber, 2 rope, ⚡4 | Ella twirling with your new basket full of flowers |
| 2 | 🧺 The washerwoman's line snapped | Carpenter's Bench | 4 rope, 2 plank, ⚡6 | Hilde smiling, holding the end of your new rope line full of flapping sheets |
| 2 | 🤒 Soup for a sick neighbour | Stove, Tomato | 2 tomato soup, ⚡4 | Old Jan sitting up in bed, cheeks pink, holding your bowl of tomato soup |
| 2 | 🌉 Mend the footbridge | Carpenter's Bench | 6 log, 8 stone, 4 plank, ⚡18 | Ferryman Otto waving a plank from your mended footbridge as children skip across |
| 2 | 🍯 Honey for the healer | Bees (straw skeps) | 2 honey, ⚡3 | Healer Wren smiling, holding a jar of your honey up to the light |
| 3 | 🔨 The smith's apprentice is short of nails | Anvil | 8 nails, 2 iron bar, ⚡6 | Apprentice Bo proudly holding up a gate made with your nails |
| 3 | 👶 A blanket for the newborn | Hand Loom, Sheep | 2 wool cloth, ⚡6 | A happy new mum holding her baby wrapped in your wool blanket |
| 3 | 💃 Cider for the harvest dance | Fermenting Crocks, Wooden Press | 3 cider, ⚡4 | Fiddler Rosa raising a mug of your cider at the harvest dance |
| 3 | ⛪ Fix the chapel roof | Sawbench | 10 plank, 10 straw, 6 nails, ⚡24 | Bell-ringer Ansel holding your last roof plank, waving from the dry chapel |
| 4 | 🏫 The schoolroom window is broken | Glass Kiln | 2 glass, 2 plank, ⚡8 | Teacher Ines and her pupils holding up your new glass pane |
| 4 | 💒 A wedding needs a cake | Oven · iron door, Berry Bush | 1 berry cake, 1 apple pie, ⚡6 | The bride and groom holding your cake between them, laughing |
| 4 | 🏮 A lantern for the night watchman | Glass Kiln, Anvil | 2 candle, 1 glass, 1 iron bar, ⚡6 | Night watchman Pieter holding your glowing lantern on the town wall |
| 4 | ⛵ Pickles for a long voyage | Cellar Racks | 4 pickled vegetables, ⚡4 | Sailor Mei waving a jar of your pickles from the deck of her boat |
| 5 | 🧣 A rainbow scarf for the little poet | Dye Vat | 1 rainbow yarn, 1 wool cloth, ⚡8 | Little poet Kit reciting proudly in your rainbow scarf |
| 5 | 🎨 Golden paint for the painter | Saffron Crocus | 1 saffron, ⚡4 | Painter Lucia holding a brush dipped in your golden saffron paint |
| 5 | 🌈 Seeds for the school garden | Rainbow Carrot | 4 rainbow carrot, 4 compost, ⚡10 | The school children each holding up one of your rainbow carrots |
| 5 | 🎭 Cheese for the travelling theatre | Cellar Racks | 2 aged cheese, 2 sourdough bread, ⚡6 | The lead actor taking a bow while holding your cheese wheel high |
| 5 | 🍓 Jam for the orphanage | Berry Bush, Stove · iron top | 4 berry jam, 4 sourdough bread, ⚡8 | Matron Elsie holding your jam jar while the children cheer with sandwiches |
| 5 | 🪔 Oil for the old lamp-maker | Olive Tree, Wooden Press | 3 olive oil, ⚡5 | Old lamp-maker Ferdinand holding a lamp filled with your olive oil, glowing |
| 5 | 🍽️ A feast for the village elders | Grinding Mill (kitchen) | 1 olive tapenade, 2 pumpkin soup, 2 sourdough bread, ⚡12 | Elder Agnes holding up your tapenade bowl as the elders laugh around the table |
| 5 | 🚩 Dye the festival flags | Dye Vat | 2 red dye, 2 yellow dye, 2 blue dye, 2 linen cloth, ⚡10 | Mayor Juno holding a string of your dyed flags over the village square |
| 5 | ⛲ Rebuild the village well | Smith's Hammer | 20 brick, 2 steel bar, 10 stone, ⚡40 | Young Sami holding a brimming bucket from the well you rebuilt |
| 5 | 🔭 The astronomer's telescope | Glass Kiln, Master Saw | 4 glass, 1 steel bar, 2 hardwood, ⚡14 | Astronomer Vega holding your telescope, pointing happily at the stars |
| 5 | 🌿 Herbs for the healer's garden | Herbs | 8 herbs, 4 compost, ⚡10 | Healer Wren kneeling in her new herb garden, holding a bunch of your herbs |

**Art:** 27 album pictures, one for each row above. Same style as the rest of the game. These are good first candidates for the image pipeline (one character sheet per villager keeps them consistent, since Healer Wren appears twice).

---

## 10. Extra fields

New section. Replaces "one 3×3 farm grid".

**What the simulation found:** with dense patches, patch *time* is never the limit (it peaks at 35% of available patch time in Ch2). Crop *variety* is: the goals of a chapter need 5 / 8 / 6 / 8 / 10 different field crops at once, on 9 patches. By Ch4, keeping flax, wheat, clover, sunflower and vegetables going side by side on one field becomes juggling.

**So there are two more fields to swipe to.** Buildings stay where they are on the home screen; only the field grid changes.

| Field | Chapter | Needs | Gives |
|---|---|---|---|
| Home Field | start | — | 3 cleared patches + 6 to clear (weeds, rocks, stumps) |
| **North Field** | 4 (main path) | Iron Hoe, Barn cellar → *clear the scrub* (⚡30, 400 coins), then Sawbench → *fence* (18 plank, 12 nails, ⚡20, 400 coins) | +9 patches |
| **River Meadow** | 5 (optional) | North Field, Import Broker, Steel Hoe → *drain the marsh* (⚡45, 30 stone, 16 plank, 1,250 coins), then Brickworks → *sluice* (25 brick, 3 steel, ⚡30, 1,250 coins) | +9 patches, +2 water per question |

New fields start at **level 1** and need their own patch levels and their own scarecrow. Weeds grow per patch, so every new field also adds to the perpetual weeding (§6), the Factorio trade-off. The orchard (3 trees, +2 with Orchard terraces in Ch5), the pond and the greenhouse (4 + 2 beds) stay as special patches.

---

## 11. Pacing (data v0.2)

Replaces the pacing table in v1.1.

| Chapter | Hours | Goals | Pet (target → simulated) |
|---|---|---|---|
| 1 · Ashes | 0 → 1.0 | 28 | Bunny 1 h → 1.0 h |
| 2 · Homestead | 1.0 → 4.6 | 43 | Tortoise 4.5 h → 4.6 h |
| 3 · Smallholding | 4.6 → 9.7 | 46 | Goat 10 h → 8.7 h |
| 4 · Village Trade | 9.7 → 17.2 | 36 | Pony 17.5 h → 17.2 h |
| 5 · Master Farm | 17.2 → 25.6 | 23 | Alpaca 25.5 h → 23.1 h |

**Totals:** 25.6 hours · 2,041 Time Quiz answers · 1,977 Training answers · 176 goals + 33 automatic unlocks · 36 optional helpers · 27 side quests (≈ 2.3 h on top) · 134 items · 101 recipes · 0 errors, 0 warnings.

**Soft spots to watch in playtests:**

- **The alpaca arrives at about 23 h, not 25.5 h.** Chapter 5 costs are already at the calibration ceiling. The last ~2.5 h are optional (River Meadow, Orchard terraces, the Ch5 side quests). To push the alpaca later, add one more Ch5 goal rather than inflating prices.
- In Ch4 and Ch5 there are short stretches where the nearest **main** goal is more than 22 minutes away (grey dots in the explorer). Side quests and helpers fill those gaps, which is one reason Ch5 has 11 side quests.

---

## 12. Notes for the game code and Godot

Addition to "Technical notes".

- The prototype's game code does **not** implement v0.2 yet. The scope so far was data, explorer and bug fixes, plus the quiz packs. To implement:
  - energy by category with multipliers;
  - patch levels per patch per field;
  - fertilizer per planting;
  - weed growth per patch with the kind rules in §6.3;
  - animal water and bedding;
  - helpers;
  - side quests with an album screen;
  - pet naming;
  - field swiping.
- The data stays engine-agnostic. In Godot, load `farm-progression.json` with `JSON.parse_string` into an autoload (`GameData`). Effects are plain dictionaries (`set`, `add`, `mult`, `produces`), so one small function can apply them all.
- Asset list for the art pipeline: 5 pets, 4 animals, 47 buildings, 38 stations, 21 tools, 22 crops, 9 patch looks (one per level), 5 weed tiers, 27 album pictures, 3 field backgrounds.
