# Progression: chapters, pets, merchants, pacing

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 10. Progression

### 10.1 Six chapters

| Chapter | Home | Material age | What opens up | Pet |
|---|---|---|---|---|
| 1 · Ashes | Tent | sticks, stones, fibre | campfire and porridge, clearing patches, stone tools, quern and flatbread, chickens, a well | Bunny |
| 2 · Homestead | Cottage | logs, planks, clay, bricks | log shed, compost and tomatoes, bees, woodlot, carpenter and kiln, the cottage in stages, stove, oven and prep table, pond, market stall, barn and cows, butter, the orchard | Tortoise |
| 3 · Smallholding | Cottage | iron, nails | smithy, forge and anvil, iron tools (more plants per patch), sawbench, sheep and cloth, linen from flax, the press (oil, juice, sugar), windmill, fermenting and the cellar (yogurt, cheese, cider, vinegar, pickles), lumbermill | Goat |
| 4 · Village Trade | Farmhouse | steel, glass, hardwood | blast forge and steel tools, drip line, the farmhouse in stages, greenhouse, brickworks, warehouse, master workshop and textile loom, walnuts and olives, pizza, the North Field | Pony |
| 5 · Healing | Farmhouse | herbs, the forest | Berit's still-room and its five stations, eleven remedies and the Healer's Chest, the forest and Wren's check, the book *The Healer's Herbal*, the healer's garden and the old lamp-maker | Badger |
| 6 · Master Farm | Farmhouse | heirlooms, dyes | Import Broker barter, saffron and heirloom crops, the dye vat and colour mixing, Harvest Fair ribbons, master oven and stove, fine flour, seed library, wind pump, the River Meadow | Alpaca |

A chapter's sheets never show anything beyond it; the quest book shows this chapter's next goals and what is one step away.

### 10.2 What opens what

Everything is a **node** in the data with `requires` (other nodes) and a `cost`. Kinds of gates:
- **Building and making:** a station or building opens the next (the kiln needs the workshop and clay).
- **Knowledge cards:** most new things need the card that explains them (§4.2); a few need a number of cards learned
  (`requiresCards`).
- **Dishes are the research.** Deliveries of dishes to the village open the next merchant (§10.4).
- **The road:** merchants come only when the road is good enough.
- **Discovery:** some cards need the item seen once.
- **An ingredient threshold:** tomato seeds need 2 eggs brought once.
- **Automatic unlocks** (41) open by themselves when their requirements are met (new seed tiers, merchants).
- **Chapters** end with a pet; later favours open only after the previous chapter's pet, so they never crowd a new chapter's
  first goals.

### 10.3 The pets

| # | Pet (default name) | Dish | Comfort item | Bonus for good |
|---|---|---|---|---|
| 1 | 🐰 Bunny (Pip) | Carrot-Clover Bowl | Straw Hutch | +1 carrot per harvest |
| 2 | 🐢 Tortoise (Mossy) | Tortoise Garden Platter | Warm Shell House | +1 💧 every water trip |
| 3 | 🐐 Goat (Bramble) | Apple Oat Crumble | Goat Shed | a little compost every question, weeds −15 % |
| 4 | 🐴 Pony (Hazel) | Apple-Carrot Cake | Saddle Blanket (needs the barn stable) | +10 % when selling |
| 5 | 🦡 Badger (Bracken) | Healer's Chest | Tea Set | +1 herb per herb harvest |
| 6 | 🦙 Alpaca (Alfie) | Golden Honey Cake + Rainbow Roast | Rainbow Quilt | a little wool every question |

**The pets' jobs *(built, phase 8: levels 1 and 2)*.** Level 1 is the bonus in the table (always on). **Level 2** opens when the *next* pet has come home (the last pet has none yet): the pet's window in the
pet corner then shows its job board, two jobs to choose from (✔ marks the one it does), and the pet does it **once every question**, in the same step as everything else (no questions, no work):
bunny and goat pull weeds (the patch with most), bunny and tortoise pick stones (they arrive in the store), tortoise brings 1 💧, goat and badger make compost (every other question), pony hauls
logs (every fourth question) or fetches sticks (every second), badger gathers herbs (every third question). A job that cannot run just waits: 💤 nothing to do, 📦 the store is full; the board says
what happened in the last question. After the Time Quiz the pets **walk to where they worked** (a patch, the pond, the pet corner), show an emoji and walk back; a pet at level 1 shows its bonus now and
then (the tortoise 💧, the goat 🌿, the alpaca 🧶). **Levels 3 and 4** *(built, phase 12)*: a pet's level is 1 + the pets that came home after it (at most 4); once the last pet is home and the story is over, every pet is level 4 and the alpaca (guard the fields, grow fleece) gets its jobs too. **Level 3** adds a **WHEN card** to the job (weeds on a patch ≥ n, empty patches ≥ n, water < n, compost < n, sticks < n, logs < n, herbs < n, pests ≥ n; the child sets the number with − and +; each pet has two cards that fit it); the pet then works only when the condition holds. **Level 4** adds a second rule, read after the first when its WHEN does not hold (*OTHERWISE*: another job and its own WHEN, or always). A rule that cannot run waits (⏸️). Data: `rules/54-pets.json`; system `G.pets`.

