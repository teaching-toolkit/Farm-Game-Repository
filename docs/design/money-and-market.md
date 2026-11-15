# Money, the market, the trip and the Lord's share

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

### 5.3 Money 🟤🟡 and the market

Coins come from **selling** — never from answering questions. They buy seeds, animals, books, materials from merchants and
the coin part of some buildings. The game starts with **no money**; the first comes from selling what the farm made (porridge, a wicker basket, a clay pot) on the
first trip to the village.

**Bronze and gold.** Money is counted in **bronze**; **100 bronze = 1 gold**, like Rappen and Franken (a real-world skill). Under a gold an amount is written in
bronze (`35 🟤`); from a gold up it shows both (`2 🟡 35 🟤`, whole bronze, stocks rounded down and costs up); **1000 gold = 1 diamond**
(`1 💎 234 🟡 56 🟤`; coins are still counted and saved in bronze, the diamond is only how they are shown). **The purse** in the top bar is
coin pictures with their numbers, stacked: a diamond row from 1000 gold, a gold row and a bronze row, each only when there is at least one
of that coin (up to three rows; fewer rows are drawn bigger). The bronze coin is the gold coin picture with its colour shifted
(`assets/ui/coin_gold.png`, `assets/ui/diamond.png`: placeholders drawn by code until the parent makes real ones). Coin costs show one cube
per bronze under a gold, per gold from a gold, per diamond from a diamond, with the sum in words (interface-feel/05, 07). The purse itself appears with
the first coin (§13.2b). **Prices are realistic** (`docs/sources/price-table.md`): an egg 65, a carrot 30, a loaf of bread 200 bronze (about Swiss prices);
the rest keeps the old ratios (one old coin became 15 bronze, so the pace of the game did not change). Figures quoted elsewhere in this
document are in bronze if they say so, otherwise in old coins (×15 for bronze); `data/farm/` is the truth.

**Prices from ingredients** (`meta.pricing`, old coins; the formula is now only a guide: `items.json` holds the price table, and dishes made from dishes no longer grow without limit — pizza 1500 bronze, a cheese board 2500). Everything that is made is priced from what goes into it: the worth of the
inputs × (1.25 + 0.1 for each different ingredient beyond the first) + ½ coin per energy, per fuel point and per question
it takes + 0.2 per water. So a dish of four different things pays more than its parts, and a dish made from dishes more
again (porridge 4, roast carrots 7, omelette 16, honey cake 49, apple pie 72, pizza 166, cheese board 212). Things a merchant
sells are worth less than his price even with every sell bonus — buying to resell never pays. Sticks, stones and fibre are
worth almost nothing, so gathering is never a money farm; straw cannot be sold at all.

**The market wants variety** (`meta.market`). Each thing sells at full price for the first 8; every further one of the same
thing fetches 8 % less (down to 60 %), and every question the market forgets a quarter of what was sold lately. A ↓ marks
something sold a lot lately. Selling a mix pays best.

