# Core kit (`kits/core/`)

The small parts every game built on these kits needs. They know nothing about farming (or any game): a game hands them its data and
its rules. Plain scripts, relative paths, no autoloads and no `class_name`s, so the folder can be copied into another project.
Tested by `tests/core_test.gd` (part of `bash tests/check_all.sh`).

| Script | Does | Used by the farm for |
|---|---|---|
| `modifiers.gd` | Folds effects (`set`, `add`, `mult`, `produces`) from many sources into one table; `value(table, key, default)`, `mult(table, key)`. A weight below 1 gives diminishing returns. | `Game.caps()`, `g()`, `m()`: every node's effects, polish, gift cards |
| `conditions.gd` | One condition language for data: `unlocked:<id>` / `done:<id>`, and `<counter>>=<n>`. The game supplies `done(id)` and `counter(name)`. | `Game.cond()`: golden acorns, perks |
| `rng.gd` | The seedable random source (a `RandomNumberGenerator` with `shuffle`, `chance`, `pick`). All rules draw from it, never from the engine's global functions; a seed gives the same game (`--seed=N`). | `Game.rng` |
| `clock.gd` | One step of time: systems register a function under a name (at the end, or after/before another); `run(report)` calls them in order, each filling the report. | `Game.step_time()`, with the systems registered in `Game._setup_clock()` |

**Still to come** (the architecture plan, `planning/2026-10-12-architecture-plan.md` §4.1): `events.gd` (the signals every system emits,
in R4 when the systems are split out of `game.gd`), `saves.gd` (versioned saves, R7), `data.gd` (loading and merging data files, R8).

**To add a system to the clock:** write its function (it gets the step's report dictionary), register it in `_setup_clock()` right after
the system it has to follow, and put what the interface should show into the report.
