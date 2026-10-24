# Almanac: the village's year, and what goes on without you

Slice 02, companion to `dossier.md`. Written 23 Oct 2026; **revised 23 Oct 2026 (revision 2: Bucket Night later and uncounted, Landing Day fortnightly, the Mark a fixed grievance, five rites only, no year counts, True Things optional, stance ladder column)**. Labels: ✅ decided · 💡 proposed (everything new; rows without a source tag are 💡) · ❓ open · 🔒 hidden. No player text here. Event seeds that use this material are in the dossier (E-n.LNN); sketches of single lines are marked *sketch*.

## 1. How the almanac meets the engine

- A season is 30 steps; the order is spring, summer, autumn, winter, and step 0 is spring (`node-map.md` §1). The counter `seasons` is steps ÷ 30, so engine season n is year ⌊n/4⌋+1 and season n mod 4 (0 spring, 1 summer, 2 autumn, 3 winter).
- **Pieces show once; barks come back** (cooldown 12 steps). So a festival that must happen every year in the village's life can be *told* once (a moment or scene, gated by `season:x`, and by `seasons>=n` if it should be a later year), and then *echoed* by barks every year. The village does the festival every year whether or not a piece fires.
- **Chapters move at the player's pace.** The bot's chapter lengths (steps → seasons): chapter 1 about 8 seasons, 2 about 6, 3 about 7.5, 4 about 6.5, 5 about 2, 6 about 5.5, and a human is slower. So the same chapter may fall in any season; **never lock a chapter's story to a season word** except where the dossier says so. Festival pieces gate on `season:` and a chapter or a done-node, not on a date.
- **The Harvest Fair is "called by full tables"** (customs: Fair). It has no date, so the engine's `done:d_fair_*` triggers can fire in any season without breaking the text. Write Fair pieces with season-proof things (long tables, lanterns, stored apples, cheese, cloth) and without weather words that say a season.
- The Time Quiz is the village's clock for the player; the village's calendar is its own. Nothing here is counted for the player (D11): the village never says "year", only "this time last winter", "the dry month", "since the Fair before last".

## 2. The week and the day 💡

**The week** has seven named days, which a child can chant as a skipping rhyme:

> Wash, Mill, Market, Smith, Bake, Landing, Rest.

| Day | What the village does |
|---|---|
| **Washday** | the Washing Stones are full; the gossip is hottest; Hilde's day |
| **Millday** | the mill grinds for Hazelwood only; Ella sweeps; flour on the Mill Bridge |
| **Marketday** | stalls on the Square; the board is read; the seed seller and Mother Thyme sit at the corner |
| **Smithday** | the Odinson forge is lit all day; children are let in to watch the quench; nails for the week |
| **Bakeday** | Appleby's second oven is lit; the whole Square smells; Lucia paints yellow |
| **Landing Day** (every *second* sixth-day, because *Nimble* takes three days down, five up and two to rest) | Mei's barge; letters called from the steps; the Weigh House chalks |
| **Restday** | nobody grinds, nobody chalks; the Kettle serves soup; the old sit on the wall; children play on the Landing Steps. The Lord's men do not collect. (Ticket 07 may use this: Pieter never knocks on Restday.) |

Only Landing Day and Marketday ever need to appear in a piece. The week is flavour.

**The day**, in sounds (for barks and for any scene that needs a time without a clock):

