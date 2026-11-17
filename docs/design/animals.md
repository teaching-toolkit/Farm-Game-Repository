# Animals

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 7. Animals

| Animal | Ch | Price | Feed per collection | Gives |
|---|---:|---|---|---|
| 🐔 Chickens | 1 | 450 bronze | 2 of any feed grain, ½ straw, water | 1 egg, sometimes a feather |
| 🐄 Cows | 2 | 600 bronze (needs the barn) | 3 of any fodder, 1 straw, water | 1 milk |
| 🐝 Bees (straw skeps, later wooden hives, bee garden) | 2 | 150 bronze, 4 straw, 1 rope | none — they need **flowering crops** somewhere on the farm (clover, sunflower, flax, berries, herbs, fruit trees) | 1 honeycomb |
| 🐑 Sheep | 3 | 1500 bronze (sheep pen, shears) | 2 of any fodder, 1 straw, water | 2 wool |

- Each animal kind is collected from when it is ready again (a few questions), all at once; the pen or building sets how
  many fit (coop → bigger coop, barn tiers for cows and sheep).
- **Muck.** Every collection leaves muck (hens 0.3, cows 1, sheep 0.6 per animal). Above 4 per animal the animals give 25 %
  less, above 8 half. **Mucking out** costs energy and gives manure — which becomes compost. Perches, a drain gutter and a
  card reduce it.
- **The fence round a pen.** Chickens, cows and sheep live behind a fence that starts **broken** (hens wander off, wool snags
  on the wire): the pen gives about 10 % less (`fence.broken` 0.9 in `data/farm/rules/10-farming.json`). Two optional upgrades,
  one after the other, for each pen (`data/farm/nodes/15-pen-fences.json`, shown in the pen's window): **mended**
  (`pen_fence_<animal>_1`: the normal yield) and **sturdy and painted** (`_2`, which replaces the first: a small bonus, `fence.sturdyBonus`
  0.05 = about 5 % more). The same three numbers for every fenced pen; the bees have no fence. The materials are those of the chapter
  the pen comes in: sticks and rope to mend; to make it sturdy logs (hens, chapter 1), planks (cows, chapter 2), planks and nails
  (sheep, chapter 3). The stage is the upgrades' effect `fence:<animal node>` (0 none, 1 mended, 2 sturdy; read by
  `FarmAnimals.fence_stage` / `fence_factor`, which the collection multiplies in), so an older save simply starts broken. The
  window of a broken pen says so in one line. **(planned)** the new look of the fence (a hen outside, wool on the wire), with `pictures/13`:
  until then the old fence is drawn at every stage.
- The condition word `animals:<animal node>` counts the animals of a kind now (`animals:animal_chicken>=2`), for story pieces and other `when` lists.
- Animals without feed or water simply wait; they never get sick, die or leave.
- Products feed the chains: eggs (cakes, omelettes, the tomato unlock), milk (butter, yogurt, cheese), honeycomb (honey and
  beeswax: candles, waxed boots and gloves), wool (yarn, cloth, blankets).
- The animals walk about their pens, turn the way they walk and hop. **Pets** are separate (§10.3).
