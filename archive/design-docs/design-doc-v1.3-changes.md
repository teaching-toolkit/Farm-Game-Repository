# Farm Quiz Game — Design Document v1.3 (changes)

**Status:** draft · 2 October 2026 · goes with progression data v0.3 and the Godot prototype in `godot-prototype/`.
Every number here comes from `progression/farm-progression.json` v0.3 and its pacing check in `progression/progression-explorer.html`.

---

## 1. Decisions in 1.3

| # | Topic | Decision |
|---|---|---|
| 1 | Food | Eating a dish lowers energy costs for **one or two Time Quiz questions** (−10% to −30% by dish). It never restores energy, so Rest stays necessary. |
| 1b | "Training" | Renamed **Rest** 😴 — sleep, eating, a sip of water, recuperating. Rest answers are still arithmetic. A better bed, pillow, water bottle and home give **more energy per answer**. Better shoes, gloves, bag and hat make work **cost less**. |
| 2 | Reviews in the Time Quiz | Yes. `knowledgeReviewShare` in `settings.json` sets the share of Time Quiz questions that review cards the child already learned. 0 turns it off; default 0.25. The rest come from the parent's packs. |
| 3 | Seasons | Light seasons: each one slows some things and makes others plentiful (§6). Nothing dies. |
| 4 | Freshness | Checked **at each change of season**. Food that has sat in the pantry long enough gets a "stale soon" badge and turns into feed mash or compost at the next change unless it is sold, eaten or cooked (§7). |
| 5 | Pests | No range and no "back to the bag". Pests **reduce the number of plants** on a patch, never below 1. More plants attract more pests. You **see them hopping**, and the scarecrow **throws fierce looks** that make them leave. Rising arrivals call for better scarecrows and fences (§8). |
| 6 | Farm layout bonuses | **No.** |
| 7 | Gift cards | Pick 1 of 3 at milestones; the other two go to the shop (§12). |
| 8 | Swappable ingredients | Many everyday recipes take "any of a kind" (any flour, fat, grain, sweetener, fodder…). **Signature dishes** asked for by deliveries and pets keep fixed ingredients. Different sweeteners make **different named dishes** that share a family: honey → Honey Cake, beet sugar → Simple Cake, both cakes (§13). |
| 9 | Village projects | Still a maybe — not built. |
| 10 | Quality stars | **No.** |
| 11 | Endless upgrades | Yes, from **chapter 1**, as **polish** with diminishing returns: the cost rises linearly, the gain halves each time, and use wears it off (§4). Weeding works the same way: you can always "root out" more, for less effect and more energy. |
| 12 | Card size | One card per idea. Some unlock things, some give a lasting boost, some both (§3). |
| 13 | Paying for knowledge | Coins (books) + time (reading) + the child **showing the knowledge** in a short quiz. No second currency. |
| 14 | Length | No hour target. The goal is **steady difficulty**: minutes per goal rise only gently, and Rest per hour stays in a band (§15). |
| — | Numbers | Every amount is exact in the background; **the player only sees whole numbers**: stocks rounded down, costs rounded up, halves shown as ½ (§5). |
| — | Luck | A hidden background value, raised for a while by side quests, little jobs and four-leaf clovers. It makes lucky events more likely (§9). |

---

## 2. Rest, gear and the home

- **Energy per Rest answer** comes from:
  - the home: Tent 5 → Cottage 6 → Loft 7 → Farmhouse 8 → Sun room 9;
  - the bed: Straw +1 → Wool mattress +2 → Linen bedding +3;
  - the pillow: +½ → +1 → +1½;
  - the water bottle: +½ → +1 → +1½ → +2;
  - the library chair: +½;
  - gift cards and polish (Air the bed: up to +1).
- **Cold house:** in winter with an empty woodpile, Rest gives 25% less.
- **Gear** (type `gear`, 23 items in 8 slots). Each slot is a ladder; a new item replaces the old one.

