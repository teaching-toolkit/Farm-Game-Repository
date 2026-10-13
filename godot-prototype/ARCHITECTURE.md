# Hazelwood Harvest — how the code is built

Written 12 Oct 2026 after the restructuring (phase 2, slices R0–R8; the plan and its reasons:
`../planning/2026-10-12-architecture-plan.md`). This file describes the code **as it is**; keep it true when the structure changes.

## 1. Three layers

```
 game/farm/        THIS GAME: the farm's rules (systems), its screens (ui), its map, its places and dev flags
     ▲  uses
 kits/             PARTS THAT KNOW NOTHING ABOUT FARMING: learn, ui, avatar, audio, i18n, world, core
     ▲  uses
 kits/core/        modifiers · conditions · random numbers · clock · saves
 data/             everything that is content: numbers, texts, places, sounds, questions (no code changes for content)
```

Rules that keep it that way:
1. **Dependencies point down.** A kit never preloads anything from `game/`; the core never preloads a kit.
2. **Content is data.** Places, pets, chapters, items, nodes, recipes, rules, texts, sounds, questions live in `data/`.
3. **Commands go in, signals come out.** The screen calls the rules (`G.harvest(…)`); the rules tell the screen through the signals
   on `Game` (`changed`, `toast`, `gained`, `sold`, `celebrate`, `step_done`, `offer_cards`, `ask_name`). The screen never
   changes `G.S` itself (a few old places in `ui/` still do for tests and cheats; don't add more).
4. **One front door.** `Game` (autoload, `game/farm/game.gd`) holds the data and the state `S`, the players and saves, the
   signals, the core parts and the clock. Every rule function is still callable on it under its old name and passes the call on to
   its system; new code may call a system directly (`G.sys_fields.harvest(…)`).
5. **Kits:** no `class_name`, no autoloads of their own, relative preloads inside the kit (`preload("srs.gd")`), a README each.
   They read some of the farm's data files by fixed paths today (sounds, avatar, acts, languages): the game should hand those in
   when a second game needs them.
6. **Generalise only as needed** (decision §11): the systems stay in `game/farm/systems/` until a second game (the quarry
   spin-off, very hypothetical) needs them farm-free; each says which kit it would become.

## 2. Where things are

| Folder / file | What |
|---|---|
| `kits/core/` | `modifiers.gd` (effects folded into one table), `conditions.gd` ("when" texts: `kind:arg`, `counter>=N`, `a & b`), `rng.gd` (the one seedable random source), `clock.gd` (one step of time, systems in a fixed order), `saves.gd` (versions, upgrade steps, defaults) |
| `kits/learn/` | the learning kit: learner record, spaced repetition, Rest sums (`math_engine.gd`), Time Quiz engine, timer, number pad; its own README |
| `kits/ui/` | `ui.gd` (styles, buttons, bars, the theme), `art.gd` (pictures with emoji fallback) |
| `kits/avatar/` | the farmer: a 3D-in-2D figure (`avatar.gd`) and its acts (`actor.gd`) |
| `kits/audio/` | `sound.gd` (autoload `Sound`: effects and music from `data/sounds.json`), `synth.gd` (stand-in sounds) |
| `kits/i18n/` | languages (`I18n`) |
| `kits/world/` | `shapes.gd`, `walk_grid.gd` (path-finding), `flight.gd` (things flying to the store) |
| `game/farm/game.gd` | the front door (autoload `Game`): data loading (`_load_farm_data`), `S`, `state_defaults()`, saves (`SAVE_VERSION`, `_save_upgrades`), players, signals, conditions vocabulary (`_setup_conditions`), the clock order (`_setup_clock`), cheats |
| `game/farm/systems/` | the rules, one file per area: `seasons`, `items`, `progression`, `pacing`, `fields`, `resources`, `animals`, `crafting`, `trade`, `knowledge`, `needs`, `rewards`. Each reaches the rest through `G` |
| `game/farm/main.gd` + `main.tscn` | the screen's composition root: builds the top bar, map, sheet, pop-up and toasts, connects the signals, refreshes |
| `game/farm/ui/` | the screen's parts (each with `M` = main screen, `G` = Game, others as `M.ui_<part>`): `map_view`, `sheets`, `modal`, `notifications`, `celebrations`, `time_quiz`, `rest`, `card`, `postcards`, `settings`, `welcome`, `menus`, `farmer_acts`, `sounds`, `widgets`, `patch_grid`; `places/` one script per kind of place |
| `game/farm/map/` | the farm map: `farm_map.gd/.tscn` (layout, ground, road, forest, critters, cat), `slot.gd` (a place on its footprint), `iso_field.gd` (a field at an angle with pests and the scarecrow) |
| `game/farm/spots.gd` | which place each data node belongs to, read from `data/farm/places.json` |
| `game/farm/dev/dev_flags.gd` | the test and screenshot flags |
| `data/farm/` | the progression (split; `tools/farm_data.py` explains it), `places.json`, `animals.json`, `chapters.json` |
| `tests/` | `check_all.sh` (everything), `golden.sh` + `golden/`, `fixtures/` + `fixtures_test`, `core_test`, `ui_smoke` + `ui_driver.gd`, `bot` (also the pacing report), `learn_sim`, `pose_sheet` |
| `tools/` | Python helpers: data (`farm_data`, `check_data`, `sync_progression`, `quiz_ids`, `i18n`), pictures, sounds, layout editor |

## 3. Where new code goes

- **A new rule** (a mechanic, a number the game uses): into the system of its area in `game/farm/systems/`; if it runs every
  step of time, register it in `_setup_clock()` at the right place. A whole new area (the market trip, the Lord's share,
  wellbeing): a new system file, created in `game.gd` like the others (`var sys_x = preload(…).new()`, set `G` in `_init`).
- **New state:** a key in `state_defaults()` (old saves get it automatically). Changing the *shape* of something saved: raise
  `SAVE_VERSION`, add a step to `_save_upgrades()`, add a fixture to `tests/fixtures/`.
- **New content:** data only (nodes, items, recipes in `data/farm/`, places in `places.json`, a "when" with known conditions); run
  `python3 tools/check_data.py`. A new condition kind or counter: register it in `_setup_conditions()` and add it to
  `tools/check_data.py`.
- **Something the screen shows:** into the part of `game/farm/ui/` that owns it (a new kind of place → a new script in
  `ui/places/`, created in `main.gd`). Texts in `tr("…")`, then `python3 tools/i18n.py`.
- **Something farm-free and reusable:** a kit (or the core), with a README, no `class_name`, nothing from `game/`.
- **Every change:** `bash tests/check_all.sh`. The golden run must stay the same unless the rules or numbers changed on purpose
  (then `bash tests/golden.sh --record` and say so in the log). The bot must learn every new mechanic.
