# Hazelwood Harvest: the game's design

How the game works and why, one file per system. It describes the **game as built**, not its history or the work still to do.
The last full pass matched version 0.10.0; later systems were added as they were built, and `design-paper/01` (D1) brings the
rest up to date. Until 30 Oct 2026 this was one file, `farm-quiz-game-master-design-document.md` (version 2.2); git has it.

- **The data is the source of truth for numbers** (`godot-prototype/data/farm/`; the explorer in `progression/` shows it). If
  the data and these files disagree, the data wins and the file is corrected.
- **Status marks:** everything is built unless marked **(planned)** (decided, not built) or **(idea)** (not decided).
- **Keeping it current:** a ticket names the one file it changes; when the game's behaviour changes, that file changes in the
  same session (the end-of-session rule in `.claude/skills/farm-game-session/SKILL.md`).
- **Words** are in `../../GLOSSARY.md`; lasting decisions in `../adr/`.

| File | Old § | What it covers |
|---|---|---|
| [vision.md](vision.md) | 1–3 | Premise, who it is for, what the child learns, design principles, the core loop |
| [time-quiz.md](time-quiz.md) | 4.1 | The Time Quiz, the farm's clock |
| [knowledge.md](knowledge.md) | 4.2 | Cards, books and the library |
| [rest.md](rest.md) | 4.3 | Rest: energy from mental arithmetic |
| [learning-record.md](learning-record.md) | 4.4–4.5 | The learning record, the parent's controls, languages |
| [energy-and-wellbeing.md](energy-and-wellbeing.md) | 5.1, 5.1b | Energy and the six wellbeing parameters |
| [water.md](water.md) | 5.2 | Water |
| [money-and-market.md](money-and-market.md) | 5.3, 5.3b, 5.3c | Coins, the market, the bag and the trip, the Lord's share |
| [forest-and-still-room.md](forest-and-still-room.md) | 5.9, 5.10 | The forest edge, the forest screen, the still-room, Wren's check |
| [store-and-materials.md](store-and-materials.md) | 5.4–5.8 | Seeds, materials and the store, fuel, freshness, numbers on screen |
| [farming.md](farming.md) | 6 | Fields, planting, weeds and stones, pests, orchard and greenhouse, crops |
| [animals.md](animals.md) | 7 | Animals |
| [making-things.md](making-things.md) | 8 | Stations, recipes, long chains, quality, skills |
| [building-and-upgrading.md](building-and-upgrading.md) | 9 | Places, stages, ruins, tools, gear, helpers, polish |
| [progression.md](progression.md) | 10 | Chapters, what opens what, pets, merchants, pacing, dynamic difficulty |
| [friends-and-story.md](friends-and-story.md) | 11 | Favours, postcards, sound, perks, luck, little jobs, the story, free play |
| [seasons.md](seasons.md) | 12 | Seasons |
| [map-and-interface.md](map-and-interface.md) | 13 | The map, what is shown when, screens, pictures, the farmer, young readers |
| [art-direction.md](art-direction.md) | 14 | Art direction |
| [technology.md](technology.md) | 15 | Engine, data, code, saves, checks |
| [idea-sources.md](idea-sources.md) | Appendix | Where the ideas came from |

The old §16 glossary is now part of `../../GLOSSARY.md`.

## Where to change a number

Every number lives in data under `godot-prototype/data/farm/`; the data wins over any document. Change it there, never in a script.
The rule files are in `rules/`, one per system.

| To change … | Edit |
|---|---|
| How the game *feels*: playback pauses and rain, plant flicking, how long notes stay and how many stack, story ration and bark rest, story picture height, grown-up lock, snow caps | `rules/65-feel.json` |
| What a chore costs (energy, water) and what it trains | `rules/46-chores.json` (Wren's bucket: `rules/57-forest.json`, `forest.wren`) |
| Weeds, water, pests, stones, crop rotation, harvests, carrying, seasons, freshness, muck, fuel | `rules/10-farming.json` |
| Rest sums, the Time Quiz, knowledge cards | `rules/20-learning.json` |
| Tool polish, building | `rules/30-crafting.json` |
| Market, prices from ingredients, bronze and gold | `rules/40-economy.json`; seasonal prices `rules/52-season-prices.json`; trust `rules/51-trust.json` |
| Weights, quality grades, skills | `rules/45-weight.json`, `rules/47-quality.json`, `rules/48-skills.json` |
| The village trip and the bag; the gate; the Lord's share | `rules/49-trip.json`, `rules/50-gate.json`, `rules/53-lord.json` |
| Luck, gift cards, jobs, acorns, perks, postcards | `rules/50-rewards.json` |
| Pets' jobs, wellbeing, nature, the forest and Wren | `rules/54-pets.json`, `rules/55-well.json`, `rules/56-nature.json`, `rules/57-forest.json` |
| What is shown when (reveal) | `rules/60-reveal.json` |
| Goals, buildings, books, cards and their costs | `nodes/*.json` |
| Item values, recipes, chapters, the start | `items.json`, `recipes.json`, `chapters.json`, `start.json` |
| Story pieces | `story/*.json` (German in `data/i18n/`) |

## Key numbers (as of 24 Oct 2026; update when the data changes)

Data v0.8: 182 items, 461 nodes, 131 recipes, 43 stations, 87 cards in 14 books, 22 polish jobs, 58 helpers, 28 side quests.
Explorer playthrough: about 21.2 hours, ~1,417 Time Quiz answers, ~1,380 Rest answers; pets at about 1.6 / 5.8 / 12 / 17 / 20 h.
Quiz packs: Farm basics (FRM, 4), Continents (CON, 12), Farm pictures (PIC, 18) + card questions KNW-001…261.