| Slot | Ladder (chapter) | Effect of each step |
|---|---|---|
| bed | 🛏️ Straw Bed (1) → 🛏️ Wool Mattress (3) → 🛏️ Linen Bedding (4) | +1 ⚡ per Rest answer / +2 ⚡ per Rest answer / +3 ⚡ per Rest answer |
| feet | 🩴 Straw Sandals (1) → 👞 Wooden Clogs (2) → 🥾 Hobnail Boots (3) → 🥾 Waxed Walking Boots (4) | planting −5%, harvesting −5%, gathering −5%, errands −5%, animal care −5% / planting −10%, harvesting −10%, gathering −10%, errands −10%, animal care −10% / planting −15%, harvesting −15%, gathering −15%, errands −15%, animal care −15% / planting −20%, harvesting −20%, gathering −20%, errands −20%, animal care −20% |
| hands | 🧤 Fibre Mitts (1) → 🧤 Wool Work Gloves (3) → 🧤 Waxed Linen Gloves (4) | weeding −10%, gathering −5% / weeding −15%, building −5%, gathering −5% / weeding −25%, building −10%, crafting −5% |
| back | 👜 Woven Bag (1) → 🧺 Wicker Pack Basket (2) → 🎒 Canvas Rucksack (3) → 🎒 Frame Rucksack (4) | gathering −10%, harvesting −5% / gathering −15%, harvesting −10% / gathering −20%, harvesting −15%, errands −10% / gathering −25%, harvesting −20%, errands −15% |
| bottle | 🏺 Clay Water Flask (2) → 🍶 Sealed Stoneware Jug (3) → 🫙 Glass Bottle & Sling (4) → 🧉 Wool-wrapped Flask (5) | +½ ⚡ per Rest answer / +1 ⚡ per Rest answer / +1½ ⚡ per Rest answer / +2 ⚡ per Rest answer |
| head | 👒 Straw Hat (1) → 🎩 Felt Hat (3) → 👒 Wide Linen Sunhat (4) | energy max +2, field work −3% / energy max +4, field work −5% / energy max +6, field work −10% |
| apron | 🥼 Linen Apron (3) → 🥼 Waxed Canvas Apron (4) | cooking −10%, prep −10% / cooking −15%, prep −15%, dairy & press −10% |
| pillow | 🛌 Straw Pillow (1) → 🛌 Feather Pillow (3) → 🛌 Wool & Down Pillow (4) | +½ ⚡ per Rest answer / +1 ⚡ per Rest answer / +1½ ⚡ per Rest answer |

---

## 3. Knowledge: cards, books and the library

**Learning a card**
1. Own its **book**.
2. Have **discovered** its item, if it lists one (e.g. hold iron ore once before "Smelting iron").
3. **Read** it. This takes a few Time Quiz questions and goes faster in a bigger library.
4. Answer its **quiz**: **2 new questions** about the card, plus **up to 3 review questions**, one from each of up to 3 earlier cards it builds on. Weakest and longest-unseen cards come first, so the quiz never gets long.
   - Wrong answers grey out, show a one-line "why" and can be retried.
   - Only first-try answers move a card up its review box (Leitner boxes 1–4).
   - A missed review never blocks learning.
5. Learned cards come back as single **reviews in the Time Quiz** (share set in `settings.json`). They are due after 12 / 40 / 100 / 250 questions, or 1 / 3 / 7 / 21 real days, whichever comes first.

**Content.** 67 cards. Each has a read-aloud page (2–4 sentences, Grade 2–3 reading level) and 3 questions with 3 answers and a one-line "why". The 🔊 button in the prototype reads them aloud where the system has a voice.

**Books and library.** Books are bought from the **Book Cart**, which arrives with the travelling merchant.

| Library level | Holds | Reading | Needs |
|---|---|---|---|
| 📦 Book box in the tent | 2 books | — | start (the free *Little Farm Book* is in it) |
| 📚 Bookshelf | 5 | 10% faster | 5 cards learned, Carpenter's Bench |
| 🪑 Bookcase & reading chair | 10 | 20% faster | 15 cards, Carpenter's Bench |
| 🏛️ Library room | 12 (all) | 30% faster, +½ ⚡ per Rest answer | 30 cards, Farmhouse |

