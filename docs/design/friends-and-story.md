# Friends, rewards, surprises and the story

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

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

Each can be switched off in the album. Their sounds come with them (§11.2b).

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

### 11.6 The story *(built: the engine and chapter 1; the rest follows the chapters)*

The story reaches the child as **story pieces** (`godot-prototype/data/farm/story/`, one entry per piece; the canon, the people and the texts live in `story/`).
Kinds: **frame** (the grandchildren at the bed, at the start and between chapters), **beat** (a plot step that hangs on a goal the child must do), **discovery**
(what you find when you first tap something or finish a job), **letter**, **moment** and **visit** (small scenes with people), **scene** (the village square),
**bark** (one line, a speech bubble tapped away) and **trace** (no text). A piece has a chapter, conditions (`done:<goal>`, `tap:<place>`, `page:<card>`,
`step>=n`, `seen:<piece>`, `after:<piece>:<n>` …, all must hold) and shows once, except barks, which come back after 12 questions.
**Rules of showing:** only when the farm is quiet (no Time Quiz, Rest, pop-up, celebration or open window; a discovery may come over a window); one box at a
time; if several are ready: frame, beat, discovery, letter, moment, visit, scene, bark; **one unprompted piece (moment, visit, letter) per 3 questions**; no
real-time gating. A story box has a picture or an emoji, 2–4 short sentences, 🔊 like the cards, one big button, and from the second viewing a **Skip**.
The **📜 scroll** in the top bar appears with the first piece read and lists what was read, a chapter at a time; a tap reads a piece again. The opening of
a new game is the bedside frame, then the nibbled stalk, then a short *How to play* hint (what the old welcome taught). German texts follow the English
ones (the *Du* form, „ss“, no gendered word for the farmer). The bot never opens a box; the data checker knows every condition.

### 11.7 Free play after the story *(built, phase 12)*

When the alpaca has come home the story is over; no epilogue follows. The pets' job boards open fully (§10.3), and six **loose ends** become optional goals in the village (each with a short box and a picture for the album, no grandchildren): a table for the family (the cousin), everything to count for Quill, a chest for Greenstem (with Wren), flour for the miller, a name for the squirrel (Lark; the reward is the
*shooting stars* perk) and a bowl of milk for the night garden (the reward is the *fireflies* perk; the unsaid thing stays unsaid). Costs are things the farm makes (pies, remedies, flour, a cake, milk). *(Planned: more side quests and add-ons.)*
