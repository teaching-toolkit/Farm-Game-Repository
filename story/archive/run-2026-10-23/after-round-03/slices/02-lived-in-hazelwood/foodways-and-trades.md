# Foodways, trades and prices

Slice 02, companion to `dossier.md`. Written 23 Oct 2026; **revised 23 Oct 2026 (revision 2: the Mark is a fixed grievance, no year counts, Rue, tolls are bible only)**. Labels: ✅ decided · 💡 proposed (rows with no source tag are 💡) · ❓ open · 🔒 hidden. Game facts are read from `godot-prototype/data/farm/recipes.json`, `items.json` and `rules/*.json` (read-only) and are marked `[game]`. Nothing here is player text.

## 1. Why a burnt-farm girl's food matters 💡

Hazelwood has no farm of its own that can feed it. The five farms in the valley (Highfold sheep, Cressbrook dairy, Three Oaks orchard, Alderbank greens, and before the fire Moonedge) grow oats, rye, greens, cheese, wool and apples on thin or heavy ground. Only **Moonedge's soil** (stony, warm, drained by its moonstones) made real wheat, and only Moonedge had the barn, the bees and the cows to feed the mill, the oven and the Fair all at once.

Since the fire:

1. **Flour is grey and dear.** The bakery buys **barge flour** from Weir, three days down and five days back up: "bread that has been on a boat" (kids' joke). A loaf is about three eggs when it used to be two.
2. **Hot food at noon is missing.** Quarry Row, the Diggings and the builders who come and go have nobody to feed them; the Square Pot feeds the village but not the workers.
3. **The mill has little to grind.** The wheel is stopped; the grindstone is dry.
4. **The Fair shrank** to three tables.
5. **The Moonedge Mark** (a chalk mark on every loaf, sack and crossing) makes every one of these things dearer. It is the Lord's way of making good the share the farm stopped paying when it burned (atlas §6). **The Mark is a fixed grievance, not a meter:** it does not shrink with what the farm pays, and it ends in chapter 6 as a village act. One child sentence: "Since the fire, every loaf in Hazelwood gets a chalk mark for the farm that burnt. Nobody likes it." So every plate of food the farm sends down the road does two or three things: feeds someone, gives the mill something to grind, and (in the village's eyes) shows the farm is back, which is a reason to hope the Mark will go.

So the farmer's food is not charity and not a hobby. **It is the one thing the valley has been missing since the fire, brought back by the child the valley remembers carrying a bucket.** That is why a dish is how she says hello, and why the village has a way of receiving it (the Open Bowl, §6).

## 2. The village's money, and a way a child can price things 💡

- **Coins** [game: `rules/40-economy.json`]: bronze and gold; 100 bronze = 1 gold ("like Rappen and Franken"). In the village the Lord's gold has his chin on it, so slang is **a chin** for a gold and **a bit** for a bronze: "three chins and a bit". Said with a smile; never in the Lord's hearing.
- **The egg rule** 💡. Children and old women price everything in eggs, because an egg (65 bronze in the game) is what everyone knows. Use "eggs" in barks and banter; use coin names for formal prices. Egg equivalents from `items.json` values:

| Thing | `[game]` value (bronze) | In eggs | Said as |
|---|---|---|---|
| wheat (a measure) | 15 | a quarter | "a fistful" |
| carrot | 30 | half | "half an egg" |
| milk | 90 | one and a half | "an egg and a bit" |
| wool (a fleece) | 60 | about one | "one egg's worth" |
| flour (a sack-measure) | 100 | one and a half | – |
| honey (a jar) | 150 | two and a bit | "two eggs and a lick" |
| bread (a loaf) | 200 | three | "a three-egg loaf" |
| stone soup (a bowl) | 180 | nearly three | – |
| porridge (a bowl) | 60 | one | "an egg-bowl" |
| butter | 330 | five | – |
| cider (a crock) | 300 | about five | – |
| jam | 400 | six | – |
| pickles | 930 | fourteen | "a voyage jar" |
| aged cheese | 800 | twelve | "a wheel's slice" |
| apple pie | 1,080 | seventeen | "a Fair pie" |
| pizza | 1,500 | twenty-three | "a builders' pizza" |
| golden honey cake | 2,000 | thirty | "a cake for a feast" |