| Book | Chapter | Coins | Arrives with |
|---|---|---|---|
| 📗 The Little Farm Book | 1 | free | start |
| 📘 Village Crafts | 1 | 15 | start |
| 📙 Grandma's Kitchen | 2 | 25 | Cottage |
| 📕 Animals & Bees | 2 | 30 | Chicken Coop |
| 📒 Soil & Seasons | 2 | 40 | Log Shed |
| 📓 The Smith's Book | 3 | 150 | Raw Materials · iron ore |
| 📔 From Fleece to Fabric | 3 | 125 | Barn |
| 📚 Cellar & Larder | 3 | 150 | Barn |
| 📘 Fire, Glass & Steel | 4 | 125 | Raw Materials · hardwood & sand |
| 📗 Orchard & Oils | 4 | 100 | Clear the old orchard |
| 🎨 Colours of the Earth | 5 | 175 | Import Broker |
| 📜 The Master Farmer | 5 | 250 | Import Broker |

**The cards** (what each one opens; ✨ = a lasting boost):

- **📗 The Little Farm Book:** 🌾 Growing wheat → Wheat; 🔥 A safe little fire → Campfire ✨ fuel −5%; 🥕 Roots you can eat → Carrot, Onion; 🪢 Twisting rope from fibres → Rope (fiber), Rope (straw); 🪨 Stone tools → Stone Knife, Hand Axe, Wooden Shovel, Stick Hoe; 🌿 Why weeds come back → Stick edging ✨ weeds −5%; 🪣 Water and the well → Well · deeper shaft, Well · winch ✨ +5 water storage; 🪏 Loose soil, happy roots → Dug beds; 🩶 Ash feeds the soil → Wood ash (burn weeds & twigs), Raised log beds; 🐔 Keeping hens → Chicken Coop; 🧍 Birds, seeds and scarecrows → Stick Scarecrow, Stick Fence ✨ pests −5%; ♻️ How compost works → Compost Bin, Compost (straw), Compost (weeds) ✨ Compost Bin time −10%
- **📘 Village Crafts:** ⚙️ Grinding grain into flour → Hand Quern, Flour (hand quern); 🪙 Fair prices ✨ +3% sales; 🪵 Logs, planks and grain → Carpenter's Shed, Carpenter's Bench, Planks (split); 🟤 Clay and bricks → Kiln, Brick, Clay Jar; ⚫ Charcoal → Charcoal; 🏗️ Walls and roofs → Cottage · log walls, Barn · frame, Log Shed; 🌾 Thatching with straw → Cottage · thatched roof
- **📙 Grandma's Kitchen:** 🍞 Why bread rises → Oven, Sourdough Starter, Sourdough Bread; ♨️ Cooking on a stove → Stove; 🧈 Cream into butter → Butter Churn, Butter; 🍯 From comb to honey → Honey (crush & strain), Candle; 🧂 Salt keeps food → Hearty Vegetable Stew, Bean Stew
- **📕 Animals & Bees:** 🐄 Cows: grass in, milk out → Barn; 🐝 Bees and flowers → Bee Yard ✨ Bees (straw skeps) output +5%; 💩 Muck and manure → Compost (manure) ✨ muck −10%; 🌾 What animals eat ✨ Chickens feed −5%, Cows feed −5%, Sheep feed −5%; 🐞 Pests and their enemies → Insect Hotel, Picket Fence, Owl Box ✨ pests −10%
- **📒 Soil & Seasons:** 🔄 Crop rotation ✨ rested soil +5%; 🍂 The four seasons ✨ winter growth +10%; 🧊 Frost heave: stones that grow → Stone borders & paths ✨ stones −15%; 🦆 Ponds and wetlands → Dig out the pond; 🌳 Planting trees → Woodlot, Clear the old orchard; ⛏️ Double digging → Double-dug beds
- **📓 The Smith's Book:** 🔩 Smelting iron → Smithy · chimney, Forge, Iron Bar; ⚒️ Hammer and anvil → Anvil, Iron Hammer; 📌 Nails and joints → Nails, Sawbench; 🌬️ Wind power → Windmill · stone tower; 💧 Channels and irrigation → Irrigation channels, Watering Can
- **📔 From Fleece to Fabric:** 🐑 Shearing and spinning → Sheep Pen, Hand Spindle, Yarn; 🧶 Warp and weft → Hand Loom, Wool Cloth; 🪻 Flax to linen → Soak (ret) flax, Linen Thread, Linen Cloth
- **📚 Cellar & Larder:** 🍇 Pressing oil and juice → Wooden Press, Apple Juice, Sunflower Oil; 🟣 Sugar from beets → Sugar; 🏺 Friendly microbes → Fermenting Crocks, Yogurt, Cider; 🧀 Making cheese → Cheese Vat & Press, Fresh Cheese; 🧀 The cool cellar → Barn · cellar, Cellar Racks ✨ food keeps +1 season; 🫙 Pickling and vinegar → Vinegar, Pickled Vegetables
- **📘 Fire, Glass & Steel:** ⚙️ From iron to steel → Blast Forge, Steel Bar; 🪟 Sand into glass → Glass Kiln, Glass; 🪴 Greenhouses → Greenhouse · frame, Glass cloches; 🧱 Brick houses → Farmhouse · foundation, Brickworks
- **📗 Orchard & Oils:** 🍎 Caring for fruit trees → Walnut Tree, Olive Tree ✨ yield Clear the old orchard +10%; 🫒 Olives: oil and curing → Olive Oil, Cured Olives; 🍝 Pasta and dough → Fresh Pasta, Tomato Sauce, Pizza Dough; 🪵 Hardwood and joinery → Master Saw, Lumbermill · hardwood grove; 🟫 Deep soil and humus → Deep-worked beds; 🌾 Mulching → Straw Mulch
- **🎨 Colours of the Earth:** 🎨 Dyes from plants → Dye Vat; 🌈 Mixing colours → Orange Dye, Green Dye, Purple Dye
- **📜 The Master Farmer:** 🪱 Worms make soil → Worm Bin, Worm Castings; 🫘 Saving seeds → Seed Library; 🌸 Saffron, the precious spice → Saffron Crocus; 🎂 Master baking → Master Oven, Fine Flour; 🌬️ Pumping water with wind → Wind Pump; 🍄 Living soil → Living-soil beds

