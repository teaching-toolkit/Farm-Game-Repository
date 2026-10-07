# Farm Quiz Game — Godot prototype

A playable prototype that runs the whole progression from `data/farm-progression.json` (data v0.8). Start with `../00-READ-ME-FIRST.md` for the project as a whole.
Made for an **iPad held upright** (design size 834×1194; other screens stretch to fit).
Pictures come from `assets/` when they exist; emojis stand in for every picture that doesn't exist yet.

## Open and play
1. Install **Godot 4.7** (standard version, not .NET) from godotengine.org.
2. Project Manager → **Import** → pick this folder's `project.godot` → **Import & Edit**.
3. Press **F5** (▶ Run Project). The first start shows the welcome page; open the book to learn how to grow wheat.
   On a computer the window opens at two-thirds size; drag it bigger if you like.

## Play it in the browser (iPad)
The game exports as a web page (`../web-build/`). It needs an **HTTPS** host; any free static host works,
because the export is single-threaded and needs no special server headers.
1. In Godot: **Project → Export… → Web → Export Project** into `../web-build/` (first time only:
   *Manage Export Templates → Download and Install*). Or use the folder that is already there.
2. Put the folder online, for example:
   - **Netlify Drop** — open netlify.com/drop and drag the `web-build` folder onto the page. You get a link right away;
     sign in (free) and claim the site so it stays online. Later drops update the same site.
   - **Cloudflare Pages** or **GitHub Pages** — same idea, upload the folder's contents.
   - **itch.io** — zip the folder's contents, upload as an HTML game, set the viewport to 834×1194 and tick
     "mobile friendly" (it is then shown inside the itch page instead of as its own app).
3. On the iPad open the link in Safari, then **Share → Add to Home Screen**. It then opens full-screen in portrait like an app,
   and the save is safe from Safari's clean-up of rarely visited sites.
4. The first start downloads about 50 MB (most of it the game engine and the emoji font; hosts send it compressed, about 15 MB).
   After that it loads from the iPad.
Saves live in the browser on that iPad (one save per device and browser). ⚙️ → *Start a new game* clears it.

## The farm map
The whole farm fits **one iPad screen** (design size 834×1000, scaled to fit; nothing scrolls). It is seen **at an angle, like
Hay Day or FarmVille** (isometric, 2:1): the ground is a grid of diamond tiles, every place stands on its **footprint** (a diamond of
tiles; its front corner is the place's "feet"), and whatever stands lower on the screen is drawn in front of what stands higher.
A picture may reach up over the grass behind it; only its non-transparent pixels react to taps, so nothing steals a tap from its
neighbour. Where everything stands, and how big it is, comes from `data/map_layout.json` (see *Moving and resizing* below).
- **Top bar** — 🪙 coins; 💧 water and ⚡ energy as rows of cubes with the number next to them (tap the energy to 😴 Rest); the
  season as a bar of thin stripes in the season's colour, one per question, filled as they pass (the number = questions until the
  next season); 🎒 pantry, 📖 quest book, 🖼️ album, ⚙️ settings.
- **The map** — the **forest** comes in diagonally from the top left (gathering, later the woodlot), the **village road** from the top
  right (market stall, book cart, notice board, later the Import Broker). The **house plot** (2×2 tiles) holds the tent, the book box
  and the campfire until the cottage is built; then the house stands there and the bed, the books and the kitchen are inside it.
  The three **fields** fill the screen from edge to edge — Home Field, North Field, River Meadow — each 3×3 big patches with a
  thin gap between them; the later two are on the map from the start, overgrown and walled by a crumbling stone wall until they
  are cleared. **No words on the field:** every plant is drawn one by one (2 seeds planted = 2 sprouts), every weed and stone too
  (fewer as you clear them); a patch not cleared yet is a diamond of wild growth with what is in the way on it (weeds, rocks or
  stumps; scrub on the North Field, marsh on the River Meadow). What is built for the patches (stick edging, stone borders, log
  beds, irrigation channels, a drip line) appears in the gaps, and the field fence runs round each field.
