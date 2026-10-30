# Round 4, part 2: pets that work, the medicine chapter, the forest, six chapters

Draft 1 (8 Oct 2026). Proposals for the parent to decide before any data changes. Labels: ✅ decided · 💡 proposed · ❓ open.
Checked against `godot-prototype/data/farm-progression.json` on 8 Oct 2026. Research: `research/story-in-games.md` (Autonauts, Junimo huts).

---

## A. Six chapters

| New | Name | Was | Ends with | Notes |
|---|---|---|---|---|
| 1 | Ashes | 1 | bunny | unchanged |
| 2 | Homestead | 2 | tortoise | unchanged |
| 3 | Smallholding | 3 | goat | unchanged |
| 4 | Village Trade | 4 | pony | unchanged; the steward arrives ✅ |
| **5** | **Healing** ✅ (or *Medicine*; German *Heilkunde*) | new | **badger** ✅ | the still-room, the forest screen, medicine |
| 6 | Master Farm | 5 | alpaca | the 52 nodes of the old chapter 5 move here |

**What changes in the data** (checked):
- `chapters` gets a sixth entry; every node with `chapter: 5` becomes `6` (52 nodes: 11 favours, 8 buildings, 8 cards, 5 stations,
  4 crops, 4 deliveries, 3 land jobs, 3 helpers, 2 books, the broker, the alpaca, the living-soil beds, 1 gear).
- `pet_alpaca` requires `pet_pony` today → **`pet_badger`**. `import_broker` requires `pet_pony` ("opens chapter 5") → 💡 **`pet_badger`**,
  so the broker opens chapter 6 as before.
- Move into chapter 5 💡: `sq_healer_garden` (Wren), `sq_lamp_maker` (Ferdinand), and the helper `copper_still` ("Herb Drying Loft",
  now chapter 5 in the data).
- `scripts/game.gd` has pet lists written into the code (two places): add `pet_badger`.
- **Pace:** the explorer says about 21 hours today. A medicine chapter of the usual size adds about 3–4 hours. ✅ About 25 hours is fine.

---

## B. The pets get jobs 💡