---

## 4. Polish: endless upgrades with diminishing returns

New type `polish`, 22 entries, available from chapter 1.

- **Gain:** each polish adds 1 point P. The listed effect is the cap.
  - Gain = cap × (1 − 0.5^P): the first time gives **half**, the second a quarter more, the third an eighth…
- **Cost:** the next polish costs base × (1 + whole P), so it rises by the base every time.
- **Wear:** using the thing (or time passing) takes P down slowly. Polish is maintenance as well as an upgrade.
- **Why:** a new **kind** of upgrade is always worth more than grinding the same one, yet there is always something useful to do.
- **Weeding** follows the same rule: *Root out the weeds* keeps regrowth down, with less effect and more energy each time.

| Polish | Ch | Needs | Base cost | Cap (endless) | Wears off |
|---|---|---|---|---|---|
| 🔪 Sharpen the knife | 1 | Stone Knife | 1 stone, ⚡1 | prep −15% | 0.05 per prep job |
| 🪓 Sharpen the axe & saw | 1 | Hand Axe | 1 stone, ⚡1 | wood work −15%, gathering −5% | 0.05 per wood work job |
| 🪏 Clean & oil the shovel | 1 | Wooden Shovel | 1 plant fiber, ⚡1 | field work −10% | 0.03 per field work job |
| ⛏️ Sharpen the hoe | 1 | Stick Hoe | 1 stone, ⚡1 | weeding −15% | 0.01 per weeding job |
| 🌱 Root out the weeds | 1 | Three cleared patches | ⚡2 | weeds −25% | 0.03 per question |
| 🛏️ Air the bed & fresh straw | 1 | Straw Bed | 2 straw, ⚡1 | +1 ⚡ per Rest answer | 0.02 per question |
| 🪣 Clean out the well | 1 | Well · deeper shaft | 1 rope, ⚡3 | +1½ 💧 per question | 0.015 per question |
| 🧹 Sweep the fire pit | 1 | Campfire | ⚡1 | cooking −8%, fuel −15% | 0.05 per cooking job |
| ⚙️ Dress the millstones | 1 | Hand Quern | 1 stone, ⚡2 | milling −20%, Windmill time −15% | 0.05 per milling job |
| 🧍 Re-stuff the scarecrow | 1 | Stick Scarecrow | 2 straw, ⚡1 | chases +½ pests | 0.02 per question |
| 🪵 Mend the fence | 1 | Stick Fence | 2 stick, ⚡1 | +15% pests kept out | 0.02 per question |
| 🪺 Fresh nest straw | 1 | Chicken Coop | 2 straw, ⚡1 | Chickens output +15% | 0.02 per question |
| 🧰 Tidy the workbench | 1 | Workbench | ⚡1 | crafting −10% | 0.01 per question |
| 🔥 Patch the kiln lining | 2 | Kiln | 1 clay, ⚡2 | Kiln time −15%, fuel −8% | 0.05 per kiln job |
| 🥾 Wax the boots | 2 | Wooden Clogs | 1 beeswax | errands −10%, planting −5%, harvesting −5% | 0.02 per question |
| 🐄 Brush the cows | 2 | Cows | ⚡2 | Cows output +15% | 0.02 per question |
| 🐝 Clean the hive frames | 2 | Bee Yard | ⚡2 | Bees (straw skeps) output +15% | 0.02 per question |
| 🪶 Dust the shelves | 2 | Bookshelf | 1 feather, ⚡1 | read −15% | 0.01 per question |
| 🧶 Oil the loom & spindle | 3 | Hand Loom | 1 any oil, ⚡1 | textiles −15% | 0.05 per textiles job |
| 🔨 Re-wedge the hammer | 3 | Iron Hammer | 1 stick, 1 nails, ⚡1 | building −10%, smithing −5% | 0.05 per building job |
| ✂️ Sharpen the shears | 3 | Shears | 1 stone, ⚡1 | Sheep output +10%, animal care −5% | 0.03 per animal care job |
| 🌬️ Tune the bellows | 3 | Forge | 1 any oil, ⚡2 | Charcoal at Forge −15%, smithing −5% | 0.05 per smithing job |

