# Farm Quiz Game — Master Design Document

**Version 2.0 · 7 October 2026 · describes game data v0.8 and the Godot prototype as built**

This document describes the game: what it is, how it plays, and why it is made this way. It describes the current design,
not its history and not the work still to do:

| Looking for … | Read |
|---|---|
| Where the project stands, how to work on it, the open tasks | `00-READ-ME-FIRST.md` (same folder) |
| What was done when, and the decisions taken along the way | `PROJECT-LOG.md` (same folder) |
| How to run, test and change the Godot prototype | `godot-prototype/README.md` |
| The learning kit (Rest sums, quiz engine, learning record) | `godot-prototype/learnkit/README.md` |
| Every number (items, buildings, recipes, costs, rules) | `godot-prototype/data/farm-progression.json` (the explorer in `progression/` shows it) |

**The data is the source of truth for numbers.** The numbers quoted here are the current ones; if the data and this
document ever disagree, the data wins and this document should be corrected.

**Status marks.** Everything is *built* unless marked otherwise: **(planned)** = decided but not built yet;
**(idea)** = a possible direction, not decided.

---

## 1. Vision

### 1.1 Premise

A craft-from-scratch farming game in an old-world, pre-industrial setting. The player comes back to a farm that has burnt
down. All that is left is a tent, an old dented bucket by a wild pond, a tin pot, a few sticks and stones, one wheat seed
— and a box with a book in it. From there the player rebuilds everything: fire and porridge first, then stone tools, a
cottage, a kitchen, animals, a smithy, a windmill, a farmhouse, a greenhouse, and finally a master farm with heirloom crops
and plant dyes.

### 1.2 Who it is for