- **Pens** (chickens, cows, sheep, pets, bees, orchard) have big footprints that may reach past the edge of the screen. They have
  no picture of their own: a generic fence runs round the footprint and what gets built there (a chicken house, nest boxes,
  hives …) stands inside as **add-ons**. At the start only a few broken posts and patches of bare earth are left. Buildings that
  are not built yet show **ruins**: the outline of their walls, broken wall pieces (stone or wood, like the building to come),
  rubble or planks. The water at the start is an **old bucket**; the **wild pond** (at the left edge) is where it gets filled.
- **Tap a place** and a sheet slides up with a picture on top and everything you can do there **now**: what to build, its
  stations and recipes, its animals, its polish. Nothing beyond the current chapter is shown. A locked place with nothing within
  reach only shows a weathered sign: *you'll find out what belongs here later, when you have what it needs.* The **forest** (tap
  the trees) opens gathering; the **road** (tap it) shows how good it is and who can come to the market. Small signs show what's
  waiting: 🔨 something to build, 🧺 animals ready, ❓ a card quiz, 📖 a card to read, 🍂 food going stale, ⏳ something cooking, 😴 tired.
- **Pictures instead of numbers:** amounts are rows of little cubes in the item's colour (smaller cubes in more rows for big
  amounts); costs show filled cubes for what you have, hollow ones for what is missing and faint grey ones for what upgrades,
  practice and meals save. Things that need time show a grey ⏳ button with the questions still to wait (tap it for the Time Quiz).
  Harvested and gathered things fly to the store, one picture per piece; what doesn't fit bounces off the store (it shakes and
  shows 🚫). When the farm is seen again after the Time Quiz, the scarecrow first throws its angry looks (more at once at higher
  levels), then the pests that stayed come one by one, carry a plant off and come back later without it; the small 🐦 sign by the
  fields says how much of what is growing they eat each question. Buttons show emojis instead of words: 💪 gather / pull weeds /
  clear, 🌱 plant, 🧺 harvest, 🪓 wood, 🤏 fine work (rope), 🔨 build, 🍲 cook, 🔪 prepare, ⚙️ mill, 🫙 press, 🧶 textiles.
- **Buildings with an inside** — once the house, the barn or the workshop stands, tapping it opens a window over the (dimmed) farm
  with its inside: the corners (bed · books · kitchen; cellar · crocks · hay · seed library; benches · kiln & forge · spinning ·
  tools) are tappable and open their own sheet; closing the sheet brings you back inside. Before the barn or workshop stands, the
  place opens one sheet for everything there.
- **Bottom bar** — the next story goal (tap it: its place glows) and the **Time Quiz** button, an old clock: its hour hand goes
  once round per season; tapped, it spins once all the way round and the quiz opens.
- Animals and pets walk around inside their pens; pests hop on the fields and the scarecrow throws fierce looks.

## Pictures (assets/)
The game looks for a picture named after the data id and uses the emoji when there is none — add pictures one at a time, no code needed
(see `scripts/art.gd`):
- `assets/map/<id>.png` — buildings and places (`tent.png`, `well_1.png` …; or the place name: `market.png`, `forest.png`).
  A picture is named after the **first** stage it stands for and later upgrades keep it until they get their own: the final
  farmhouse is `cottage.png`, the barn `barn_1.png`, the workshop `workshop_1.png`, the warehouse `shed.png`.
- `assets/plots/<place>.png` — `pond.png` (dug out), `pond_wild.png` (at the start) and `home.png` (the house plot before the
  house). Pens have no picture of their own any more (a generic fence and ground; see `PENS` in `scripts/spots.gd`).
- `assets/ruins/stone_wall.png`, `wood_wall.png` — one side of a ruined wall (like a fence side) for buildings not built yet;
  `deco/rubble.png`, `planks.png` lie about. Without them the broken fences are used.
- `assets/addons/<id>.png` — things built on a place, shown when built (`coop_2`, `nest_boxes`, `beehive`, `bee_house` …).
  Leave upgrades out of the main pictures, so they can be added one at a time.