The child names each pet (or keeps the default). Each pet adds a little luck for good, walks about the pet corner, and its
arrival brings a celebration and a chance of a postcard. The fifth pet needs the most branches at once: fine flour, honey,
butter, eggs, saffron and walnuts for the cake; rainbow carrots, golden beets, onions, olive oil and herbs for the roast;
linen and plant-dyed wool for the quilt (no silk — making silk kills the silkworms, which does not fit a vegetarian farm).

### 10.4 Merchants and deliveries

Merchants come one at a time, opened by a dish delivered to the village and a good enough road:

| Merchant | Opened by | Sells |
|---|---|---|
| Seed merchant (on foot) | start | wheat, then clover and more |
| Seed cart | 2 porridge for the travelling merchant + the potholes filled | more seeds |
| Raw materials · timber & stone | same | sticks, stones, fibre, logs |
| Book cart | same | the books the library has room for |
| Seed stall, Spice merchant | 3 vegetable soups for the village | seeds; salt |
| Raw materials · clay | 2 Stone Soups for the quarry folk + gravel road | clay |
| Culture specialist | 2 sourdough breads | yogurt and cheese cultures (barter) |
| Seed shop | 2 pancake breakfasts + gravel road | sunflower, flax, oats, apple saplings … |
| Raw materials · iron ore | 2 Hearty Stews for the miners + gravel road | iron ore |
| Raw materials · hardwood & sand | 2 Honey Oat Cakes for the forester + cobbled road | hardwood, sand |
| Seed nursery | a cake for the seed merchant's birthday + cobbled road | pumpkin, berries, herbs, walnut and olive saplings |
| Raw materials · guild stock | 2 pizzas for the builders + paved road | steel and glass (an expensive shortcut) |
| Import Broker | the pony + paved road | barter only: saffron corms, rainbow carrot, golden beet and woad seeds for fine goods |

Small **presents for the seed seller** (porridge, soup, pancakes, a cake) bring single new seeds in between. In chapter 5
four **Harvest Fair** tables (pies; cheese; preserves; weaving) each give a ribbon (+5 % when selling).

### 10.5 Pacing

The goal is **steady difficulty**, not fixed hours: minutes per main goal rise only gently (targets 2.5 / 4 / 5 / 6 / 7 by
chapter), Rest answers per hour stay in a band, and at every moment 2–12 goals are open with a quick win nearby
(`meta.targets`). The explorer simulates a player and reports it:

| | Ch 1 | Ch 2 | Ch 3 | Ch 4 | Ch 5 |
|---|---|---|---|---|---|
| Simulated hours | 0 → 1.6 | → 5.8 | → 12 | → 17 | → 20 |
| Pet | Bunny 1.6 h | Tortoise 5.8 h | Goat 12 h | Pony 17 h | Alpaca 20 h |
| Minutes per goal (target) | 2.3 (2.5) | 4 (4) | 6 (5) | 6.8 (6) | 7 (7) |
| Rest answers per hour | 102 | 53 | 71 | 68 | 64 |

Whole game: about **21 hours**, 1,400 Time Quiz answers, 1,400 Rest answers, 67 cards (about an hour of card quizzes),
333 goals + 41 automatic, 28 favours (about 3 hours on top), 141 items, 106 recipes; upgrades save about 38 % of the energy.
The simulation rests on guesses (25 seconds per Time Quiz question, 3 per action, 5 per Rest answer, a player using 60 % of
their capacity) that play-tests should replace. The test bot (`tests/bot.gd`) plays the real rules engine: chapter 3 after
about 290–530 questions and chapter 5 (the first four pets; it stops before the alpaca) after about 690–870, in runs of
12 Oct 2026 (it plays randomly). `--accuracy=0.8` lets it miss a share of first tries, which costs extra questions.

### 10.6 Dynamic difficulty — prices that fit the farm *(built, off by default)*

**Aim:** the Goldilocks zone — every goal reachable, but only with real work, and the quickest way through is an improvement
or a polish the child has not tried yet. Switched on in ⚙️ → **🎚️ Prices fit my farm** (or `dynamicDifficulty`).

- **What is measured — the pace:** the worth of everything the player brings in per Time Quiz question (gathered, harvested,
  made, collected; a running average over about 20 questions; things bought don't count). It already contains everything the
  player has: upgrades, polish, perks, gifts, skill ranks, meals, a bigger store — and how hard the child works.
- **Compared with:** the pace the test bot has after the same number of goals (`meta.flex.basePace`, a table of [goals, pace]).
- **What changes:** when a goal first shows up, its **coins and bigger material amounts** are multiplied by
  (pace ÷ planned pace)^0.4, kept between ×0.8 and ×1.25 (favours ×0.75–1.35). A goal that an improvement not made yet would
  make quicker asks 8 % more and shows **💡 Quicker with: …**. Energy and the kinds of things never change; an amount never
  grows beyond what the store holds; **the factor is fixed** the moment the goal appears — a price never changes in front of
  the child; nothing before the first 15 questions.
- **Why only part of the pace:** the pace grows both when the farm is stronger and when the child simply works more per
  question. Following it fully would make every upgrade feel useless and punish effort (the old complaint about games whose
  monsters level up with the player). Following only part of it keeps most of the reward of getting better, and a child who is
  struggling gets goals up to a fifth cheaper.
- **Deliberately not flexed:** recipes keep fixed amounts — a recipe the child can learn by heart is part of the fun.