---

## 5. Numbers: exact underneath, whole on screen

- Everything (stocks, energy, water, plants on a patch, polish, luck) is a float, so percentages multiply exactly. A harvest of 2.7 wheat shows **2**, and the 0.7 is kept.
- **Display rule:**
  - stocks round **down** and costs round **up**, so whatever looks affordable is;
  - halves in descriptions show as ½;
  - no decimals anywhere.

---

## 6. Seasons

- A year is 4 seasons of 30 Time Quiz questions each; the top bar shows how many questions are left.
- Nothing dies; seasons only change speeds and amounts.

| Season | Slower | Plenty |
|---|---|---|
| 🌱 Spring | — | weeds sprout (+50%, more fibre); rain 30% |
| ☀️ Summer | thirstier fields (+30% water), more pests (+50%) | crops grow 20% faster, bees +30% honeycomb |
| 🍂 Autumn | crops 15% slower | orchard +40%, fallen branches (sticks ×2) |
| ❄️ Winter | crops at half speed, home burns firewood | frost lifts **stones** in every patch, stones from the field edge ×2, indoor work −10% energy, thick fleece +20%, few weeds and pests |

---

## 7. Freshness (at the change of season)

- Each pantry batch remembers the season it arrived in.
- **Shelf life** is counted in season changes:
  - lettuce, berries, tomatoes, herbs, clover, olives, eggs, milk, butter, fresh cheese, yogurt, juices, sauce, fresh pasta, dough and dishes: 1;
  - roots, apples and beans: 2;
  - pumpkins: 3;
  - everything preserved keeps for ever: flour, grain, honey, jam, pickles, aged cheese, oils, cider, vinegar, nuts.
- **"Stale soon" badge** on anything that will turn at the next change.
- **At the change:** plant food becomes 🥣 **Feed Mash** (hens, cows and sheep eat it; the compost takes it); eggs and dairy go to **compost**.
- **Keeps longer:** Cellar Racks +1 season, the Cool Cellar card +1, the Cool Cellar gift card +1.

---

## 8. Pests

- **Arrivals** per question = 0.05 × plants growing × chapter tier (1 / 1.4 / 1.8 / 2.3 / 2.8) × season × (1 − fence share kept out).
- **Defence:**
  - the scarecrow chases up to its **scare** value per question: Stick 0.6 → Dressed 1.2 → Guardian 2 → Whirligig 3, +½ when re-stuffed;
  - the barn cat, owl box and ducks add 0.4 / 0.4 / 0.3;
  - 20% of the pests left wander off by themselves.