- `assets/interiors/<house|barn|workshop>.png` — the empty inside of a building (an isometric cutaway room);
  `assets/interior/<id>.png` — what stands in its corners (beds, shelves, stoves, looms …; `map/<id>.png` is used until then).
- `assets/tiles/` — `grass.png`, `path.png` (repeating ground; the forest edge is the grass, shaded darker).
- `assets/fences/<kind>.png` — ONE side of a field fence or wall (`stick_broken`, `stick_fence`, `wattle_fence`, `picket_fence`,
  `stone_wall`, `stone_broken`, `hedge_row` …), running from lower left to upper right (1 up for every 2 across); the game repeats it
  three times per side and mirrors it for the other two sides. `assets/edging/<kind>.png` — the same for the low borders in the
  gaps between patches (`stick`, `log`, `stone`, `channel`, `drip`, `net` …). Without pictures, lines and posts are drawn.
- `assets/crops/<crop id>.png` — one grown plant; a patch shows one per plant (up to 9), and the patch's sheet shows it on top.
  Without it the crop's emoji is used.
- `assets/deco/` — `soil_heap.png` (a worked patch), `sprout.png` (one young plant), `weeds.png`, `stone.png`, `rubble.png`,
  `stump.png`, `reeds.png` (things on the patches, one picture per piece), `mystery_sign.png` (shown for places you can't reach
  yet), and decorations: `tree_pine.png`, `tree_oak.png`, `bush.png`, `signpost.png`, `fence_stick.png`, `planks.png`.
  `tiles/overgrown.png` (repeating) is the wild growth on patches not cleared yet.
- `assets/ground/earth_<n>.png` — bare beige earth tiles (several variants) under the tent, in the yard and where ruins were cleared;
  they fade into the grass. Without them soft earth patches are drawn.
