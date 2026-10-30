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

### 13.2b What is shown when *(built: the mechanism; planned: most of the schedule)*

The engine runs from the start; **what the child sees comes later.** Every button, bar, icon and number can be given a rule in
`data/farm/rules/60-reveal.json` (conditions such as `coins>=1`, `chapter>=2`, `step>=40`, `done:<node>`, `seen:<element>`; all must hold).
When the rule first holds, the thing appears for good with a small hop and a note (*New: …*); a farm that is loaded counts what it already
has as shown. An element without a rule is always there.

| System | Before it is shown | Shown when |
|---|---|---|
| 🪙 The purse (coins) | hidden *(built)* | the first coin |
| 🖼️ The album button | hidden *(built)* | the first picture in the album |
| Item weight and carrying | works, unexplained (the bag simply fills) | the first market trip |
| Energy drain and wellbeing *(planned)* | frozen | chapter 2 (the face appears) |
| The bed's energy | shown plainly from chapter 1 ("+1 ⚡ per right sum"); that it goes through *sleep* is never said | – |
| Happy boost from helping *(planned)* | works, unexplained | a book explains it |
| Sustainability (forest, water, clay) *(planned)* | frozen | chapter 2–3, through a note in the grandmother's book |
| Market prices changing | works from the first change of season; the news line shows it | the first season with market news |
| Merchant favour and trust *(planned)* | works, unexplained | the merchant says so ("for you, a better price") |
| Skills and practice *(built)* | works, unexplained | the first rank-up (the album then lists them) |
| The Lord's share *(planned)* | does not exist | chapter 2 or 3 |
| The forest screen *(planned)* | does not exist, not even visible | chapter 5 |

**The first screen today** (a new game): the water and energy bars, the season bar with the question count, the next goal, 🎒, 📖, ⚙️, the
Time Quiz clock; the farm with its ruins, the tent, the one cleared patch, the workbench, the market stall and the board, each with a 🔨
when there is something to do. Everything on it is needed for the first jobs, except what 13.2b hides. *(planned with the new chapter 1: the
bag and the book also wait until the first thing is in the bag and the first goal is done.)*

### 13.3 Screens

- **Top bar** (it fits every iPad width from 744 px): 🟤🟡 the purse; 💧 water and ⚡ energy as rows of cubes (tap water to fetch, energy to
  Rest); the season bar (one thin stripe per question, in the season's colour); **the next story goal** across the whole middle (tap: its place
  glows); 🎒 pantry, 📖 quest book, 🖼️ album, ⚙️ settings; and the **Time Quiz clock** hanging from the bar's right end (its hour hand goes once
  round per season; tapped, the quiz opens). There is **no bottom bar**: the map runs to the bottom edge. Some of these appear only when
  they matter (§13.2b).
- **Notifications** look like a phone's: small cards stacked under the top bar, each with its own time (a hint goes sooner than news); a swipe
  sideways sends one away; taps outside the cards go through to the farm.
- **Testing buttons** (⏩ Cheat, 🪙 +50 bronze, 🎓 Quizzes) float at the top left when a grown-up switches them on (device setting).
- **Tap a place → a sheet slides up** with a picture on top and everything to do there: build, stations and recipes, animals,
  polish. Everything with a button is a **tile in a grid** (like the store and the market): a picture or emoji, the name,
  what it gives and costs, and its button at the bottom, as wide as the tile — recipes, crops to plant, weeds and stones on
  a patch, goals and upgrades (two per row), polish, collecting from animals and mucking out, and the knowledge cards.
- **Tap a patch that is still overgrown** and a window opens with a note on top: which patch it is, what is in the way
  (weeds, rocks, stumps, scrub, marsh) and what clears it, or what is needed first. When planting, a cost the player can't
  pay shows its missing cubes hollow (e.g. the water a full patch needs).
- **Buildings with an inside** (house, barn, workshop) open a window over the dimmed farm showing the room as a cutaway; its
  corners (bed · books · kitchen; cellar · crocks · hay · seed library; benches · kiln & forge · spinning · tools) open their own
  sheets.
- **Signs on places:** 🔨 something to build, 🧺 animals ready, ❓ a card quiz, 📖 a card to read, 🍂 stale soon, ⏳ busy, 😴 tired.
- **⬅️ Back to the farm** closes any window.

### 13.4 Pictures instead of words

- No text on the map (place names can be switched on, `showPlaceNames`). Every plant, weed, stone and stump is drawn one by
  one and gets fewer as it is cleared; patch upgrades appear in the gaps between the patches, the fence round the field.
- **Amounts are cubes** in the item's colour (smaller cubes in more rows for big amounts). **Costs** show filled cubes for what you
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
the pond and sows, picks with a basket, chops, hammers, stirs the pot, reads, sits to rest, cheers. The game has already
counted the result; the farmer only catches up, and a new tap stops the act at once. Acts, poses and the props in the
farmer's hands are data (`data/acts.json`), so new ones need no code. **(planned)** a "make your farmer" screen at the start, the look kept per player, gear visible on the
farmer, merchants walking about.

### 13.6 For young readers

- **Font:** Andika (SIL), designed for children learning to read; emojis from Noto Color Emoji, the same on every device.
- **Short sentences**, everyday words, one idea per line; numbers whole (§5.8).
- **🔊 Read aloud** for quiz questions and card pages, where the device has a voice: off, a button or by itself (§4.1).
- **Big touch targets**, nothing that punishes slowness (§4.3), nothing that dies or is lost for good.
- The whole game in **English and German** (§4.5).
