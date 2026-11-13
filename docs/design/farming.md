# Farming

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 6. Farming

### 6.1 Fields and patches

- **Three fields** of 3 × 3 diamond patches stand in a column in the middle of the map: the **Home Field** (from the start),
  the **North Field** (chapter 4: clear the scrub, then fence it) and the **River Meadow** (chapter 5, optional: drain the
  marsh, then a sluice; it also gives water). Later fields are on the map from the start, overgrown behind a crumbling wall;
  tapping them shows only the mysterious sign until their chapter.
- **The fields have no sign.** The bottom of a patch's window has a titled section **The whole field**: *Harvest all*, *Pick all weeds*, *Pick all stones*
  (each with the number of patches it is for; greyed when there are none), then what can be done on the fields (clearing, new land), the field's
  upgrades and polish, then the pests line. The farmer walks from patch to patch while acting. A small 🔨 shows above the first field when
  something can be built there.
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
  season, the cloches and **crop rotation**: the same crop twice in a row grows 15 % slower (tired soil); after beans or clover
  the next crop grows 10 % faster (rested soil). Weeds and stones do not slow growth any more (they take a share of the harvest, §6.3).
- **Harvests vary** around an average per plant (`meta.yield`): average × (1 + luck × 0.1) × the patch's quality, with a
  random spread of ±22 %, rounded up or down at random so the average holds; whole numbers only, at least 1 of the main crop
  per plant. Upgrades add to it (the bunny +1 carrot per harvest, autumn +40 % in the orchard). Then the **weeds and stones on the
  patch take their share** (§6.3).
- **🧺 Harvest all** at the storage basket harvests every ripe patch at once.

### 6.3 Weeds and stones

- **Weeds** grow on every field patch every question, planted or not: faster with more plants and more fertilizer, faster in
  later chapters (dandelions → docks → thistles → brambles → bindweed), +50 % in spring. One weeding tap
  pulls 3 weeds (energy per weed) and gives plant fibre. The answers: edging and borders, hoes (stick → iron → steel), gloves,
  weeder geese, the goat, straw mulch, and the endless polish **Root out the weeds** (keeps regrowth down; each time also puts
  the weeds into the store as fibre: 2, then 4, 6 …).
- **Frost stones.** In winter, frost lifts stones in every patch (more in deep and bare beds); picking them gives **small stones** (light, 0.5):
  they are for tools, fire rings and small things. **Big rocks** (`boulder`, heavy, 4) are a different item (`nature/04`): they come from the
  shovel (*Dig out big rocks* at the forest edge, *Clear the rocks*, the first steps of clearing a ruin) and are what roads, walls, wells, ovens
  and big buildings are made of. Old saves: what was carried as stone is a big rock now, nothing is lost.
- **What weeds and stones cost** *(crops-and-items/02, the parent's rule of 30 Oct 2026; numbers in `rules/10-farming.json`, `crowding`)*:
  they no longer slow growth. At harvest **every whole weed and every whole stone on the patch takes 4 % of the harvest, together at
  most 75 %**, and the main crop never drops below 1. It is worked out when the patch is harvested, so pulling and picking first gives
  everything back; a half weed is not drawn, cannot be pulled and costs nothing. They also still lower the **grade** of the whole harvest (§8.5).
  A bare patch loses nothing (nothing grows on it); an orchard or greenhouse bed has no weeds. *(Measured with the test bot, 9 Nov 2026: a player who
  clears a ripe patch first loses about 2 % of the harvests, one who lets the weeds stand 5–9 %; the old slowing cost about as much. A neglected patch
  with 12 weeds and 6 stones gives 28 %.)*
- **The loss is seen, not read.** On the map the plants the weeds and stones take (the share, in whole plants) stand **small, grey and
  drooping** while the others stay green (ripe ones glow and sway); pulling the weeds makes them stand up again. At harvest the lost
  crops rise from the patch as **grey ghosts** (one per piece) next to the weeds and stones, while the kept crops fly to the store.
  The patch's window shows a red **🌿🪨 −16 %** with the crops that would be lost in grey, the harvest button shows only the crops that
  stay, and a line says that each weed and stone takes 4 % of the harvest. The log adds "Weeds and stones took …".

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
- **On screen** (played after the quiz, §4.1): the scarecrow throws angry looks (💢😠👀) — as many as
  its level — and the pests it hits fly off; the others fly or crawl to the crops one after another, peck, and speed off
  with a plant. Pests change by chapter: sparrows, rabbits, slugs, caterpillars, voles.

### 6.5 Orchard and greenhouse

- **The orchard** (cleared in chapter 2; 3 tree spots, +2 with the orchard terraces in chapter 5): apple, walnut and olive
  trees are planted once, take long to grow (10–14 questions) and then give a harvest every 4–5 questions for good. A tree
  can be **cut down** (🪓, 3 energy, gives a log and sticks) to plant another kind — so three apple trees never block the
  walnuts the pony's cake needs. Planting a tree costs energy like any other planting: the same field upgrades and skills make
  it cheaper.
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