- **Damage:** each pest still around eats 0.15 plants per question from growing patches; a patch never drops below 1 plant.
- **Fences:** Stick 15% → Wattle 30% → Picket 45% → Field Stone Wall 55% (made of frost-heaved stones) → Hedgerow 65%.
- **On screen:** pests (🐦🐇🐌🐛🐭, by chapter) hop between growing patches. The scarecrow throws fierce looks (💢😠👀) that fly across the field, and the pests it chases fly off.
- **Simulated losses:** about 10% in chapter 1 before the first scarecrow, a few percent in chapter 2, near zero once defences keep up. Leave the scarecrow un-stuffed or skip a fence and losses come back as arrivals grow.

---

## 9. Luck and lucky events

- Luck is hidden; a 🍀 appears in the top bar while it is high.
- Every event's chance is multiplied by (1 + luck).
- **Sources:**
  - side quest +0.5 for 30 questions;
  - little job +0.1 for 10;
  - four-leaf clover +0.3 for 20;
  - each pet +0.05 for good;
  - Lucky Horseshoe gift card +0.15 for good.

| Event | When | Base chance | What happens |
|---|---|---|---|
| weed coin | pulling weeds | 4% | A lost coin in the weeds! |
| weed seed | pulling weeds | 2% | An old seed packet! |
| weed clover | pulling weeds | 1% | A four-leaf clover! You feel lucky. |
| weed relic | pulling weeds | 0.7% | Something old in the soil: a relic for the album! |
| stone quartz | picking stones | 2% | A sparkling quartz crystal inside a stone! |
| rain | each Time Quiz answer | by season (30% / 10% / 30% / 20%) | It rained: no watering needed, and the well fills a little. |
| double harvest | harvesting | 3% | Bumper crop: double harvest! |
| double yolk | collecting from Chickens | 5% | A double-yolk egg! |
| honey flow | collecting from Bees (straw skeps) | 5% | A honey flow: extra comb! |
| thick fleece | collecting from Sheep | 5% | An extra-thick fleece! |
| neighbour gift | each Time Quiz answer | 1% | A neighbour drops off a little gift basket. |
| seed bargain | buying seeds | 5% | The seed merchant adds one for free. |
| golden acorn | pulling weeds | 0.2% | A golden acorn glints under a leaf! |

---

## 10. Perpetual pressures that grow with the farm (adopted)

All are soft: things get slower, never lost.

| Pressure | Grows with | Answer (upgrade ladder) |
|---|---|---|
| Weeds | patches, plants per patch, fertilizer, chapter | edging, borders, hoes, gloves, geese, goat, mulch, **Root out** polish |
| Frost stones (winter) | patches, deep beds, bare beds | pick them (stones for walls and paths), Stone Sense card |
| Pests | plants growing, chapter, summer | scarecrow ladder + re-stuffing, fences, cat, owl, ducks, insect hotel |
| Firewood | heat stations (campfire 1, oven 2, kiln 3, forge 2 per batch) + the home in winter | woodpile size (basket 20 → shed 40 → warehouse 80), fire ring, tripod, tall chimney, hearth, sweep the fire pit, Firekeeper card |
| Muck | animals (hens 0.3, cows 1, sheep 0.6 per collection) | muck out (gives manure); perches, drain gutter, Clean Barn card. Above 4 per animal: −25% output; above 8: −50% |
| Tired soil | planting the same crop twice in a row (−15% growth) | rotate; after beans or clover +10% |
| Blunt tools and worn machines | use | polish (sharpen, oil, dress the millstones, tune the bellows…), quench trough |
| Freshness | food stored across seasons | sell, eat or cook into something that keeps; cellar |

---

## 11. Food

| Dishes | Effect |
|---|---|
| Porridge, roast carrots, flatbread, baked potato, salad, omelette | −10% energy for 1 question |
| Soups, stews, bread, pancakes, honey porridge, mash, onions, pickles, yogurt bowl, pasta, sandwich | −20% for 2 questions |
| Cakes, pies, pizza, pasta pomodoro, pumpkin soup, tapenade, pesto, cheese board | −30% for 2 questions |

