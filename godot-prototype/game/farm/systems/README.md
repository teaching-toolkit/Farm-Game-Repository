# The farm's systems (`game/farm/systems/`)

`game.gd` (the autoload `Game`, class `FarmGame`) is the front door: it holds the farm's state (`G.S`) and data (`G.D`, `G.items`,
`G.nodes`, `G.recipes`, `G.meta`, `G.settings`), starts, loads and saves the farm, folds the effects of everything done into one table
(`caps`, `g`, `m`; `kits/core/modifiers.gd`), runs one step of time (`step_time`, with the systems registered in `setup_clock`) and
emits the signals the interface listens to (`changed`, `toast`, `gained`, `sold` …). The rules are in the systems, each a script
`class_name Farm<Name>` with a handle `G` to the Game, reached as `G.<system>.<function>`:

| System (`G.…`) | Owns | Calls (most first) |
|---|---|---|
| `seasons` | the season clock, rain, what a season changes, the new-season step, the look's fade (`blend()`) | rewards, inventory, needs |
| `inventory` | the store: batches that remember their season, put in / take out, tags, shelf life, passive producers | seasons, needs, pace |
| `needs` | energy maximum, cost of work (`ecost`), food buffs, Rest sums and their energy | seasons, rewards |
| `pace` | dynamic difficulty (off by default): the running pace and the factors on costs | progression, inventory, crafting, needs |
| `progression` | costs, requirements, steps and waits, unlocking, helpers on stations, clearing jobs that open patches early, `plots()` | pace, rewards, fields, inventory, crafting |
| `fields` | fields, orchard, greenhouse: patches, planting, growth, harvest, weeds, stones, pests, scarecrow, the bucket | inventory, rewards, seasons, needs, progression, crafting |
| `actions` | every chore's check (cost now, what is missing; changes nothing) and perform (spends, runs the chore's effect and follow-ups, reports); base costs in `rules/46-chores.json`; the doer is an input (`G.actions.farmer`). Every farm chore: fetch water, weed, pick stones, clear snow, plant, harvest, cut tree, collect from animals, muck out, the forest tasks and trips, the village trip, recipes at stations, throw a party, visit a friend; `perform_batch` for whole-field chores; it also counts the moments a step holds (a chore's `moments` in the same file, fewer with skill ranks, 24 a step, the one save key `moments`; `check` says `time` when none is left); a pet can do a chore for the farmer (`pet_doer`, `run` without save or message, `register_auto` / `auto_args` for the target): the farmer pays, no moment, no skill practice, no wear | needs, skills, crafting, the owner of each effect |
| `animals` | buying, feeding, collecting, muck (collect and muck out are chores of `actions`; their effects are here) | rewards, progression, pace, inventory, needs |
| `pets` | the pets' blessings and chores, WHEN cards and second rule (`rules/54-pets.json`), one pass per question in `step`; an entry of kind `chore` is one of the farmer's chores done by the pet through `actions` (`_work_chore`: the one place that knows how); a rule is either a blessing (`blessings_of`) or a chore (`chores_of`, offered once its place is built), and choosing a chore for a rule that has a WHEN card and no WHEN sets the `energy` WHEN card ("my energy is above", the farmer's `energy` word) at its default, choosing a blessing frees it again | actions, inventory, fields, needs, conditions |
| `crafting` | stations, recipes, fuel and the woodpile, house firewood, polish (endless upgrades) | inventory, pace, needs, seasons, rewards |
| `trade` | market demand and prices, selling, seeds, merchants, barter, eating | inventory, rewards, pace |
| `reveal` | what is shown when: `shown(id)`, once shown always shown (rules in `data/farm/rules/60-reveal.json`) | the Game (conditions), the interface |
| `quality` | grades (Lumpy / Proper / Fancy): the chances, the expected grade of a crop or a recipe, the price factor (`rules/47-quality.json`) | inventory, fields, crafting, trade |
| `skills` | eight skill families, ranks from batches and gates, what a rank changes (`rules/48-skills.json`); building (`builds`: buildings, stations, helpers, ruins) trains woodwork and construction and its rank lowers a build's materials and energy (`family_of_build`, priced in `pace.node_cost`) | crafting, fields, animals, needs, quality, pace, progression |
| `story` | which story piece is ready and in what order (kinds, rationing, seen, taps, a chapter's frame before the next chapter; data in `data/farm/story/`) | the Game (conditions), the interface (`ui/storybox.gd`, `ui/framescene.gd`) |
| `trip` | the bag (packing, capacity from the carrying thing and strength, load) and the market trip (energy: errand multiplier of boots, road, a borrowed donkey; the walk, the village square, what is bought on the way home; the walk home is the time question's `home_from_village`; `rules/49-trip.json`) | inventory, trade, progression, the interface |
| `knowledge` | knowledge cards, the library, reading, card quizzes, which cards are due and how a review went | rewards, progression, pace |
| `timeq` | the Time Quiz question, the one rule that moves time: `next()` (a retry, a due review, or a pack question; its own random source) and `answered(q, first_try, purpose)` (records it; a right first answer steps time and runs the purpose's follow-up: `farm`, `to_village`, `home_from_village`, `visit`, `into_forest`, `out_of_forest`); the one door for packs (`add_pack`); retry and recent questions by id | knowledge, trip, well, actions, the Game (`step_time`) |
| `rewards` | luck, gift cards, little jobs, golden acorns, perks | crafting, fields, inventory, seasons |
| `people` | the people who are not the farmer: who belongs to a scene (`who`), their data (`person`, `spot`) and what a tapped person says (`line`, the one place for it; today their three lines in turn, nothing saved), and the story visitor (`visit(id)`, started when a visit piece with a `visitor` is shown, and `visitor()`: the person's id, or "" once `visitSteps` questions have passed; in memory only). Data: `rules/58-people.json` | conditions |
| `loose` | the sticks and small stones lying about on the farm: where (a share `u`, `v` of the area, rolled with `G.rng` and saved), the start, one more every few steps up to a most, the chore `pick_loose` (`rules/68-loose.json`) | inventory, actions, the map (`map/loose_things.gd` finds the free spot) |
| `trodden` | the paths that wear in where the farmer walks (visible-work/08): `wear(cell)` (called once per cell and walk by the map's walker), `wear_of(cell)`, `worn()`; a count per cell of the walking grid, a cap below 1, a fade at each change of season (`step`); draw only; the sparse save key `trodden` (absent until the first walk; `rules/69-trodden.json`) | the map (`map/walker.gd` tells it, `map/ground.gd` draws it) |

**Rules of the house** (also in `.claude/skills/farm-game-session/SKILL.md`):
- A new mechanic is a new system file here (or a new function in the system that owns the thing), not new lines in `game.gd` or `main.gd`.
- A system that reads something a condition in the data may ask about registers a **condition word** for it in its `register_words(c)`
  (`kits/core/conditions.gd`; called from `Game._init`), with a note and an example; then `tests/conditions_test.tscn -- --seed=1 --write-words`
  refreshes the word list the data checker reads.
- A system that has to run every step of time registers a function in `Game.setup_clock()`, right after the one it must follow (order is part of
  the rules), and puts what the interface should show into the step's report.
- Functions another system or the interface uses have public names (no leading `_`); the state shared between systems still lives in `G.S`
  (versioned slices per system come with R7).
- The interface (`main.gd`, the tests, the dev flags) calls `G.<system>.<function>`; it should not write into `G.S` (R5 removes the last cases).
- A system is promoted to a kit (`kits/`) when a second game needs it and it no longer names anything of the farm (`docs/sources/2026-10-12-architecture-plan.md` §4.2).

The lists of node types (`goal_types`, `main_types`, `not_auto`, `default_cat`) are data: `rules/05-node-types.json`, filled into `Game` by `load_data()`.