**Selling happens on a trip** (§5.3b). The store has no sell buttons: its tiles say what a thing sells for (*Sells for about 60 🟤 each*) and let you
pack it; the square's sell buttons say exactly what you give and what you get: `1 🥣 = 60 🟤`, and for all of it `5 🥕 = 1 🟡 50 🟤` (the
village's price for that many). Recipes, chopping, cooking and other making show no sell value (interface-feel/03): prices are shown only where
selling or paying happens (the square, the gate, the store's tiles, a goal that costs coins).

**Sell bonuses:** Market Stall +10 %, the pony +10 %, four Harvest Fair ribbons, the *Fair prices* card, gifts.

**Quality pays.** A grown or made thing has a grade (§8.5): Lumpy sells for 60 %, Proper for 100 %, Fancy for 150 %. Selling goes best grade first
(so the market's "lots sold lately" drop falls on the cheaper ones).

**Made things and their price** (`money-market/01`): what a merchant asks for a made thing lies between what it costs a master and what it costs
a beginner to make it (inputs, energy, fuel, water and waiting), so a beginner does better buying and a master making: the guild merchant asks 740 for
steel (making costs 687 to 795). Glass is the exception: he asks 235, the lowest the no-resale rule allows (a merchant never asks less than 1.3 × a
thing's worth), and making it is cheaper. Selling a made thing pays at least a master's cost, except for things made for the farm (compost, ash),
gathered things, what a merchant sells, and three Swiss prices (fresh cheese, cider, tomato sauce). `python3 godot-prototype/tools/price_rule.py`
prints every recipe against the two costs; run it when a recipe or a price is added.

### 5.3b The bag, the trip and the village square

**The bag.** Packing is how things leave the farm: in the store tap a thing and put one (or all that fit) into the 🎒 bag; packed things *stay in the store*, marked 🎒, and
can be unpacked for free. The bag holds **load units** (the weights of §5.5): the farmer's arms 20, a woven bag 30, a wicker pack 44, a canvas rucksack 60, the hand
cart 60, a frame rucksack 80, a wheelbarrow 100 (the best one owned counts; `rules/49-trip.json`). The 🎒 icon in the top bar (it appears with the first packed thing) has a thin bar under it that fills as you pack (on the village square it also counts what is bought for the way home);
its window shows the load and what is packed.
**Strength carries more** (`money-market/02`): the 💪 strength of the wellbeing dashboard (§5.1b; every farm starts at 0.5, frozen until chapter 2, and it rises with the skill ranks) adds
0.6 of the capacity for every point above 0.5 — full strength carries 30 % more — in whole load units and never less than the plain capacity (a weak farmer is not made to carry less).
The bag's window says so in a line (*💪 You are strong: your strength adds N room.*) once it is more than nothing. Numbers: `strength` in `rules/49-trip.json`.

**The trip.** The market place on the map is a signpost to the village: a wooden sign beside the road with a painted cream arrow that points along the road, towards the village beyond the screen's right edge (`assets/map/village_sign.png`, made from the blank `deco/signpost.png` by `tools/make_village_sign.gd`; no words). Tapping the sign opens the window; once the Market Stall (a building, +10 % on sales) is built, its picture stands there instead and the tap does the same. The window prepares the trip: the bag, the *orders to deliver* (each with *pack what it needs*) and
*Go to the village* — it costs a little energy (3 ⚡ × the errand factor of boots and the big rucksacks × what a better road saves × the factor of a borrowed donkey, rounded up, at least 1) and **exactly one Time Quiz question** on the way
(a wrong first try leads to another question; only a right first answer gets you there). **Boots** (straw sandals, wooden clogs, hobnail boots, waxed walking boots, the polish for the boots) and **Old Jan's donkey**
(×0.6 on the trip only; the helper of the favour *Soup for a sick neighbour* in chapter 2, `jans_donkey`) make it cheaper; because the cost is rounded up to whole ⚡ a small saving shows only once the road is better
(boots from road level 3) while the donkey takes a trip from 3 to 2 ⚡ at once. The canvas and the frame rucksack lower the errand factor too (−10 %, −15 %). Then the **village square** opens: **sell** what is in the bag (the market pays less for a
pile of one thing), **hand over orders** from the bag (deliveries ride in the bag like everything else), **buy** seeds and wares within the room left for the way home (the
same size as the way there, counted separately; seeds weigh almost nothing), and go **back home**: *🏠 Back home* is a walk like the one there and costs **one Time Quiz question** too (no energy; a wrong first try leads to another question, a pop-up closed without an answer leaves the
farmer on the square, only a right first answer takes him home); what was not sold simply stays in the store. A trip with an empty bag, only to buy, is allowed.
**Does the room count each way separately?** Yes, and it is the same size both ways: the bag's capacity is the room for the way there (what is packed to sell or hand over) and the same capacity is the
room for the way home (what is bought on the square); the two do not share one load (this is what the game does; the answer to the question in `money-market/02`).
Selling, buying, barter and deliveries work only on the square (or with the merchant at the gate). **The square is its own screen** (`money-market/07`): while the farmer is in the village, a scene of the square stands where the farm was, and nothing of the farm is seen or can be tapped. The scene fills the screen, as the farm does (`money-market/10`). **Its ground is diamond tiles all the way to the top edge, with no sky** (`money-market/12`): grass and flowers with a tulip bed, autumn leaves, lupins and a ploughed strip with seedlings at the top, a plaza of cobbles (round, grey setts, a few mossy, wet or straw-strewn ones) with a pale slab path and brick in front of the stalls, edge tiles where cobbles meet grass or soil, and a plank stage under the order cart. It is a map in the data (`rules/49-trip.json` `trip.square.ground`: rows of letters, one letter per tile, and a table of what each letter is) built by `ui/square_ground.gd`; which of a kind's pictures a tile gets is a stable hash of its place, so it never changes between visits. About 8 tiles span the width, so what stands where on screen is the same on every device. The village miller's water mill, a lantern or two, a flower tub, crates, barrels, milk churns, a wheelbarrow and a horse trough stand on it as deco, no one of them tappable. Its stalls are pictures with a symbol, no words: 🪙 the stall that buys what is in the bag, 🌱 the seed merchant, 🧺 the other traders (once one trades with the farm), 📦 a cart for the orders (only while an order can be handed over), 📋 the notice board (the same favours and little jobs as the board on the farm, which stays there too), 📚 the book cart (it stands on the square for good once it has come, and books are bought only there: `money-market/11`) and 🏠 the sign for the walk home. A stall shows only its own seller's things: the seed merchant's wheat, winter wheat and hay are in the seeds stall, not among the traders (`money-market/09`). A tap on a stall opens its window from below; ✖ or a tap on the bare scene closes it again, back to the full scene. The stall that is open stands on a light spot. On arrival no window is open, unless the farmer came for one stall (something in the bag sells, or an order can be handed over): then that stall's window is open. The 🏠 sign and the bag's bar in the top bar work with no window open. The bag, the quest book and the album open over the scene and close back to it. People stand and stroll on the square and say a line when tapped (`people/06`; see `friends-and-story.md` §11.0). The scene is a mockup made from pictures the game already has (`rules/49-trip.json`, "square": what stands where, in shares of the scene); *planned: one painted village square (`pictures/04`) and a face for every trader (`pictures/06`), which need only that data block and the picture files.*
At the top of the square window the bag is shown as **two bars** that move with every sale, purchase and delivery: the 🎒 bar is what is still in the bag to sell or hand
over (it empties as things are sold or delivered), the 🏠 bar is what has been bought for the way home (it fills with every purchase; the number beside it is the room left,
which is what the shops take). Seeds weigh almost nothing, so buying only seeds hardly moves it.

**The travelling merchant.** Where a cart can come (road level 2 and up) he turns up at the gate now and then — more often and with a bigger cart on a better road — stays a few
questions and buys crops, ingredients, dishes, animal things, crafts, cloth and finds in bulk without a trip or energy, at the village price less his cut (15 %), until his cart is full
(`rules/50-gate.json`). His cart stands at the road while he is there; a tap on it opens the road's window.

**Trust and reputation.** The village distrusts the farm at first (it burned, the family was blamed, everybody is poor). As the farm visibly recovers (every 14 main goals done is a level of
*reputation*, ♥ to ♥♥♥♥) and as each trader gets a good turn (deliveries handed to them, ♥ to ♥♥♥) their seeds and wares cost a little less (never more); nobody is ever angry (`rules/51-trust.json`).

**Season prices.** At every change of season a news line says what the village pays more or less for (`rules/52-season-prices.json`: spring pays a little more for crafts and cloth; summer has
plenty of crops (−8 %) and pays more for dishes and animal things; autumn has the harvest (crops −5 %) and pays more for ingredients and crafts; winter is hungry and pays more for crops (+25 %), dishes,
animal things, cloth and crafts). Goals' costs never change.

**Coins fly** between the purse and the square — one coin for every 10 bronze, in tight bunches of 10 — plain for everyone; the *Coin shower* perk makes the selling flight a shower.

### 5.3c The Lord's share

From **chapter 3** the farm owes the Lord a share at the end of every season (a season is 30 questions; until then it is a ruined plot nobody watches). It is counted on what the Lord
*assumes* the farm gives, not on what it gave: every patch that can be planted (field 420, orchard and greenhouse 630 🟤) and every building that produces or processes (mills, kiln, smithy, press,
loom, lumbermill, workbench …, 420 🟤 × its level), times a fraction that rises with the chapter (a tenth, a fifth, a third, a half: the origin story's numbers), so a bigger farm owes more
whatever it yields. A share is never more than a quarter of what the farm sold in the season that ended (at least 200 🟤): a quiet season costs little.
**Pieter the night watchman** (his lantern) comes to the gate and waits there until it is paid; the child pays in the road's window (all of it, or what they have). Unpaid shares pile up
to two seasons' worth. **While something is owed, everything that costs coins is blocked** (the goal tiles say *the Lord's share first*; seeds and wares cannot be bought); selling, making,
farming, trips and barter go on, so nobody is stuck. *(planned: in chapter 6 the story eases the fraction to a tenth; the data has `easedFraction` and the save has `lord.eased`, but no story piece sets it yet.)* Data: `rules/53-lord.json`; system `G.lord`;
story pieces `c3_pieter`, `c3_pieter_paid`, `c3_k_pieter`. *(planned: Quill counts the patches and buildings himself in chapter 4, the story beat that eases it.)*
