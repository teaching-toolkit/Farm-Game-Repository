# Architecture plan (TODO T2 → T1): the game's code, restructured for upkeep and reuse

Written 12 Oct 2026 after reading the code (Godot 4.7 project in `godot-prototype/`). Labels: ✅ decided · 💡 proposed · ❓ for the parent.
Nothing here is built yet. When the restructuring is done, the parts of this file that describe the result move into
`godot-prototype/ARCHITECTURE.md` (the lasting description), and this plan goes to `archive/`.

---

## 0. In short

- **What we want** ✅ (R5, R6): code that stays easy to change while six chapters' worth of new systems arrive (market trips, packing,
  quality, skills, wellbeing, sustainability, seasons, story, pets' jobs), and parts that can be **reused in a spin-off**: another
  character starting a **quarry, mine and smithy** from scratch at the other end of Hazelwood, with less story but the same kind of
  unlocking and building, energy and time, and books to read.
- **The shape** 💡: three layers. A small **core** that knows no game (data loading, modifiers, conditions, the clock, saves); a set of
  **kits** that each do one job and know nothing about farming (learning, progression, items and trade, crafting and skills, needs and
  energy, resources, seasons, story, the map, the avatar, the interface, sound, languages); and **the farm** on top, which is just the
  game made from them plus its own rules (fields, crops, weeds, pests, animals, pets, the Lord's share).
- **How we get there** 💡: in nine small slices, **none of which changes how the game plays**. Before the first slice, a "golden run" is
  set up: the test bot plays a fixed-seed game and records the farm's state after every question; after each slice the run must come out
  identical. That is what makes a large restructuring safe.
- **Two decisions for the parent** (§11): let the real game engine (through the bot) produce the pacing numbers instead of the explorer's
  separate copy of the rules; and do the small interface fixes after the big scripts are split, except three that don't touch them.

---

## 1. Goals and limits

1. **Easy to change:** a new system is a new file, not a hundred lines spread through two big ones. A change is found by its name.
2. **Easy to reuse:** the quarry game takes the kits it needs as they are, and only writes its own rules, data and screens.
3. **Content stays data:** the parent (and Claude) change the game by editing JSON, not code. Today this is already mostly true; the
   remaining exceptions go (§2, P3).
4. **Nothing breaks on the way:** the restructuring doesn't change the game; old saves keep loading; the web build keeps working; the
   smoke test, the bot and screenshots keep working after every slice.
5. **Fits how the project is worked on:** small files that a session can read whole (the session skill asks not to read big files in
   full); one README per kit, like `learnkit/README.md`; plain JSON saves and data that a parent can open.
6. **Don't build what nobody needs yet:** a kit is generalised only as far as the farm and the quarry game both need it. Building a
   general engine ahead of the second game usually produces the wrong one.

---

## 2. Where the code stands (measured 12 Oct 2026)

| File | Lines | What it does |
|---|---:|---|
| `scripts/main.gd` | 3,136 | The whole interface: top and bottom bar, every place's sheet, the Time Quiz, Rest, cards, settings, album, quest book, celebrations, toasts, about 30 test and screenshot flags |
| `scripts/game.gd` (autoload `Game`) | 2,376 | The whole rules engine: data loading, players and saves, effects, energy, seasons, inventory, costs, dynamic difficulty, unlocks, fields, water, animals, stations, polish, market, cards, Rest, luck, the time step, pests, gifts, jobs, acorns, perks, cheats |
| `scripts/farm_map.gd` | 1,044 | The isometric map: layout, drawing grass/road/forest, flying things, the cat, path-finding, perks' effects |
| `scripts/iso_field.gd` | 734 | A field on the map: patches, borders, fence, pests and the scarecrow's looks |
| `scripts/ui.gd` | 694 | Interface helpers: buttons, cards, bars (cube bar, season bar), clock button, celebration |
| `scripts/slot.gd` | 655 | One place on the map: footprint, picture, ruins, pens, inside view |
| `scripts/avatar.gd` | 438 | The farmer: a small 3D figure drawn into the 2D map, poses, props, walking |
| `scripts/fx.gd` | 335 | Synthesised sounds and perk effects (lightning, coin shower, sparkles, weather bits) |
| `scripts/field_view.gd` | 307 | The field grid inside the sheet, again with pests and scarecrow looks |
| `scripts/spots.gd` | 185 | Which place each data node belongs to, **plus the farm's places, insides, picture chains, ruins, pens and bench written as constants** |
| `scripts/sound.gd`, `actor.gd`, `i18n.gd`, `art.gd` | 136, 96, 85, 35 | Sound and music (autoload `Sound`), acts from data, languages, pictures by name |
| `learnkit/` | 1,459 | ✅ Already a reusable kit: Rest sums, quiz engine, spaced repetition, learning record, number pad, own README |
| `tests/` | bot 257, ui_smoke 374, learn_sim 39, pose_sheet 42 | Bot plays the rules; smoke test clicks through the opening |
| `../progression/progression-explorer.html` | 443 KB | Browses the data **and simulates a player with its own JavaScript copy of the rules** |
| `data/farm-progression.json` | 320 KB | All items, nodes, recipes and rule numbers in one file |

**What is already good and stays:** the game is data-driven (nodes, recipes, items, acts, sounds, layout, quiz packs are all JSON); the
effect system (`caps()`: every node's `set` / `add` / `mult` / `produces` folded into one table) is a clean, general mechanism; the
learning kit is properly separate; acts and the avatar are data-driven; pictures are found by name; languages are files.

**What makes it hard to change** (each one is something the plan fixes):

- **P1. Two very big files.** `main.gd` and `game.gd` hold about 5,500 lines between them. Nearly every new feature means editing both.
- **P2. The interface reaches into the rules' memory.** `main.gd` reads and writes the save dictionary `G.S` directly (74 places); tests
  and screenshot flags write into it too. Any change to how the state is stored breaks the interface in unexpected places.
- **P3. Farm content written in code.** The places, insides, picture chains, ruins, pens and bench in `spots.gd`; the list of pets
  in four places (`main.gd` `PETS`, `spots.gd`, and twice in `game.gd`, one of them the `chapter()` rule); the animal list and the goal
  types. Adding the badger (chapter 5) means finding all of these. The quarry game would have to fork the code.
- **P4. One long time step.** `step_time()` calls every tick by hand (pace, season, rain, producers, crops, weeds, pests, stations,
  reading, home fuel, market, wear, neighbour gifts, luck, acorns, unlocks, perks). Every new system (pets' jobs, energy drain,
  regrowth, merchant visits, the Lord's share, snow) would add lines here, and again in the playback after the quiz.
- **P5. Saves have no version.** `load_game()` patches missing keys by hand ("saves from an older version: …"). With many new systems
  coming, this becomes fragile, and "old saves must keep loading" can't be tested.
- **P6. The rules exist twice.** The explorer simulates a player with its own copy of the rules in JavaScript; the bot plays the real
  engine. Every new mechanic must be written twice, or the explorer's pace estimate (21.2 h) drifts away from the real game.
- **P7. One huge data file.** Fine for the code, hard for people and for AI sessions to edit safely; every change is a diff in a 320 KB file.
- **P8. Tests tied to private insides.** The smoke test calls `main.gd`'s private functions (`M._show_card`, `M._on_patch`,
  `M._close_modal` …); splitting `main.gd` would break it. The ~30 screenshot flags also live in `main.gd`.
- **P9. Duplicated code.** Pests and the scarecrow's looks are drawn in both `iso_field.gd` and `field_view.gd`.
- **P10. No fixed random seed.** The rules use `G.rng` (randomised at start), one global `shuffle()` and the wall clock for card reviews,
  so two runs never match, and nobody can prove that a restructuring changed nothing.

---

## 3. The target: three layers

```
 ┌──────────────────────────────────────────────────────────────────────────┐
 │  THE GAME (game/farm/)   its own rules · its data · its screens · start   │
 │  fields · crops · weeds · pests · animals · orchard · pets & job board ·  │
 │  the Lord's share · deliveries · favours            (quarry game: its own) │
 ├──────────────────────────────────────────────────────────────────────────┤
 │  KITS (kits/)   each: one job, own folder, README, data format, save      │
 │  slice and tests; no kit knows "farm"                                     │
 │  learn · progression · knowledge · items & trade · crafting & skills ·    │
 │  needs & energy · resources · seasons & weather · story · rewards ·       │
 │  world (map) · avatar · ui · audio · i18n                                 │
 ├──────────────────────────────────────────────────────────────────────────┤
 │  CORE (kits/core/)   data loading · modifiers · conditions · clock ·      │
 │  saves with versions · events                                             │
 └──────────────────────────────────────────────────────────────────────────┘
```

**The rules of the house** (they go into `ARCHITECTURE.md` and the session skill):

1. **Dependencies point down only.** The game uses kits; kits use the core; a kit may use another kit only where its README says so
   (e.g. *knowledge* uses *learn*). The core uses nothing.
2. **Commands in, events out.** The interface asks the rules to do something (`trade.sell(item, n)`), and the rules announce what
   happened (`sold`, `gained`, `changed`). The interface **never writes the state** and reads it only through the systems' functions.
3. **Each system owns its part of the save** (`S.fields`, `S.inventory`, `S.needs` …) with defaults and its own upgrade steps.
4. **Content is data.** Places, pets, chapters, crops, recipes, cards, story pieces, acts, sounds: JSON. Code holds rules only.
5. **A new mechanic is a new system file** that registers with the clock (`on_step`) and, if it is seen, with the playback.
6. **Kits are plain folders** with relative `preload`s (as `learnkit/` already does), no global `class_name`s and no autoload of
   their own, so they can be copied into another project and just work.
7. **The game has one front door.** `Game` (the autoload) stays, as a thin facade that holds the systems and keeps today's function
   names working while the interface and tests move over.

---

## 4. The parts

### 4.1 Core (`kits/core/`)

| Part | Does | Comes from today |
|---|---|---|
| `data.gd` | Loads a game's data files, merges them, lays the language files over them, runs light checks | `load_data()` in `game.gd`, `i18n.gd` overlay |
| `modifiers.gd` | Folds effects (`set`, `add`, `mult`, `produces`) from many sources into one table; diminishing returns | `caps()`, `_apply()`, `m()`, `g()` |
| `conditions.gd` | **One** condition language for unlocks, story pieces, little jobs, hidden finds, the unlock schedule: `done:<id>`, `has:<item>:<n>`, `season:<name>`, `chapter:<n>`, `step>=<n>`, `seen:<id>`, `chance:<p>` … | `cond()` (acorns), the story plan's `when` list (`story/story-delivery.md` §6) |
| `clock.gd` | One step of time: calls every registered system in a fixed order, collects a **step report** (what changed, for the playback), saves | `step_time()` |
| `saves.gd` | Save and load with a **version number**; each system's slice; upgrade steps from older versions; players | `save_game()`, `load_game()`, players |
| `events.gd` | The signals everyone listens to (changed, gained, sold, celebrate, toast …) | the signals at the top of `game.gd` |
| `rng.gd` | One random source for all rules, seedable (`--seed=`) | `G.rng`, the global `shuffle()` |

### 4.2 Kits (`kits/<name>/`)

"Quarry?" says whether the spin-off would use it, which is the test of whether it belongs in a kit at all.

| Kit | Does | Comes from today | New systems that live here | Quarry? |
|---|---|---|---|---|
| **learn** | Rest sums, Time Quiz engine, spaced repetition, learning record, number pad | `learnkit/` (moves as is) | the first-try rule and "comes back after one" (J10) | yes |
| **progression** | Nodes, requirements, costs, steps with waits, auto-unlocks, chapters from data, "only what you can do now", the unlock schedule | unlock/cost/requirement parts of `game.gd` | O1–O3 (what is shown when), chapters without hard-coded pets | yes |
| **knowledge** | Books, the library, reading, card quizzes, card reviews in the Time Quiz | card parts of `game.gd` | the new books (body and mind, seed saving …) are data only | yes |
| **items & trade** | Items with tags; batches with freshness and **quality**; **weight**; the store and its limits; the **bag** and packing; prices and demand; merchants, **trips**, barter; **bronze and gold** | inventory and market parts of `game.gd` | M1–M14, U3 | yes |
| **crafting & skills** | Stations, recipes, fuel and the woodpile, slots, outcome quality, **skill families and ranks** | stations/recipes/polish parts of `game.gd` | Y1, Y2 (replaces practice stars) | yes (smithing!) |
| **needs & energy** | The energy model (home base × parameters, gain or drain per step), parameters that sink and recover, short boosts (food, happiness, poisoning), Rest's energy | energy, Rest and buff parts of `game.gd` | L1–L8 | yes |
| **resources** | Gathering spots that give, empty and **refill or regrow**; depletion, floors, advice; trees ↔ stumps ↔ saplings; water sources | gathering and water parts of `game.gd` | N2–N5, the forest screen's spots (S4) | yes (the quarry face, ore veins) |
| **seasons & weather** | The season clock, season modifiers, rain, **snow** that falls and stays, the season's text | season, rain and freshness timing in `game.gd` | N6–N8 | yes |
| **story** | Story pieces, their conditions, priority and rationing, the 📜 scroll, bubbles, frame scenes, opening panels | (new; planned in `story/story-delivery.md`) | I8, I9 | yes (less of it) |
| **rewards** | Luck and lucky finds, little jobs, hidden finds (acorns), perks, postcards and gifts, the album | those parts of `game.gd` | – | yes |
| **world** | The isometric one-screen map: layout from data, places on footprints, path-finding, taps, things flying to the store, the **playback after the quiz**, the **season shader** | `farm_map.gd`, `slot.gd` (generic parts) | J4, N7 | yes |
| **avatar** | The 3D-in-2D figure, looks, poses, props, acts from data; any number of figures | `avatar.gd`, `actor.gd` | villagers and merchants as figures (P1), the farmer's dashboard tap | yes |
| **ui** | Theme, tiles and grids, sheets, pop-ups, bars, the clock button, notifications, celebrations | `ui.gd`, parts of `main.gd` | J5 (phone-like notifications), M11 (store grid) | yes |
| **audio** | Sound effects and music from data, synthesised stand-ins | `sound.gd`, part of `fx.gd` | – | yes |
| **i18n** | Languages from files, device language | `i18n.gd`, `tools/i18n.py` | – | yes |

### 4.3 The farm (`game/farm/`)

What only this game has: **fields and patches** (clearing, patch levels, fertiliser, rotation, crops, weeds, frost stones, pests and
the scarecrow, harvests), **animals and muck**, **orchard and greenhouse**, **pets and their job board**, **the Lord's share**,
deliveries and favours (as data on top of *progression*), the farm's **screens** (place sheets, the field view, the house inside), and
the farm's data. The quarry game would have instead: the quarry face and mine galleries, ore and stone, the smithy's line, its own
screens and data.

💡 Two things that could become kits once the quarry needs them, not before: the Lord's share ("dues": the quarry is on the Lord's land
too) and pets' job boards (helpers with WHEN → DO cards).

### 4.4 The interface, split

`main.gd` becomes a **composition root** of about 200 lines that builds the screen from parts:

| New script | Holds (from today's `main.gd`) |
|---|---|
| `game/farm/ui/top_bar.gd` | coins, water, energy, season, next goal, the clock button, the bag, the icons (J8) |
| `kits/ui/sheet_host.gd` | the sheet that slides up, its title, scroll, open/close |
| `kits/ui/modal_host.gd` | pop-ups, their sizing, the queue of celebrations and postcards |
| `kits/ui/notifications.gd` | toasts → phone-like notifications (J5) |
| `game/farm/ui/places/*.gd` | one script per kind of place sheet: field and patch, kitchen and stations, animals, home, well and water, road, market, book cart and library, pets, notice board, woodpile |
| `game/farm/ui/time_quiz.gd`, `rest.gd`, `card.gd` | the three learning screens |
| `game/farm/ui/settings.gd`, `album.gd`, `quest_book.gd`, `log.gd` | the menus |
| `game/farm/ui/celebrations.gd` | the big pop-ups for new things |
| `game/farm/dev/dev_flags.gd` | the ~30 screenshot and test flags (`--shot`, `--qid`, `--give` …), loaded only when flags are given |

Each place script gets the game's front door and the sheet to draw into; none of them touches `G.S`.

---

## 5. Data

```
data/
  settings.json                 the parent's settings (as now)
  farm/
    items.json  recipes.json    split out of farm-progression.json
    nodes/ch1.json … ch6.json   nodes by chapter (easier to read and to edit)
    rules/*.json                today's "meta" blocks, one file per system (seasons, pests, market, pricing, needs …)
    places.json                 places, insides, picture chains, ruins, pens, bench (out of spots.gd)
    pets.json                   pets, their chapters, dishes, comfort items (out of main.gd / game.gd)
    layout.json  acts.json  avatar.json  sounds.json  story.json
  quiz_packs/  i18n/            as now
```

- The loader merges the files into the same structure the code uses today, so the code doesn't change when the file is split.
- 💡 A **data checker** in Python (`tools/check_data.py`): every id a node, recipe or story piece names exists; costs and effects use known
  keys; conditions parse; quiz ids are unique. It takes over the static checks the explorer does now, and runs with the other checks.
- `tools/sync_progression.py` writes the merged file for the explorer (so the explorer keeps working with one file).

---

## 6. Saves

- A save gets `"version": N`. Each system owns its slice (`fields`, `inventory`, `needs`, `progression` …) with its defaults.
- Every change to the shape of a slice adds an **upgrade step** (`N → N+1`) instead of patches spread through `load_game()`.
- **Fixtures:** today's real save files (a fresh game, a chapter-3 game from the bot) are kept in `tests/fixtures/`; a test loads every
  fixture after every change. That turns "old saves must keep loading" from a hope into a check.
- The learning record (`learning.json`) stays the learn kit's own file, as now.

---

## 7. Tests and tools

- **The golden run** (built first, slice R0): `--seed=N` fixes all randomness and the clock for the card reviews; the bot plays 300
  questions and writes a short fingerprint of the farm after each one. Before the restructuring this run is recorded; after every slice it
  must match exactly. Any difference points at the slice that changed behaviour.
- **A test driver for the interface:** the smoke test stops calling `main.gd`'s private functions and uses a small driver (`open_place`,
  `tap_patch`, `press(text)`, `answer_right` …), so the interface can be reorganised without rewriting the test.
- **Tests per kit:** small headless scripts like `learn_sim.gd` (modifiers fold correctly; the store respects limits; a recipe gives the
  right outcome; the clock calls systems in order; every save fixture loads).
- **The bot learns each new mechanic** as it arrives (packing and trips, the Lord's share, the first-try rule …), as the TODO already asks.
- 💡 **Pacing from the real engine** (❓ §11): the bot already plays the real rules; with the timing assumptions the explorer uses
  (25 s per Time Quiz question, 3 s per action, 5 s per Rest answer) it can report hours, questions and Rest answers per chapter as a JSON
  file. The explorer then shows that report next to the data instead of simulating its own copy of the rules. New systems are then
  written once, in Godot.

---

## 8. Reuse in the quarry game

- **Until the quarry game starts:** the kits live in this repo (`godot-prototype/kits/`), each with a README and a version line.
- **When it starts** 💡: the kits move to their own repo (e.g. "hazelwood-kits") and both games include it (git subtree, or a copy kept
  in step by a small script). The farm keeps working the whole time because the folder paths stay the same.
- **What the quarry game writes itself:** its rules (quarry face, galleries, ore, smelting line), its data, its screens, its story pieces.
  It uses: core, learn, progression, knowledge, items & trade (same village, same merchants, same coins), crafting & skills (smithing,
  stonework), needs & energy, resources (rock faces and ore veins that run out and are found again), seasons & weather, story, rewards,
  world, avatar, ui, audio, i18n.
- 💡 Same world, same village: the two games could later share Hazelwood's people, merchants and prices as a common data folder. Not
  needed now; the data layout above leaves room for it.

---

## 9. The migration, slice by slice

Every slice: no change to how the game plays; the golden run matches; smoke test, bot and a few screenshots pass; one log row. Sizes are
rough (S ≈ one session, M ≈ two, L ≈ three or four).

| Slice | What | Fixes | Size |
|---|---|---|---|
| **R0. Safety net** ✅ 12 Oct 2026 | `--seed=` for all randomness; the golden run (bot fingerprint per question); save fixtures; the interface test driver, with the smoke test moved onto it; the screenshot flags moved out of `main.gd` | P8, P10 | M |
| **R1. Folders** ✅ 12 Oct 2026 | `kits/` and `game/farm/`; move the files that are already separate (learnkit → `kits/learn`, ui, avatar and actor, sound, i18n, art); fix the `preload` paths | – | S |
| **R2. Content out of code** ✅ 12 Oct 2026 | places, insides, picture chains, ruins, pens, bench, pets and animals, the chapter rule → data files | P3 | S |
| **R3. Core** ✅ 12 Oct 2026 | modifiers, conditions, rng, events, the clock (with the systems registered in today's exact order) | P4 | M |
| **R4. Rules split** ✅ 12 Oct 2026 | `game.gd` → systems (progression, knowledge, items & trade, crafting, needs, resources, seasons, rewards, farm: fields, animals …) behind the same `Game` front door; today's function names keep working | P1 | L |
| **R5. Interface split** ✅ 12 Oct 2026 | `main.gd` → composition root, sheet and modal hosts, notifications, place scripts, learning screens, menus; reads through the systems only | P1, P2 | L |
| **R6. Map** ✅ 12 Oct 2026 | generic map (`kits/world`) vs the farm's drawing (road, forest, fields); pests and the scarecrow drawn once | P9 | M |
| **R7. Saves** ✅ 12 Oct 2026 | version number, slices per system, upgrade steps; all fixtures load | P5 | M |
| **R8. Data and pacing** ✅ 12 Oct 2026 | data files split (§5), the data checker, pacing from the bot (if §11 a is yes) | P6, P7 | M |

Then `ARCHITECTURE.md` is written from this plan, the session skill gets a short "where new code goes" section, and every new system of
the TODO's steps 5–13 is built directly as a kit or a farm system.

---

## 10. How this fits the rest of the TODO

- **Before the restructuring** (they don't touch the big files, or only one line): J1 version number, J10 the first-try rule (in the learn
  kit and one line of the quiz screen), J11 "ss" (data files).
- 💡 **After R5:** the other interface tasks (J2 field section, J3 Rest walk, J4 playback, J5 notifications, J6 read aloud, J8 top bar,
  J9 cheats). Doing them before would mean writing them into `main.gd` and then moving them again.
- **The paper designs (D1–D4)** are written with this plan's parts in mind: each system's chapter in the design document says which kit
  it lives in and what it adds to the save.
- **Story Round 6 and 7** (texts) don't depend on any of this and can run alongside.

---

## 11. Decisions ✅ (parent, 12 Oct 2026)

- **a. Pacing from the real engine:** yes. The explorer depends on the game's files and the bot's report instead of its own copy of the
  rules, refreshed by a script the parent can run (a double-click `Update explorer.command`). The explorer is a nice-to-have.
- **b. The interface fixes after the split,** except J1, J10 and J11 (before): yes.
- **c. Rename** the Godot project to *Hazelwood Harvest* in phase 1; keep the folder name `godot-prototype/`: yes.
- **d. The spin-off games are very hypothetical.** So kits are separated cleanly but generalised only as far as the farm needs.

---

## 12. Risks

| Risk | How it is handled |
|---|---|
| A slice changes the game without anyone noticing | The golden run must match after every slice; screenshots compared |
| Old saves stop loading | Save fixtures loaded in every check; from R7 on, upgrade steps per version |
| The web build breaks (paths, export filters) | A web export after R1, R2 and R8 (the export filter must include the new data folders) |
| The restructuring drags on and blocks visible progress | Slices are small and each leaves a working game; J1, J10, J11 and story work go on alongside |
| Over-engineering kits nobody reuses | Every kit must pass the "quarry?" test (§4.2); farm-only rules stay in the farm |
| AI sessions get lost in the new layout | `ARCHITECTURE.md`, one README per kit, and the session skill's "where new code goes" |