Pet dishes are not eaten.

---

## 12. Gift cards, little jobs, golden acorns, practice stars, choice slots

- **Gift cards:** 24 in the pool.
  - Offered 3 at a time when a pet arrives, at each library level and every 12 goals.
  - The two not picked go to the shop (20 / 50 / 100 / 180 / 300 coins by chapter).
  - Effects include +5 storage, +½ water per question, +3 energy max, growth +5%, luck, +½ per Rest answer, pests −10%, reading +20%, +3% sales, winter growth, food keeps longer, firewood −15%, muck −20% and stones −20%.
- **Little jobs:** three small tasks that refill themselves as soon as one is done. They only offer what you can do right now: harvest, weed, make, sell, collect, stones, rest. The reward is 4 coins × chapter and a little luck.
- **Golden acorns (7):**
  - first favour, a bookshelf, the first winter, 100 weeds, the first pet, 10 cards, and one found by luck while weeding;
  - each gives energy max +3 for good.
- **Practice stars:** every station counts its uses. At 10, 40 and 120 uses it earns a star: −5% energy for its recipes per star.
- **Choice slots:** ten stations or buildings have one slot with two items (e.g. Campfire: Fire Ring −15% cooking energy *or* Cooking Tripod −30% firewood). Only one works at a time; you can swap freely.

---

## 13. Every item has more than one use

**Audit before 1.3:** 134 items, median 2 uses besides selling, 64 with one use or none (dishes worst).

**Added in 1.3:**
- **Eating** — every dish except pet dishes gives a food bonus.
- **Firewood:** sticks, straw, logs, planks, hardwood, charcoal.
- **Composting:** any scraps.
- **Feeding animals:** any grain or fodder.
- **New items:**
  - 🪶 feathers from hens: pillows, the library feather duster;
  - 🥣 feed mash: from stale food or chopped vegetables;
  - 🟤 linseed from flax: hen feed, linseed oil;
  - 🫗 linseed oil: oiling tools and looms;
  - 💎 quartz and 🏺 relics: lucky finds.
- **Other new uses:**
  - beeswax: boots, gloves, aprons;
  - wool and linen: gear;
  - stones: the field wall;
  - the new Honey Cake and honey jam.
- **Swappable recipe inputs:** porridge (any grain), flatbread and pancakes (any flour), mash, caramel onions and pumpkin soup (any fat), tomato sauce and pizza dough (any cooking oil), yogurt bowl (any sweetener).

---

## 14. Data model additions (for whoever codes the game)

- **New node types:**
  - `knowledge` (fields `discover`, `unlocks`, `page`, `questions`, `cost.read`);
  - `book`;
  - `gear` (slot `gear:<slot>`);
  - `polish` (fields `target`, `wear`).
- **New node fields:** `requiresCards`, `attach` (choice slot), `muck` (animals).
- **New recipe field:** `fuel`. **New item field:** `buff`.
- **New effect keys:**
  - `scare`, `pestBlock`, `fuel`, `fuel:<station>`, `muck`, `muck:<animal>`;
  - `stones`, `pests`, `read`, `yield:orchard`, `slots:<station>`, `wear`;
  - `shelfLife`, `restedSoil`, `winterGrow`, `woodpileCap`, `homeFuel`, `bookSlots`, `luck`, `luckDuration`, `energyPerRest`.
- **New meta blocks:** `rest`, `quiz`, `knowledge`, `seasons`, `freshness`, `pests`, `stones`, `fuel`, `muck`, `rotation`, `polish`, `luck`, `giftCards`, `jobs`, `practice`, `acorns`, `numbers`.

---

## 15. Pacing (data v0.3): steady instead of fixed hours

| Chapter | Hours | Main goals | Minutes per goal (target) | Rest per hour | Energy per goal, bare hands → with upgrades | Saved | Cards | Weeding · stones share | Pest loss |
|---|---|---|---|---|---|---|---|---|---|
| 1 · Ashes | 0.0 → 1.4 | 36 | 2.4 (2.5) | 73 | 13 → 11 | 21% | 13 | 9% · 2% | 10% |
| 2 · Homestead | 1.4 → 5.5 | 56 | 4.3 (4) | 50 | 27 → 20 | 28% | 20 | 14% · 3% | 3% |
| 3 · Smallholding | 5.5 → 10.0 | 56 | 4.9 (5) | 59 | 47 → 32 | 31% | 16 | 7% · 1% | 0% |
| 4 · Village Trade | 10.0 → 14.7 | 43 | 6.5 (6) | 56 | 94 → 60 | 36% | 10 | 4% · 1% | 0% |
| 5 · Master Farm | 14.7 → 18.2 | 28 | 7.5 (7) | 51 | 152 → 79 | 48% | 8 | 6% · 2% | 0% |