- **Season prices** [game: `rules/52-season-prices.json`]: spring list price; summer crops 0.92 and dishes 1.05; autumn crops 0.95; **winter crops 1.25, dishes 1.15**. In the village: "Winter eats what summer sold."
- **The eighth-loaf rule** [game: `rules/40-economy.json`: the first 8 of a thing sell at full price, each extra fetches 8% less down to 60%]. In the village: "Eight loaves fill the square; the ninth sits politely." And "Bring a little of everything" (selling many different things pays best).
- **Trust prices** [game: `rules/51-trust.json`]: with no trust the price is the list price; trust and reputation only lower prices; nobody is ever angry. In the village: a merchant who has had a bowl from you "knows your face".
- **Coin is scarce.** Most of the valley's trade is bowls, favours and swaps. The Lord's share and the water-toll take coin down the river on the grey barge ("coins swim down, goods float up"). A family may see three gold in a month.

## 3. Staple foods of the valley 💡

| Season | Everyday | Hungry-year (the grey years) |
|---|---|---|
| Spring | wild garlic and nettle in flatbread, eggs, oat porridge, thin soup | thin soup |
| Summer | peas, early carrots, salads, berries, cheese, pancakes | bread and scrape |
| Autumn | apples, pumpkin, potatoes, hazelnuts, cider, fresh cheese | roast apples and rye |
| Winter | oat porridge, kale, stored carrots and onions, pickles, hard cheese | barge flour bread, if the barge comes |

The valley's tastes: **hazelnuts** in everything (they are free and the village is named for them), **onions** (the most trusted vegetable), **pickles**, **honey for the sick**, **cheese with something sharp on top**, **oat porridge with a spoon of apple butter**. Hazelnuts are not an item in `items.json`; a data wish (§8).

## 4. Festival foods and the game's dishes 💡