### Principles
1. **Learning stays the economy** ✅: a pet acts **once per Time Quiz question** (the same tick as everything else). No play, no work.
2. **Start simple, grow with the child:** on return a pet does **one fixed job**; later the child **chooses** the job; later still the child
   sets **when** it happens. Two rules per pet at the end, read top to bottom, like a tiny program (Autonauts teaches bots with
   Scratch-style blocks; Stardew's Junimo huts simply harvest what is near). This is the "Factorio" part, sized for an 8-year-old.
3. **Pets never make things worse.** A rule that cannot run just waits, and the pet shows why (a thought bubble: 💤 nothing to do, 📦 store
   full, 🥕 no carrots).
4. **You can see them work:** the pet walks to the place and acts (the actor system already does this for the farmer, `data/acts.json`).
5. Today's small bonuses (`+1 carrot`, `+1 water per question`, weeds −15 % and compost, +10 % selling, wool) become each pet's **first job**,
   so nothing already balanced is lost.

### The job board (one per pet, in its sheet)

```
 🐰 Pip                         ← tap a card to choose another
 ┌──────────────┐   ┌────────────────────────┐
 │ WHEN          │ → │ DO                      │
 │ weeds ≥ 5 🌿  │   │ pull weeds on that patch │
 └──────────────┘   └────────────────────────┘
 ┌──────────────┐   ┌────────────────────────┐
 │ OTHERWISE     │ → │ sow clover on an empty  │
 │               │   │ patch (rests the soil)  │
 └──────────────┘   └────────────────────────┘
 Last question: pulled 3 weeds on patch 4.
```

Levels (💡 opened by the pet's comfort-item upgrades or by the next chapter's cards):
- **Level 1** (on return): one DO card, fixed, always on.
- **Level 2:** choose the DO card from 2–3.
- **Level 3:** add a WHEN card (a condition with a number the child sets with + and −).
- **Level 4:** a second rule ("otherwise"). The order matters, which is the lesson.

### Each pet's cards (first list)

| Pet | DO cards | WHEN cards | Level 1 (today's bonus) |
|---|---|---|---|
| 🐰 Bunny | pull weeds on a patch · sow clover on an empty patch (rested soil, +10 % next crop, a real rule in the game) · nibble the extra carrot tops (+1 carrot) | weeds ≥ N · a patch is empty | +1 carrot per carrot harvest |
| 🐢 Tortoise | bring water · water a planted patch · fill the animals' trough | water < N · not raining | +1 💧 per question |
| 🐐 Goat | graze weeds · turn the compost (+compost) · clear scrub on the North Field | weeds ≥ N · compost < N | weeds −15 %, 1 compost per 4 questions |
| 🐴 Pony | carry surplus to market and sell it · carry an order to the village · fetch from a merchant | the store has ≥ N of X ("sell carrots when I have more than 20") | +10 % when selling |
| 🦡 Badger | gather a herb in the forest · turn the drying rack · make a simple tea or syrup | herbs < N · a remedy is missing in the chest | ❓ new: dries herbs by himself |
| 🦙 Alpaca | guard the fields (chase pests) · give wool · watch the animals (less muck) | pests ≥ N | 1 wool per 4 questions |

✅ **All four levels** (parent, 8 Oct 2026). 💡 A parent setting could still switch the WHEN cards off if a child finds them too much.

---

## C. The medicine chapter 💡

### Story
Illness comes to Hazelwood (a winter cough, children first). Wren the healer cannot do it alone. You clear the matriarch's **still-room**
(the new ruin, `ruins_stillroom`), learn plants from the forest and the fields, build the stations, and make remedies. The village needs you;
you are needed, not only tolerated. The badger comes home when you make **really good medicine** ✅. In the forest, once, you see the conch
from afar ✅ and do not go closer.

### What "really good medicine" means in the game
The game has no quality stars (an old decision). So 💡 the badger's dish is the **Healer's Chest**: a box holding several different
remedies, each needing the right part of the right plant, picked in its season, dried properly. The comfort item ✅: a **tea set** (clay
from the kiln; the badger's spine is "tea first").

### Stations (in the still-room) 💡
Drying rack · mortar and pestle · tea pot (infusions) · syrup pan (honey or sugar; both exist in the game) · salve pot (oil and beeswax;
both exist) · infusion jars in the sun (oils) · later a small **still** for lavender water (glass from chapter 4).

### Remedies, simplified but real 💡 (to check against sources and for the parent to review before anything ships)

| Remedy | From | For (traditional use) | Note |
|---|---|---|---|
| Chamomile tea | chamomile flowers, dried | an upset tummy, sleep | |
| Peppermint tea | peppermint leaves | an upset tummy | grows in the garden |
| Elderflower and lime-blossom tea | elder and linden flowers | a cold, to sweat it out | elder *berries* must be cooked |
| Thyme and honey syrup | thyme, honey | a cough | |
| Plantain leaf, crushed | ribwort plantain | an insect bite or sting | the classic field remedy |
| Marigold salve | calendula flowers, oil, beeswax | small cuts, sunburn on the skin | EMA: skin use, minor wounds and sunburn |
| Yarrow | yarrow leaves | a small cut | look-alike danger (below) |
| Willow-bark tea | willow bark (spring) | fever, aches | the plant behind the story of aspirin (salicin) |
| Arnica salve | arnica flowers | bruises, **on the skin only** | poisonous if swallowed |
| Sage gargle | sage leaves | a sore throat | |
| Lavender water | lavender, the still | calm, a cool wash | |

**Look-alikes as gameplay** (the "find the right one" game; real lessons):
- **Wild garlic** vs **lily of the valley** and **autumn crocus**: wild garlic leaves have their own thin stalk and smell of garlic;
  autumn crocus is highly poisonous (Tox Info Suisse records deaths in Switzerland).
- **Yarrow** vs **hemlock** (a white umbellifer): yarrow's leaves are feathery and finely cut; hemlock has purple-spotted, smooth stems.
- **Foxglove:** a real heart medicine, so strong that only doctors may use it; poison for everyone else. A card, not a recipe.

**Safety rules for every text** ✅ spirit / 💡 wording: "In the old days people …"; no doses or amounts a child could copy; every remedy
card ends with "Today: ask a grown-up or a doctor"; "never eat a wild plant you are not sure about".

### Checking with Wren, or not ✅ (parent, 8 Oct 2026)

The badger only comes home at the **end** of chapter 5, so he cannot help while you learn. Instead:

- **You can pick the wrong plant.** Nothing stops you in the forest.
- **You can have your plants checked:** a quick **visit to Wren's place** (a pop-up scene, like the village-square scenes) where Wren
  looks through your basket and points out anything wrong. It costs **a tiny favour**: a small dish, or a little salve or paste.
- **If you skip the check and something was wrong,** and you use it: you wake up **in bed, poisoned**: all energy gone, **all coins
  gone** ✅, and a grumpy Wren next to the bed: *"What were you thinking!"*
- **Why the coins are gone** ✅: when you felt the poison, you set off down the road for help and collapsed. You were found unconscious;
  your purse was not on you any more. (Nobody knows where it went. 💡 Never Mumyo: he moves things, he does not take them.)
- **Getting well** ✅: for the next few Time Quiz questions (💡 about 6) **every job costs double energy** until you are completely well
  again. 💡 The game already has a timed energy multiplier (`S["buff"]`, used by food); a poisoning can use the same with ×2.
- The point (parent): **natural consequences and a no-brainer trade-off** (a small cost for safety against a reckless risk), safely
  inside a game. The lesson matches real life: have a plant checked by someone who knows.
- ⚠️ This is a deliberate **exception** to the standing rule "nothing that punishes the child" (`00-READ-ME-FIRST.md` §4.6), decided by
  the parent. 💡 Design notes to keep it fair: (1) it can only happen if the check was skipped, never by bad luck; (2) the check is
  always offered, cheap and one tap away, right when you come out of the forest and again before you use the plants; (3) the first
  time, Wren explains the check in a story box, so nobody falls into it unwarned; (4) nothing is lost for good: the farm, the animals,
  the stores and the Helpers stay; (5) ✅ all coins: the setback is meant to sting, because skipping the check is really dangerous.
- 💡 After the badger comes home, he can do the checking (a job card: *check the basket*), so the risk fades as you master it.

### Knowledge
A new book 💡 *The Healer's Herbal* (about 8–10 cards, one idea each, same as the other books): plant parts and seasons, drying, teas,
syrups, salves, look-alikes, foxglove, the willow and aspirin.

---

## D. The forest screen 💡

- **Getting in:** in chapter 5 the forest edge place (`wild_edge`, "Field Edge & Woods") gets a tile **🌲 Into the forest**. Going in and
  coming out each cost **one Time Quiz question** ✅ (the path is a question).
- **The screen:** one painted forest, upright like the farm, with about 8 spots: a glade, the stream bank, an old oak, a moonstone, a hedge,
  the shady floor, a clearing with flowers, a willow by the water. Tap a spot, your avatar walks there.
- **Tasks at a spot:** *find* (pick the right plant among 3–4 pictures: the game's picture questions already do this), *pick carefully*
  (the right part: flower, leaf, bark or root), *dig* (roots, with the right tool). Each costs a little energy, as gathering does now.
- **Seasons:** plants show only in their season (flowers in summer, bark in spring, roots in autumn), so the seasons matter.
- **Basket:** carry a few things per trip (the gathering basket and later gear make it bigger).
- **Spots refill** after Time Quiz questions, like the field edge.
- **Surprises** (story): a squirrel's acorn stash, a humming moonstone, a Mumyo trace, once the conch far off ✅.
- **Before the badger:** nobody stops you; you can have your basket checked at Wren's (see C). **After:** the badger can be set to gather and to check (job board).
- **In chapter 6** the forest stays open, for dye plants (walnut husks, birch leaves, …) and the herbs.

---

## E. Order of building (for Round 8) 💡

1. The story engine (story pieces, the 📜 scroll, bubbles) with chapter 1 texts.
2. Six chapters in the data (renumbering, the badger as a placeholder, the broker and alpaca moved) and the bot and explorer re-run.
3. Pets level 1 made visible (they walk and act); then the job board, level 2.
4. The medicine chapter: the still-room, stations, remedies, cards.
5. The forest screen.
6. Pets levels 3–4, if play-testing says the child wants them.

## F. Answers (8 Oct 2026) and what is still open

- ✅ Chapter 5 is *Healing* (or *Medicine*); about 25 hours is fine; a Time Quiz question into and out of the forest; the job board goes to
  level 4; the badger's comfort item is a tea set; the remedy list stays as it is (no St John's wort).
- ✅ The Wren check and the poisoning consequence (section C).
- ✅ Coins after a poisoning: **all**, plus double energy costs for a few questions while you recover.
- ✅ Wren is a **woman**, the herb woman from the next valley, and **young Greenstem's mentor** (`characters/hazelwood-people.md`).

## Sources for the plant facts so far
- EMA, [Calendulae flos](https://www.ema.europa.eu/en/medicines/herbal/calendulae-flos) (traditional skin use, minor wounds, sunburn)
- Tox Info Suisse, [Wild garlic's toxic look-alikes](https://www.toxinfo.ch/wild_garlics_toxic_lookalikes)
- McGill Office for Science and Society, [willow bark, salicin and aspirin](https://www.mcgill.ca/oss/node/9247)
