# The map and the interface

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 13. The map and the interface

### 13.1 One farm on one screen

The whole farm fits **one iPad screen held upright** (design size 834×1194; the map 834×1000, scaled to fit; nothing
scrolls). It is seen **at an angle, like Hay Day** (2:1 isometric): the ground is a grid of diamond tiles, every place stands
on its **footprint** (a diamond of whole tiles; its front corner is its "feet"), and what stands lower on the screen is drawn in
front. Only a picture's visible pixels react to taps, so a tall roof never steals a tap from the place behind it.

- **The forest** comes in diagonally from the top left (gathering, later the woodlot): its trees stand right on the meadow,
  with no darker forest floor; **the village road** from the top right
  (market stall, book cart, notice board, later the Import Broker).
- **The three fields** stand in a column in the middle, edge to edge; animals and the pond on the left; workshop, bees, barn,
  orchard and greenhouse on the right; compost, scarecrow and broker in the pockets between.
- **The house plot** (2×2) holds the tent, the book box and the campfire until the cottage stands; then the bed, the books and
  the kitchen are inside the house.
- **Pens** are fenced diamonds with no picture of their own; what is built there (a coop, nest boxes, hives, a salt lick)
  stands inside as **add-ons**, so every upgrade shows.
- Where everything stands is data (`data/map_layout.json`), set by dragging in the **layout editor**
  (`godot-prototype/tools/layout-editor.html`; online as *Farm Map Layout*, https://claude.ai/artifact/U7XSKLW8GcAacyAx1Uh7uV).

### 13.2 Ruins, mysteries and "only what you can do now"

- Places not built yet are **ruins**: the outline of walls, broken stone or wood pieces, rubble, bare earth; pens show broken
  posts. Some must be cleared before building (§9.3).
- A locked place with nothing within reach shows only a weathered sign: *Something stood here once… You will find out what
  belongs here later — when you have what it needs.*
- **No sheet shows anything beyond the current chapter**, and a place's sheet shows what can be done there now; the quest book
  keeps the chapter's "coming up".

### 13.2b What is shown when

Every system runs from the start; **what the child sees comes later** ([ADR-0009](../adr/0009-systems-run-hidden-then-reveal.md)). Per system it
was chosen whether it works unexplained until then, is frozen, or does not exist yet. Buttons and icons of the top bar can be given a rule in
`data/farm/rules/60-reveal.json` (conditions such as `coins>=1`, `chapter>=2`, `packed>=1`, `skill_ranks>=1`, `story_seen>=1`, `done:<node>`,
`seen:<element>`; `when` = all must hold, `whenAny` = one is enough). When the rule first holds, the thing appears for good with a small hop
and a note (*New: …*); a farm that is loaded counts what it already has as shown. An element without a rule is always there. Other systems
are gated by their own data (a chapter, a card, a building), as the table says.

| System | Before it is shown | Shown when |
|---|---|---|
| 🟤 The purse (coins) | hidden | the first coin (`reveal.coins`) |
| 🖼️ The album button | hidden | the first picture in the album or the first skill rank (`reveal.album`) |
| 🎒 The bag, item weight and carrying | weights work unexplained (they limit nothing at home) | the first packed thing or the first trip (`reveal.bag`) |
| 📜 The story scroll | hidden | the first story piece read (`reveal.scroll`) |
| Wellbeing and the energy drain | frozen at "fine" (0.5), no drain, no boost | chapter 2: the face appears at the end of the energy bar (`reveal.face`); the dashboard's rows open one by one with the cards of *Body and mind* |
| The bed's energy | shown plainly from chapter 1 ("+1 ⚡ per right sum"); that it goes through *sleep* is never said | – |
| Happy boost from helping | frozen until chapter 2, then works: it shows only in the energy change after the quiz and the dashboard's *⚡ each question* line | the card *Friends* (*Body and mind*) says that helping feels good |
| Sustainability (the forest edge's pools and trees) | works from the start, unexplained: a tap gives less when its pool is low, and a short advice says so the first time | the card *Take only what grows back* (chapter 2): bars and 🌲🪵🌱 in the forest edge's window |
| Soil rest (crop rotation) | – | from the start: a planted patch's window says *😴 Tired soil* or *💚 Rested soil*; the card *Crop rotation* (chapter 2) explains it |
| Market prices changing | work from the first change of season | the news line at each change of season |
| Merchant trust and the village's reputation | work from the start | the first trip: the square shows ♥ for the village and hearts beside each trader |
| Skills and practice | work unexplained (practice counts from the first batch) | the first rank-up (`reveal.skills`): the album lists the skills, a station's card shows its rank |
| The Lord's share | does not exist (nothing is owed) | chapter 3: the end of the first season, Pieter at the gate |
| The forest screen | does not exist, not even visible | chapter 5: the cleared still-room opens it from the forest edge's window |
| Workshop corners (benches, kiln & forge, loom, tools) *(built)* | not drawn in the workshop window | something of the corner is built or can be built now (the workbench; the kiln or forge, from chapter 2; the hand loom, spinning wheel or dye vat, from chapter 3; the tool rack, whetstone or shears) |

**The first screen** (a new game): the water and energy bars (with the 😴 Rest icon), the season bar with the question count, the next goal,
📖 the quest book, ⚙️ settings, the Time Quiz clock; the farm with its ruins, the tent, the one cleared patch, the workbench, the market stall and
the board, each with a 🔨 when there is something to do. The purse, the bag, the scroll, the album and the face wait for their rule above.

### 13.3 Screens

- **Top bar** (it fits every iPad width from 744 px): the purse (coin pictures stacked: 💎 from 1000 gold, gold, bronze); 💧 water and ⚡ energy
  as rows of cubes (tap water to fetch, energy to Rest); right under them the season row, as wide as the bars (one stripe per question, in the
  season's colour, then the questions left and the next season); **the next story goal** across the whole middle, only its symbol and name, the
  text as big as fits (tap: its place glows; what it needs is on its place's sheet); chapter and question number are in ⚙️ Settings, not in the bar
  (interface-feel/06); 🎒 pantry, 📖 quest book, 📜 the story scroll, 🖼️ album, ⚙️ settings; from chapter 2 the farmer's face at the end of the energy bar (it opens the wellbeing dashboard); and the **Time Quiz clock** hanging from the bar's right end (its hour hand goes once
  round per season; tapped, the quiz opens). There is **no bottom bar**: the map runs to the bottom edge. Some of these appear only when
  they matter (§13.2b).
- **Notifications** look like a phone's: small cards stacked under the top bar, each with its own time (a hint goes sooner than news); a swipe
  sideways sends one away; taps outside the cards go through to the farm.
- **Testing buttons** (⏩ Cheat, 🪙 +50 bronze, 🎓 Quizzes) float at the top left only when a grown-up switches them on (⚙️ Settings, grown-up part; a device setting). They start off (`"showCheatButton": false` in `data/settings.json`); a device that already saved its choice keeps it.
- **Tap a place → a sheet slides up** with a picture on top and everything to do there: build, stations and recipes, animals,
  polish. Everything with a button is a **tile in a grid** (like the store and the market): a picture or emoji, the name,
  what it gives and costs, and its button at the bottom, as wide as the tile — recipes, crops to plant, weeds and stones on
  a patch, goals and upgrades (two per row), polish, collecting from animals and mucking out, and the knowledge cards.
- **Tap a patch that is still overgrown** and a window opens with a note on top: which patch it is, what is in the way
  (weeds, rocks, stumps, scrub, marsh) and what clears it, or what is needed first. When planting, a cost the player can't
  pay shows its missing cubes hollow (e.g. the water a full patch needs).
- **Buildings with an inside** (house, barn, workshop) open a window over the dimmed farm showing the room as a cutaway; its
  corners (bed · books · kitchen; cellar · crocks · hay · seed library; benches · kiln & forge · spinning · tools) open their own
  sheets. In the workshop a corner is drawn only once something of it is built or can be built now (its row in §13.2b); before that it
  is not there at all, not even as a faded symbol, and a station's "choice slot" names only choices that are built or can be built now.
- **Signs on places:** 🔨 something to build, 🧺 animals ready, ❓ a card quiz, 📖 a card to read, 🍂 stale soon, ⏳ busy, 😴 tired.
- **⬅️ Back to the farm** closes any window.

### 13.4 Pictures instead of words

- No text on the map (place names can be switched on, `showPlaceNames`). Every plant, weed, stone and stump is drawn one by
  one and gets fewer as it is cleared; patch upgrades appear in the gaps between the patches, the fence round the field.
- **Amounts are cubes** in the item's colour, **one cube for one** (no "×5" label, interface-feel/05): up to 10 in a row (20 when there is
  room), then rows of 10, and beyond 100 the bar grows in both directions (200 = 20 × 10) with smaller cubes, so it fits any width from
  744 px; the top bar's water and energy keep their height. Coin costs count by the coin: a cube per bronze under a gold, per gold from
  a gold, per diamond from a diamond, with the sum in words. **Costs** show filled cubes for what you
  have, hollow for what is missing, faint grey for what upgrades save — every upgrade is seen shrinking the bar.
- **Waiting is an hourglass:** a grey ⏳ with the questions still to wait; tapping it opens the Time Quiz.
- **Things fly** to the store, one picture per piece; what does not fit bounces off (🚫).
- **Buttons** carry an emoji and one word (💪 gather, 🌱 plant, 🧺 harvest, 🪓 wood, 🤏 fine work, 🔨 build, 🍲 cook, 🔪 prepare,
  ⚙️ mill, 🫙 press, 🧶 textiles).
- **Tap a bar** (season, growing, weeds, stones, pages, steps, polish, pests, seeds, store) for a one-line explanation.
- **Celebrations** for new buildings, tools, gear and helpers (§11.5); after the quiz the farm plays what changed (§4.1).

### 13.5 The farmer

A little farmer walks to wherever the player taps — on the grass, to a place (its sheet opens at once), to the edge of a field —
and finds the way round buildings, pens, ponds and fields; tapped, it waves and hops. It is a small 3D figure made of simple
shapes, toon-shaded and drawn into the 2D map (`kits/avatar/avatar.gd`); its look is data (`data/avatar.json`: skin, hair, shirt,
trousers, shoes, hat). After each action the farmer goes there and acts it out — kneels and pulls weeds, fetches water at
the pond and sows, picks with a basket, chops, hammers, stirs the pot, reads, goes into the tent or house to rest (and comes out when Rest closes), cheers. The game has already
counted the result; the farmer only catches up, and a new tap stops the act at once. Acts, poses and the props in the
farmer's hands are data (`data/acts.json`), so new ones need no code. **(planned)** a "make your farmer" screen at the start, the look kept per player, gear visible on the
farmer, merchants walking about.

### 13.6 For young readers

- **Font:** Andika (SIL), designed for children learning to read; emojis from Noto Color Emoji, the same on every device.
- **Short sentences**, everyday words, one idea per line; numbers whole (§5.8).
- **🔊 Read aloud** for quiz questions and card pages, where the device has a voice: off, a button or by itself (§4.1).
- **Big touch targets**, nothing that punishes slowness (§4.3), nothing that dies or is lost for good.
- The whole game in **English and German** (§4.5).