An **8-year-old** first (the designer's child), playing on an **iPad held upright**, mostly alone in chapter 1 and
sometimes with the family later. A **parent** is the curator: they choose the quiz packs, the maths topics, and can look
at and edit the child's learning record.

### 1.3 What the child learns

The learning is the economy, not a quiz bolted onto a game:

1. **General knowledge** — the Time Quiz (question packs chosen by the parent, plus reviews of farm knowledge).
2. **Mental arithmetic, fluent and by heart** — the Rest sums, a full curriculum for about classes 1–7 with spaced
   repetition and medals.
3. **How a farm and old crafts really work** — 67 knowledge cards that unlock what they describe (compost, crop rotation,
   linen from flax, charcoal, bread that rises, plant dyes and colour mixing …).
4. **Planning and opportunity cost** — sell now or save for a recipe; which upgrade first; what to plant where.
5. **Scarce water** — every drop is carried; animal products need more water than plants.
6. **Circular farming** — weeds, straw, manure and scraps become compost; stale food becomes animal feed.

### 1.4 The player fantasy and the hidden goal

The satisfaction is not "I harvested a crop" but **"I turned a few scarce things into something valuable, and that opened
the next part of my farm."** The long chains (§8.3) are the heart of it: seed → crop → ingredient → processed ingredient →
dish → delivery → a new merchant, a new pet.

The quiet goal of the whole game is **five pets coming home** (bunny, tortoise, goat, pony, alpaca). Each one needs a
special dish and a comfort item, and each arrival ends a chapter. The farm is rebuilt *for someone to come home to*.

### 1.5 What the game deliberately is not

- **No XP and no player level.** Progress is what the farm can do now.
- **Nothing is ever lost.** Crops never die, animals never get sick or leave; pressure only slows things down.
- **Farm time only moves with right answers.** Nothing happens while the child is away; no real-time timers, no waiting
  for hours.
- **The Time Quiz never gives energy and never gives coins.** It moves time; Rest gives energy.
- **No buying power, no shop for advantages.** Gifts come from friends and cannot be bought. Perks make the farm prettier,
  never stronger.
- **No streaks that break, no leagues, no comparing with other children.**
- **No tech-tree screen.** The whole tree exists as data and in the explorer for the designer; the child only ever sees
  what is within reach now.

---

## 2. Design principles

- **One farm, one screen.** The whole farm fits one iPad screen. Everything happens where it belongs on the map; a tap
  opens a sheet or a window over the farm, never a separate page.
- **Pictures instead of words.** No text on the map. Amounts are rows of cubes, waiting is an hourglass, buttons show a
  picture and one specific word (*Gather, Plant, Bake, Smelt …*).
- **Exact underneath, whole on screen.** Every amount is kept exactly; the child sees whole numbers only: stocks rounded
  down, costs rounded up, so whatever looks affordable is.
- **Two loops, two currencies.** The **Time Quiz** is the clock: one right answer = one step of farm time. **Rest** is
  energy: right sums give energy back. Everything the child *does* costs energy.
- **Always a bit out of reach.** There is always a near goal (a few questions away) and a far one (the chapter's big
  build or pet); 2–6 open goals in chapter 1, up to about 12 later.
- **The bottleneck moves.** Each upgrade relieves one limit and shows the next one (more plants per patch → water runs
  short → better wells and watering).
- **By hand first, automatic later.** Every chain starts as handwork and is later handed to something that works by itself
  (hand quern → windmill, gathering → woodlot and lumbermill).
- **Upgrades replace.** A better tool, house or well replaces the old one; whatever needed the old one stays satisfied.
- **Making things pays; variety pays.** A made thing is worth more than its ingredients, more for more different
  ingredients; the market pays less for a big pile of one thing.
- **Soft pressure, never loss.** Weeds, stones, pests, muck, blunt tools, cold, staleness: each grows with the farm and has
  an upgrade ladder that answers it. None of them ever destroys anything.
- **Every item has more than one use.** Food can be eaten for a bonus, wood burned, scraps composted, grain fed.
- **Only what matters now.** Sheets show what can be done now; nothing beyond the current chapter is shown; locked places
  are ruins with a mysterious sign.
- **Content is data.** Items, buildings, recipes, cards, quests, prices and rules live in JSON files; the code only knows
  the rules.

---

## 3. The core loop

1. **Answer a Time Quiz question.** A right answer moves farm time one step: crops grow, ovens and kilns finish, reading
   progresses, animals get ready, gathering spots refill, weeds grow, pests come and are chased, the season moves on. A
   wrong answer can be tried again; it never moves time.
2. **Look at the changed farm.** Ripe crops glow, things that came in fly to the store, pests peck and leave.
3. **Do things on the farm** — gather, plant, harvest, weed, cook, craft, build, collect from animals. Every job costs
   **energy** (and often water, materials and coins).
4. **Rest when tired.** Tap the energy bar and answer sums: each right sum gives energy back (more in a better home).
5. **Choose:** sell now, keep for a recipe, eat for a bonus, burn, compost, feed.
6. **Reach goals** — a building, a tool, a delivery that opens a new merchant, a knowledge card, a favour for a neighbour,
   and in the end a pet. Each goal opens the next ones.

A chapter takes about one to five hours of play; the whole game about 20 hours (§10.5).

---

## 4. Learning systems

### 4.1 The Time Quiz — the farm's clock

The ❓ button (an old clock) at the bottom right opens the Time Quiz. One right answer = one step of farm time. It is the
only thing that moves time.

- **Where questions come from.** Mostly from the **question packs** the parent switched on (`activePacks` in
  `data/settings.json`; packs are files in `data/quiz_packs/`). A share of the questions (25 % to start, `knowledgeReviewShare`;
  the parent changes it per farm in the grown-up part of ⚙️ Settings, in 5 % steps) are reviews of knowledge cards the child has already learned
  (§4.2); when no card is due, a pack question takes the place. A question asked lately does not come back within
  the next few (`avoidRepeatWithin`, 3).
- **Spaced repetition per question.** The learning record keeps every question: answered wrong, it comes back after 3
  others; right at the first try, it waits 12, then 32, 80, 200 and 480 questions. New questions come before known ones
  most of the time (70 %).
- **Answers.** Each question shows **3–4 answers** (`quizOptions`, 4): the right one and up to three wrong ones, mixed up
  anew each time. A pack can have a **pool** of answers of the same kind (all seven continents) that fills up questions
  written with fewer wrong answers, so the child meets different wrong answers and cannot learn a question by the look of
  its buttons.
- **Pictures.** A question can have a picture above it ("What is this?" 🎃); answers can be pictures, then they are four
  big picture buttons, two by two ("Which one grows under the ground?"). A picture is a name in the game's pictures
  (`items/carrot`, `animals/animal_cow`) with an emoji that stands in until the picture exists.
- **Feedback.** A wrong pick greys out and shows a short hint ("Hens lay something you can cook for breakfast"); the right
  one turns green with a one-line "why". Wrong answers can be retried (`wrongAnswer: retry`); only the first try counts for
  the repetition.
- **Read aloud.** 🔊 reads the question and the answers where the device has a voice.
- **Every question has an id** that never changes and is never reused: a pack code and a number (`CON-003`, `PIC-012`);
  the knowledge cards' questions are `KNW-001` … `KNW-201`. The learning record and the translations use the id, so the
  record says how well the child knows *that* question in any language, and a question can be reworded without losing
  what was learned.
- **Packs now:** *Farm basics* (FRM, 4), *Continents* (CON, 12), *Farm pictures* (PIC, 18, picture questions). A playthrough
  has about 1,400 Time Quiz answers, so a live set of 40–80 questions, swapped as the child learns (one pack per school
  topic or term), keeps it fresh.

A pack file:

```json
{"id": "farm-pictures", "code": "PIC", "title": "Farm pictures", "subject": "Science",
 "pool": ["…optional extra wrong answers of the same kind…"],
 "questions": [
  {"id": "PIC-004", "q": "What does a hen give us?", "img": "animals/animal_chicken", "emoji": "🐔",
   "answers": [{"text": "Eggs", "img": "items/egg", "emoji": "🥚"}, {"text": "Milk", "img": "items/milk", "emoji": "🥛"}, "Wool", "Honey"],
   "correct": 0, "right": "Right! Hens lay eggs.", "wrong": "Hens lay something you can cook for breakfast."}]}
```

### 4.2 Knowledge: cards, books and the library

What the farm can do is learned. **67 knowledge cards** in **12 books**, one idea per card (*A safe little fire*, *Twisting
rope from fibres*, *Why bread rises*, *Smelting iron*, *Mixing colours* …). A card unlocks the things it describes (the
campfire, rope, the oven …), gives a lasting boost (✨, e.g. fuel −5 %), or both.

**Learning a card:**
1. Own its **book** (bought from the book cart, which comes with the travelling merchant).
2. Have **discovered** the thing it is about, if it names one (hold iron ore once before *Smelting iron*).
3. **Read** it: the card's page (2–4 sentences, reading level of class 2–3, can be read aloud) stays open while the reading
   takes a few Time Quiz questions; a bigger library reads faster.
4. Take its **quiz**: 2 new questions about the card plus up to 3 review questions, one from each of up to 3 earlier cards
   it builds on (weakest and longest-unseen first). Wrong answers grey out with a one-line "why" and can be retried; a
   missed review never blocks learning.

Learned cards come back as **reviews in the Time Quiz** (Leitner boxes 1–4: due after 12 / 40 / 100 / 250 questions or 1 /
3 / 7 / 21 days, whichever comes first). Only first-try answers move a card up.

**The library** grows from a box in the tent to a room:

| Level | Holds | Reading | Needs |
|---|---|---|---|
| 📦 Book box in the tent | 2 books | — | start (*The Little Farm Book* is in it) |
| 📚 Bookshelf | 5 | 10 % faster | 5 cards learned, Carpenter's Bench |
| 🪑 Bookcase & reading chair | 10 | 20 % faster | 15 cards |
| 🏛️ Library room | 12 (all) | 30 % faster, +½ ⚡ per Rest answer | 30 cards, Farmhouse |

**The books** (chapter, price): *The Little Farm Book* (1, free) · *Village Crafts* (1, 15) · *Grandma's Kitchen* (2, 25) ·
*Animals & Bees* (2, 30) · *Soil & Seasons* (2, 40) · *The Smith's Book* (3, 150) · *From Fleece to Fabric* (3, 125) · *Cellar
& Larder* (3, 150) · *Fire, Glass & Steel* (4, 125) · *Orchard & Oils* (4, 100) · *Colours of the Earth* (5, 175) · *The Master
Farmer* (5, 250). Which card opens what is in the data (node type `knowledge`, field `unlocks`) and in the explorer.

Knowledge is paid for with coins (books), time (reading) and **the child showing the knowledge** in the quiz — there is no
second currency.

### 4.3 Rest — energy from mental arithmetic

Tapping the energy bar opens **Rest** (sleep, food, a sip of water). The child types answers to sums on a number pad (or the
keyboard). The sums come from the **learning kit** (`learnkit/`), a self-contained part that any game can use.

- **A start page first.** Rest opens on a page that shows where the child stands: the category and its title (🌰 Seed …
  🏔️ Mighty oak), the section and level ("level 2 of 13: 🐥 Take away up to 5") with a bar for how far along it is, the
  medals of the section won so far and an empty slot for the next one with what it takes, and the best streak. A big
  **🏁 Ready, set, go!** counts down (Ready… Set… Go!) and the sums begin.
- **Leaving mid-sum.** Going back to the farm while a sum is on screen leaves no trace: it is not wrong, not slow, and it
  does not change when it comes back.

- **Taking an answer.** The moment the typed number is right it is taken — no ✔ needed. A wrong number only counts when ✔
  is tapped; then the right sum is shown, with the steps for a tricky one (13 − 5: 13 − 3 = 10, 10 − 2 = 8).
- **Energy.** A quick right answer gives the full energy per Rest answer (§5.1), a slower right one half
  (`restSlowShare`), a wrong one nothing. Rest stops by itself when energy is full.
- **The curriculum** (`learnkit/curriculum/math.json`), planned from class 1 to about class 7 (Swiss Lehrplan 21 and the
  *Schweizer Zahlenbuch*): **7 categories** — Plus & minus, Times & divide, Numbers, Fractions, Decimals & percent,
  Measures, Powers & minus numbers — with **76 levels**. Each category has two sections:
  - **⚡ By heart** — facts to recall at once (8 + 5, 6 × 7, 1/2 of 16). Quick = 2.5–3 s, plus ½ s for every extra digit
    typed.
  - **🧠 Working it out** — too many to learn by heart (32 − 17, 12 × 17, 3/4 of 24). The steps should run smoothly, so the
    time is longer (5–30 s) and a hint after a mistake shows the steps.
  A level opens when the level it builds on is passed (38 + 5 after 8 + 5). Times tables follow the German-language
  practice: core tasks first (×1, ×10, ×2, ×5, squares), the rest derived from them. Only *Plus & minus* is on at first;
  a parent ticks on the next category when the child is ready (⚙️ → 📊 Learning record, or `mathCategories`).
- **Spaced repetition.** Every task is a flash card: wrong → back after 2 others; slow → back after 3; quick and right →
  waits 3, 8, 20, 60, 180, 500, 1,400 answers. A task answered quickly the very first time counts as known already. At
  most 4 new tasks are learned at once and a new one comes at least every other answer, so the child moves forward instead
  of drowning in reviews.
- **When it is hard going** (4 of the last 8 wrong, or 7 of 8 slow): every third task is an easy one the child knows, only
  2 new tasks at a time, and now and then a kind word ("Tricky ones today — take your time"). Praise at 5, 10, 20, 30 quick
  answers in a row and for a sum known for good.
- **Medals for every level:** 🥉 **bronze** = passed (enough tasks quick and right twice in a row); 🥈 **silver** = the whole
  level quick (by heart: every task of a small level or 70 % of a big one, and 9 of the last 10 quick; working it out: 20
  different tasks quick); 🥇 **gold** = still quick at least a week after silver. 🏆 **Trophy** = a whole section silver;
  👑 **crown** = all gold. Each category gives a growing title: 🌰 Seed → 🌱 Sprout → 🌿 Seedling → 🌳 Young tree → 🌲 Tall
  tree → 🏔️ Mighty oak. The album shows the medals won and the next one to win.
- **Timing is generous by default.** The quick time only decides full energy and medals; a slow right answer still counts
  and still gives energy, and the timer bar never punishes. `restTimerScale` stretches every time limit.

How much arithmetic: about 1,400 Rest answers in a playthrough, roughly 60–100 an hour (§10.5) — arithmetic never
disappears and never floods.

### 4.4 The learning record and the parent's controls

- **One record per child**, shared by every game that uses the learning kit: `players/<name>/learning.json` in Godot's
  user folder (on a Mac: `~/Library/Application Support/Godot/app_userdata/<game>/players/<name>/`). It is plain,
  pretty-printed JSON: every sum and every quiz question (by id) with its box, when it comes back and how it went; every
  level with its medals and the dates they were won.
- **⚙️ → 📊 Learning record** shows a summary, opens the folder, copies the record out and pastes one back in (the way to
  edit it in the web version), and chooses the maths categories.
- **The editor page** `learnkit/tools/learning-editor.html` opens a record in any browser: tick or untick medals, choose where
  a child starts ("Start here" passes the levels before it), choose the categories, change or delete tasks, see every quiz
  question with its id and text, and download the record again.
- **Settings** for the parent (`data/settings.json`): which packs, how many answers, the share of card reviews, the language,
  the maths categories and timing, dynamic difficulty, place names on the map, the test cheat buttons.
- **The grown-up part of ⚙️ Settings** (the question share, the learning record, dynamic difficulty, a new game) is behind a
  simple password (`parentPassword`, with a hint under the box) and stays open for 5 minutes; "Who is playing" and the log
  stay open to the child. It is a child lock, not a secret.

### 4.5 Languages

The whole game is in **English and German**, and more languages can be added as files. ⚙️ Settings has a button per
language (🇬🇧 English · 🇩🇪 Deutsch); the choice belongs to the device and switches everything at once: the interface, the
farm's names and descriptions, the knowledge cards and their questions, the quiz packs, the Rest sums and their kind words,
and the read-aloud voice. English is written in the code and the data; every other language is a set of files in
`data/i18n/` (`ui-<lang>.json` for the interface, `data-<lang>.json` for the game data, `learn-<lang>.json` for the Rest
sums, `quiz-<lang>.json` for the packs). A text not translated yet shows in English. A new language is a new set of files
and a line in `data/i18n/languages.json`; `tools/i18n.py` collects every text into them.

---

## 5. Resources and economy

### 5.1 Energy ⚡

Everything the player does costs energy in proportion to the work: gathering, planting, harvesting, weeding, clearing,
building, crafting, cooking, smithing, milking, errands. Every recipe and goal has a **category** (`field`, `plant`,
`harvest`, `weed`, `gather`, `wood`, `build`, `craft`, `smith`, `kiln`, `cook`, `prep`, `mill`, `process`, `textile`,
`animal`, `errand`), and tools, gear, helpers, polish, practice stars and meals lower the cost per category. Raw effort per
goal grows about twelvefold from chapter 1 to 5; upgrades cut the late costs almost in half — tinkering pays.

**Getting energy back** is Rest (§4.3). The home sets the energy bar and how much each right sum gives:

| Home | Energy max | Energy per Rest answer |
|---|---:|---:|
| Tent | 20 | 5 |
| Cottage | 30 | 6 |
| Cottage · loft & second room | 40 | 7 |
| Farmhouse | 50 | 8 |
| Farmhouse · sun room | 65 | 9 |

On top: the bed (Straw Bed +1 → Wool Mattress +2 → Linen Bedding +3), the pillow (+½ → +1 → +1½), the water bottle (+½ →
+2), the library room (+½), polish (*Air the bed*: up to +1) and gifts. Energy max also rises with the Brick Hearth and
Lanterns (+5 each), hats, a gift, and every golden acorn (+3). **Cold house:** in winter with an empty woodpile, Rest gives
25 % less.

**Food** is a bonus, not energy: eating a dish lowers energy costs for one or two questions (simple dishes −10 % for 1,
soups, stews, bread and pasta −20 % for 2, cakes, pies and pizza −30 % for 2). Pet dishes are not eaten.

### 5.2 Water 💧

Water never comes by itself: **every drop is carried.** A trip (tap the water in the top bar, the pond or the well) costs
1 ⚡; what improves is how much a trip brings and how much the store holds, so later on the player carries water less often.

| Water source | Each trip | Holds |
|---|---:|---:|
| Old bucket (start) | 2 | 8 |
| Dig a well | 4 | 24 |
| Well · winch | 6 | 36 |
| Well · brick lining & pulley | 9 | 60 |
| Well · hand pump | 12 | 80 |

On top: the carrying yoke +2 a trip, the dug-out pond +2 (holds 20 more), the rain barrel +1 (15 more), the wind pump +4
(40 more), the tortoise +1, *Clean out the well* (polish) and the *Hidden Spring* gift. Water is used by planting (2–4 per
plant), animals (1–3 per collection, so animal products are the thirstiest) and some recipes. Using less is as good as
getting more: Watering Can −25 %, Drip Line −50 %, irrigation channels −15 %, water trough (animals −20 %), straw mulch.
**Rain** (a chance every question, highest in spring and autumn) waters the fields: planting costs no water until the next
question. When there is not enough water to plant, a pop-up with a crossed-out drop offers to fetch some. Start: 4 💧.

### 5.3 Coins 🪙 and the market

Coins come from **selling** — never from answering questions. They buy seeds, animals, books, materials from merchants and
the coin part of some buildings. The game starts with **0 coins**; the first coins come from porridge.

**Prices from ingredients** (`meta.pricing`). Everything that is made is priced from what goes into it: the worth of the
inputs × (1.25 + 0.1 for each different ingredient beyond the first) + ½ coin per energy, per fuel point and per question
it takes + 0.2 per water. So a dish of four different things pays more than its parts, and a dish made from dishes more
again (porridge 4, roast carrots 7, omelette 16, honey cake 49, apple pie 72, pizza 166, cheese board 212). Things a merchant
sells are worth less than his price even with every sell bonus — buying to resell never pays. Sticks, stones and fibre are
worth almost nothing, so gathering is never a money farm; straw cannot be sold at all.

**The market wants variety** (`meta.market`). Each thing sells at full price for the first 8; every further one of the same
thing fetches 8 % less (down to 60 %), and every question the market forgets a quarter of what was sold lately. A ↓ marks
something sold a lot lately. Selling a mix pays best.

**Clear sell buttons.** Store tiles say exactly what you give and what you get: `1 🥣 = 4 🪙`, and for all of it
`5 🥕 = 10 🪙` (the market's price for that many). Each recipe shows what its ingredients would fetch and what the result
fetches (🪙2 → 🪙4).

**Sell bonuses:** Market Stall +10 %, the pony +10 %, four Harvest Fair ribbons, the *Fair prices* card, gifts.

### 5.4 Seeds

Only seeds you have can be planted; seeds are bought from the **seed merchant**, who grows from a seller on foot to a cart,
a stall, a shop and a nursery (§10.4). New crops come a few at a time: some need a better road (beans the ditch, sunflowers
the kerbstones, herbs the row of trees), some a present for the seed seller (onion sets for two bowls of porridge, lettuce
for vegetable soup, beets for pancakes, flax for a honey oat cake, berry bushes for a cake). Heirloom seeds come from the
Import Broker in packets; the Seed Library (chapter 5) lets heirlooms give their own seeds back. The game starts with 5
wheat seeds.

### 5.5 Materials and the store

- **Basic materials any time.** The forest edge (*Field Edge & Woods*) always offers *Gather sticks*, *Pick stones* and *Pull
  wild weeds* (plant fibre); later *Chop deadwood* (axe) and *Dig out stones* (shovel); at the pond *Dig clay*. Gathering
  comes **at once** — the things fly to the store the moment the button is tapped — and then that spot needs a Time Quiz
  question to refill (the grey ⏳ appears where the button was).
- **Carrying gear takes bigger loads.** The Gathering Basket, Wicker Pack and Canvas and Frame Rucksacks add loads to every
  gathering tap (🧺×2, ×3 …): more comes in per question, for the same energy per piece (`meta.carry`). A tap takes a
  smaller load when energy is short.
- **The store** holds a limited number of **each** item: Basket 10 → Log Shed 25 → Warehouse 60 (gifts add a few). What does
  not fit flies to the store, bounces off and tumbles away (🚫). Some things are **keepers** — needed but not used up (the
  tin pot, the sourdough starter, cultures, the stone in Stone Soup).

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

---

## 6. Farming

### 6.1 Fields and patches

- **Three fields** of 3 × 3 diamond patches stand in a column in the middle of the map: the **Home Field** (from the start),
  the **North Field** (chapter 4: clear the scrub, then fence it) and the **River Meadow** (chapter 5, optional: drain the
  marsh, then a sluice; it also gives water). Later fields are on the map from the start, overgrown behind a crumbling wall;
  tapping them shows only the mysterious sign until their chapter.
- **Clearing takes steps.** The Home Field starts with **one** cleared patch (and one wheat seed to plant in it); the other eight
  are cleared two at a time — *Clear the thistles*, *Pull the weeds*, *Clear the rocks*, *Clear the stumps* — in 4–5 taps each (cut the tall weeds, pull the roots, pick the stones,
  gather the sticks, rake). Every step costs a little energy, gives material back (fibre, stones, sticks, a log) and makes the
  patch look more like soil. New patches can be planted after the first two steps (the weeds are out); they give 85 % of a
  full harvest until the job is done.
- **Patch levels** improve every patch of a field, one patch at a time (each level is paid per patch, then applies to the
  field):

| Ch | Level | Effect |
|---|---|---|
| 1 | Dug beds | 2 plants of the same crop fit in one patch |
| 1 | Stick edging | weeds grow 20 % slower |
| 1 | Raised log beds | 3 plants per patch |
| 2 | Stone borders & paths | weeds −15 %, harvesting −10 % energy |
| 3 | Double-dug beds | 4 plants per patch |
| 3 | Irrigation channels | field water −15 % |
| 4 | Deep-worked beds | 5 plants per patch |
| 4 | Glass cloches | crops grow 15 % faster |
| 5 | Living-soil beds | 6 plants per patch |

  Edging, borders, channels and drip lines are drawn in the gaps between the patches.
- **Fertilizer.** The first 2 plants in a patch need nothing; each plant beyond 2 needs 1 fertilizer point every planting:
  wood ash 1 point, compost 2, worm castings 4. Missing fertilizer never blocks planting — the patch just takes fewer plants.
  "Hungry" crops (tomato and others marked `needs`) need compost to be planted at all.

### 6.2 Planting, growing, harvesting

- **Planting** uses one seed, water and energy per plant; the patch sheet shows how many plants fit and why fewer (seeds,
  water, fertilizer). Each plant is drawn on the patch.
- **Growing** takes a number of Time Quiz questions per crop (2 for wheat, up to 14 for an olive tree), changed by the
  season, the cloches, stones and weeds on the patch (together at most half speed) and **crop rotation**: the same crop
  twice in a row grows 15 % slower (tired soil); after beans or clover the next crop grows 10 % faster (rested soil).
- **Harvests vary** around an average per plant (`meta.yield`): average × (1 + luck × 0.1) × the patch's quality, with a
  random spread of ±22 %, rounded up or down at random so the average holds; whole numbers only, at least 1 of the main crop
  per plant. Upgrades add to it (the bunny +1 carrot per harvest, autumn +40 % in the orchard).
- **🧺 Harvest all** at the storage basket harvests every ripe patch at once.

### 6.3 Weeds and stones

- **Weeds** grow on every field patch every question, planted or not: faster with more plants and more fertilizer, faster in
  later chapters (dandelions → docks → thistles → brambles → bindweed), +50 % in spring. Weeds slow growth. One weeding tap
  pulls 3 weeds (energy per weed) and gives plant fibre. The answers: edging and borders, hoes (stick → iron → steel), gloves,
  weeder geese, the goat, straw mulch, and the endless polish **Root out the weeds** (keeps regrowth down; each time also puts
  the weeds into the store as fibre: 2, then 4, 6 …).
- **Frost stones.** In winter, frost lifts stones in every patch (more in deep and bare beds). Stones slow growth a little;
  picking them gives stones for walls and paths.

### 6.4 Pests

- **Arrivals** every question grow with the plants growing, the chapter (×1 → ×2.8) and summer (+50 %), minus what the fence
  keeps out.
- **Defence.** The scarecrow chases a number of pests away each question: Stick 0.6 → Dressed 1.2 → Guardian 2 →
  Whirligig 3 (+½ when re-stuffed); the farm cat, owl box and ducks help; a fifth of the rest wander off. Fences keep a
  share out: Rickety Stick Fence 15 % → Woven Wattle → Stake Fence → Field Stone Wall (from frost stones) → Hedgerow 65 %.
  Small side-quest helpers keep particular pests away (a straw hat and a brass bell for birds, a wind chime for rabbits,
  lavender for slugs and caterpillars, a bird feeder).
- **Damage.** The pests that stay eat a share of every growing patch: 2 % per pest, at most 35 %, worked out exactly and
  shown rounded; a patch never drops below one plant.
- **On screen** (played when the farm is seen again after the quiz): the scarecrow throws angry looks (💢😠👀) — as many as
  its level — and the pests it hits fly off; the others fly or crawl to the crops one after another, peck, and speed off
  with a plant. Pests change by chapter: sparrows, rabbits, slugs, caterpillars, voles.

### 6.5 Orchard and greenhouse

- **The orchard** (cleared in chapter 2; 3 tree spots, +2 with the orchard terraces in chapter 5): apple, walnut and olive
  trees are planted once, take long to grow (10–14 questions) and then give a harvest every 4–5 questions for good. A tree
  can be **cut down** (🪓, 3 energy, gives a log and sticks) to plant another kind — so three apple trees never block the
  walnuts the pony's cake needs.
- **The greenhouse** (chapter 4: frame, then glass; extension in chapter 5) grows the heirlooms: saffron crocus (one small
  harvest after 8 questions, leaving corms behind), rainbow carrots and golden beets.

### 6.6 Crops

| Crop | Ch | Where | Grows (questions) | Water | Gives per plant (average) |
|---|---:|---|---:|---:|---|
| Wheat | 1 | field | 2 | 2 | 1.3 wheat, 0.65 straw |
| Carrot | 1 | field | 3 | 2 | 1.3 carrots |
| Clover | 1 | field | 2 | 1 | 1.95 clover (fodder, bee flowers, rests the soil) |
| Onion | 1 | field | 3 | 2 | 1.3 onions |
| Potato | 2 | field | 4 | 3 | 1.95 potatoes |
| Lettuce | 2 | field | 2 | 3 | 0.65 lettuce |
| Beans | 2 | field | 4 | 2 | 1.95 beans (rests the soil) |
| Beet | 2 | field | 4 | 2 | 1.3 beets (sugar, red dye) |
| Tomato | 2 | field | 4 | 3 | 1.95 tomatoes (2 eggs once to unlock; needs compost) |
| Sunflower | 3 | field | 5 | 3 | 2.6 seeds (oil) |
| Flax | 3 | field | 4 | 2 | 1.95 flax, 0.65 linseed |
| Oats | 3 | field | 3 | 2 | 1.3 oats, 0.65 straw |
| Pumpkin | 4 | field | 6 | 4 | 1.3 pumpkins |
| Berry bush | 4 | field | 5 | 3 | 2.6 berries |
| Herbs | 4 | field | 3 | 1 | 1.95 herbs |
| Apple tree | 2 | orchard | 10, then every 4 | 4 | 2.6 apples |
| Walnut tree | 4 | orchard | 12, then every 5 | 4 | 1.95 walnuts |
| Olive tree | 4 | orchard | 14, then every 5 | 3 | 2.6 olives |
| Woad | 5 | field | 4 | 2 | 1.95 woad (blue dye) |
| Saffron crocus | 5 | greenhouse | 8 | 1 | 0.65 saffron, 0.4 corms |
| Rainbow carrot | 5 | greenhouse | 3 | 2 | 1.95 |
| Golden beet | 5 | greenhouse | 4 | 2 | 1.3 |

---

## 7. Animals

| Animal | Ch | Price | Feed per collection | Gives |
|---|---:|---|---|---|
| 🐔 Chickens | 1 | 30 coins | 2 of any feed grain, ½ straw, water | 1 egg, sometimes a feather |
| 🐄 Cows | 2 | 40 coins (needs the barn) | 3 of any fodder, 1 straw, water | 1 milk |
| 🐝 Bees (straw skeps, later wooden hives, bee garden) | 2 | 10 coins, 4 straw, 1 rope | none — they need **flowering crops** somewhere on the farm (clover, sunflower, flax, berries, herbs, fruit trees) | 1 honeycomb |
| 🐑 Sheep | 3 | 100 coins (sheep pen, shears) | 2 of any fodder, 1 straw, water | 2 wool |

- Each animal kind is collected from when it is ready again (a few questions), all at once; the pen or building sets how
  many fit (coop → bigger coop, barn tiers for cows and sheep).
- **Muck.** Every collection leaves muck (hens 0.3, cows 1, sheep 0.6 per animal). Above 4 per animal the animals give 25 %
  less, above 8 half. **Mucking out** costs energy and gives manure — which becomes compost. Perches, a drain gutter and a
  card reduce it.
- Animals without feed or water simply wait; they never get sick, die or leave.
- Products feed the chains: eggs (cakes, omelettes, the tomato unlock), milk (butter, yogurt, cheese), honeycomb (honey and
  beeswax: candles, waxed boots and gloves), wool (yarn, cloth, blankets).
- The animals walk about their pens, turn the way they walk and hop. **Pets** are separate (§10.3).

---

## 8. Making things: stations and recipes

### 8.1 Stations

A **station** is where recipes are made: 38 of them, added chapter by chapter, most standing inside the kitchen, the
workshop or the barn.

| Ch | Stations |
|---|---|
| 1 | Campfire, Workbench, Chopping Block, Hand Quern, Field Edge & Woods (gathering) |
| 2 | Compost Bin, Compost Heap, Carpenter's Bench, Kiln, Stove, Oven, Prep Table, Butter Churn, Pond bank |
| 3 | Forge, Anvil, Sawbench, Hand Spindle, Hand Loom, Wooden Press, Fermenting Crocks, Cellar Racks, Cheese Vat & Press, Honey Extractor, Stove · iron top, Oven · iron door |
| 4 | Brickworks, Blast Forge, Glass Kiln, Spinning Wheel, Textile Loom, Prep Table · marble top, Grinding Mill (kitchen) |
| 5 | Dye Vat, Master Stove, Master Oven, Cheese Cave, Worm Bin |

Some stations are upgrades of another (Stove → iron top → Master Stove) and keep its recipes.

### 8.2 Recipes

106 recipes. A recipe has inputs, outputs, energy, sometimes water and fuel, and a time in Time Quiz questions (0 = at once).
- **One word on the button** for what it does: *Gather, Pull, Twist, Weave, Cook, Bake, Fry, Grind, Churn, Press, Saw,
  Smelt …* (`verb` in the data).
- **"Any of a kind" inputs.** Many everyday recipes take any flour, fat, grain, sweetener, fodder, cooking oil (`tag:` inputs).
  Signature dishes asked for by deliveries and pets keep fixed ingredients. Different sweeteners make different named dishes
  of one family (honey → Honey Cake, beet sugar → Simple Cake).
- **Keepers.** Some inputs are needed but not used up (the tin pot, the sourdough starter, yogurt and cheese cultures, the
  stone in Stone Soup) — "a culture lives on".
- **Slots and batches.** A station runs one batch at a time; helpers can add a slot. Its recipes wait while it is busy (the
  grey ⏳ shows how many questions). Gathering recipes give at once and refill (§5.5).
- **Practice stars.** Every station counts its uses; at 10, 40 and 120 uses it earns a star: −5 % energy for its recipes
  per star.
- **Choice slots.** Ten stations or buildings have one slot with two options, of which one works at a time and can be swapped
  freely (the campfire: *Stone Fire Ring* −15 % cooking energy **or** *Cooking Tripod* −30 % firewood).
- **Fuel** comes from the woodpile, which is stoked first (§5.6).
- Each recipe shows what its ingredients would fetch and what it fetches; costs show as cubes: filled = you have it, hollow =
  missing, faint grey = what upgrades, practice and meals save compared with the first time.

### 8.3 The long chains

- **Grain:** wheat → hand quern, later the windmill → flour → flatbread, bread (oven, starter kept), pasta, cakes. Wheat and
  oats also give **straw** → rope, thatch, skeps, bedding, scarecrows, compost.
- **Dairy:** clover → cow → milk → churn → butter; milk + culture → yogurt; milk + culture + salt → fresh cheese → the cellar
  → aged cheese → cheese boards, pesto.
- **Sugar:** beets → press → beet juice → iron-top stove → sugar → cakes, jam, pies.
- **Fermentation:** apples → press → juice → crocks → cider → cellar → vinegar → pickles.
- **Textiles:** sheep → wool → spindle → yarn → loom → wool cloth → sails, scarecrow, blankets. Flax → soak in the pond →
  flax fibre → linen thread → linen cloth.
- **Metal:** logs → kiln → charcoal; iron ore (bought) + charcoal → forge → iron → anvil → nails and iron tools; iron + more
  charcoal → blast forge → steel.
- **Glass:** sand + charcoal → glass kiln → glass → farmhouse windows, greenhouse, lanterns.
- **Colour:** beets, onions, woad → red, yellow, blue → mixed into orange, green, purple → rainbow yarn → the rainbow quilt.
- **Compost loop:** straw, weeds, manure, oilcake, stale food → compost bin → compost → hungry crops and deep beds.

The deepest item is the Rainbow Quilt (about eight steps from the field); the Golden Honey Cake draws on seven buildings.

### 8.4 Every item has more than one use

141 items. Besides selling and recipes: every dish can be **eaten** for a bonus (§5.1), wood is **firewood**, scraps and
stale food go to the **compost**, grain and fodder **feed animals**, beeswax waxes boots and gloves, wool and linen become
gear, frost stones build the field wall, feathers fill pillows, linseed oil oils tools and looms.

---

## 9. Building and upgrading

### 9.1 Places and their ladders

Every data node belongs to a **place** on the map (its `slot`). The main ladders:

| Place | Ladder |
|---|---|
| Home | Tent → Cottage (log walls, thatched roof, cottage) → Cottage · loft → Farmhouse (foundation, brick walls, farmhouse) → Farmhouse · sun room |
| Library | Book box → Bookshelf → Bookcase & reading chair → Library room |
| Storage | Basket (10 of each) → Log Shed (25) → Warehouse (60) |
| Well | Old bucket → Dig a well → Winch → Brick lining & pulley → Hand pump; rain barrel, wind pump |
| Workshop | Workbench → Carpenter's Shed → Smithy (chimney, workshop) → Master Workshop |
| Barn | Barn frame → Barn → cellar → stable; seed library |
| Windmill | Stone tower → Windmill (sails) → stone grinders; wind pump |
| Lumber | Woodlot → Lumbermill → hardwood grove |
| Road | Muddy track → brushwood → potholes → ditch → gravel → kerbstones → cobbles → a row of trees → paved road & bridge |
| Fence (Home Field) | Rickety Stick Fence → Woven Wattle → Stake Fence → Field Stone Wall → Hedgerow |
| Scarecrow | Stick → Dressed → Guardian → Whirligig |
| Pens & gardens | chicken coop, cow pen (with the barn), sheep pen, bee yard → bee garden, pet corner, pond, orchard, greenhouse |
| Village | market stall, book cart, notice board (little jobs and favours), Import Broker |

**The road is a ladder of its own:** it starts as a muddy track where only the seed seller on foot gets through; each road
level lets more merchants come (carts with timber and stone, books, clay, iron ore, hardwood and sand, guild goods, the Import
Broker), and the road looks like what it is (mud, filled potholes, gravel, cobbles, paving).

### 9.2 Building in stages

About 40 bigger builds go up in 2–4 steps, one kind of material per step (lay the stones, raise the beams, fit the planks,
bring the straw, fix the ironwork …). Each step takes its share of the energy (the coins go with the first step), and the next
step can start only after a short wait — 1 question in chapter 1, 2 in chapters 2–3, 3 in chapters 4–5 (the mortar dries).
The place shows the stage reached (site, foundation, frame, walls, roof beams). A step never needs more of a thing than the
store can hold.

### 9.3 Ruins to clear first

Where an old building stood, its remains must be cleared before the first new building there: 4 steps that cost energy and
give material back (stone ruins give stones; burnt wooden ones sticks, charcoal and ash) — the old workshop (ch 1), the burnt
woodshed, barn and compost corner (ch 2), the old mill (ch 3), the old glasshouse (ch 4). Before the campfire there is no ruin,
only an old fire spot: a few blackened rocks round a burnt log.

### 9.4 Tools

Tools come in tracks; a new tier replaces the old one and lowers the energy of its category (or opens recipes and builds):

| Track | Ladder | Effect |
|---|---|---|
| Digging | Hands → Wooden Shovel → Iron Shovel → Steel Shovel | field work −10/−20/−30 %; clears rocks; deeper beds |
| Cutting | Stone Knife → Iron Knife → Steel Knife | prep −20/−35 %; finer recipes |
| Hammering | Rock → Iron Hammer → Smith's Hammer | building −20/−35 %; iron and steel builds |
| Woodworking | Hand Axe → Saw → Master Saw | wood work −25/−40 %; planks 1 → 2 → 4 per log |
| Watering | Watering Scoop → Watering Can → Drip Line | planting water −25/−50 % |
| Weeding | Stick Hoe → Iron Hoe → Steel Hoe | weeding −25/−45/−60 % |
| Special | Wheelbarrow (harvesting −25 %), Shears (needed for sheep) | |

The tools made so far lie on the workbench (rope, stone hammer, flint knife, stone axe, wooden shovel, rake, saw, iron hammer);
once the tool rack is built they hang on the workshop wall.

### 9.5 Gear

23 pieces of gear in 8 slots, each a ladder where the new piece replaces the old one: **bed** (+1 → +3 ⚡ per Rest answer),
**pillow** (+½ → +1½), **bottle** (+½ → +2), **head** (energy max +2 → +6, field work −3 → −10 %), **feet** (planting,
harvesting, gathering, errands, animal care −5 → −20 %), **hands** (weeding and building), **back** (gathering, harvesting,
errands; the packs also carry bigger loads, §5.5), **apron** (cooking, prep, dairy and press).

### 9.6 Helpers (optional)

58 optional helpers, most in chapters 2–3. **None is ever required**; each makes something cheaper or better for good:
the Gathering Basket, Stone Fire Ring, Straw Bed, Nest Boxes, Whetstone and Carrying Yoke in chapter 1; pot shelf, dough
trough, milking stool, water trough, hay rack, salt lick, bee smoker, scaffolding, brick hearth, compost fork, tool rack …
later; bellows, grindstone, oak barrels, hand cart, insect hotel, weeder geese, owl box, duck house, seed drill, straw mulch,
master tool chest. Some are the choice-slot options (§8.2). Six favours leave a **small helper** (a lucky horseshoe, a straw
hat and a brass bell that keep birds away, a wind chime against rabbits, lavender against slugs, a bird feeder), and a stray
kitten becomes **Ginger the farm cat**, who strolls about, naps, chases pests and makes the scarecrow work better.

### 9.7 Polish — endless upgrades with diminishing returns

22 polish jobs from chapter 1: *Sharpen the knife*, *Sharpen the axe & saw*, *Clean & oil the shovel*, *Sharpen the hoe*,
*Root out the weeds*, *Air the bed*, *Clean out the well*, *Sweep the fire pit*, *Dress the millstones*, *Re-stuff the
scarecrow*, *Mend the fence*, *Fresh nest straw*, *Tidy the workbench*, *Patch the kiln lining*, *Wax the boots*, *Brush the
cows*, *Clean the hive frames*, *Dust the shelves*, *Oil the loom*, *Re-wedge the hammer*, *Sharpen the shears*, *Tune the
bellows*.
- **Gain:** each polish adds 1 point P; the listed effect is the cap; gain = cap × (1 − 0.5^P) — the first time gives half,
  the next a quarter more, then an eighth …
- **Cost:** base × (1 + whole P) — it rises by the base every time.
- **Wear:** use (or time) takes P down slowly, so polish is also maintenance.
- **Why:** a new *kind* of upgrade is always worth more than grinding the same one, yet there is always something useful to
  do. Some polish also brings something in (rooting out weeds gives fibre).

---

## 10. Progression

### 10.1 Five chapters

| Chapter | Home | Material age | What opens up | Pet |
|---|---|---|---|---|
| 1 · Ashes | Tent | sticks, stones, fibre | campfire and porridge, clearing patches, stone tools, quern and flatbread, chickens, a well | Bunny |
| 2 · Homestead | Cottage | logs, planks, clay, bricks | log shed, compost and tomatoes, bees, woodlot, carpenter and kiln, the cottage in stages, stove, oven and prep table, pond, market stall, barn and cows, butter, the orchard | Tortoise |
| 3 · Smallholding | Cottage | iron, nails | smithy, forge and anvil, iron tools (more plants per patch), sawbench, sheep and cloth, linen from flax, the press (oil, juice, sugar), windmill, fermenting and the cellar (yogurt, cheese, cider, vinegar, pickles), lumbermill | Goat |
| 4 · Village Trade | Farmhouse | steel, glass, hardwood | blast forge and steel tools, drip line, the farmhouse in stages, greenhouse, brickworks, warehouse, master workshop and textile loom, walnuts and olives, pizza, the North Field | Pony |
| 5 · Master Farm | Farmhouse | heirlooms, dyes | Import Broker barter, saffron and heirloom crops, the dye vat and colour mixing, Harvest Fair ribbons, master oven and stove, fine flour, seed library, wind pump, the River Meadow | Alpaca |

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

### 10.3 The five pets

| # | Pet (default name) | Dish | Comfort item | Bonus for good |
|---|---|---|---|---|
| 1 | 🐰 Bunny (Pip) | Carrot-Clover Bowl | Straw Hutch | +1 carrot per harvest |
| 2 | 🐢 Tortoise (Mossy) | Tortoise Garden Platter | Warm Shell House | +1 💧 every water trip |
| 3 | 🐐 Goat (Bramble) | Apple Oat Crumble | Goat Shed | a little compost every question, weeds −15 % |
| 4 | 🐴 Pony (Hazel) | Apple-Carrot Cake | Saddle Blanket (needs the barn stable) | +10 % when selling |
| 5 | 🦙 Alpaca (Alfie) | Golden Honey Cake + Rainbow Roast | Rainbow Quilt | a little wool every question |

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
about 300–400 questions, all five pets after about 700.

### 10.6 Dynamic difficulty — prices that fit the farm *(built, off by default)*

**Aim:** the Goldilocks zone — every goal reachable, but only with real work, and the quickest way through is an improvement
or a polish the child has not tried yet. Switched on in ⚙️ → **🎚️ Prices fit my farm** (or `dynamicDifficulty`).

- **What is measured — the pace:** the worth of everything the player brings in per Time Quiz question (gathered, harvested,
  made, collected; a running average over about 20 questions; things bought don't count). It already contains everything the
  player has: upgrades, polish, perks, gifts, practice stars, meals, a bigger store — and how hard the child works.
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

---

## 11. Friends, rewards and surprises

### 11.1 Favours for neighbours (side quests)

28 favours: 4–5 in chapters 1–4 and 11 in chapter 5 (Tom the shepherd boy is freezing, Granny Maud's goat ran off, porridge
for the hungry twins, a basket for the miller's daughter, a stray kitten …). They **unlock nothing** and never block the
main path: the player hands over things they made or spends energy. The reward is a **picture for the album** — the
neighbour, happy, holding what the player made for them — a bit of luck, sometimes a small helper or a perk, and a **friend**.
Chapter-1 favours open as soon as the building they need exists. While the player has fewer than two friends, the quest book
recommends the favours first.

### 11.2 Postcards and gifts

The people you helped are your **friends** (a person helped twice counts once). When something big happens — a pet arrives,
the library grows, every 12 goals — a friend may hear of it and send a **postcard** with a gift. The chance is 35 % + 20 % per
friend; the very first postcard always comes; the more friends, the more gifts to choose from (1 friend: one gift; 2: pick 1
of 2; 3 or more: pick 1 of 3). A postcard shows the friend's portrait as its stamp. **24 gifts** (deep pockets: +5 storage;
hidden spring: +1 water a trip; early bird: +3 energy max; growth, luck, Rest, pests, reading, sales, freshness, firewood,
muck, stones …). **Only two gifts work at a time**; the others rest in the album, where they are swapped. **Gifts can never
be bought.**

### 11.2b Sound and music

Everyone hears the everyday sounds from the start: a soft click on every button, a sheet sliding up and closing, a right
and a gentle "not quite" answer, harvesting, planting, weeding, digging, chopping, cooking, crafting, the forge, building,
water, coins, collecting from animals, turning a page, and jingles for something new, a new Rest level or a medal. Music
plays by situation: its own loop for the farm in each season, a quiet one for the Time Quiz and a calm one for Rest, faded
in and out. ⚙️ Settings switches music and sounds off separately (on this device), and *🎼 Credits* names who made them.
The extra, fun sounds belong to perks and come with what the perk shows: animal voices (*Farm sounds*), thunder with the
lightning sums, a pluck with the hot streak, coins with the coin shower, a party popper with the harvest party, a glassy
chime with the rainbow and the sparkles, a breeze when the season changes. What plays is data (`data/sounds.json`); only
CC0 or CC-BY sounds are used. Until the sound files are in, the game makes a few little sounds itself.

### 11.3 Perks — prettier and livelier, never stronger

The pop-up for a new perk and its tile in the album say why it came ("You harvested 40 times!", or the favour that
earned it) before what it does.

| Perk | What it does | How it comes |
|---|---|---|
| 🦋 Butterflies | butterflies over the fields | Granny Maud's goat (favour) |
| ✨ Magic sparkles | sparkles where you tap | porridge for the twins (favour) |
| 🔔 Farm sounds | animal voices: hens, cows and sheep call when their pen is tapped and now and then on their own; birdsong | the miller's daughter's basket (favour) |
| 🌈 Rainbows | a rainbow after rain | the washerwoman's line (favour) |
| ⚡ Lightning sums | lightning on about one in three quick Rest sums | 25 quick Rest sums |
| 🔥 Hot streak | a flame counts quick sums in a row | 3 sum medals |
| 🪙 Coin shower | coins fly into the purse when selling | 8 different things sold |
| 🎉 Harvest party | confetti when you harvest everything | 40 harvests |
| 🍃 Season breeze | petals, fluff, leaves or snow | a whole year |

Each can be switched off in the album. The sounds are made by the game itself (no sound files).

### 11.4 Luck and lucky finds

Luck is a hidden number that makes lucky things more likely (chance × (1 + luck)); a 🍀 shows in the top bar while it is
high. Sources: favours (+0.5 for 30 questions), little jobs, a four-leaf clover, each pet (+0.05 for good), a gift. Lucky
events: a lost coin, an old seed packet, a four-leaf clover or a relic while weeding; a quartz in a stone; rain; a double
harvest; a double-yolk egg, a honey flow, a thick fleece; a neighbour's gift basket; a free seed; a golden acorn.

### 11.5 Little jobs, golden acorns, celebrations, the album

- **Little jobs** on the notice board: three small tasks (harvest, weed, make, sell, collect, pick stones, rest) that refill as
  soon as one is done and only ask for what can be done now. Reward: a few coins and a little luck.
- **Seven golden acorns** hide in the game, each found a different way (the first favour, a bookshelf, the first winter, 100
  weeds pulled, the first pet, 10 cards, one by luck while weeding); each gives +3 energy max for good. The album shows the ones
  found and that one more is still hidden.
- **Celebrations.** A new building, tool, gear or helper gets its own window: the picture big, its name, what it does, and
  confetti, stars, fireworks, balloons or sun rays. A new sum medal brings stars and a fanfare.
- **The album 🖼️** holds the pets, the favour pictures, the medals won (big) and the next one to win, the golden acorns, the
  friends and their postcards, the perks owned and the next one to win, and the gifts (at work or resting).

---

## 12. Seasons

A year is four seasons of 30 Time Quiz questions; the season bar in the top bar shows how many are left. Nothing dies;
seasons change speeds and amounts:

| Season | Slower | Plenty |
|---|---|---|
| 🌱 Spring | — | weeds sprout (+50 %, more fibre to pull); rain often |
| ☀️ Summer | fields thirstier (+30 % water), more pests (+50 %) | crops grow 20 % faster; bees +30 % honeycomb |
| 🍂 Autumn | crops 15 % slower | orchard +40 %; branches fall (sticks ×2); rain often |
| ❄️ Winter | crops at half speed; the house burns firewood | frost lifts stones (more to pick); indoor work −10 % energy; thick fleeces; few weeds and pests |

At each change of season, stale food turns (§5.7).

---

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

### 13.3 Screens

- **Top bar:** 🪙 coins; 💧 water and ⚡ energy as rows of cubes (tap water to fetch, energy to Rest); the season bar (one thin
  stripe per question, in the season's colour); 🎒 pantry, 📖 quest book, 🖼️ album, ⚙️ settings.
- **Tap a place → a sheet slides up** with a picture on top and everything to do there: build, stations and recipes, animals,
  polish. Everything with a button is a **tile in a grid** (like the store and the market): a picture or emoji, the name,
  what it gives and costs, and its button at the bottom, as wide as the tile — recipes, crops to plant, weeds and stones on
  a patch, goals and upgrades (two per row), polish, collecting from animals and mucking out, and the knowledge cards.
- **Tap a patch that is still overgrown** and the field's sheet opens with a note on top: which patch it is, what is in the way
  (weeds, rocks, stumps, scrub, marsh) and what clears it, or what is needed first. When planting, a cost the player can't
  pay shows its missing cubes hollow (e.g. the water a full patch needs).
- **Buildings with an inside** (house, barn, workshop) open a window over the dimmed farm showing the room as a cutaway; its
  corners (bed · books · kitchen; cellar · crocks · hay · seed library; benches · kiln & forge · spinning · tools) open their own
  sheets.
- **Bottom bar:** the next story goal (tap: its place glows) and the **Time Quiz clock** (its hour hand goes once round per
  season; tapped, it spins and the quiz opens).
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
- **Celebrations** for new buildings, tools, gear and helpers (§11.5); pests and the scarecrow play out when the farm is seen
  again after the quiz (§6.4).

### 13.5 The farmer

A little farmer walks to wherever the player taps — on the grass, to a place (its sheet opens at once), to the edge of a field —
and finds the way round buildings, pens, ponds and fields; tapped, it waves and hops. It is a small 3D figure made of simple
shapes, toon-shaded and drawn into the 2D map (`scripts/avatar.gd`); its look is data (`data/avatar.json`: skin, hair, shirt,
trousers, shoes, hat). After each action the farmer goes there and acts it out — kneels and pulls weeds, fetches water at
the pond and sows, picks with a basket, chops, hammers, stirs the pot, reads, sits to rest, cheers. The game has already
counted the result; the farmer only catches up, and a new tap stops the act at once. Acts, poses and the props in the
farmer's hands are data (`data/acts.json`), so new ones need no code. **(planned)** a "make your farmer" screen at the start, the look kept per player, gear visible on the
farmer, merchants walking about.

### 13.6 For young readers

- **Font:** Andika (SIL), designed for children learning to read; emojis from Noto Color Emoji, the same on every device.
- **Short sentences**, everyday words, one idea per line; numbers whole (§5.8).
- **🔊 Read aloud** for quiz questions and card pages, where the device has a voice.
- **Big touch targets**, nothing that punishes slowness (§4.3), nothing that dies or is lost for good.
- **(planned)** the whole interface in German (§4.5).

---

## 14. Art direction

- **Style C, bold cartoon:** thick rounded outlines, flat colours, chunky proportions, three-quarter top-down view, soft
  daylight. Pictures stand on a flat base whose footprint is a diamond about twice as wide as deep; shadow falls down-right.
- **Made with OpenArt** (Nano Banana 2, later Nano Banana 2 Lite at 1K) as **sprite sheets on white** (3×3 or 4×4 objects), with
  an earlier sheet as the style reference so everything matches; several versions per sheet, the parent picks the best.
- **Into the game:** `tools/import_art.py` cuts a sheet into transparent sprites by the names in `tools/art_sheets.json`
  (reading order; `-` skips one), makes seamless ground tiles, and turns the generator's grey shadows into see-through dark blue
  so they darken whatever is beneath them.
- **Names follow the data ids** (`assets/map/tent.png`, `assets/items/egg.png`, `assets/animals/animal_cow.png`). A missing picture
  shows the emoji; an upgrade without its own picture keeps the previous one. So pictures can be added one at a time, no code.
- **Final look first, upgrades as add-ons:** each place gets a picture of its final look without anything that is an upgrade of
  its own; upgrades are separate pictures shown when built.
- **The to-do list** is `art-inbox/ART_LIST.csv` (every picture, in the order worth drawing, with a prompt; `tools/art_list.py`
  refreshes it). The folder layout of `assets/` is described in `godot-prototype/README.md`.

---

## 15. Technology

### 15.1 Engine and platforms

- **Godot 4.7** (standard, GDScript), Compatibility renderer, portrait 834×1194, stretched to fit.
- Runs on a computer from the editor, and **in the browser** as a single-threaded web export (`web-build/`) that any HTTPS static
  host can serve; on the iPad it is added to the Home Screen and runs full-screen like an app.
- The earlier HTML5 prototype (1.0–1.1) is kept in `archive/html-prototype/` for reference only.

### 15.2 Data first

Everything about the content is data, so the game can be rebalanced without code:

| File | Holds |
|---|---|
| `data/farm-progression.json` | the whole tree (v0.8): 141 items, 424 nodes (buildings, upgrades, tools, gear, helpers, polish, cards, books, goals, side quests, pets, merchants …), 106 recipes, and the rules in `meta` (energy, water, yields, pricing, market, seasons, pests, freshness, carry, flex …) |
| `data/map_layout.json` | where every place, add-on, corner and decoration stands |
| `data/quiz_packs/*.json` | Time Quiz packs |
| `data/i18n/quiz-<lang>.json` | quiz texts by question id |
| `data/settings.json` | the parent's settings (§4.4) |
| `data/avatar.json` | the farmer's look |
| `data/acts.json` | what the farmer acts out: poses, props, acts |
| `learnkit/curriculum/math.json` | the maths curriculum |

`progression/progression-explorer.html` browses the tree, simulates a playthrough (pacing, Rest per hour, pets, storage and
value checks) and keeps a copy of the current data.

### 15.3 Code

| Part | Does |
|---|---|
| `scripts/game.gd` (autoload `Game`) | the rules engine: time, energy, water, fields, weeds, pests, animals, stations, fuel, knowledge, polish, gear, seasons, freshness, luck, gifts, jobs, dynamic difficulty, saves |
| `scripts/main.gd` | the interface: bars, sheets, inside windows, quizzes, album, settings |
| `scripts/farm_map.gd`, `slot.gd`, `iso_field.gd`, `spots.gd` | the one-screen map, a place, a field, which data node belongs where |
| `scripts/art.gd`, `ui.gd`, `fx.gd`, `avatar.gd`, `sound.gd`, `i18n.gd` | pictures with emoji fallback, styles and explanations, perk effects, the farmer |
| `learnkit/` | the learning kit — learner record, spaced repetition, maths engine, quiz engine, timer, number pad; reusable in any Godot game |

### 15.4 Saves

Per player in Godot's user folder: `players/<name>/farm_save.json` (the farm) and `players/<name>/learning.json` (the learning
record, kept when a new game starts). In the browser they live in that browser on that device.

### 15.5 Checks and tools

- `tests/ui_smoke.tscn` clicks through the opening and checks the systems; `tests/bot.tscn` lets a greedy bot play the rules
  engine through the chapters (`--flex` with dynamic difficulty); `tests/learn_sim.gd` lets a pretend child practise Rest sums.
- `tools/quiz_ids.py` (question ids and translation files), `tools/import_art.py` (cut sprite sheets), `tools/art_list.py`
  (picture list), `tools/make_layout_editor.py` (layout editor), `learnkit/tools/make_editor.py` (learning-record editor).
- How to run all of these: `godot-prototype/README.md` and `00-READ-ME-FIRST.md`.

---

## 16. Glossary

| Word | Meaning |
|---|---|
| **Time Quiz** | general-knowledge questions; each right answer moves farm time one step |
| **Rest** | mental-arithmetic sums that give energy (once "Training") |
| **question** (as a unit of time) | one right Time Quiz answer = one step of farm time |
| **pack** | a file of Time Quiz questions on one topic, chosen by the parent |
| **card** | one idea of farm knowledge; learned by reading and a short quiz; unlocks or boosts |
| **learning kit** | the reusable part with the learning record, sums, quiz engine and timer (`learnkit/`) |
| **learning record** | one child's progress on every sum and question (`learning.json`) |
| **chapter** | one of five stages of the game, each ending with a pet |
| **goal** | a story step in the quest book |
| **node** | anything in the data that can be unlocked or built (building, upgrade, tool, card, goal …) |
| **place / slot** | a spot on the map that data nodes belong to |
| **station** | where recipes are made |
| **category** | the kind of work a cost belongs to (`field`, `cook`, `build` …); upgrades lower costs per category |
| **helper** | an optional upgrade that makes something cheaper or better for good |
| **gear** | worn or used items in 8 slots (bed, pillow, bottle, head, feet, hands, back, apron) |
| **polish** | an endless upgrade with diminishing returns |
| **keeper** | an input that is needed but not used up |
| **add-on** | a picture of an upgrade shown on its place |
| **favour / side quest** | an optional job for a neighbour, who becomes a friend |
| **postcard / gift** | a friend's surprise with a lasting bonus; two work at a time |
| **perk** | a cosmetic extra (butterflies, sounds, rainbows …), never stronger |
| **woodpile** | the fuel store for heat stations; stoked by hand |
| **pace / flex** | dynamic difficulty: the farm's output per question, and the factor that fits new goals to it |
| **explorer** | `progression/progression-explorer.html`, the data browser and playthrough simulation |
| **bot** | the automated test player in `tests/bot.gd` |

---

## Appendix — Where the ideas came from

- **Knowledge discovered by doing:** Factorio 2.0 trigger technologies; Valheim and Minecraft recipe unlocks.
- **A library that grows as you learn:** the Animal Crossing museum. **Books from a visiting seller:** Stardew Valley 1.6.
  **Reading over time:** Kingdom Come: Deliverance.
- **Reviews woven into the quiz:** Khan Academy Mastery Challenges and Leitner boxes; feedback after every pick (Marsh et al.
  2012: with feedback, second-graders' wrong answers carried forward fell from 26 % to 5 %); intrinsic integration of learning and
  play (Habgood & Ainsworth 2011).
- **Arithmetic fluency:** mastery before moving on, spaced retrieval and small sets of new facts (XtraMath, Reflex, Anki);
  generous timing by default (XtraMath); visible progress and titles (Duolingo, Yousician, Times Tables Rock Stars); the Swiss
  Lehrplan 21 and the *Schweizer Zahlenbuch* for the curriculum.
- **Pressure tied to your own growth, with soft failure:** Factorio pollution, RimWorld wealth, Banished tool wear, Rune Factory
  soil, Farthest Frontier and Farming Simulator stones and weeds.
- **One slot with two options:** Stardew sprinkler attachments. **Permanent energy finds:** Stardew Stardrops. **Refilling small
  tasks:** Animal Crossing Nook Miles+. **Polish with diminishing returns:** Cookie Clicker.
- **The map seen at an angle:** Hay Day, FarmVille, Township.
- **Dynamic difficulty:** flow and the Goldilocks zone; the known trap of enemies that level up with the player (followed only in
  part here, §10.6).

---

*End of the master design document. History and decisions: `PROJECT-LOG.md`. Open tasks: `00-READ-ME-FIRST.md`.*

