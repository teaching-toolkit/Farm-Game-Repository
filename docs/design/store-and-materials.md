# Seeds, materials, fuel, freshness and numbers on screen

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

### 5.4 Seeds

**Only seeds you have can be planted.** There are two kinds:

- **Grain that is its own seed.** Wheat, meadow hay and winter wheat have no seed packet: the harvest *is* the seed (`seedItem` in the
  data). Planting takes one from the store, so the child keeps some back before cooking or selling the rest (the card *Saving seed*,
  chapter 1). The game starts with **one wheat grain** in the store and one cleared patch: the first stalk is the start of the farm.
  If the grain runs out, the seed merchant sells sacks of wheat, hay and winter wheat (45, 25 and 60 🟤).
- **Seeds bought in the village.** Every other crop has a price per seed (`seedCost`, bronze: clover, lettuce and oats 15, kale 24,
  carrot, onion, beans, beet and flax 30, potato, sunflower, berries and herbs 45, tomato and pumpkin 60; saplings: apple 450, walnut
  600, olive 750). Seeds are bought on the square (§5.3b), 🛒 1 or 🛒 5 at a time; they weigh almost nothing (a feather), and the
  store's 🌱 *Seeds* section shows how many of each you have. Trust and reputation make them cheaper (§5.3b), never dearer.

**The seed merchant grows** from a seller on foot (carrots) to a cart (clover, onion), a stall (potato, lettuce, beans, beet, tomato,
kale), a shop (sunflower, flax, oats, apple saplings) and a nursery (pumpkin, berries, herbs, walnut and olive saplings) (§10.4).
New crops come a few at a time: some need a better road (beans the ditch, sunflowers the kerbstones, herbs the row of trees), some
a card (carrots and onions *Roots you can eat*, kale, the orchard trees), some a present for the seed seller (onion sets for two
bowls of porridge, lettuce for vegetable soup, beets for pancakes, flax for a honey oat cake, berry bushes for a cake), and the
tomato two eggs and the compost bin. Heirloom seeds (rainbow carrot, golden beet, woad, saffron corms) come from the Import Broker
in packets, which are items in the store like the grain; the Seed Library (chapter 6) lets an heirloom give one seed back at each
harvest. **In winter** only hardy crops (winter wheat, onions, beans, kale) can be sown outdoors (§12).

### 5.5 Materials and the store

- **Basic materials any time.** The forest edge (*Field Edge & Woods*) always offers *Gather sticks*, *Pick stones* and *Pull
  wild weeds* (plant fibre); later *Chop deadwood* (stone axe), and *Dig out stones* and *Dig clay* (wooden shovel). Each draws on a pool
  that grows back slowly (§5.9). Gathering
  comes **at once** — the things fly to the store the moment the button is tapped — and then that spot needs a Time Quiz
  question to refill (the grey ⏳ appears where the button was).
- **Carrying gear takes bigger loads.** The Gathering Basket, Wicker Pack and Canvas and Frame Rucksacks add loads to every
  gathering tap (🧺×2, ×3 …): more comes in per question, for the same energy per piece (`meta.carry`). A tap takes a
  smaller load when energy is short.
- **The store** holds a limited number of **each** item: Basket 10 → Log Shed 25 → Warehouse 60 (gifts add a few). It opens from the
  storage place on the map (the basket, later the log shed and the warehouse): on top *🧺 Harvest all*, then *What you have* as a grid of tiles (picture, name, the number, 🍂 when it goes stale
  soon, 🎒 and the number packed, and a coloured dot for each grade there is), with a filter row (All, Crops, Food, Crafts, Herbs,
  Materials; `storeFilters` in `rules/49-trip.json`), and the 🌱 *Seeds*. A tap on a tile opens the thing: how many of each grade
  (⭐⭐⭐ 2 ⭐⭐ 5), what goes stale, and its buttons: 😋 *Eat* (dishes), 🔥 *Fire* (wood for the woodpile), 🎒 +1 and *+ all that fits*,
  ↩ −1, and what it sells for in the village. There is no sell button at home (§5.3b). What does
  not fit flies to the store, bounces off and tumbles away (🚫). Some things are **keepers** — needed but not used up (the
  tin pot, the sourdough starter, cultures, the stone in Stone Soup).
- **Every thing has a weight** (five classes: feather 0.1 · light 0.5 · normal 1 · bulky 2 · heavy 4 load units; seeds are feathers; straw is light but
  bulky, logs, stones and iron ore are heavy; `data/farm/rules/45-weight.json`). It works from the start but is not shown and limits nothing until
  the first market trip (§5.3b), when carrying (backpack → basket → cart, the farmer's strength, the road) starts to matter.

### 5.6 Fuel and the woodpile 🪵

Heat stations (campfire, stove, oven, kiln, forge, glass kiln) burn **fuel points from the woodpile** per batch (campfire 1,
oven 2, kiln 3 …). Wood is worth fuel: stick 1, straw ½, plank 2, log 4, hardwood 6, charcoal 8. The woodpile holds 20 → 40
→ 80 points (basket, shed, warehouse).

**The woodpile is stoked first.** Nothing jumps onto it by itself: when everything else for a recipe is there but the
woodpile is short, the recipe's button becomes **🪵 Stoke**, which puts on just enough wood (sticks first, then straw, then
logs); then the recipe can start. Wood can also be stacked by hand at the kitchen or the forest edge. **The house in winter**
burns a little firewood every question by itself (tent 0.2 → farmhouse 0.4 points); with an empty woodpile the house is cold
(Rest −25 %).

### 5.7 Freshness

Each batch in the store remembers the season it came in. At each **change of season**, food that has lived through its
shelf life turns stale: plant food becomes 🥣 **feed mash** (animals eat it, compost takes it), eggs and dairy go to the
compost. Shelf life in season changes: fresh greens, berries, tomatoes, eggs, dairy, juices and most dishes 1; roots, apples
and beans 2; pumpkins 3; preserved things (flour, grain, honey, jam, pickles, aged cheese, oils, cider, vinegar, nuts) keep
for ever. A **"stale soon" 🍂** badge warns one change ahead — sell it, eat it, or cook it into something that keeps. Cellar
racks, a card and a gift each add a season.

### 5.8 Numbers on screen

Every amount (stocks, energy, water, plants on a patch, polish, luck) is a decimal underneath, so percentages multiply
exactly. The child sees whole numbers only: stocks rounded **down**, costs rounded **up**, halves in descriptions as ½, no
decimals anywhere.