- **Totals:**
  - 18.5 hours on the main path, plus ≈ 2.4 h of side quests and the optional River Meadow;
  - 1,466 Time Quiz answers, 1,009 Rest answers;
  - 67 cards (≈ 1 h of card quizzes);
  - 315 goals + 35 automatic;
  - 0 errors, 0 warnings.
- **Pets:** 1.5 / 5.5 / 9.6 / 14.3 / 18.2 h.
- **Reading the table:**
  - Raw effort per goal grows 12× from chapter 1 to 5, while upgrades cut chapter 5's cost almost in half. The tinkering pays.
  - Rest per hour stays between 50 and 73, so arithmetic never disappears and never floods.
  - The simulated player buys every defence as soon as it can, so its pest losses fall to zero after chapter 2; a player who skips scarecrow and fence upgrades loses more as arrivals grow.

---

## 16. The Godot prototype

`godot-prototype/` opens in **Godot 4.7** (Import → `project.godot` → F5). Everything comes from the same `farm-progression.json`; emojis stand in for art.

**What's in it**
- Time Quiz (packs plus card reviews), Rest, fields with 3 areas (fields, orchard, greenhouse) and swiping between fields.
- Weeds, frost stones, pests hopping with scarecrow looks, rain, seasons and freshness.
- Animals with muck, stations with a woodpile and choice slots, the market and merchants.
- Library with books, reading and card quizzes; gear; polish; food; luck events.
- Gift cards, little jobs, golden acorns, the album, pet naming, autosave.
- **⏩ Cheat:** lets time pass until everything is done, then fills energy and water. **🪙+100** adds coins.

**Tested**
- A headless bot plays the rules engine from the start into **chapter 4** (goat home by question ~490) without errors.
- A UI smoke test clicks through the opening: first card, planting, Time Quiz, Rest, every tab.
- Screenshots of every screen are in `godot-prototype/screenshots/`.

**Simplified**
- Patch upgrades are paid patch by patch but apply to all patches.
- One scarecrow and one fence cover all fields.
- No sound, no avatar, no pixie chest yet.

---

## 17. Where the ideas came from (research summary)

- **Knowledge discovered by doing:** Factorio 2.0 trigger technologies, Valheim and Minecraft recipe unlocks.
- **The library growing as you learn:** the Animal Crossing museum.
- **Books from a visiting seller, permanent-perk books:** Stardew Valley 1.6.
- **Reading over time:** Kingdom Come: Deliverance.
- **Reviews woven into the quiz:**
  - Khan Academy Mastery Challenges and Leitner boxes;
  - feedback after every pick (with feedback, second-graders' wrong answers carried forward fell from 26% to 5%, Marsh et al. 2012);
  - intrinsic integration (Habgood & Ainsworth 2011).
- **Pressure tied to your own growth, with soft failure:**
  - Factorio pollution, RimWorld wealth;
  - Banished tool wear, Rune Factory soil;
  - Farthest Frontier and Farming Simulator stones and weeds.
- **One slot with two options:** Stardew sprinkler attachments.
- **Permanent energy finds:** Stardew Stardrops.
- **Refilling small tasks:** Animal Crossing Nook Miles+.
- **Polish with diminishing returns:** the user's Cookie Clicker idea.

---

## 18. Still open

- Village projects (bundles with substitutes): still a maybe.
- Cider is alcoholic. It is needed for vinegar; rename it "apple must" for young players if wanted.
- Art for the 67 card pages, 27 album pictures, 23 gear items and pests.
- Playtest with real 8-year-olds:
  - how many review questions they tolerate;
  - whether 30 questions per season feels right;
  - whether pest pressure is noticeable but not annoying.
