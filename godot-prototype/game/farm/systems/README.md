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
| `animals` | buying, feeding, collecting, muck | rewards, progression, pace, inventory, needs |
| `crafting` | stations, recipes, fuel and the woodpile, house firewood, polish (endless upgrades) | inventory, pace, needs, seasons, rewards |
| `trade` | market demand and prices, selling, seeds, merchants, barter, eating | inventory, rewards, pace |
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

Not in a system yet: `GOAL_TYPES` in `main.gd` and `NOT_AUTO`, `MAIN_TYPES`, `DEFAULT_CAT` in `game.gd` (what the node types mean; they move to data with R8).
