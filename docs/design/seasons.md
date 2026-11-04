# Seasons and sustainability

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 12. Seasons

A year is four seasons of 30 Time Quiz questions; the season bar in the top bar shows how many are left. Nothing dies;
seasons change speeds and amounts:

| Season | Slower | Plenty |
|---|---|---|
| 🌱 Spring | — | weeds sprout (+50 %, more fibre to pull ×1.5); rain often (30 % a question) |
| ☀️ Summer | fields thirstier (+30 % water), more pests (+50 %), little rain (10 %) | crops grow 20 % faster; bees +30 % honeycomb |
| 🍂 Autumn | crops 15 % slower | weeds slow down (−30 %); orchard +40 %; branches fall (sticks ×2); rain often (30 %) |
| ❄️ Winter | crops at a quarter of their speed; snow covers the empty patches; only hardy crops can be sown outdoors; the house burns firewood | frost lifts stones (stones ×2 at the forest edge); indoor work −10 % energy; thick fleeces (sheep +20 %); few weeds and pests (a fifth); fields need 20 % less water |

At each change of season, stale food turns (§5.7) and one box with the season's picture says what changes now (growth, weeds, pests, rain, what can be sown; `intro` in the data), what there is plenty of and the market news (§5.3), said once; it comes at a quiet moment and the 📜 scroll shows it again (see the story design, news boxes).

**The look of the season.** One shader lies over every picture on the map: in **winter** snow caps sit on every top edge (roofs, tree tops,
fence rails) and the colours are muted and cooler; in **autumn** greens turn golden. Soil and plants keep their own look (muted in winter, no caps).
**Snow**: in winter the rain is snow; every empty field patch is covered until the farmer clears it (a whole-field action, 1 ⚡ a patch) or spring melts it; nothing can be sown under snow. Outdoors in winter only **hardy** crops (winter wheat, onions, beans, winter kale) can be sown; every other crop's tile says *too cold to sow* (the greenhouse and the orchard do not mind). *(Planned: snow drawn on the ground, bare trees, a smooth change from one season to the next.)*

**More of the season's look** *(built, season-look)*: **spring** is full of flowers in the grass (240; summer has 24, autumn and winter none); over the first 10 questions of a season their number moves from the last season's to the new one's, one flower at a time. In **autumn** about 20 leaves drift down over the farm, flipping from side to side (a drawn stand-in until the leaf pictures exist). In **winter** a thin frost sits on the top edge of the field patches and on the road, like the snow caps but lighter. Creatures show only in their seasons: no butterflies, fireflies, bees, slugs or caterpillars in winter (the pet tortoise and the other Helpers stay all year). Out of season only means *not drawn*: pests still eat, animals still give. All of it is look only (`rules/66-season-look.json`; frost strength in `rules/65-feel.json`).

Data: `rules/10-farming.json` (`seasons`); system `G.seasons`. The season's text and the market news (`rules/52-season-prices.json`, §5.3b)
come at each change.

## 12.2 Sustainability: taking only what grows back

The farm can over-use what it lives on, and the consequence is natural, lasts a while and mends itself
([ADR-0004](../adr/0004-natural-consequences.md)). Nothing is ever used up for good.

- **The forest edge** (§5.9): sticks, loose stones and clay are pools that fall with every tap and grow back each question; trees go
  from stump to sapling to tree. A low pool gives less per tap (never less than one piece), and a short advice says so the first
  time and again after 40 questions. Stones hardly come back, so the fields' stones (frost heave in winter) and the quarry folk
  matter. This works from the start; the bars appear with the card *Take only what grows back* (chapter 2).
- **The soil** (§6.2): a patch remembers its last crop. The same crop again grows 15 % slower and is graded lower (*tired soil*);
  after beans or clover the next crop grows 10 % faster and is graded higher (*rested soil*). The patch's window says which.
- **Water** is carried, never free (§5.2), and a hot summer needs more of it.
- *(planned: water as a pool like the forest edge's, herbs in the forest edge's pools, and a Helper who pauses a job and gives the
  farmer a look when advice is ignored: `nature/01`, `nature/02`.)*
