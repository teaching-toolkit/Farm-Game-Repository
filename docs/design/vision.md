# Vision, principles and the core loop

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 1. Vision

### 1.1 Premise

A craft-from-scratch farming game in an old-world, pre-industrial setting. The player comes back to a farm that has burnt
down. A borrowed tent stands where the house was; Berit's box holds an old dented bucket, a tin pot and the farm book, and
the one live patch has a single wheat seed to find. From there the player rebuilds everything: fire and porridge first, then stone tools, a
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