| Time | The sound or smell the farmer hears from Moonedge, or in the village |
|---|---|
| before dawn | Appleby's oven being fed; the first cart on the Hurst Road |
| dawn | the rooster on the Hall roof (Alderman); cowbells going up to the Tops |
| morning | the mill wheel groan; the schoolroom slates |
| noon | **the Quarry whistle**, three long, across the water (faint from the farm, heard only when the wind is right); the Kettle's soup |
| afternoon | the ferry bell; hammers on Smithday |
| dusk | cowbells coming down; **one big slow ring** from the Hall (a bark: supper); **the lantern** (Pieter's, lit while the sky is still light, always) |
| night | Ansel's **nine slow rings** on the Hall bell, faint from the farm: everyone should be in; then the Watch Walk |

The Hall bell has a **ringing code** (Ansel's *Book of Rings*, a village game: kids learn it): **one slow** at dusk = supper (a bark); **nine slow** = night, everyone in; **three** = something good (a birth, a wedding, the Fair); **five fast then one slow** = fire, then all well (born the night of the Moonedge fire; Bucket Night). A child can repeat "five fast, one slow".

## 3. The four seasons 💡

Each block: what the land does · the work · the market · weather and hazards · what the village does · the festival · the share day · the gossip theme · foods (with the game's dish names).

### 3.1 Spring (engine season n mod 4 = 0)

- **Land:** the Hazel is up and noisy; the Hop is under water for ten days ("how many stones show?" is the children's bet); the River Meadow is a lake with reeds; frogs; wild garlic along the lane; the first hazel catkins are long gone; the hum-stone is warm in the afternoon.
- **Work:** First Furrow; sowing oats and clover on the Tops' lower fields; lambing on the Tops (Tom is up all night); hens start to lay again; Odinson hammers ploughshares; the cobbler has a queue (spring mud).
- **Market:** eggs are cheap, flour is dear (the winter store is gone), seed is the thing; the seed seller's corner is busiest. Season prices in the game: list price (`rules/52-season-prices.json`: craft 1.1, textile 1.05).
- **Weather:** rain, flood, mud on the Moonedge road; the Lord's Mile is the only dry road.
- **Village:** everyone airs the house; Hilde hangs everything out; the school windows open; Ines's yearly war with the draught.
- **Festivals:** **First Furrow** (the village ploughs one strip together first, for whoever cannot, a widow or a sick man; nothing is said, the plough just goes there; "the first furrow is for somebody else") and **Hatching Day** (first warm Marketday): eggs dyed yellow with onion skins and red with beet, an egg roll down the slope below the Hall, a pancake toss by the bakery; the winner of the toss gets to name the next calf. Game links: `yellow_dye` (onion), `red_dye` (beet), `pancakes`, `omelette`, `egg` (65).
- **Share day:** the end of spring: **Share Day** (see 4.2).
- **Gossip theme:** who survived the winter; who is expecting; what the flood took.
- **Foods:** wild garlic with flatbread, pancakes, eggs every way, `veg_soup`, `roast_carrots` from the stored root cellar.

### 3.2 Summer (n mod 4 = 1)

- **Land:** the Hazel falls; the Pool drops a hand's breadth a week; herons at the Landing; the river is low and the barge touches bottom at one bend (Mei curses it, creatively); the forest edge smells of warm resin; flowers for the bees; elder and chamomile in the forest.
- **Work:** hay on the Tops and in every meadow; peas and berries; the long light means the Quarry whistle goes later; Otto's ferry is busy with the quarry folk; the Landing is hot.
- **Market:** vegetables glut (game: `crop` 0.92 in summer) so the price of a carrot goes down while dishes are up (1.05); the seed seller is quiet; Mistress Appleby's second oven is too hot to use after nine.
- **Weather:** the **Dry Watch**: in a dry summer every household keeps a full bucket by the door from the first hot week to the first rain. Hay is tinder and everyone says so. "When the Hazel sings low, fill the buckets."
- **Festivals:** **Floating Lights** (the first warm night once the year's lamps are ready, usually early summer, but not tied to a date, so the engine's `done:sq_lamp_maker` can fire it in any season; a fun night, not a rite): paper boats with a candle stub are set on the Alder at the Landing; each carries a wish for someone on the river (a sailor, a mother in Weir); Ferdinand's finest lamps hang on the Landing House; Rosa plays; the children are allowed up late. A flame on water cannot spread; people say so out loud, which is the point. **Bucket Night** (the last evening before the dry month breaks, or the last evening of summer if it never does; Maud alone at first, then the village): see 4.1.
- **Share day:** the end of summer, often on the first rain.
- **Gossip theme:** will it rain? who left the lantern in the barn? (in the Dry Watch everybody is a little afraid of everybody else's lantern).
- **Foods:** `garden_salad`, `garden_platter`, `berry_cake` if there is sugar, `yogurt_bowl`, `jam`, `pickles` starting; cold `tomato_soup`.

### 3.3 Autumn (n mod 4 = 2)

- **Land:** the Alder breathes out a fog ("Alder breath") on windless mornings and the village is an island until ten; the hazel nuts fall; apples; leaves along the Lord's Mile; swallows leave the Hall roof.
- **Work:** harvest; threshing in the barns (Moonedge's barn used to host the valley's threshing); the press at Three Oaks; hazelnut gathering; charcoal burning in the clearing; the Lord's men count sacks at the Weigh House.
- **Market:** the busiest; crops 0.95, ingredients 1.05, craft 1.05 in the game; everyone sells and the market "forgets" slowly (the eighth-loaf rule in `foodways-and-trades.md`).
- **Weather:** fog, then wind, then the first frost; the Hop is dry; the Tops' sheep come down.
- **Festivals:** **Nut Week** (the week the nuts fall): the village gathers nuts together on the Lord's nut wood (a Lord's right waived for the week by old custom) and the first nut is thrown over the Hall roof by the youngest child who can reach; whoever finds it keeps it as a luck-nut; **Cider Night** (the last night of the pressing, a dance in the Hall yard, Rosa on the fiddle): mugs on every table, one extra, the **Late Mug**, set for whoever comes last; cider is `cider` (apple_juice, fermenter); the shipped dance (`c3_dance`) is this; the **Harvest Fair** is separate (see 4.4); the **Grey Barge** at the quarter-end (see 4.2).
- **Share day:** the end of autumn, the biggest: the whole year's rent is weighed at the Weigh House.
- **Gossip theme:** who had a good harvest; who is courting after the dance; what the Count's barge carried.
- **Foods:** `apple_pie`, `apple_crumble`, `pumpkin_soup`, `pumpkin_pie`, baked potatoes, hazelnut anything, `cider`.

### 3.4 Winter (n mod 4 = 3)

- **Land:** frost on the Pool (children slide, Ines forbids, everyone slides); snow on the Tops; the Landing is slippery and the steps are salted by Tally; the forest is quiet; the stones don't hum less, they hum louder (Vega's notebook); wet sleet most days.
- **Work:** mending (Mending Week); spinning, weaving, carving; the cobbler's second queue; Hilde's hands are red; Otto's ferry sits idle when the river skins with ice.
- **Market:** hungry: crops 1.25, animals 1.1, dishes 1.15, textile 1.1, craft 1.1 in the game ("winter eats what summer sold"); the **Frost Market**, one evening a month after dark: stalls under lanterns on poles with glass hoods (Ferdinand's), chestnuts and hot cider.
- **Weather:** cold, then snow; gales that test roofs and windows (the schoolroom window).
- **Festivals:** **Longnight** (the longest night): see 4.5.
- **Share day:** the end of winter, the thinnest: Pieter sits longest at the soup.
- **Gossip theme:** who is ill; whose roof leaks; which letters came by the last barge before the ice.
- **Foods:** `honey_porridge`, `hearty_stew`, `mashed_potatoes`, `tomato_soup`, `pickles`, `cheese_board`, `bread`, `thyme_syrup` in a sick house.

## 4. The customs that happen in the calendar 💡

Short cards. A longer treatment is in `customs-and-sayings.md`. **Rite cap (revision 2, review F8):** the village has only **five rites** a child can hold and say: **the Open Bowl, the Cup (true things), "Here!", Bucket Night, Hook outside, hay inside**. Everything else on these cards is something people do for fun or habit (an egg roll, a pancake toss, a stool, a saucer) with **no formula, nobody made to**. The word "prayer" appears nowhere.

### 4.1 Bucket Night (later, and uncountable)

- **Origin:** the night of the Moonedge fire the whole village ran to the farm with buckets and made a line from the stream at the foot of the rise (the pond) up to the burning barn, about a hundred paces. They were too late for the barn and the house. The next late summer, at dusk on the day of the fire, **Granny Maud alone** set a bucket of water on the Moonedge gatepost "for the farm to drink", and went on doing it. Hoop the cooper, who made her bucket, nailed a **tin leaf** under its rim; every bucket she has left has that leaf. That is how the player will know one bucket from another (the dented bucket, the childhood bucket, the box's bucket: this one has a tin leaf, every time it is mentioned).
- **At arrival (chapter 1) it is Maud's alone:** a few old buckets by the post, the oldest rusted and the newest bright, never counted in text. One old woman is not a village. The village is *polite and watching* (rung 1).
- **The whole village grows into it.** Only when the farm smokes again and keeps smoking does the village's Chain form: **chapter 3** (E-3.L11), the first summer in which more than Maud turns up; the doorstep buckets, the Chain from Deep to the Hall and back, the bun for the team that spills least. **Chapter 6** reverses it (E-6.L09): the farm leaves a bucket at the Hall.
- **Ansel rings five fast, one slow** (fire, then all well).
- In the morning Maud's bucket is always empty. (Who drinks it is 🔒 for ticket 06: the bunny, the imp, nobody. The village says "the farm drank it". **Not** the farmer's patch: the ch1 turn is that the *bunny* kept the patch alive, and a village bucket must not compete with it.)
- **No counter:** the row of buckets is an object, never a number in text; the player may count, the text never invites it (D11).
- **Seeds:** E-1.L01, E-1.L05 (Maud's bucket), E-3.L11 (the Chain forms), E-6.L09.

### 4.2 Share Day (the end of every season) 💡 and the Grey Barge

- **What:** the Lord's collection. **Pieter** walks the valley with the book, a lantern lit in daylight. Every house puts a **stool** outside so that the man who comes to take can sit while he does it. Nobody says why. A **Share Day soup** (stone soup, with the Soup Stone, 4.6) is served at the Hall at noon on Share Day, so that nobody pays on an empty stomach ("Pay on a full belly"). Pieter is always given the first bowl.
- **At Moonedge** (from chapter 3): Pieter waits at the gate until the share is paid (✅ engine). The village stool habit (no formula, nobody told) gives the shipped `c3_pieter` an extra layer: for the first visits the farm has no stool.
- **The Grey Barge:** at the end of autumn (the biggest quarter) the Count's grey barge ties up at the Landing. The whole village stands on the Landing Steps. Nobody speaks until it rounds the bend. Children are told to **hold their breath** (the Grey Breath); it is a game that everyone loses.
- **Engine:** the share counters (`lord_shares`, `lord_paid`, `lord_owed`), `season:autumn`.
- **Seeds:** E-3.L02, E-3.L03, E-3.L06, E-6.L04.

### 4.3 The Square Pot

- **What:** a big iron pot on a tripod at the corner of the Square, lit on Marketday and every Share Day. Anyone who has something brings it: a carrot, a potato, a handful of beans, a crust, a pinch of salt. The village puts it in. Everyone who comes eats. **Maribel Kettle** keeps the Pot on Marketday (the Pot scene is hers; Marta Hewitt only hands over the Stone). This is **stone soup** in the old sense: the pot always starts with a clean river stone, the **Soup Stone**, which the quarry folk lend to a new household each Share Day ("it is nobody's soup and everybody's"). The stone goes back in somebody's pocket.
- **Why it matters to the farm:** the Pot is the village's way of being poor together. The farmer's first deliveries (porridge, veg soup, stone soup) are really contributions to the Pot, and that is why the village notices them.
- **Game ties:** `d_veg_soup`, `d_stone_soup`, `stone_soup` recipe, `veg_soup`, `hearty_stew`.

### 4.4 The Harvest Fair, called by full tables

- **What:** the grand gathering on the Green behind the Hall. **Four long tables**, each belonging to a trade: **Pie** (orchards and kitchens), **Cheese** (dairy, cellar), **Preserves** (jars), **Cloth** (the weaving table). The game's Fair deliveries are exactly these (`d_fair_pies`, `d_fair_cheese`, `d_fair_preserves`, `d_fair_cloth`).
- **Called by full tables:** Mayor Juno rings the Hall bell three times when the four tables are full "and the apples are down", not on a date. So the Fair comes when Hazelwood has enough, which can be in the engine's autumn, winter, spring or summer, and the season is never a story problem. Small bells answer Ansel's three (that is his favour, `sq_chapel_roof`).
- **The Empty Table:** the Cloth Table was always the Moonedge table (the Keepers wove; the cloth was the farm's pride). At every Fair since the fire the village has laid it with the old Moonedge cloth, folded, and set a stool at the head that nobody sits on. It has become a habit; Juno and Agnes remember why. This is the table the farmer fills (E-6.L01).
- **The thin Fairs:** the last proper Fair was in the slide years. Since then there have been dances, soup and Fairs of only three tables. ("The Fair that only had three tables.") No Fair is ever counted.
- **Order of events** (Juno's scroll, too long): the Bell, the Tables, the Flags, the Players (if any), the Supper, the Dance, and at the end **the roll call**: Mei calls "Moonedge!", the same call Jan has answered alone on Landing Day, and this time the family answers with him (E-6.L10). There is one roll, not two: no Reading of the Names.
- **Seeds:** E-6.L01 (with the three rings folded in), E-6.L03, E-6.L10.

### 4.5 Longnight and the Cup (a rite, optional)

- **What:** the longest night. The village sits in the Hall around the great fire. Anyone who wants to says **a true thing**, one, small, said into the fire or into the room. "I broke Mum's jug." "I'm glad of the bread." "I was afraid of the dark all autumn." Children's are funny; old men's are surprisingly sad. **Nobody is made to.** A true thing is never answered with a word. It is answered with a cup: whoever is nearest passes the speaker something hot, and the fire goes on. ("Say a true thing and pass the cup.") The rite is the Cup; the rest of the night is porridge and noise.
- **Food:** `honey_porridge` with a hidden hazelnut in one bowl (the finder gets the first cup).
- **The farmer and Longnight:** she is invited by Greenstem (E-2.L05), says "I'll do the soup", and ladles for everyone so that she never has to say one. This is the spine in action. A second Longnight (E-4.L09) she says one tiny true thing ("My feet hurt") and is handed a cup. The custom is the rehearsal for the shipped bend (`c6_bend`: "Somebody passes you a cup"). Nothing else in the village is built to receive the confession (review F3: the village does not know what she will say).
- **Engine:** `season:winter`, chapter 2 or later; the piece fires once; the village does it every winter.
- **Seeds:** E-1.L08 (seen from the hill), E-2.L05, E-4.L09.

### 4.6 The Soup Stone and Mending Week

- The **Soup Stone** is a smooth grey river stone the size of a fist with a hollow in it from a thousand ladles. Quarry Row keeps it between Share Days and hands it to a new household each time "so that nobody's pot is the only pot".
- **Mending Week** (the week after Longnight): everyone mends; nothing is bought; the cobbler's queue goes down the Lane; **Boot-share**: in poor households two children share one pair, Linus on school days, Lotte on Marketday. Solemate mends the shared boots free, "one sole for two soles".

## 5. What the village does in each chapter, whether or not you look 💡

The player decides when the chapter starts and ends. The village's life has three parts for every chapter: **the pulse** (where the village is in its year), **the threads** (what individuals are in the middle of), and **the ground** (what the village looks like and what is on the table).

**The stance ladder** (revision 2, review F1; the whole village's stance, one word per chapter, and who breaks it first). It is the shape of the ✅ "the village distrusts the whole family and is poor, and is won by kindness and a turned-around farm". Every seed in the dossier says which rung it sits on.

| Ch | Rung · the village's stance | Who breaks it first | A cold face, and what it costs |
|---|---|---|---|
| 1 | **1 · polite and watching.** They nod; nobody comes up the road. "The Moonedge girl" is pointed at. | Maud (alone), the seller Rue (a stranger), Old Jan (one old man) | none yet; the cold is distance |
| 2 | **2 · curious.** A boy asks questions, Hilde ties a knot, the twins spy. Then the first loaf is chalked. | Greenstem; Hilde | **face (a):** Appleby chalks the farm's first loaf "double" (the Mark for the loaf and the Mark for the name); she needs her sums to balance and the farmer needs the sale; the farmer earns less (E-2.L10). A child says the chalk rhyme to her face (E-2.L11) |
| 3 | **3 · grudging and fair.** The miller's nod; Pieter's stool; the Chain forms for the first time. | the miller; Pieter | **face (b):** the farm's bread sells and Appleby's ninth loaf sits; no one blames her, the farmer pays for it (E-3.L10) |
| 4 | **4 · split.** Quill counts; some in the Pot say "the farm is rich, let it pay", some say "we know that number". | Mayor Juno, who will not choose | **face (c):** the Pot argues; Maud and Appleby stop speaking for a week; the pony's order is chalked in front of everyone (E-4.L11, E-4.L12) |
| 5 | **5 · needs her.** Children first; the village comes to the gate for medicine. | Wren; Greenstem; Lotte's mother | an old grudge turned inside out: she is fed (E-5.L02) |
| 6 | **6 · home.** The half reaches the Pot; the village stands with the farm; the Mark is wiped. | Appleby wipes the first board | the village risks the Lord's displeasure before Quill's paper arrives (E-6.L04) |

**What the village is doing each chapter** (whether or not you look):

| Ch | The pulse (the usual seasons it passes through) | The threads in motion | The ground |
|---|---|---|---|
| **1 Ashes** (about 8 seasons) | two of each season; Maud's bucket; Longnight seen from the hill | the seller's gossip runs; Ella's basket; Maud's goat; Tom is cold; Hilde ties a new knot; the twins start Ghost Patrol; the miller glares; Anna and Ben walk out | the Mark on every loaf; the market is three stalls; the Square Pot is thin; the road is mud; very little hot food reaches the quarry folk |
| **2 Homestead** (about 6 seasons) | a full round of seasons; Hatching Day; Cider Night (small); Longnight with the farmer in the kitchen | Baby Lena is born; Jan is ill; Otto begins the bridge; Wren is first seen; Ginger roams; the first letters; the first chalked loaf | the road gets gravel; the Pot has a regular pot of stone soup; the Wagon Players pass without stopping |
| **3 Smallholding** (about 7.5 seasons) | the first share at the gate; the first Chain; the first real Cider Night; the grey barge | Pieter's visits; Anna and Ben engaged; the miller's wheel turns again; Rosa loses a tune; the school window cracks in a gale | the market is bigger; Marketday has a second corner; the Hall roof leaks over Ansel's bell |
| **4 Village Trade** (about 6.5 seasons) | builders on the farm; the wedding; the Wall at night | Quill counts; the gardener sneaks grafts; Mei's long voyage; the Pot divides | road trees; Marketday doubles; the Pot has pizza |
| **5 Healing** (about 2 seasons, any season) | a cough that goes house to house, children first | the Pot is never empty; the school half-closes; Wren is stretched across two valleys; Ferdinand's lamp; the Lord's red seal comes up the road | the village is tired and does not complain; bowls go up the road to the farm |
| **6 Master Farm** (about 5.5 seasons) | the Fair is called; the Players come; the family comes up the Landing Steps | the half is announced (shipped `c6_lord`) and argued in the Pot; the Mark is wiped; Maud's mercy comes out | flags; the Cloth Table; four tables; free play after |

## 6. Open threads: what the village does if you do nothing 💡

The rule behind every row: **no favour is a deadline and the village never fails because the player is busy**. If the player never touches a thread, the village mends it in its own slow, messy, charming way (the middle column), and the player's later help makes it better and more specific (the right column). No row is a punishment.

| Thread | A. Before the player helps | If ignored, the village... | B. After the player helps |
|---|---|---|---|
| Ella wants the sails | she mends the gearing at night, secretly | rebuilds a sail frame from fence rails in two summers; the sails turn badly | linen canvas sails; the grandfather's face |
| Rosa's lost tune | she has a tune she can't finish | writes a different dance and the Cider Night is merry but without "that bit" | the tune the farmer hums; the Fair reel |
| Tom is cold | he sleeps in the shepherd hut with the dog | learns to whittle a fire-drill; learns he can warm his hands on a lamb | firewood; he nails a horseshoe over the farm door |
| Maud's goat Biscuit | runs off every Millday | gets a bell on a string; Maud follows the bell | the goat is found with a muddy smile |
| The twins' Ghost Patrol | catching "the Bell" at Moonedge | become a regular outing; cheerfully disappointed | porridge, and the jar trap |
| The school window | cracks in a gale | is patched with oiled paper; the room is cold; Ines wears a blanket | glass from the glass kiln |
| Anna and Ben | betrothed at Cider Night | wed at the Hall on a plain Restday with a bread loaf | a three-layer cake and a threshold loaf |
| Baby Lena | born in winter | gets wrapped in six borrowed scarves | the wool blanket; the naming spoon |
| Ferdinand's eyes | he is going blind; the oil is thin | buys cheap oil; his lamps smoke | olive oil; lamps that glow |
| Kit's ode | rhymes everything; wants a word for "orange" | recites to the cat | a rainbow scarf and an audience |
| Lucia's gold | paints in yellow, wants real gold | paints the Fair banners in ochre | saffron paint |
| Sami's well | Deep has dropped; the Plink is long | digs it a little deeper and curses | the well rebuilt; a short plink |
| Vega's telescope | a tube and a lens, no clear glass | draws the stars by hand | a proper telescope |
| The Elders' feast | the elders eat at the Kettle on their own | eat at the Kettle and complain pleasantly | a table with tapenade, soup, bread |
| The Nest's jam | the children eat bread and butter | the cook makes bramble jam in autumn | jam jars and sandwiches |
| Mayor Juno's flags | she sews bunting from old shirts | the Fair has white flags | dyed flags over the Square |
| The Wagon Players | pass through in the spring and don't stop | stay one night in the Hall barn | cheese on the wheel |
| Otto's bridge | he builds one plank a winter | the Footbridge gets finished in six winters | the Footbridge in one |
| Mei's voyage | she carries empty jars | carries a letter for each | jars of pickles |
| Pieter's night watch | the lantern is oil and weak | he has a better one in a good while | the lantern with glass |
| Hilde's line | it snaps | she dries sheets on the hedge | rope line, a wind chime |
| Jan is ill | tomato soup is the cure he can't make | the Kettle sends broth | tomato soup, pink cheeks |
| Bo's gate | he forges nails one at a time | builds the gate from old horseshoes | gate of your nails |
| The cough | winter coughs | passes through every house | the healer's chest; the badger |

## 7. Weather and land, in the village's own words 💡

- **The valley.** Hazel groves on the lower slopes (hence the name), alders along the river, oaks on the ridges, beech toward the forest. Moonedge's soil is stony and warm: moonstones and flints, well drained; "the best wheat in the valley, the worst for the plough". The river flats are heavy clay (Alderbank, the claypits). The Tops are thin grass and wind.
- **The Hazel's moods.** Spring: "a lazy stream that thinks it is a river". Summer: "sings low" (a quiet trickle you can hear from the Hop). Autumn: sleepy. Winter: skinned with ice at the edges.
- **Wild food.** Wild garlic, nettle, sorrel in spring; elderflower and berries in summer; hazelnuts, blackberries, crab apples in autumn; chestnuts at the Frost Market (bought, from the Weir barge); fish: trout in the Hazel, eel and pike in the Alder.
- **Animals the village counts as neighbours.** Herons at the Landing (Otto talks to them), cowbells on the Tops, the swallows on the Hall roof, the Neighbour in the hearth (customs).
- **Weather words a child can repeat:** Alder breath (fog), a Hurst day (windy), a Hop day (flooded), Pieter weather (a lantern could be needed in the daytime: grey and low).

## 8. A bark kit: one-liners the engine can use *(sketches; beats not final text)* 💡

All are `bark` (a bubble you tap away). `chance` between 0.12 and 0.25. A bark never carries a clue.

| # | Trigger | Beat |
|---|---|---|
| B1 | `season:spring + chapter:1 + chance:0.2` | the Hazel is so loud this morning that the hens stop to listen |
| B2 | `season:spring + chance:0.15` | a thin line of smoke far down the valley: Appleby's oven. Somebody is baking |
| B3 | `season:spring + chapter:2 + chance:0.15` | dyed eggshells in the road: yellow, red, a green one that nobody can explain |
| B4 | `season:summer + chance:0.2` | the Quarry whistle, faint: three long, across the water, then everybody on the road below stops for lunch |
| B5 | `season:summer + chance:0.15` | the Hazel sings low; the farmer fills the bucket and looks at the sky |
| B6 | `season:summer + chapter:3 + chance:0.15` | a heron stands in the Pool and looks at the wheel as if it owes him money |
| B7 | `season:autumn + chance:0.2` | a hazelnut hits the roof; then another; then a squirrel's opinion |
| B8 | `season:autumn + chance:0.15` | Alder breath: the village is an island of chimneys; a cow bell sounds from nowhere |
| B9 | `season:autumn + lord_shares>=3 + chance:0.12` | far below, a grey sail; no one is waving |
| B10 | `season:winter + chance:0.2` | a boot-print in the frost, two sizes: someone small in someone else's boots |
| B11 | `season:winter + chance:0.15` | the Hall bell, nine slow, very faint; the lights go out one by one |
| B12 | `season:winter + chapter:2 + chance:0.15` | the sound of fiddle and clapping from a long way off: Longnight practice |
| B13 | `chance:0.12 + chapter:1` | a crust on the fence post. The crust has been eaten at one end |
| B14 | `chapter:1 + done:d_porridge + chance:0.2` | a cart driver: "They say you cooked for forty." (It was one bowl.) |
| B15 | `chapter:1 + done:d_porridge + chance:0.2` | a carter: "They say the burnt farm has a ghost that cooks." |
| B16 | `chapter:2 + chance:0.15` | Old Jan, out of breath on the road with the letter bag, because Mei said there was one: "I carried it, not her" |
| B17 | `chapter:3 + chance:0.15` | a bucket-line rhyme sung by small voices on the road: "Fill, fill, fill the pail..." |
| B18 | `chapter:3 + done:pond + chance:0.15` | children counting under their breath at the village well: "Plink-three!" |
| B19 | `chapter:4 + chance:0.15` | Quill, passing the hens, whispers a number, looks round, and goes on |
| B20 | `chapter:4 + done:road_4 + chance:0.15` | wheel-ruts of two carts that met and neither would back up: both are deep |
| B21 | `chapter:5 + chance:0.15` | a basket of boiled beetroot left on the step, no note |
| B22 | `chapter:5 + chance:0.12` | the school bell rings, then stops; fewer children than yesterday |
| B23 | `chapter:6 + chance:0.15` | a boy rehearsing a poem on the road, loudly, stuck on one line |
| B24 | `chapter:6 + chance:0.15` | someone is humming the farmer's tune on the Road Gate Watch Walk, wrongly |
| B25 | `season:summer + done:pet_alpaca + chance:0.2` | a bucket on the farm's own post, left by someone small, with a note in a child's hand |
| B26 | `chapter:3 + chance:0.12` | the miller shouts at the stream. The stream does not answer. He shouts again |


### Folded in from the seed list (revision 2): these used to be seeds and are now barks

| # | Trigger | Beat | Was |
|---|---|---|---|
| B27 | `after:c1_seller:3` | a washed bowl on the fence with three carrot seeds in a twist of paper and a crust: the first Open Bowl | E-1.L03 |
| B28 | `done:d_porridge + step>=14 + chance:0.2` (three variants, one per hop) | a cart driver says she cooked for forty; a woman says a ghost cooks; Hilde says the girl came back and is thin | E-1.L04, the Three Dresses |
| B29 | `chapter:1 + step>=10 + chance:0.15` | a crust on the fence post, eaten at one end; the bite is not a rabbit's | E-1.L02 |
| B30 | `seen:c1_bell_out + chapter:2 + chance:0.25` | a jam jar with a crust on the gatepost, upside down, with a bunny's opinion of it (Ghost Patrol) | E-2.L07 |
| B31 | `done:sq_washing_line + chance:0.2` | Hilde holds up the Knot-string; there is a knot with the farm's name on it; she unties it | E-2.L04 |
| B32 | `after:c2_letter:3` | Mei, from the road: ninety-one steps down, ninety-two coming up | E-2.L09 |
| B33 | `seen:c3_stream + chance:0.2` | children at the village well counting under their breath: "Plink-three!" | E-3.L01 |
| B34 | `season:winter + chapter:4 + chance:0.2` | the board says winter prices are up; the farmer sold her carrots cheap in the summer | E-4.L10 |
| B35 | `done:sq_baby_blanket + chance:0.25` | a lopsided wooden spoon hung by a cradle among the good ones | E-3.L09 |
| B36 | `done:sq_wedding_cake + chance:0.25` | crumbs of a broken loaf on a doorstep, and a boy putting one under his pillow | E-4.L04 |

## 9. Cautions for whoever writes from this almanac

1. **Don't let the village be too jolly.** It is poor; ✅ the village distrusts the whole family. The festivals are real and warm, but small; there is not enough of anything. The warmth is what people do with not enough.
2. **Don't fix the year (D11).** No text says "in the third spring", "seven years", "nine Fairs" or counts buckets. Customs are *old*; a piece can say "every year", "since the fire", "as long as anyone remembers", but not count.
3. **Fire.** Lanterns, candles and cooking fires are everywhere in this world and the farmer's 🔒 fear of them must be played gently (one beat per festival at most). Floating Lights is deliberately a fire that cannot spread.
4. **Mumyo's bells** are the only small bells that ring by themselves. Cowbells and the Hall bell are big, deep, ordinary; Ella's brass gate bell (a favour gift) rings only in wind.