- Variants (the game picks one per spot, so the map doesn't repeat): `deco/weed_1..9`, `deco/debris_1..9` (stones, sticks),
  `deco/post_1..4` (lone fence posts in the gaps of broken fences), `deco/grass_1..9` (grass tufts), `fences/stick_broken_2/3`,
  `tiles/grass_2..4` (made from `tiles/grass.png`: turned or mirrored, a little lusher or drier), `tiles/overgrown_2/3`.
  The grass texture is drawn at half size (`GRASS_SCALE` in `scripts/farm_map.gd`). Earth tiles (`ground/…`) lose the grass
  rim the generator paints round them and get a wide soft edge when `import_art.py` cuts them.
- `assets/map/workbench_empty.png` and `assets/tools/<tool>.png` — the workbench at the workshop place and the tools that appear
  on it once made (rope, stone hammer, flint knife, stone axe, wooden shovel, rake, saw, iron hammer; where each lies: `BENCH` in
  `scripts/spots.gd`). Inside the workshop they hang on the wall once the tool rack is built.
- `assets/ui/clock_face.png`, `clock_hour.png`, `clock_minute.png` — the Time Quiz clock (hands pointing up, hub at the bottom);
  without them a clock is drawn.
- `assets/items/<item id>.png` — optional pictures of items (for things flying to the store and the pantry); emojis otherwise.
- `assets/animals/<id>.png` — animals and pets walking around (`animal_chicken.png`, `pet_bunny.png` …).

- Round 6 pictures: `patches/` (wild patches: overgrown_1/2, overgrown_rocks, overgrown_stumps, scrub, marsh; half_cleared,
  soil_dug, soil_raked), `road/road_1 … road_9` (diamond road tiles, mud to paving: two per road level), `animals/cat_*` (walk_1,
  walk_2, sit, sleep, leap, run, stretch, lick, lie — all looking right), `construction/stage_1 … stage_5` (a building site),
  `helpers/<id>` (the small helpers), `ruins/half_wall`, `ruins/rocks`, `ruins/block`, `map/field` (the sign by the Home Field,
  painted with a field), `fences/stick_fence` (rickety) and `fences/picket_fence` (the low stake fence).

Making pictures: the list of everything, in the order worth drawing, with a prompt for each, is `../art-inbox/ART_LIST.csv`
(`python3 tools/art_list.py` refreshes it). Generate several objects at once as a sprite sheet on a white background in the same style
(style C, bold cartoon — prompt at the top of the list), save it into `../art-inbox/`, then cut it into sprites:
`python3 tools/import_art.py sheet ../art-inbox/sheet.png map/tent map/well_1 …` (names in reading order, `-` skips one;
`tile` mode makes a seamless ground texture). Needs Python with Pillow, numpy and scipy.
`python3 tools/import_art.py all` cuts every sheet listed in `tools/art_sheets.json` again in one go.

**Shadows.** The generator draws a light grey shadow (about `#b6b3b4`) under things, meant for a white page — on grass it looked like
a pale smudge. While cutting, `import_art.py` finds the grey that touches the white background and turns it into a **see-through
dark blue** (darker grey → stronger shadow, at most half see-through), so it darkens whatever is underneath, like a real shadow.
Colours and strength are at the top of the script (`SHADOW_COLOR`, `SHADOW_STRENGTH`, `SHADOW_MAX`).

## Moving and resizing things on the map
The layout lives in `data/map_layout.json` (version 2): `tile` (width of one ground diamond), `field` (`patch`: width of a field
patch, `gap`: the gap between patches), the forest (a polygon) and the road (a line and a width), the three `fields` (front corner
of each 3×3 field), and for every place its feet (`x`, `y`), its footprint
(`foot`: tiles along ↘ and ↙), its picture width `w` and, where a stage needs another size, `ws` (picture name → width: the start
basket is smaller than the warehouse that replaces it). `k` says how it stands: `obj` (upright), `plot` (flat) or `sub` (in the house
yard until the house is built). `addons` place the things built on a place (`dx`, `dy` from its feet, `w`, `pic`, `until`),
`interiors` place the corners inside the house, barn and workshop (fractions of the inside picture), plus `deco`, `scarecrow`, `pests`.

**The layout editor** does this by dragging, no numbers needed:
- Online: the page *Farm Map Layout* on claude.ai (https://claude.ai/artifact/U7XSKLW8GcAacyAx1Uh7uV; also in the design document §13.1).
  It has a **Send to Claude** button — press it, then tell Claude "I sent the layout".
- Offline: open `tools/layout-editor.html` in any browser (it carries small copies of the pictures). **Download layout file** and
  copy the file over `data/map_layout.json`, or **Copy as text** and paste it to Claude.
- **Farm / House / Barn / Workshop** switch between the map and the insides; **Start of the game / Everything built** shows the
  farm on day one (house plot with tent, footprints of what is still locked) or finished (final pictures and add-ons).
- Tap a picture to pick it, drag to move it (places snap to the diamond grid), drag the yellow dot to resize it (or + / −, arrow keys
  nudge by one pixel). Moving the house plot moves the tent, book box and campfire with it; moving a place moves its add-ons.
  The footprint size is set under *Selected*. *Edit forest and road* shows their corners to drag. The palette adds trees, bushes
  and stones; **Undo** and **Back to the game's layout** are there too; unsent changes are remembered in that browser.
- After pictures were added or the layout changed, rebuild the editor: `python3 tools/make_layout_editor.py`.
- `python3 tools/default_layout.py` writes the starting layout again (it overwrites `data/map_layout.json`).

## How it plays
- **👋 Who is playing?** — the game asks for a name at the start (⚙️ switches). Every name has its own farm and its own
  learning record (every Rest sum and Time Quiz question practised, medals). *Start a new game* clears only the farm; the
  learning record stays. ⚙️ → 📊 *Learning record* shows it, opens its folder, copies it out and pastes it back in, and chooses
  what the Rest sums practise.
- **❓ Time Quiz** — the clock. Every right answer moves farm time one step: crops grow, ovens finish,
  weeds grow, pests arrive, reading progresses, seasons turn. Wrong answers can be retried. A question shows 3–4 answers,
  mixed up anew each time; some have a picture above them, some have four picture answers (two by two). Every question has an
  id (CON-003, PIC-012, KNW-045 …) under which the learning record keeps how well the child knows it.
- **⚡ / 😴 Rest** — tap the energy button and answer sums on the number pad (or the keyboard). The moment the typed number is
  right it is taken — no ✔ needed; a wrong number only counts when ✔ is pressed, then the right sum is shown, with the steps
  for a tricky one (13 − 5: 13 − 3 = 10, 10 − 2 = 8). A quick right answer (2.5 s for a sum learned by heart, more for longer
  ones) gives the full energy, a slower one half. The sums come from the **learning kit** (`learnkit/`): levels from 1 + 1 to
  32 − 17 and on to times tables, fractions and more in later years, spaced repetition for every sum, an easy one now and then
  when it is hard going, and medals for every level (🥉 passed, 🥈 every sum quick, 🥇 still quick a week later; in the album).
  Better home, bed, pillow and water bottle give more per answer.
- **💧 Water** never comes by itself: every drop is carried (tap the water in the top bar, or the pond or the well). A trip costs
  1 ⚡; the old bucket brings 2 💧 and holds 8, a well 4 (holds 24), the winch 6, the brick well 9, the hand pump 12 (holds 80);
  the yoke, the dug-out pond, the rain barrel and more add to every trip. When there isn't enough to plant, a pop-up with a
  crossed-out drop offers to fetch some. Rain waters the fields: planting costs no water until the next question.
- **🛤️ The road** starts as a muddy track: only the seed seller on foot gets through. Filling the potholes, gravel, cobbles and a
  paved road with a bridge let more merchants come (carts with timber and stone, books, clay, iron ore, hardwood, guild goods,
  the Import Broker).
- **🐦 Pests** eat a share of every growing patch each question (more pests, bigger share; worked out exactly, shown rounded);
  the scarecrow chases some off, fences keep some out.
- **Clearing takes steps** — pulling the weeds, clearing rocks or stumps is 5 taps (cut the tall weeds, pull the roots, pick out
  the stones …); each step costs a little energy, gives something back (fibre, stones, sticks) and the patch looks a bit more
  like soil. Where an old building stood (the workshop, the barn, the woodshed, the compost corner, the mill, the glasshouse) its
  ruins must be cleared first, in 4 steps that give stones or sticks, charcoal and ash.
- **Gathering** at the forest edge gives sticks, stones and fibre at once (they fly to the store straight away); then the spot
  needs a Time Quiz question to fill up again (the grey ⏳ is where the button was). Carrying gear (Gathering Basket, Wicker
  Pack, Rucksacks) takes bigger loads per tap — 🧺×2, ×3 … for as many times the energy.
- **🪵 The woodpile is stoked first** — stoves, ovens, kilns and the forge only burn what is on it. When the rest of a recipe is
  there but the wood isn't, the button says **Stoke** and puts on just enough. (The house in winter takes its wood by itself.)
- **Tap a bar** (season, growing, weeds, stones, pages, steps, polish, pests, seeds, store) for a one-line explanation.
- **Reading a card** — 📖 Start reading shows the card's text (read it, or read it aloud) while the reading takes its questions;
  ❓ Take the quiz then shows only the questions. Reading it again in the library shows the text again.
- **Straw** can't be sold — use it for thatch, bedding, compost and skeps.
- **Harvests vary** around each crop's average (1 wheat seed gives 1 or 2 wheat, 1.3 on average); luck and upgrades raise it.
  New patches can be planted after the first 2 clearing steps; the remaining steps make them give more (85 % → 100 %).
- **Seeds** are bought at the market — planting only uses seeds you have. New crops come a few at a time: some need a better
  road (brushwood, a ditch, kerbstones, a row of trees), some a present for the seed seller (porridge, soup, pancakes, a cake).
- **Big buildings** are built in 2–4 steps (stones, beams, planks, straw, ironwork …) with a short wait between them (⏳); the
  place shows the building site as it grows.
- **🐈 The farm cat** comes from a side quest in chapter 2 (a stray kitten): she walks about, naps and chases pests; fewer pests
  come. Six other side quests leave a small helper (a horseshoe, a bell, a wind chime, lavender …).
- **💌 Postcards** — the neighbours you help in side quests become your friends. When something big happens (a pet arrives, the
  library grows, every 12 goals) a friend may hear of it and send a postcard with a gift (the more friends, the likelier, and
  the more gifts to choose from — 1 of 1, 1 of 2, 1 of 3). Gifts can't be bought. Only 2 work at a time; the others rest in
  the album 🖼️, where you swap them. While you have fewer than 2 friends the quest book recommends the favours first.
- **✨ Perks** — small extras for favours and achievements that only make the farm prettier or livelier: butterflies, sparkles
  where you tap, farm sounds, rainbows after rain, lightning on quick sums, a streak flame, a coin shower, harvest confetti and
  a season breeze. Each can be switched off in the album.
- **🧑‍🌾 The farmer** walks to wherever you tap — on the grass, to a place (its sheet opens at once) or to the edge of a field —
  around buildings, pens, fields and the forest; tap the farmer to get a wave. A little 3D figure (`scripts/avatar.gd`) whose
  look is data (`data/avatar.json`: skin, hair, shirt, trousers, shoes, hat), ready for a "make your farmer" screen.
- **🪙 Selling** — the store tiles say exactly what you get: `1 🥣 = 4 🪙`, `5 🥕 = 10 🪙`. Made things pay more than their
  ingredients (more for more different ingredients); the market pays a little less for a big pile of the same thing and
  forgets it again over a few questions, so selling different things pays best.
- **🎚️ Prices fit my farm** (⚙️ Settings, off at first) — dynamic difficulty, a first version: when a goal first shows up, its
  coins and bigger amounts are fitted to how fast this farm brings things in compared with the plan (×0.8 to ×1.25, then fixed);
  a goal that an untried improvement would make quicker shows it as a 💡 tip. See the design document §10.6.
- **New things** (buildings, tools, gear, helpers) get a big pop-up with their picture and confetti, stars, fireworks, balloons
  or sun rays.
- **🧺 Harvest all** is at the storage basket and lights up when something is ripe. The store, the market and the gift cards are
  grids; green buttons say in one word what they do (Gather, Pull, Plant, Twist, Cook, Bake, Lay, Raise …).
- **Fields** — tap a patch to plant (the pop-up shows how many seeds you have), harvest, pull weeds or pick stones. Patches of a
  field from a later chapter only show the mysterious sign. All three fields are always on the map (North Field and
  River Meadow stay overgrown until they are cleared); the 🪧 signpost next to the Home Field opens clearing land, better patches,
  scarecrow and fence (so does tapping a patch that isn't cleared yet). Orchard and greenhouse are their own places; an orchard tree can be cut down (🪓, a log and sticks) to plant another kind.
- **Places** — kitchen and workshop (stations, woodpile, choice slots), pens (feed, collect, muck out), storage (sell, eat for an
  energy discount, burn as firewood, “stale soon”), market (seeds, merchants; orders to deliver at the bottom), book cart and library
  (books, reading, card quizzes), home (Rest, food, what you wear), notice board (little jobs, favours for neighbours).

## Testing shortcuts
- **⏩ Cheat** (top bar) lets time pass until everything growing, cooking, reading or resting animals is done
  (at most 60 questions), then fills energy and water. **🪙+100** adds coins.
  Hide both by setting `"showCheatButton": false` in `data/settings.json`.
- ⚙️ → **Start a new game** deletes this player's farm (the learning record stays).
- Saves live in Godot's user folder, one folder per player: `players/<name>/farm_save.json` and `learning.json` (on a Mac:
  `~/Library/Application Support/Godot/app_userdata/Farm Quiz Game (prototype)/`).
- Screenshots and tests: `--player=Name`, `--newgame`, `--timestep=N`, `--spot=storage`, `--patch=K`, `--unlock=id,id`,
  `--give=item:5`, `--water=1` (carried water), `--menu` (⚙️ Settings), `--grownup` (its grown-up part open), `--password` (the password box), `--celebrate=id`, `--postcard`, `--perks=all` (or a list of perk ids), `--rainbow`, `--rest` (the Rest start page; add `--restgo` for the sums), `--qid=PIC-004`
  (one Time Quiz question), `--lang=de` (quiz texts in German), `--shot=file.png`.

## Changing content (no code needed)
- `data/farm-progression.json` — the whole tree. Edit it, run `python3 tools/sync_progression.py` (copies it into
  `../progression/` and the explorer) and check it in `../progression/progression-explorer.html`.
- `data/quiz_packs/*.json` — Time Quiz questions, one file per pack: `{ "id", "code", "title", "subject", "pool", "questions":
  [ {"id", "q", "img", "emoji", "answers", "correct", "right", "wrong"} ] }`. An answer is text or `{"text", "img", "emoji"}` (a
  picture answer; `img` = a picture name like `items/carrot`, `emoji` stands in until it exists); `img`/`emoji` on the question =
  a picture above it; `pool` = more wrong answers of the same kind to fill questions up. Add a file and list its id in
  `activePacks`. **After adding or changing questions run `python3 tools/quiz_ids.py`**: it gives new questions their id
  (never change or reuse one) and updates `data/i18n/quiz-en.json` and `quiz-de.json` (German texts; empty = still English).
- **Languages** (`data/i18n/`, see `scripts/i18n.gd`): `languages.json` lists them; per language `ui-<lang>.json` (interface:
  English text → translation), `data-<lang>.json` and `learn-<lang>.json` (game data and Rest sums: `{"path": {"en", "<lang>"}}`)
  and `quiz-<lang>.json` (packs). In the scripts every text the player sees is wrapped in `tr("…")` (`TranslationServer.translate`
  in static functions); tables of texts are marked `# i18n` and shown with `tr()`. **After changing any text run
  `python3 tools/i18n.py`**: it adds new texts to every language (empty = English for now), flags data texts whose English
  changed (`"stale": true`) and checks that `%s`/`%d`/`{…}` slots match. `--check` only reports. Plurals: write two full
  sentences (singular and plural), never add an "s" by code. Screenshots in a language: `--lang=de`.
- `data/settings.json`:
  - `activePacks` — which packs are on (empty = all); `quizOptions` — answers per question (4; a question with fewer shows all
    it has); `language` — the language when the device has not chosen one in ⚙️ Settings (`en` or `de`);
  - `dynamicDifficulty` — prices that fit the farm (see above; tuned in `meta.flex` of farm-progression.json);
  - `knowledgeReviewShare` — share of Time Quiz questions that are reviews of knowledge cards the child already learned
    (0 = off, 0.25 = one in four); the rest come from the parent's packs. This is the starting value: ⚙️ Settings changes it
    for each farm in 5 % steps;
  - `mathCategories` — what the Rest sums practise (`addsub`, later `muldiv`, `numbers`, `fractions`, `decimals`, `measures`,
    `powers`; a parent can also tick them in ⚙️ → 📊 Learning record);
  - `restTimerScale` — stretches every time limit (1.5 = half as much time again); `restSlowShare` — the share of the energy a
    slow right answer gives;
  - `mathCurriculum` — the curriculum file (`learnkit/curriculum/math.json`: levels, times, repetition, medals, kind words);
  - `showPlaceNames` — name labels under the places on the map (off: no words on the map);
  - `parentPassword`, `parentHint` — the password for the grown-up part of ⚙️ Settings (question share, dynamic difficulty,
    learning record, new game; open for 5 minutes once typed, not case-sensitive) and the hint shown under the box. For now the
    hint is the password itself ("farm"); change the password later and the hint becomes a reminder. Only a child lock: the
    web build is public;
  - `avoidRepeatWithin`, `showCheatButton`.

## Automated checks
- `godot --headless --path . res://tests/bot.tscn -- --iters=900 --chapter=3` — a greedy bot plays the rules engine and prints progress
  (chapter 3 in about 290–420 Time Quiz answers; `--chapter=5 --iters=1100` reaches chapter 5 in about 680–800; it plays randomly, so
  the number changes from run to run; `--flex` plays with dynamic difficulty on; `--trace=N` prints what happens during the first N questions; it prints
  its pace, which `meta.flex.basePace` is taken from).
- `godot --headless --path . res://tests/ui_smoke.tscn` — clicks through the opening (first card, planting, Time Quiz, Rest,
  every place on the map, quest book, album, log) and checks the sums, the market, postcards, perks, the farmer, quiz ids,
  answers and pictures, German texts, stoking, carrying, rooting out and dynamic prices.
- `godot --headless --path . -s res://tests/learn_sim.gd` — a pretend child practises 2,500 Rest sums: when is each level passed?
- Screenshots: `godot --path . --resolution 834x1194 -- --shot=out.png [--spot=kitchen] [--spot=home] [--quiz] [--goal]`
  (`--demo=1` fast-forwards with the cheat; `--timestep=95` jumps to question 95, i.e. winter, to check the seasons).

## What's simplified in this prototype
- A patch upgrade (dug beds, raised beds…) is paid patch by patch, then applies to every patch; new fields get it too.
- One scarecrow and one fence protect all fields; pests are counted for the whole farm.
- Sounds only with the "Farm sounds" perk (made by the game itself); text-to-speech (🔊) works where the system has a voice.
- The pixie chest mini-game is not in yet; the farmer is a first prototype (one look, no "make your farmer" screen yet).

## Files
- `scripts/game.gd` — rules engine (autoload `Game`): data, time, energy, fields, weeds, stones, pests, animals, stations,
  firewood, knowledge, polish, gear, seasons, freshness, luck, gift cards, jobs, acorns, cheat.
- `scripts/main.gd` — the interface (top bar, map, sheets, the inside windows, quizzes); `farm_map.tscn` + `scripts/farm_map.gd` — the
  one-screen map, built from `data/map_layout.json` (ground, forest, road, house yard, fields with shadows and fence, pens, places,
  add-ons and decorations sorted by their feet; scaled to fit the screen); `scripts/slot.gd` — one place (stands on its footprint,
  taps only on its pixels, draws its footprint until it has a picture); `scripts/spots.gd` — which place or corner each data node
  belongs to, the buildings with an inside (`INTERIORS`), and which pictures an upgrade chain uses; `scripts/iso_field.gd` — a field at
  an angle (diamond patches, pests, scarecrow looks, rain); `scripts/field_view.gd` — the square patch grid still used inside the
  orchard and greenhouse sheets; `scripts/art.gd` — pictures with emoji fallback; `scripts/ui.gd` — styles.
- `scripts/avatar.gd` — the farmer (a 3D figure drawn into a picture on the map) + `data/avatar.json` (its look); `scripts/fx.gd` —
  perk effects (sounds made in code, lightning, flying coins, butterflies, sparkles, rainbow, season breeze).
- `learnkit/` — the learning kit, usable in any Godot game: learning records, the maths curriculum and engine, question packs,
  spaced repetition, the timer and the number pad window; `learnkit/tools/learning-editor.html` views and edits a record in any
  browser. See `learnkit/README.md`.
- `export_presets.cfg` — the Web export (single-threaded, installable to the Home Screen, portrait).
- `tools/` (not exported with the game) — `import_art.py` + `art_sheets.json` (cut sprite sheets), `art_list.py` (picture list),
  `default_layout.py` (first map layout), `make_layout_editor.py` + `layout_editor_template.html` → `layout-editor.html` (layout editor).
- `fonts/Andika-*.ttf` — Andika by SIL, a font designed for children learning to read, SIL Open Font License 1.1.
- `fonts/NotoColorEmoji.ttf` — Noto Color Emoji by Google, SIL Open Font License 1.1 (same emojis on every device).
- The earlier landscape layout (tabs on the right) is kept in `../archive/godot-landscape-v1/` (with the old top-down map scene
  generator `make_map_scene-v1.py`).
