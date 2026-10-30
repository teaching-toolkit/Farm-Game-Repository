# Money, the market, the trip and the Lord's share

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

### 5.3 Money 🟤🟡 and the market

Coins come from **selling** — never from answering questions. They buy seeds, animals, books, materials from merchants and
the coin part of some buildings. The game starts with **no money**; the first comes from porridge.

**Bronze and gold.** Money is counted in **bronze**; **100 bronze = 1 gold**, like Rappen and Franken (a real-world skill). Under a gold an amount is written in
bronze (`35 🟤`); from a gold up it shows both (`2 🟡 35 🟤`, whole bronze, stocks rounded down and costs up). The purse in the top bar says bronze
only until the child has had a gold, then both. Coin costs show as cubes of 10 bronze (or of a gold) with the sum in words. The purse itself appears with
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
village's price for that many). Each recipe shows what its ingredients would fetch and what the result fetches (30 🟤 → 60 🟤).

**Sell bonuses:** Market Stall +10 %, the pony +10 %, four Harvest Fair ribbons, the *Fair prices* card, gifts.

**Quality pays.** A grown or made thing has a grade (§8.5): Lumpy sells for 60 %, Proper for 100 %, Fancy for 150 %. Selling goes best grade first
(so the market's "lots sold lately" drop falls on the cheaper ones).

### 5.3b The bag, the trip and the village square *(built, phase 6)*

**The bag.** Packing is how things leave the farm: in the store tap a thing and put one (or all that fit) into the 🎒 bag; packed things *stay in the store*, marked 🎒, and
can be unpacked for free. The bag holds **load units** (the weights of §5.5): the farmer's arms 20, a woven bag 30, a wicker pack 44, a canvas rucksack 60, a frame
rucksack 80, a wheelbarrow 100 *(💡 numbers in `rules/49-trip.json`)*. The 🎒 icon in the top bar (it appears with the first packed thing) has a thin bar under it that fills as you pack;
its window shows the load and what is packed.

**The trip.** The market place on the map is a signpost to the village. Its window prepares the trip: the bag, the *orders to deliver* (each with *pack what it needs*) and
*Go to the village* — it costs a little energy (3 ⚡ × the errand factor of rucksacks and boots × what a better road saves, at least 1) and **exactly one Time Quiz question** on the way
(a wrong first try leads to another question; only a right first answer gets you there). Then the **village square** opens: **sell** what is in the bag (the market pays less for a
pile of one thing), **hand over orders** from the bag (deliveries ride in the bag like everything else), **buy** seeds and wares within the room left for the way home (the
same size as the way there, counted separately; seeds weigh almost nothing), and go **back home** — what was not sold simply stays in the store. A trip with an empty bag, only to buy, is allowed.
Selling, buying, barter and deliveries work only on the square (or with the merchant at the gate). The painted village square (M9) is still to be drawn; the window stands in for it.

**The travelling merchant.** Where a cart can come (road level 2 and up) he turns up at the gate now and then — more often and with a bigger cart on a better road — stays a few
questions and buys crops, ingredients, dishes, animal things, crafts, cloth and finds in bulk without a trip or energy, at the village price less his cut (15 %), until his cart is full
(`rules/50-gate.json`). His cart stands at the road while he is there; a tap on it opens the road's window.

**Trust and reputation.** The village distrusts the farm at first (it burned, the family was blamed, everybody is poor). As the farm visibly recovers (every 14 main goals done is a level of
*reputation*, ♥ to ♥♥♥♥) and as each trader gets a good turn (deliveries handed to them, ♥ to ♥♥♥) their seeds and wares cost a little less (never more); nobody is ever angry (`rules/51-trust.json`).

**Season prices.** At every change of season a news line says what the village pays more or less for (`rules/52-season-prices.json`: spring is the list price; summer and autumn have plenty of crops;
winter is hungry and pays more for what keeps). Goals' costs never change.

**Coins fly** between the purse and the square — one coin for every 10 bronze, in tight bunches of 10 — plain for everyone; the *Coin shower* perk makes the selling flight a shower.

### 5.3c The Lord's share *(built, phase 8)*

From **chapter 3** the farm owes the Lord a share at the end of every season (a season is 30 questions; until then it is a ruined plot nobody watches). It is counted on what the Lord
*assumes* the farm gives, not on what it gave: every patch that can be planted (field 420, orchard and greenhouse 630 🟤) and every building that produces or processes (mills, kiln, smithy, press,
loom, lumbermill, workbench …, 420 🟤 × its level), times a fraction that rises with the chapter (a tenth, a fifth, a third, a half: the origin story's numbers), so a bigger farm owes more
whatever it yields. A share is never more than a quarter of what the farm sold in the season that ended (at least 200 🟤): a quiet season costs little.
**Pieter the night watchman** (his lantern) comes to the gate and waits there until it is paid; the child pays in the road's window (all of it, or what they have). Unpaid shares pile up
to two seasons' worth. **While something is owed, everything that costs coins is blocked** (the goal tiles say *the Lord's share first*; seeds and wares cannot be bought); selling, making,
farming, trips and barter go on, so nobody is stuck. In chapter 6 the story eases the fraction to a tenth (`lord.eased`, *planned*). Data: `rules/53-lord.json`; system `G.lord`;
story pieces `c3_pieter`, `c3_pieter_paid`, `c3_k_pieter`. *(Planned: Quill counts the patches and buildings himself in chapter 4, the story beat that eases it.)*
