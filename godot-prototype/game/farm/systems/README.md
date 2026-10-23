# The farm's systems (`game/farm/systems/`)

`game.gd` (the autoload `Game`, class `FarmGame`) is the front door: it holds the farm's state (`G.S`) and data (`G.D`, `G.items`,
`G.nodes`, `G.recipes`, `G.meta`, `G.settings`), starts, loads and saves the farm, folds the effects of everything done into one table
(`caps`, `g`, `m`; `kits/core/modifiers.gd`), runs one step of time (`step_time`, with the systems registered in `setup_clock`) and
emits the signals the interface listens to (`changed`, `toast`, `gained`, `sold` …). The rules are in the systems, each a script
`class_name Farm<Name>` with a handle `G` to the Game, reached as `G.<system>.<function>`:

| System (`G.…`) | Owns | Calls (most first) |
|---|---|---|
| `seasons` | the season clock, rain, what a season changes, the new-season step | rewards, inventory, needs |
| `inventory` | the store: batches that remember their season, put in / take out, tags, shelf life, passive producers | seasons, needs, pace |
| `needs` | energy maximum, cost of work (`ecost`), food buffs, Rest sums and their energy | seasons, rewards |
| `pace` | dynamic difficulty (off by default): the running pace and the factors on costs | progression, inventory, crafting, needs |
| `progression` | costs, requirements, steps and waits, unlocking, helpers on stations, clearing jobs that open patches early, `plots()` | pace, rewards, fields, inventory, crafting |
| `fields` | fields, orchard, greenhouse: patches, planting, growth, harvest, weeds, stones, pests, scarecrow, the bucket | inventory, rewards, seasons, needs, progression, crafting |
| `actions` | every chore's check (cost now, what is missing; changes nothing) and perform (spends, runs the chore's effect and follow-ups, reports); base costs in `rules/46-chores.json`; the doer is an input (`G.actions.farmer`). So far: fetch water, weed, pick stones, clear snow, plant, harvest, cut tree, collect from animals, muck out, throw a party, visit a friend; `perform_batch` for whole-field chores | needs, skills, crafting, the owner of each effect |
| `animals` | buying, feeding, collecting, muck (collect and muck out are chores of `actions`; their effects are here) | rewards, progression, pace, inventory, needs |
| `crafting` | stations, recipes, fuel and the woodpile, house firewood, polish (endless upgrades) | inventory, pace, needs, seasons, rewards |
| `trade` | market demand and prices, selling, seeds, merchants, barter, eating | inventory, rewards, pace |
| `reveal` | what is shown when: `shown(id)`, once shown always shown (rules in `data/farm/rules/60-reveal.json`) | the Game (conditions), the interface |
| `quality` | grades (Lumpy / Proper / Fancy): the chances, the expected grade of a crop or a recipe, the price factor (`rules/47-quality.json`) | inventory, fields, crafting, trade |
| `skills` | eight skill families, ranks from batches and gates, what a rank changes (`rules/48-skills.json`) | crafting, fields, animals, needs, quality |
| `story` | which story piece is ready and in what order (kinds, rationing, seen, taps; data in `data/farm/story/`) | the Game (conditions), the interface (`ui/storybox.gd`) |
| `trip` | the bag (packing, capacity from the carrying thing, load) and the market trip (energy, the walk, the village square, what is bought on the way home; `rules/49-trip.json`) | inventory, trade, progression, the interface |
| `knowledge` | knowledge cards, the library, reading, card quizzes, the Time Quiz (next question, retries, results) | rewards, progression, pace |
| `rewards` | luck, gift cards, little jobs, golden acorns, perks | crafting, fields, inventory, seasons |

**Rules of the house** (also in `claude-skills/farm-game-session/SKILL.md`):
- A new mechanic is a new system file here (or a new function in the system that owns the thing), not new lines in `game.gd` or `main.gd`.
- A system that has to run every step of time registers a function in `Game.setup_clock()`, right after the one it must follow (order is part of
  the rules), and puts what the interface should show into the step's report.
- Functions another system or the interface uses have public names (no leading `_`); the state shared between systems still lives in `G.S`
  (versioned slices per system come with R7).
- The interface (`main.gd`, the tests, the dev flags) calls `G.<system>.<function>`; it should not write into `G.S` (R5 removes the last cases).
- A system is promoted to a kit (`kits/`) when a second game needs it and it no longer names anything of the farm (`planning/2026-10-12-architecture-plan.md` §4.2).

The lists of node types (`goal_types`, `main_types`, `not_auto`, `default_cat`) are data: `rules/05-node-types.json`, filled into `Game` by `load_data()`.
