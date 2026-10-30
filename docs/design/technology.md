# Technology

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 15. Technology

### 15.1 Engine and platforms

- **Godot 4.7** (standard, GDScript), Compatibility renderer, portrait 834×1194, stretched to fit.
- Runs on a computer from the editor, and **in the browser** as a single-threaded web export (`web-build/`) that any HTTPS static
  host can serve; on the iPad it is added to the Home Screen and runs full-screen like an app.
- **Version numbers:** the game's version is set once in `godot-prototype/project.godot` (`application/config/version`), bumped
  with every web build and shown with the data's version in ⚙️ Settings and 🎼 Credits ("Hazelwood Harvest · version 0.9.0 · data
  0.8"), so the parent can see which build the iPad has loaded.
- The earlier HTML5 prototype (1.0–1.1) is kept in `archive/html-prototype/` for reference only.

### 15.2 Data first

Everything about the content is data, so the game can be rebalanced without code:

| File | Holds |
|---|---|
| `data/farm/` | the whole tree (v0.8), in files: `items.json` (182 items), `nodes/` (461 nodes in 14 themed files: buildings, upgrades, tools, gear, helpers, polish, cards, books, goals, side quests, pets, merchants …), `recipes.json` (106), `rules/` (energy, water, yields, pricing, market, seasons, pests, freshness, carry, flex …, by system), `chapters.json`, `start.json`, and `places.json` (the farm's places) |
| `data/map_layout.json` | where every place, add-on, corner and decoration stands |
| `data/quiz_packs/*.json` | Time Quiz packs |
| `data/i18n/quiz-<lang>.json` | quiz texts by question id |
| `data/settings.json` | the parent's settings (§4.4) |
| `data/avatar.json` | the farmer's look |
| `data/acts.json` | what the farmer acts out: poses, props, acts |
| `kits/learn/curriculum/math.json` | the maths curriculum |

`progression/progression-explorer.html` browses the tree, simulates a playthrough (pacing, Rest per hour, pets, storage and
value checks) and keeps a copy of the current data.

### 15.3 Code

| Part | Does |
|---|---|
| `game/farm/game.gd` (autoload `Game`) and `game/farm/systems/` | the rules engine: the front door (state, data, saves, effects, one step of time) and one script per system: seasons, inventory, needs (energy, Rest), pace (dynamic difficulty), progression, fields (weeds, pests, water), animals, crafting (fuel, polish), trade, knowledge (cards, Time Quiz), rewards (luck, gifts, jobs, acorns, perks); `kits/core/` holds the shared parts (modifiers, conditions, rng, clock) |
| `game/farm/main.gd` and `game/farm/ui/` | the interface: `main.gd` builds the screen (bars, map, sheet, pop-up) and refreshes it; one script per job in `ui/`: sheets, pop-ups, notes, the Time Quiz, Rest, cards, the places' sheets, inside windows, album, quest book, settings |
| `game/farm/map/` (`farm_map.gd`, `slot.gd`, `iso_field.gd`), `game/farm/spots.gd` with `data/farm/places.json`, `game/farm/ui/field_view.gd` | the one-screen map, a place, a field, which data node belongs where (the places, their insides, picture chains, ruins, pens and the workbench are data), the patch grid |
| `game/farm/fx.gd`, `game/farm/dev/dev_flags.gd` | perk effects drawn over the farm; the test and screenshot flags |
| `kits/ui/` (`art.gd`, `ui.gd`), `kits/avatar/` (`avatar.gd`, `actor.gd`), `kits/audio/` (`sound.gd`, `synth.gd`), `kits/i18n/i18n.gd` | pictures with emoji fallback, styles and explanations, the farmer, sound and music, languages (reusable parts, 12 Oct 2026) |
| `kits/learn/` | the learning kit — learner record, spaced repetition, maths engine, quiz engine, timer, number pad; reusable in any Godot game |

### 15.4 Saves

Per player in Godot's user folder: `players/<name>/farm_save.json` (the farm) and `players/<name>/learning.json` (the learning
record, kept when a new game starts). In the browser they live in that browser on that device.

### 15.5 Checks and tools

- `tests/ui_smoke.tscn` clicks through the opening and checks the systems; `tests/bot.tscn` lets a greedy bot play the rules
  engine through the chapters (`--flex` with dynamic difficulty); `tests/learn_sim.gd` lets a pretend child practise Rest sums.
- `tools/quiz_ids.py` (question ids and translation files), `tools/import_art.py` (cut sprite sheets), `tools/art_list.py`
  (picture list), `tools/make_layout_editor.py` (layout editor), `kits/learn/tools/make_editor.py` (learning-record editor).
- How to run all of these: `godot-prototype/README.md` and `00-READ-ME-FIRST.md`.
