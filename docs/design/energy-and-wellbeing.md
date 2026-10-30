# Energy and wellbeing

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 5. Resources and economy

### 5.1 Energy ⚡

Everything the player does costs energy in proportion to the work: gathering, planting, harvesting, weeding, clearing,
building, crafting, cooking, smithing, milking, errands. Every recipe and goal has a **category** (`field`, `plant`,
`harvest`, `weed`, `gather`, `wood`, `build`, `craft`, `smith`, `kiln`, `cook`, `prep`, `mill`, `process`, `textile`,
`animal`, `errand`), and tools, gear, helpers, polish, skill ranks and meals lower the cost per category. Raw effort per
goal grows about twelvefold from chapter 1 to 5; upgrades cut the late costs almost in half — tinkering pays.

*(built, farm-actions)* **One price everywhere.** Every farm chore (fetching water, planting, harvesting, weeding, stones, snow,
cutting a tree, collecting and mucking out, the forest tasks and trips, the village trip, parties and visits, every recipe at a
station) has one written base cost and is priced and done by one module, `G.actions`: *check* says what it costs now and what
is missing, *perform* takes exactly that. The price on a button is the price taken, and a chore works with exactly the
energy it costs. Every coin payment (shops, goals, buildings, animals) goes through one pay function that is blocked while
the Lord's share is owed.

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

### 5.1b Wellbeing: how the farmer feels and what it does to energy *(built, phase 9)*

Six **parameters**, each a number from 0 to 1 that starts at 0.5 ("fine"): 😴 **sleep**, 🍽️ **food** (variety), 💪 **strength**, 🤝 **friends**, 🧘 **calm**, 🎵 **play**. Until chapter 2 they are frozen at 0.5 and nothing
follows from them. The home still sets the base numbers (the table in §5.1); the parameters work like a **dial on top** and, for three of them, as the energy change per question.

*Where they come from.* Every question each parameter moves a small step towards its **target** (`rate`: down 0.01, up 0.015, so it sinks slowly and recovers a little faster; a face warns before it hurts). A target is a floor plus what the farm gives:
- sleep: 0.4 + the sum of `well_sleep` of the beds, pillows, hearth … that are built (data in the nodes' effects);
- food: 0.35 + 0.1 × the number of *different* dishes among the last 6 eaten (so a farm that cooks varied food is fed);
- strength: 0.35 + 0.05 × the skill ranks (the farmer gets stronger by doing) + `well_strength` (gear, training);
- friends: 0.3 + 0.07 × friends made (favours done) + the village's reputation (0.02 per level);
- calm: 0.65 − 0.35 × the farm's **load** + `well_calm` (a bench, books, quiet things);
- play: 0.3 + `well_play` (a whistle, a sketchbook, a party now and then, a visit to a neighbour's farm).
The **load** is how much runs on the farm: (patches + 2 × animals + 2 × the levels of producing buildings) ÷ (that + 30), so it climbs slowly towards 1.

*What they do* (all clamped; at 0.5 everything is exactly the base):
- **energy maximum** × (0.7 + 0.6 × (food + strength) ÷ 2);
- **energy per Rest answer** × (0.7 + 0.6 × sleep);
- **energy change per question** = **+ boost − drain**, where drain = load × (1 − mood)² × 1.5 × (energy per Rest answer), the **mood** being the mean of friends, calm and play. So the drain is at most
  1.5 right sums' worth per question and in practice a small fraction of one; it **stops at zero energy** (no debt). The **boost** comes from helping someone (a favour, a delivery): +0.2 sums' worth for the next 6 questions.
- the **face** on the farmer is the overall mood (the mean of all six): 😄 ≥ 0.75, 🙂 ≥ 0.55, 😐 ≥ 0.4, 😟 ≥ 0.25, 😣 below.
The energy change after a question is shown with the other changes (J4). Nothing is ever lost for good: a low parameter recovers when its cause is mended.

*What the child sees.* The face appears at the end of the energy bar in chapter 2 and opens the **dashboard** (so does tapping the farmer). Rows appear one by one as the cards of the book *Body and mind* are learned (L3): each shows
a bar and the things that lift it. Before that the dashboard shows the face and a hint to read.

*Levers.* Beds, pillows and the hearth lift sleep; different dishes lift food; skill ranks lift strength; favours and the village's trust lift friends; calm falls with the load of the farm and is lifted by the hearth, the barn cat, every pet, a sketchbook and the bench by the pond; play is lifted by the willow whistle, the sketchbook and the little fiddle (small helpers, opened by the cards *Play and music* and *Calm and breathing*). Two things lift a parameter *at once* (it then sinks back at the usual pace): a **party** at the farm (three dishes from the store and 6 ⚡, once in 20 questions: play +0.3, friends +0.15, calm +0.05 and a boost) and a **visit**: now and then (4 % per question, from the first friend) a friend invites you; the visit costs 4 ⚡ and one question, like the walk to the village, and gives a little scene and play +0.25, calm +0.15, friends +0.1. Both are buttons under *Play* on the dashboard once its card is learned. Berit's note *Rest the field. Rest yourself.* is found when the face appears (`c2_berit_note`).