| Festival / custom | Food | `[game]` recipe | Notes |
|---|---|---|---|
| Hatching Day (spring) | dyed eggs, pancakes, omelette | `pancakes`, `omelette`, `yellow_dye` (onion), `red_dye` (beet) | pancake toss; names the calf |
| First Furrow | bread and cheese in the field, eaten standing | `bread`, `fresh_cheese` | for whoever cannot plough |
| Floating Lights (midsummer) | cold berry things, salad, cold soup | `garden_salad`, `yogurt_bowl`, `jam`, `berry_cake` | eaten on the Landing Steps |
| Bucket Night (late summer) | cold bread and a bun for the winning Chain | `bread` | the bun is always a bun |
| Nut Week (autumn) | hazelnuts roasted in the Square Pot's embers | – | a hazelnut item is a data wish |
| Cider Night (autumn) | cider, apple things | `cider`, `apple_pie`, `apple_crumble` | the Late Mug is cider |
| Share Day (any season's end) | stone soup | `stone_soup`, `veg_soup` | Pay on a full belly |
| Longnight (winter) | honey porridge with one hidden hazelnut | `honey_porridge` (wheat, honey, milk) | whoever finds the nut tells first |
| Frost Market (winter) | hot chestnuts, hot cider, thyme syrup | `cider`, `thyme_syrup` | stalls under lanterns |
| Weddings | three-layer cake, threshold loaf | `berry_cake`, `apple_pie`, `bread` | [game] `sq_wedding_cake` |
| Birthdays | a plain cake; one candle per ten years and a spoon for the rest | `simple_cake` | [game] seed merchant's birthday |
| Naming (new baby) | porridge for the neighbours | `honey_porridge` | |
| The Harvest Fair | the four tables | `pumpkin_pie`, `apple_pie` (Pie); `cheese_board`, `tapenade` (Cheese); `pickles`, `jam`, `cured_olives` (Preserves); `rainbow_yarn`, `linen_cloth` (Cloth) | [game] `d_fair_*` |
| The Elders' feast | a feast of old comforts | `tapenade`, `pumpkin_soup`, `bread` | [game] `sq_elders_feast` |
| Sick-room | broth, tomato soup, thyme syrup, chamomile tea | `tomato_soup`, `thyme_syrup`, `chamomile_tea` | [game] Old Jan, the healer's chest |

## 5. Who eats what: the game's deliveries, as village life 💡

`[game]` deliveries open the traders; in story terms each is somebody eating something for a reason.

| Delivery node | Who eats it | Why *that* dish (village logic) | Trader it opens |
|---|---|---|---|
| `d_porridge` | the seller (Rue) on the road | what a person can make on a campfire in a tin pot; "an egg-bowl" | `seed_1`, `seed_2`, `raw_1`, `book_cart` |
| `present_onion` | the seed cart | onions are the most trusted vegetable | `seed_2` |
| `d_veg_soup` | the Square Pot | the first thing the village can share | `seed_3`, `spice_1`, `raw_1` |
| `d_stone_soup` | Quarry Row | their own dish; the Soup Stone | `seed_3`, `raw_2` |
| `present_lettuce`, `present_beet` | the seed stall | soup and pancakes as gifts | `seed_3` |
| `d_bread` | Mistress Leaven | the Culture Mother judges a loaf by its crumb | `culture_1`, `raw_2` |
| `d_pancakes` | the seed stall | Hatching Day food, any day | `seed_4` |
| `d_hearty_stew` | the miners of the Diggings | pay-day food: potatoes, beans, carrot, onion | `raw_3`, `spice_1` |
| `d_honey_oat_cake` | Forester Ash | his weakness | `raw_4`, `seed_4` |
| `d_simple_cake` | Rue's birthday | a plain cake; one candle per ten years | `seed_4`/`seed_5` |
| `d_pizza` | the builders of the farmhouse, on the Square | a big shared thing to eat standing | `raw_5`, `seed_5` |
| `d_fair_pies/cheese/preserves/cloth` | the whole Fair | the four tables | `import_broker` (Fenwick) |

## 6. The Open Bowl as an economy 💡

The rule "No bowl goes home empty" (custom 1) is the village's credit system. A bowl given is a favour owed; the bowl comes back washed, with something in it; the something is a small repayment *and* an invitation. Three consequences for writers:

1. **A delivery is not a sale.** When the farmer hands over soup, the story shows a bowl coming back (almanac bark B27), not a coin. The coin side is the game's.
2. **The village can feed the farmer back** and does, at her lowest (E-5.L02). The reverse of the rule: now she has fourteen bowls to return, and cannot, because she is ill.
3. **The rule is why gossip can be kind.** Everybody owes somebody a bowl.

## 7. The trades, and what each needs from a farm 💡

| Trade | Who | What they buy from a farm | What they sell | Where in the game |
|---|---|---|---|---|
| Baker | Mistress Appleby, Anna, Crumb | flour, eggs, butter, honey | bread (sells the farm's from `d_bread`) | `bread`, `oven_1` |
| Miller | Hob and Ella Millward | wheat, oats | flour; milling | `flour_mill`, `windmill_1` |
| Smith | Old Odinson, Bo | charcoal, iron ore, ale | nails, tools, shoeing | `forge`, `anvil` |
| Cobbler | Heel and Toe Solemate | leather, wool | mended boots (free for shared pairs) | gear |
| Washerwoman | Hilde and sisters | soap, rope | clean sheets; news | `sq_washing_line` |
| Lamp-maker | Ferdinand, Spark | oil, wax, glass | lamps, hoods | `sq_lamp_maker` |
| Cooper | Hoop | oak | buckets, barrels, the Moonedge bucket tags | – |
| Healer | Wren | honey, wax, clean jars | remedies | `healers_chest` |
| Charcoal | the Burners | stumps, log ends | charcoal | `charcoal` (`kiln`) |
| Ferry, barge | Otto, Mei | pickles, bread (for voyages) | crossing; letters; cargo | `sq_long_voyage` |
| Quarry | Marta Hewitt | hot food at noon | stone | `raw_1` |
| Mine | Garnet Pike | hearty stew | iron ore | `raw_3` |
| Tolls (bible only; the text needs only the Mark and the share) | Tally, Pieter, Quill | – | the Mark, the share | `rules/53-lord.json` |

## 8. Data wishes this slice would like (not edited; for `story/data-wishes.md` in 08c) 💡

| Wish | Why |
|---|---|
| a `hazelnut` crop or find (and roasted hazelnuts) | the village is named for them; Nut Week and Longnight need them |
| `sq_chapel_roof` renamed "Fix the Hall roof" | ✅ no religion (C12) |
| the book title "Grandma's Kitchen" renamed "The Kitchen Book" | C18 |
| a bucket helper "The Village Buckets" (6 or 7, from the Moonedge post) | small gift, water trips carry a bit more; optional |
| `well_mood` or a village-well counter if the Plink should be reactive | optional; seeds can work without it |

## 9. Food-writing cautions

1. Hunger is real but never shown as a sad scene; it appears as portion sizes and what is shared.
2. Never make the farmer's cooking magic. It is good because she is careful.
3. Dishes are "the research" (project rule): each delivery should teach one real fact about the food (for example that stone soup works because everyone adds one thing).
