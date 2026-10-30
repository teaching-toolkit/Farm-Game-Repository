# Atlas of the valley: Hazelwood, the river and the roads

Slice 02, companion to `dossier.md`. Written 23 Oct 2026; **revised 23 Oct 2026 (revision 2: farm gate, fortnightly Landing Day, fire-night chain, stream start, Mark, trimmed Lord's table, faint sounds)**. Labels: ✅ decided by the parent · 💡 proposed (everything new) · ❓ open · 🔒 hidden from the player. **Convention:** in the tables below a row with no source tag is 💡. Rows that reuse canon say `[canon: file]`. Walking times are for a grown-up with an empty basket ("a farmer's walk"); with a full basket add a quarter, for a child of six multiply by one and a half. Nothing here is player text; it is the ground the other slices stand on.

## 1. The valley in one picture 💡

Standing at the old gatepost of Moonedge with the forest at your back, the road runs away downhill toward the village. The game's map has the forest coming from the top left and the village road from the top right (✅ `world/hazelwood.md`); this atlas does not use compass points, only "toward the forest", "down the road", "across the water", so it can never disagree with the picture.

```
   THE MOONSTONE FOREST (many hours deep; the shell is at its heart)
   .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
   Stone Line (white stones in a ragged row: where the Lord's maps stop)
        Ribbon Oak (15 min)            THE TOPS  (sheep; Tom)  . . . . . .
           |                                     |  (35 min across the spur)
      [ MOONEDGE ] farm                          |            HURST MANOR
       |  \  old windmill on the spur            |            (15 min up Hurst Road)
       |   River Meadow (marsh, the "night garden")                |
       |      \                                                    |
       |   the Hop (stepping stones, 12 min)                       |
       |        \_ Crossroads Stone (18 min) -- Saddle Road --> LINDEN DALE (Wren)
       |                 \                                         |
       |                  Road Gate (30 min) --- THE SQUARE: Deep (well), Hall, board,
       |                                           Mother Hazel, bakery, Kettle
       |                                     /        |           \
       |                          Mill Bridge      Lantern Lane    Hurst Gate
       |                          the Millward's Mill     (lamp-maker)
       |                          Washing Stones
       |                          Otto's Footbridge
       |                                \
       |                           Landing Gate -- 91 Landing Steps --> THE LANDING
       |                                                              quay, Stork crane,
       |                                                              Weigh House, Landing House
       |                                                              ferry stage (Otto)
       =====================  THE RIVER ALDER  (flows toward Weir, 3 days down) =========
                                         |  ferry (4 min)
                                   FAR BANK: Quarry Row (15 min) ... the Diggings (1.5 h)
```

**Six sentences for a six-year-old.** Moonedge sits high, with the forest behind it. A stream runs down from the forest, through the farm, across a wet meadow and past the village mill. The village is half an hour down the road. Below the village there is a big slow river, and on the river a landing where the barge ties up. The Lord lives on the hill above the village. Far down the river is a town called Weir, where your mother is.

## 2. Places, one row each 💡

**Rule: a child hears at most ten places named** in the village strand: Moonedge, the Square, the Hall, the Mill, the Hop, the Landing, the Hurst, the forest edge (with the Ribbon Oak and the Stone Line), Weir, the next valley. Everything else in this atlas is for authors, so that every voice sounds from a real place.

Times: **FG** = from the old gatepost ("the farm gate"); **SQ** = from the Square. "Hooks" are the game's own spot keys and node ids (`node-map.md`).

| Place | What it is | FG | SQ | Who is there / sounds and smells | Game hooks |
|---|---|---|---|---|---|
| **Moonedge** [canon] | the farm, on a gentle hillside at the forest edge, Hazel stream below; the first field is full of moonstones | 0 | 32 | wind in the burnt posts; later bread, hens, a mill | all farm spots |
| **Ribbon Oak** | the first big oak, where the forest starts being a forest; hung with faded ribbons; the squirrel's stash | 15 | 47 | ribbons creaking; acorn shells | forest spot `oak`; `tap:forest` |
| **The Stone Line** | a ragged row of white stones just inside the first trees; the old edge of the Lord's maps and the ordinary world | 20 | 50 | the humming starts here, very faint | forest spot `moonstone` is the hum-stone just past it |
| **The Hop** | stepping stones where the Moonedge track crosses the Hazel, at the foot of the River Meadow | 12 | 20 | frogs; floods in spring; the village's quickest way to get wet | `road_*`; replaced by a stone bridge at `road_5` |
| **The River Meadow** [canon: marsh below the farm] | low ground the stream spreads over since it silted; reeds, white flowers at dusk in chapter 6 | 8 | 24 | frogs, midges, a tiny light at night 🔒 | `tap:marsh`, `river_meadow_drain` |
| **Crossroads Stone** | a milestone leaning on its elbow where the Saddle Road leaves the village road; a bench, "Tinker's Rest" | 18 | 14 | tinkers, Wren on her way | none |
| **Road Gate** | the west gate in the village wall; Granny Maud's cottage is at Lane's End just inside | 30 | 3 | goat Biscuit; knitting needles; broth | – |
| **The Square** | cobbled patch, the well **Deep**, the Mother Hazel (a huge old hazel), notice board on the Hall steps, bakery, Kettle, market stalls on Marketday | 32 | 0 | chatter; bread by dawn; Hall bell; board | `tap:board`, `tap:market`, `market` |
| **The Hall** | the village hall: bell tower (Ansel), schoolroom in the side wing (Ines), meeting room, yard for the dance; ✅ no chapel | 32 | 1 | bell; slates scratching | `sq_chapel_roof` (to become the Hall roof) |
| **Millward's Mill** | water mill with a wheel on the stream side and a small windcap with sails on the roof (see 4.4) | 35 | 3 | wheel groan (when the stream runs); flour dust | `ruins_windmill` is the *farm's* old mill, not this one |
| **Mill Bridge** | the small stone hump bridge by the mill where the miller stands to glare at the water | 35 | 3 | the Pool: still water above the wheel | shipped `c3_stream`, `c3_miller` |
| **Odinson smithy** | by the Mill Bridge (quench water) | 35 | 4 | hammer rhythm, the quench hiss | `forge`, `anvil` stories |
| **Washing Stones** | flat stones on the Hazel below the mill; the gossip exchange | 37 | 6 | slap of wet cloth, laughter, Hilde | `sq_washing_line` |
| **Otto's Footbridge** [canon: `sq_bridge`] | plank bridge over the last stretch of the Hazel, just above where it joins the Alder; the village's way to the Landing for people with feet | 40 | 9 | planks that talk | `sq_bridge` |
| **Lantern Lane** | a crooked lane off the Square; Ferdinand's workshop; windows full of lamps | 33 | 2 | glass chinks | `sq_lamp_maker` |
| **The Nest** (the orphanage) | the orphanage by the Landing Gate; 11 children | 36 | 4 | many boots on stairs | `sq_orphanage_jam` |
| **Hurst Gate / Hurst Road** | north-east gate and the steep road up to the manor | 36 | 4 | carts of the Lord's | – |
| **Hurst Manor** [canon: the manor on the hill above] | grey stone, one tall chimney that smokes always; the Lord, Quill's office, the kitchens | 51 | 19 | a gong for dinner; hounds | Quill, Pieter |
| **The Old Beacon** | a ruined signal tower on the hilltop beyond the manor; Vega's roof | 70 | 38 | wind; a brass telescope | `sq_telescope` |
| **The Tops** | high sheep pasture; Highfold farm's shepherd hut | 35 across the spur | 40 | wind, bells of sheep, Tom's dog | `sq_cold_shepherd` |
| **Landing Gate** | south gate; the top of the Landing Steps | 36 | 4 | smell of river | – |
| **The Landing** [canon: C15 asks for it] | stone quay on the Alder: the Stork (a crane), the Weigh House (the Lord's toll hut), Landing House (inn and warehouse), ferry stage | 46 | 12 | herons, ropes, Mei's voice | letters, jars, flax |
| **Far Bank** | across the water; **Quarry Row** (stone folk, 15 min from the ferry) and the Diggings (small mine, 1.5 h) | – | 30 | noon whistle, three long | stone/iron merchants |
| **Linden Dale** | the next valley, Wren's; reached over the **Tinker's Saddle** | 110 | 100 | lime trees, bees, drying herbs | `sq_healer_*` |
| **Weir** [canon] | river town, three days down by barge, five days back up; Fenna's parents live there | – | – | – | letters |
| **Greywater** 💡 | the Count's seat, three days beyond Weir; **bible only: the Count's name and seat never appear in a player text** (digest gap Q9 is a gap, not a licence); ❓ for ticket 07 | – | – | – | the Grey Barge |
| **The coast** [canon] | flax, spice; eight days | – | – | – | `spice_1`, `present_flax` |

## 3. The routes that matter 💡

| Journey | Time | Note |
|---|---|---|
| Farm gate to the Square | **30 min** to the wall, 32 to the bread ✅ (half an hour down the road) | uphill home it is 36; with a full basket 45 |
| Square to the Landing | 12 min down, 16 up | 91 steps down, "92 going up" (a saying) |
| Moonedge to the Landing, the quickest way | 46 min | the Hop, the road, the Landing Gate, the steps |
| Moonedge to Wren's door | 1 h 50 | Crossroads Stone, the Saddle (an hour), then down into the dale |
| Moonedge to the Ribbon Oak | 15 min | |
| Moonedge to the hum-stone (forest spot `moonstone`) | 50 min | |
| Moonedge to the shell | "half a day beyond the last stone, and nobody timed the way back" 🔒 | the player never goes (✅); seen once from far (`c5_conch`) |
| Landing to Weir by barge | **3 days** down (two nights moored), **5 days** up (towed by two horses along the towpath) | Landing Day is **fortnightly** (see 4.5); a letter's round trip is about a month |
| Landing to Weir by road | 4 days by cart, bad road | the Lord's carts use it |
| Weir to Greywater | 3 days more | |
| A rumour, Washing Stones to the Hurst kitchen | an hour | see `gossip.md` |
| A rumour, Hazelwood to Weir | it waits for the barge (up to a fortnight), then three days down; always late and always kinder | |

## 4. Water, the river and the Landing (ticket 02's job: C15) 💡

### 4.1 The reconciliation in one paragraph

`world/hazelwood.md` has a stream, a footbridge and a ferry "with a pole"; the shipped letters and `c4_mei` want a barge. All four fit if there are **two waters**. The **Hazel** is the stream (forest, farm, River Meadow, the Hop, the mill, the Washing Stones, the Footbridge). The **Alder** is the river, a slow brown river below the village, deep enough for a barge, too wide for a bridge, crossed by Otto's pole ferry. Where the Hazel ends in the Alder, the **Landing** was built. Mei's barge ties up there. Nothing in `world/hazelwood.md` has to be deleted; it needs one added line (the Alder) and one changed word ("a ferry across the Alder").

A small and nice oddity: the Moonedge family always called the Hazel "the river" (it was wider and louder before the pond was drained). That is why the marsh is the **River Meadow** in Berit's book. Everyone else says "the Hazel" for the stream and "the river" for the Alder. This is for the book's pages and authors; a text a six-year-old hears tells it once, in one line, or not at all.

### 4.2 The water, in order

| Water | What | Who uses it |
|---|---|---|
| **Moonedge spring and pond** [canon: drained in the slide, `pond` node] | the farm's reservoir, fed by the Hazel's thread from the Head in the forest (the stream starts at the Head, 12 minutes into the trees; the pond is where it pooled at Moonedge); the tortoise sits where the spring first rose | the farm; the Plink (the well) follows it |
| **The Hazel** | stream; "a lazy stream that thinks it is a river in spring" (saying) | farm, mill, washing |
| **The River Meadow** | the stream spreads over the low ground since it silted; reeds, marsh | the night garden 🔒 |
| **The Pool** | the millpond above Millward's Mill | the miller, ducks, Duchess the goose |
| **The Alder** | river, brown and slow; eels, pike, herons | the barge, the ferry, the Landing |
| **Deep** | the well in the Square, 23 steps of rope | everybody, and the Plink gauge (customs) |

### 4.3 Crossings

| Crossing | Where | Who/what | Game tie |
|---|---|---|---|
| **The Hop** | foot of the River Meadow | stepping stones; a plank for carts in summer | becomes the stone bridge at `road_5` |
| **Mill Bridge** | by the mill | stone hump; the miller's glaring-place | `c3_stream` nod, `c3_miller` bark |
| **Otto's Footbridge** | the Hazel's last stretch | planks; Otto's favour | `sq_bridge` |
| **The ferry (the Hush)** | across the Alder, Landing to Far Bank | Otto poles it; no talking on the water (a custom); **how the family left:** by night they crossed to the Far Bank to avoid the toll men at the Landing and took the Far Bank road to the quarry stage, where a downriver barge takes passengers (one line, if needed) | the quarry folk and the Diggings come this way |
| **The great bridge** | at Weir | the only bridge on the Alder | – |

### 4.4 Millward's Mill: wheel and sails 💡 (❓ open question: the mill type)

The shipped pieces disagree: `c3_miller` and the silted stream mean a *wheel*; `c6_free_miller` has *sails* turning "as they did before the fire". Proposal: one building with both. A water wheel on the stream side (stopped since the stream silted), and on the roof a small windcap with four sails that the miller's father built for dry years, which stand bare because the canvas rotted when there was no grain to grind. The old miller, **Grandfather Millward** (88), built the sails as a boy. The wheel turns again in chapter 3 (the stream runs, the nod); the sails turn in chapter 6 (flour, and linen for the canvas, from the farm). Both stories stay true. The farm's own windmill (`windmill_1`, built on the old Moonedge mill at the spur) is a different building: the *Little Mill*.

### 4.5 The Landing, drawn 💡 (answers C15)

- **The quay:** a stone wall along the Alder, forty paces long, with iron rings. **The Stork** is the wooden crane that lifts bales, grey with age, one leg longer than the other.
- **The Landing Steps:** 91 steps from the Landing Gate down to the quay, for feet. Carts use the **Cart Ramp**, a long slope that curves round the hill; it is the Lord's Mile's last stretch. Everyone takes the steps.
- **The Weigh House:** the Lord's toll hut. Every sack, bale and barrel that goes on or off a boat is weighed and chalk-marked. The tollman is **Tally**.
- **Landing House:** inn on the upper floor, warehouse below, kept by **Mistress Quay**. The letter bag hangs on a hook by its door.
- **The ferry stage:** a wooden jetty at the downstream end where Otto's pole-ferry the *Hush* ties up.
- **The barge:** Mei's **Nimble** (the slowest boat on the Alder; "I named her so she'd have something to live up to"), 18 paces long, a deckhouse, a stove, two tow horses (**Pudding** and **Prudence**) that walk the towpath upriver. A second, grey barge belongs to the Count (see 4.6).
- **Landing Day:** **every second sixth-day**. One barge cannot be everywhere: three days down, five days up (towed), two days to load and rest, so *Nimble* is at the Landing once a fortnight and a letter's round trip is about a month (`sq_long_voyage` is the long run, with a full hold). It is the news day. Mei calls the letters from the middle of the Landing Steps, name by name, and each person shouts "Here!" Children go for the show. **Letters for Moonedge:** the first one Mei carries up the hill herself, because Jan will not stop asking (E-2.L01); after that the letter bag waits at Landing House and Jan or a child carries it up; by the cobbled road (`road_4`) the farmer asks to be called at the Landing "like everyone" (E-4.L07). Sounds heard from the farm (the noon whistle, the bell) are **faint**, never "the sound you hear".

### 4.6 What the river carries 💡

| Up (to Hazelwood) | Down (from Hazelwood) |
|---|---|
| salt, in grey blocks | hazelnuts, in sacks |
| iron bar, tools, nails | cheese, wool, honey (when there is any) |
| coast flax and spice, glass sand later | charcoal, stone from Quarry Row |
| barge flour (grey, dear) | timber, hides |
| paper, ink, newsprint ballads | letters, jars, and the Lord's money |

The Lord's money goes **down**. Every quarter-end the Count's **Grey Barge** ties up at the Landing (a barge with a plain grey sail and no name painted on it). Pieter and Quill (from chapter 4) load it. It is the one thing the whole village watches in silence (customs: the Grey Breath). "Coins swim down, goods float up" (a saying). This is physical geography only; what the Count wants, and why, is ticket 07's.

## 5. Inside the wall 💡

Hazelwood is **31 households** inside a low, old wall with three gates, plus about nine farms and cottages outside it, so roughly **140 people** (and Quarry Row across the water, 60 more). The wall is mostly knee-high and used as a bench, but it has a short **Watch Walk** at Road Gate where a person can stand and see up the valley to the dark of the River Meadow. That is where Pieter stands at night (`sq_night_watch`, "on the town wall").

| Street | Households and shops |
|---|---|
| **The Square** | the Hall; Appleby's bakery (Lucia lodges above it); the Kettle (inn, tea room); Mother Thyme's herb stall at the market corner; Solemate's cobbler; the Pocket Stall's spot; Deep; the Mother Hazel; the notice board |
| **Mill Lane** | Millward's Mill; Odinson smithy; the Washing Stones below; Old Jan's tied cottage |
| **Lantern Lane** | Ferdinand's lamp workshop; Rosa's seamstress room; the Reeds' cottage |
| **Lane's End** | Granny Maud, Biscuit's paddock; Road Gate |
| **Hurst Gate side** | Mayor Juno's house (flag-pole in the garden); the school children's slate yard; Ines's room |
| **Landing Gate side** | the Nest; the cooper; Sami's mason yard |
| **The Landing** | Quay, Tally, Otto's hut, the eelmen |

Plus the outliers: **Highfold** (sheep, the Tops), **Cressbrook** (dairy and watercress, downstream of the Meadow), **Three Oaks** (orchard), **Alderbank** (market garden on the river flat), **the Burners' clearing** (charcoal, at the forest edge twenty minutes from Moonedge). Names and people in `people.md`.

## 6. Hurst Manor and the Lord's reach 💡

**Hurst Manor** (the locals say "the Hurst"). The manor name was ❓ in `world/hazelwood.md`; *hurst* is an old word for a wooded hill. Grey stone, one tall chimney that smokes in all weathers, kitchens, a walled garden (Thorne's), a steward's office with a window facing the village, a long drive. The Lord is never seen on the road. The Hurst Road from the Square is steep and was widened in the slide years for the Lord's timber carts (the pony's work, `world/00-timeline.md` Y−5). The village calls the best bit, from the Hurst Gate to the Landing by the Cart Ramp, **the Lord's Mile**: "the only road in the valley that has never met a puddle". When the player's road reaches cobbles and trees (`road_4`, `road_4b`) it becomes finer than the Lord's Mile, and the village notices.

The Lord's reach, trimmed (revision 2). **Only two things ever need to be in a text: the chalk mark and the share.** The rest is bible, never said to the player.

| What | How it reaches | Text? |
|---|---|---|
| The farms | a lease with a share of what the land gives ("the farm pays the Lord") | the share only (ticket 07) |
| **The Moonedge Mark** 💡 | a chalk mark on every loaf, sack and crossing "for the farm that burnt": a **fixed grievance since the fire, not a meter**; unchanged by what the farm pays; ended in chapter 6 as a village act (ticket 07 confirms how the Lord's accounts allow it) | yes: "Since the fire, every loaf in Hazelwood gets a chalk mark for the farm that burnt. Nobody likes it." |
| tolls on the mill, the ferry, the oven and the market stalls | small payments chalked at the Weigh House or the counter | bible only |
| the forest edge | the Lord's maps stop at the Stone Line; inside it "belongs to the moon" | a saying only |
| the Far Bank quarry and the Diggings | licences | bible only |

## 7. The forest edge and the way in 💡 (chapter 5's forest screen)

The forest spots in `rules/57-forest.json` get a place and a time from the farm gate. In the game every trip costs one step in and one out; these times are for what the text may say.

| Spot (game id) | Name 💡 | Time from FG | What the place is |
|---|---|---|---|
| `hedge` | the Hedge Walk | 5 | elder and hawthorn along the old field edge |
| `meadow` | the Hay Meadow | 10 | a small clearing the family once mowed |
| `stream` | the Head | 12 | where the Hazel starts: a thread of water; peppermint; clay in the bank |
| `oak` | the Ribbon Oak | 15 | wishes on ribbons; the squirrel |
| `glade` | the Chamomile Glade | 25 | a ring of white flowers in a sun-hole |
| `willow` | the Water Willow | 30 | a pool and a willow |
| `clearing` | the Wide Clearing | 40 | from its north edge a white shine can be seen through the leaves (`c5_conch`) |
| `moonstone` | the Hum-stone | 50 | a white stone, hand-warm, humming |
| `floor` | the Deep Floor | 60 | ferns and leaf-mould; the last spot the game shows |

The **Burners' clearing** (charcoal burners, **Old Cole and Mistress Cole**) is twenty minutes along the edge from Moonedge on the village side. They are the only people who live near enough to have watched the ruin all that time. They are very quiet and want nothing (a red herring and a kindness; see dossier).

## 8. Moonedge as it was and is, relative to the game's spots 💡

For writers who need to say "where is the compost from the house" without a map. Paces are a child's.

- **The house** (`home`) stood on the rise, facing down the valley; its back to the barn yard.
- **The barn** (`barn`) 40 paces from the house, across the yard, hay corner at the north end. The iron hook (shipped `c2_hook`) was found in the barn frame.
- **The workshop** (`workshop`): beside the barn; the ruined workshop is where the burnt ledger was.
- **The well** (`well`): between house and barn, on the yard's edge.
- **The coop** (`coop`) and cows (`cows`): against the barn's long wall; sheep (`sheep`) on the lower slope.
- **The compost corner** (`compost`): behind the barn, squared with flat stones (shipped `c2_compost`).
- **The pond** (`pond`): at the foot of the rise, the spring; the tortoise's spot.
- **The orchard** (`orchard`): the sheltered side, toward the Hop.
- **The old windmill** (`windmill`) on the spur, four minutes uphill: "the Little Mill".
- **The still-room** is behind the kitchen (shipped `c5_cough`).
- **The greenhouse** (`greenhouse`): south-facing, near the orchard; the old glasshouse where the lease tin was.
- **The woodlot** (`lumber`): the cut forest edge, stumps.
- **The first field** (`field`): moonstones; the one green patch where the bunny sits.
- **The notice board** (`board`) and **Market** (`market`): the player's UI lives in the village; the farmer walks there (shipped `c1_board`: "keep your hat low").
- **The old gate** has no gate left, only a post: the post where Maud's buckets stand (dossier E-1.L01).
- **The fire-night chain** ran from the stream at the foot of the rise (the pond) up to the barn, about a hundred paces, which a village of 140 can fill with buckets. The Hop is where Otto saw the sooty child at dawn; it is not where the chain stood.

## 9. How the map grows: the road is Hazelwood's progress 💡

`world/hazelwood.md` already says the road tiers are the road to Hazelwood. Here is what each tier means at the village end.

| Road tier (node) | Who can now come | What the village gains |
|---|---|---|
| Muddy track | only people on foot | the seller with a pack |
| `road_1b` brushwood | handcarts | the Coles' charcoal sacks reach the farm |
| `road_2` potholes filled | a seed cart | the seed seller's cart; the book cart |
| `road_3` gravel | the gate merchant; Lark | Lark (shipped `c2_lark`); Farthing's wagon |
| `road_4` cobbles | carts both ways | Marketday doubles; Mistress Leaven opens her shop |
| `road_4b` trees | shade, and a bench or two | the lime avenue; Marketday gets a second bakery cart |
| `road_5` paved and a bridge | wagons, travellers, the Players | the stone bridge replaces the Hop; Minena's Hazelwood |

## 10. Edits needed in live canon at the integration ticket (not made here) 💡

| File | Change |
|---|---|
| `world/hazelwood.md` | add the Alder, the Landing, Hurst Manor by name, the Mark, the 31 households; say "ferry across the Alder"; resolve the ❓ about the manor's name |
| `world/00-timeline.md` | note that Otto ferried the family across the Alder; no change to dates |
| `characters/hazelwood-people.md` | replace the 11-row recurring table with `people.md` here (or link to it) |
| shipped `c2_letter` | "rows on" becomes "goes back down to her boat"; or accept the Landing Day letter delivery described in the dossier (E-2.L01) |
| `nodes/09-side-quests.json` (data wish) | `sq_chapel_roof` becomes "Fix the Hall roof" |
