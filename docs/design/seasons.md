# Seasons

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 12. Seasons

A year is four seasons of 30 Time Quiz questions; the season bar in the top bar shows how many are left. Nothing dies;
seasons change speeds and amounts:

| Season | Slower | Plenty |
|---|---|---|
| 🌱 Spring | — | weeds sprout (+50 %, more fibre to pull); rain often |
| ☀️ Summer | fields thirstier (+30 % water), more pests (+50 %) | crops grow 20 % faster; bees +30 % honeycomb |
| 🍂 Autumn | crops 15 % slower | orchard +40 %; branches fall (sticks ×2); rain often |
| ❄️ Winter | crops at a quarter of their speed; snow covers the empty patches; only hardy crops can be sown outdoors; the house burns firewood | frost lifts stones (more to pick); indoor work −10 % energy; thick fleeces; few weeds and pests |

At each change of season, stale food turns (§5.7) and a short text says what changes now (growth, weeds, pests, rain, what can be sown; `intro` in the data), next to the market news (§5.3).

**The look of the season.** One shader lies over every picture on the map: in **winter** snow caps sit on every top edge (roofs, tree tops,
fence rails) and the colours are muted and cooler; in **autumn** greens turn golden. Soil and plants keep their own look (muted in winter, no caps).
**Snow** *(built, phase 10)*: in winter the rain is snow; every empty field patch is covered until the farmer clears it (a whole-field action, 1 ⚡ a patch) or spring melts it; nothing can be sown under snow. Outdoors in winter only **hardy** crops (winter wheat, onions, beans, winter kale) can be sown; every other crop's tile says *too cold to sow* (the greenhouse and the orchard do not mind). *(Planned: snow drawn on the ground, bare trees, a smooth change from one season to the next.)*
