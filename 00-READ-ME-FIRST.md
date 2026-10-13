# 👉 READ ME FIRST — for a new chat or another AI

This file is the starting point for a new chat or another AI: what the project is, how the folder is laid out, the parent's
rules and where we left off. **How to work on the project** (what to read, the checks, changing content) lives in three skill
files in `claude-skills/`; see §2. Last updated: **13 October 2026** (phase 1 built: version 0.9.0; phase 2, the restructuring, is done: R0–R8; phase 3, the interface, is built: version 0.10.0; phase 4, the foundations, is built: version 0.11.0; phase 5, the story engine and chapter 1, is built: version 0.12.0; phase 6, the store and market, is built: version 0.13.0; phase 7, the new chapter 1, is built: version 0.14.0; phase 8, six chapters, the Lord's share and the pets' jobs, is built: version 0.15.0; phase 9, wellbeing and energy, is built: version 0.16.0; phase 10, nature and winter, is built: version 0.17.0).

---

## ⚠️ Standing rule for every conversation: keep the log and the to-do list up to date

**`TODO.md`** is the project's to-do list, and `PROJECT-LOG.md` is its history. Keep both current **as you go, not just at the
end**: a chat can stop at any time, and a task that is not written down in `TODO.md` does not exist for the next chat. What to
update when, and what to do at the end of a session: `claude-skills/farm-game-session/SKILL.md` §4.

---

## 1. The project in a few lines

**Hazelwood Harvest** (until 0.9.0 *Farm Quiz Game*) — an educational farming game for an **8-year-old**, played on an **iPad held upright**. The player
rebuilds a burnt-down farm from a tent and one wheat seed to a master farm, over six chapters, each ending with a pet
coming home (bunny, tortoise, goat, pony, alpaca). Learning *is* the economy:

- **Time Quiz** — general-knowledge questions from packs the parent chooses; each right answer moves farm time one step.
- **Rest** — mental-arithmetic sums (a curriculum for classes 1–7 with spaced repetition and medals) give energy.
- **Knowledge cards** — 78 cards about real farming and crafts, read and quizzed, unlock what they describe.

It is built as a **Godot 4.7 prototype** (GDScript) that is fully playable through all six chapters, driven by one data
file. It also runs in the browser (`web-build/`). The person you work with is the child's parent and the game's designer;
they test on the iPad, pick the generated pictures and decide on design questions. Write to them in plain, friendly English
and keep the game's own texts simple enough for a young reader.

---

## 2. What to read

Don't read every document in full: together they are over 180 KB. Start with:

1. **This file:** the standing rule above, §1, §4.6 (the parent's rules) and §5 (where we left off).
2. **`TODO.md`:** §0 (the plan at a glance) and §1 (waiting on the parent), then only the section of your task.
3. **`claude-skills/farm-game-session/SKILL.md`:** what else to read for which kind of task, how to plan bigger steps, how to
   keep the record, git.

The other two skills come in when needed: `claude-skills/farm-game-check/SKILL.md` (set up Godot, run the checks, screenshots,
debugging, review, web export) and `claude-skills/farm-game-content/SKILL.md` (questions, cards, texts and German, numbers,
sounds, pictures, the map layout).

Background, read only the parts a task needs: `farm-quiz-game-master-design-document.md` (what the game is and why; v2.0;
marks *(planned)* and *(idea)*; no history or to-dos), `PROJECT-LOG.md` (history, decisions, assumptions still to confirm),
`godot-prototype/README.md` (how to run, test and change the prototype; every setting and test flag),
`godot-prototype/kits/learn/README.md` (Rest sums, quiz engine, learning record, question ids) and `story/README.md` (the story).
The numbers are in the files of `godot-prototype/data/farm/` (browse them in `progression/progression-explorer.html`).
**The data wins** if it and a document disagree.

---

## 3. The folder

| Folder / file | What it is |
|---|---|
| `00-READ-ME-FIRST.md` | this file |
| `TODO.md` | **the to-do list and plan** (open tasks only; done ones go to the log) |
| `PROJECT-LOG.md` | history and decisions |
| `planning/` | the parent's raw notes and the decision rounds, kept word for word; **the architecture plan** (`2026-10-12-architecture-plan.md`); `TODO.md` points into them |
| `farm-quiz-game-master-design-document.md` | the design (v2.0) |
| `godot-prototype/` | **the game** — Godot project (`project.godot`), `kits/` (reusable parts: learn, ui, avatar, audio, i18n), `game/farm/` (this game's rules and screens), `data/`, `assets/`, `tests/`, `tools/`, `fonts/` |
| `Build web version.command` | **double-click on the Mac** to re-export the game into `web-build/` (needs Godot.app and its export templates installed once) |
| `Update explorer.command` | **double-click on the Mac** to refresh `progression/progression-explorer.html` from the game as it is now: checks the data, lets the test bot play (about 3 minutes) and writes its pacing report into the explorer's Pacing tab (needs Godot.app and python3) |
| `Publish web version.command` | **double-click on the Mac** to push `web-build/` to the public GitHub repo as one fresh commit (see §4.7) |
| `CLAUDE.md` | short pointer that Claude Code loads by itself: start with the session skill |
| `claude-skills/` | **how to work on the project**, three skill files: `farm-game-session` (what to read, planning, keeping the record, git), `farm-game-check` (set up Godot, checks, screenshots, debugging, review, web export), `farm-game-content` (questions, texts and German, numbers, sounds, pictures, layout) |
| `.gitignore` | what the private repo leaves out (`.godot/` caches, `web-build/`, big archive screenshots, `.DS_Store`) |
| `web-build/` | its own **public** git repo, ignored by the private one; the latest web export (put online on any HTTPS host; see the prototype README) |
| `progression/` | the progression explorer (`progression-explorer.html`) with a copy of the current data and the bot's pacing report (`pacing-report.json`); refresh with `Update explorer.command` |
| `story/` | **the story**: premise, book file, world, characters, outline, texts (see `story/README.md`; worked in rounds, nothing built into the game yet) |
| `art-inbox/` | generated sprite sheets waiting to be cut (`sheetN-….png`), `ART_LIST.csv` (every picture still needed, with prompts), `ROUND8-PICK-LIST.md` |
| `Claude outputs/` | a transfer folder for update bundles (`*.tgz`); temporary, nothing depends on it |
| `reference-art/` | style references and a free asset pack (not used in the game) |
| `archive/` | old design docs (1.0 – 1.3.8, the briefing), the old HTML5 prototype, the old landscape Godot layout, screenshots of rounds 1–8, rejected pictures (`art-rejected/`), an older zip — **reference only, do not edit** |

---

## 4. How to work on it

### 4.1 Where things run

- The parent's folder is on their **Mac** (`~/Documents/files/diverses/Kinder zeug/Wissensspiele/Farm game`). In a Cowork
  session (a chat linked to the Mac) it is connected as **"Farm game"** and appears in the device shell as `$HOME/mnt/Farm game`.
  Edit the real files there (they are what the parent opens). Deleting files in the parent's folder needs their permission
  each session; prefer moving things to `archive/`.
- **Claude Code cloud sessions** work on the private GitHub repo (a mirror of this folder, §4.7), starting from an empty machine.
- Setting up Godot and running it in either place: `claude-skills/farm-game-check/SKILL.md` §1.

### 4.2–4.5 Checks, screenshots, web export, after changing content

Moved into the skills on 11 October 2026, so each instruction lives in one place:

- the checks (smoke test, bot, learner simulation, explorer), screenshots, debugging, review and the web export →
  `claude-skills/farm-game-check/SKILL.md`;
- what to run after changing questions, texts, numbers, sounds, pictures or the layout → `claude-skills/farm-game-content/SKILL.md`;
- every test flag and data format → `godot-prototype/README.md`.

The parent can build and publish the web version alone: double-click `Build web version.command`, then
`Publish web version.command` (§4.7).

### 4.6 Rules the parent has set

- Do not try to get round blocked websites or downloads (e.g. `cdn.openart.ai` is blocked): the parent downloads OpenArt
  pictures into `art-inbox/` by hand.
- Never handle passwords, tokens or credentials. Ask before downloading files or deleting anything.
- Pictures: OpenArt project "Farm Quiz Game", model **Nano Banana 2 Lite at 1K**, sprite sheets of several objects, **3
  versions per sheet**, with an earlier sheet as the style reference. Only about two generations run at a time.
- No words on the map; whole numbers on screen (also with bronze and gold coins); short, simple texts; German with "ss", never "ß".
- **Natural consequences, never stuck** (parent, 10 Oct 2026; replaces "nothing that punishes the child"): setbacks that follow
  naturally (over-using the land, neglecting health) are allowed, last a while and can always be corrected; nothing is lost for good,
  Helpers never leave. See `PROJECT-LOG.md` §2.8. **One deliberate exception** on top
  (parent, 8 Oct 2026, planned for the medicine chapter): skipping the cheap plant check at Wren's and using a wrong plant puts the farmer
  in bed, poisoned (energy and all coins gone, double energy costs while recovering). See `story/game-design-round4.md` §C.

---

### 4.7 GitHub repos

- **Private repo** = a mirror of this whole folder (the parent pushes it from the Mac). The single root `.gitignore` decides
  what stays out. Cloud sessions commit or open pull requests there; the parent pulls them to the Mac. The old
  `Claude outputs/*.tgz` bundles are no longer needed for that.
- **Public repo** = only `web-build/`, which is a separate git repo nested inside this folder (one-time setup:
  `cd web-build && git init -b main && git remote add origin https://github.com/<you>/<public-repo>.git`). GitHub Pages serves it
  (Settings → Pages → Deploy from a branch → `main`, root). `Publish web version.command` replaces the history with one commit
  each time, because `index.pck` (~50 MB) and `index.wasm` (~40 MB) change with every build and would make the repo grow fast.
- Everything in the web build (data, quiz packs, pictures) is public to anyone with the link (accepted for now; see `TODO.md`, Z7).

---

## 5. Where we left off

Round 8 is finished and delivered (design 1.3.8, data v0.8; see `PROJECT-LOG.md`). After it, the folder was tidied and the
documents reorganised into the design document 2.0, the log and this file. The web build in `web-build/` matches the current
code. **Nothing is half-done in the code.**

Waiting on the parent: picking the round 8 pictures (open task W1), and the GitHub access and the two double-click scripts
on the Mac (W2).

7 Oct 2026 (after 2.0): added `Build web version.command`, `Publish web version.command`, `CLAUDE.md`, the root `.gitignore`
and `godot-prototype/tools/setup_godot.sh` for cloud sessions. No game changes; `web-build/` still matches the code.

7 Oct 2026 (group A): the five small fixes A1–A5 are in the code (see the log); `web-build/` does **not** match the code now.

7 Oct 2026 (sounds): sound files from `sound-inbox/` imported (see §F). `web-build/` does not match the code until it is
re-exported with the sounds.

7 Oct 2026 (cloud check): a fresh cloud session was set up and verified (smoke test, bot, screenshot); the cloud notes in
this file and `CLAUDE.md` were corrected (see the log). No game changes; `web-build/` still matches the code.

8 Oct 2026 (story, rounds 0–4 part 1): `story/` holds the premise, book file, world bible, character files, research notes and the story-delivery design. Nothing in the game or its data has changed; `web-build/` matches the code as before.

9 Oct 2026 (planning): the to-do list moved out of this file into `TODO.md`; the finished groups A–G were already in the log, their leftovers became tasks (W4, W5, W8). The parent's new notes (16 game ideas, 8 story notes; raw in `planning/`) were sorted into `TODO.md` by area, with a proposed order, a queue of decisions (contradictions with existing rules flagged ⚠️) and a first batch of title ideas. No game, data or code changes; `web-build/` is unchanged.

11 Oct 2026 (working instructions): how to work on the project moved into three skill files in `claude-skills/`
(`farm-game-session`, `farm-game-check`, `farm-game-content`). `CLAUDE.md` and §2 and §4 of this file now point to them instead
of repeating them, and a session no longer reads every document in full. No game, data or code changes; `web-build/` is unchanged.

12 Oct 2026 (decisions): five rounds of questions and the parent's answers (10–12 Oct; word for word in `planning/`) settled the
market trips, packing and the store, bronze and gold coins, realistic prices, the Lord's share, quality, skills, the energy model and
wellbeing, skills, sustainability and seasons, the top bar, the Time Quiz's first-try rule, an architecture study before splitting the
big scripts, and the story's open questions. Listed in
`PROJECT-LOG.md` §2.8; `TODO.md` rebuilt around them (next: the open questions in its §2, then everything on paper, step 3). No game,
data or code changes; `web-build/` is unchanged.

12 Oct 2026 (architecture): round 6 answered; the code read and measured, and the restructuring planned in
`planning/2026-10-12-architecture-plan.md` (core, kits, the farm; nine slices that don't change the game, checked by a seeded golden
run). Read it before any code work. No game, data or code changes; `web-build/` is unchanged.

12 Oct 2026 (implementation plan): the plan's decisions answered; `TODO.md` §0 is now the implementation plan in twelve phases.
Phase 1 starts: the round 8 pictures (in `art-inbox/`, not yet named or imported), version numbers, "ss", the first-try rule, the
rename to *Hazelwood Harvest*. No game, data or code changes yet; `web-build/` is unchanged.

12 Oct 2026 (phase 1 built): round 8 pictures imported; version 0.9.0 *Hazelwood Harvest* (shown in ⚙️ Settings); German with
"ss"; only a right first try moves time; design document 2.1. Smoke test and bot pass. **`web-build/` matches the code** (exported
12 Oct 2026, 89 MB `index.pck`). Next: the parent tests 0.9.0 on the iPad (publish with `Publish web version.command`), then phase 2.

12 Oct 2026 (phase 2, R0): the safety net for the restructuring: `--seed`, the golden run, save fixtures, the UI test driver,
screenshot flags in `game/farm/dev/dev_flags.gd`, `tests/check_all.sh`. No change to the game; `web-build/` still matches it.
R1 done too: the code now lives in `kits/` (reusable parts) and `game/farm/` (this game). Next: R2 (farm content out of code).

13 Oct 2026 (phase 2, R2): farm content out of code: the places, their insides, picture chains, ruins, pens, the workbench and the
rules that put a data node at a place are now `godot-prototype/data/farm/places.json`; the pets and animals come from the nodes and
`chapters[].pet` instead of lists in four places. A new test (`tests/places_test.tscn`, in `check_all.sh`) pins it to what the old code
gave; all checks pass, the golden runs are identical. No change to the game; `web-build/` still matches it (a web export would now also
carry `data/farm/*.json`). 
13 Oct 2026 (phase 2, R3): the core: `godot-prototype/kits/core/` (modifiers, conditions, rng, clock; own README and test). `Game.step_time()`
is now a list of registered systems in today's order (`Game._setup_clock()`). No change to the game (golden runs identical, also strict);
`web-build/` still matches it.

13 Oct 2026 (phase 2, R4): `game.gd` (2,460 lines) is split: the autoload `Game` (now `class_name FarmGame`, about 500 lines) is the front door;
the rules are 11 systems in `godot-prototype/game/farm/systems/` (own README), reached as `G.<system>.<function>` (e.g. `G.inventory.add_item`,
`G.fields.plant`); `main.gd`, the tests and the dev flags were rewritten by a script to call them that way. No change to the game (golden
runs identical, also strict; bot, smoke test, screenshots unchanged); `web-build/` still matches it.

13 Oct 2026 (phase 2, R5): `main.gd` (3,108 lines) is split: it is now the 400-line composition root (`FarmMain`: builds the screen and
refreshes it); the interface's jobs are 25 parts in `godot-prototype/game/farm/ui/` (and `ui/places/`; own README), reached as `M.<part>.<function>`
(e.g. `M.modals.open_modal`, `M.patches.on_patch`). Same method as R4. No change to the game: all checks pass, the golden runs are identical, and 21
screens (sheets, pop-ups, Rest, quiz, menu, album, cards, English and German) look the same as before. `web-build/` still matches the code.

13 Oct 2026 (phase 2, R6): the map: `farm_map.gd` (1,042 lines) is split into the map node and `ground`, `critters`, `cat`, `walker` (`godot-prototype/game/farm/map/`, own README); the pest and scarecrow drawing that existed twice is now only in `iso_field.gd` (the copy in `field_view.gd` was dead code). No change to the game (all checks pass, golden runs identical, map screenshots in four seasons and a fully built winter farm look the same as before). `web-build/` still matches the code. 
13 Oct 2026 (phase 2, R7): saves have a version: `kits/core/saves.gd`, `Game.SAVE_VERSION` = 1 (older saves are 0 and are upgraded when loaded), every
system declares the save keys it owns (`save_defaults()`), a new key or a changed layout has a clear place to go (README, `farm-game-session` skill). The
fixtures stay in the old layout and still load; a new test (`tests/saves_test.tscn`) checks the new-game state, key owners, upgrades and saves from a newer
game. The golden runs' numbers are unchanged (only their state hash, since every save now has `version`; recorded anew). `web-build/` still matches the code.

13 Oct 2026 (phase 2, R8 — end of phase 2): the data is in files (`godot-prototype/data/farm/`: items, recipes, chapters, start, `nodes/` in 14 themed slices that keep the
exact node order, `rules/` by system; loader `kits/core/data.gd`, Python `tools/farmdata.py`); the old `farm-progression.json` is gone. New `tools/check_data.py` (every id, cost,
effect and condition exists; part of `check_all.sh`; 0 errors, 7 warnings). The bot writes a pacing report (`--report=FILE`) that the explorer's Pacing tab shows; the new
double-click **`Update explorer.command`** refreshes the explorer (checks the data, lets the bot play seeds 1 and 2, about 3 minutes). No change to the game: all checks pass,
golden runs identical. `web-build/` still matches the code. **Phase 2 is finished.** Next: phase 3 (the interface in the new structure: J2–J6, J8, J9, N7; version 0.10).

13 Oct 2026 (phase 3, version 0.10.0): the interface work is built: new top bar without a bottom bar (J8), cheat buttons and read aloud as device settings (J9, J6), phone-like notifications (J5), no field sign: *The whole field* in the patch window (J2), the farmer walks home before Rest (J3), the playback after the Time Quiz (J4), the season shader with snow caps and golden autumn (N7). All checks pass, golden runs identical. **Needs the iPad** (publish with `Publish web version.command`; `web-build/` does NOT match the code yet): the timing of the Rest walk and of the playback, swiping a notification, the shader on the real screen (snow caps look right on roofs, fences and trees?). Next: phase 4 (foundations, D-papers first).

13 Oct 2026 (phase 4, version 0.11.0): the foundations are built, each slice checked and committed: **what is shown when** (`G.reveal`, `rules/60-reveal.json`; the purse and the album button wait for their first coin and picture; design document §13.2b, the D4 table), **item weights** (`rules/45-weight.json`, hidden), **quality** Lumpy / Proper / Fancy (`G.quality`, `rules/47-quality.json`; `SAVE_VERSION` 2), **skills and ranks** (`G.skills`, `rules/48-skills.json`; shown from the first rank-up in the album; `SAVE_VERSION` 3), **bronze and gold with realistic prices** (every old coin = 15 bronze, `planning/price-table.md`, `G.money`; `SAVE_VERSION` 4). Also the top bar now fits 744 and 834 px, the effect lines of upgrades and pets are readable (J12). New tests: quality (31), skills (31), money (17); golden runs re-recorded on purpose (the bot reaches chapter 5 in 603 / 741 steps); the explorer is refreshed. **Needs the iPad** and the parent's eye on the Swiss prices (TODO W9); `web-build/` does NOT match the code yet. Next: phase 5 (the story engine).

13 Oct 2026 (phase 5, version 0.12.0): the story engine and chapter 1 are built. `G.story` (`game/farm/systems/story.gd`) decides which story piece is ready (data in `godot-prototype/data/farm/story/`, conditions in the kit's language plus the game's own terms); the part `game/farm/ui/storybox.gd` shows it (story box with pages and Skip from the second viewing, speech bubbles that stay until tapped, the 📜 scroll, only when the farm is quiet). Chapter 1 is 17 pieces in English and German (`story/texts/ch1.md` is the readable source; flagged inventions in `story/book-file.md`). A new game opens with the bedside frame, the nibbled stalk and the *How to play* hints. New test `tests/story_test.tscn` and a story section in the smoke test; the data checker knows every condition; the log sheet's 📜 is now 📋. Chapters 2–6 get their pieces when their chapters are built (phase 8). `web-build/` does not match the code. Next: phase 6 (the store and market: M11, M5–M9, M3, M8, M12, P1).

13 Oct 2026 (phase 6, version 0.13.0): the store and the market trip are built. `G.trip` (`game/farm/systems/trip.gd`, `rules/49-trip.json`): the bag with a capacity from the carrying thing (packing leaves things in the store, marked 🎒), the trip (3 ⚡, one Time Quiz question on the way, the village square: sell from the bag, hand over orders from the bag, buy within the room left, back home); the market place on the map is the signpost; selling, buying, barter and deliveries work only on the square. The store is a grid of small tiles with filters and a tap panel; the 🎒 icon (with a thin bar) is the bag. `G.gate` (`rules/50-gate.json`): the travelling merchant at the gate (a cart for now) buys in bulk without a trip at 85 %. `G.trust` (`rules/51-trust.json`): reputation and each trader's trust lower prices a little; season prices with a news line (`rules/52-season-prices.json`); coins fly in bunches of 10. The bot makes trips (it needs about a quarter more questions to reach chapter 5: 765 / 820 instead of 603 / 741). New tests `trip_test`, `gate_test`, `market_test`. Open: the painted village square and a signpost picture, merchants as walking figures, trust-gated wares. `web-build/` does not match the code. Next: phase 7 (the new chapter 1: D2, U1–U5, M14).

13 Oct 2026 (phase 7, version 0.14.0): the new chapter 1 is built. The grain is the seed (wheat has `seedItem`; start with 1 grain; the seller sells grain as a safety net). Crafts to sell: wicker basket, clay (dug at the field edge), clay pot; card *Saving seed*. The travelling merchant barters an axle (900 🟤 + 2 baskets) for the hand cart (bag 60). Hay (`crop_hay`) and winter wheat (`crop_winter_wheat`, `sowSeasons`, `G.fields.sow_season_ok`) with cards; the autumn news line hints at winter wheat. The chapter 1 plan is `planning/2026-10-13-chapter-1-draft.md`. Tools `tools/add_data.py` (add data entries, one per line) and `tools/set_de.py` (set German texts). Bot steps to chapter 5: 761 / 893. New test `crops_test`. Open: winter wheat's quarter-speed winter growth and the ❄️ tiles for other crops (phase 10), the iPad test (W9). Next: phase 8 (six chapters, pets, the Lord's share: S1, S2, M13, I6).

13 Oct 2026 (phase 8, version 0.15.0): six chapters in the data (chapter 5 *Healing* with a placeholder badger, the old chapter 5 is chapter 6; S1), **the Lord's share** (`G.lord`, `rules/53-lord.json`: from chapter 3, due each season, Pieter at the gate, buying with coins blocked until it is paid, at most a quarter of the season's sales; story pieces in `story/texts/ch3.md`), **the pets' jobs** (`G.pets`, `rules/54-pets.json`: level 2 when the next pet is home, a job board in the pet corner, the pets walk to where they work). Tests `lord_test`, `pets_test`. Open: Quill and the story beat that eases the share in chapter 6; levels 3–4 of the pets (S5); the medicine chapter (S3, phase 12). Next: phase 9 (wellbeing and energy: L1–L8).

13 Oct 2026 (phase 9, version 0.16.0): **wellbeing** (`G.well`, `rules/55-well.json`, design document §5.1b): six parameters (sleep, food, strength, friends, calm, play) from chapter 2, a dial on the energy maximum and the energy per Rest answer, a drain that grows with the farm's load and a boost after helping; the farmer's face at the end of the energy bar and a dashboard (tap the face or the farmer) whose rows open with the cards of the new book *Body and mind*; a party and visits to friends; four helpers (whistle, sketchbook, fiddle, bench); Berit's note. The library holds one book more (11 / 13). Tests `well_test`. Open: Wren's line, the chapter 5 collapse (phase 12), meditation and training. Next: phase 10 (nature and winter: N1–N6, N8, U5 rest).

13 Oct 2026 (phase 10, version 0.17.0): **the forest edge** (`G.nature`, `rules/56-nature.json`: pools for sticks, loose stones and clay, the trees' cycle, a yield that falls with the pool but never below 1, advice, a card that shows the numbers) and **winter** (snow on the empty patches until cleared, only hardy crops outdoors, a quarter of the growing speed, winter kale, a text at the start of each season). Tests `nature_test`, `crops_test`. The bot needs about 10–25 % more questions for winter. Open: water as a pool, herbs, the Helper's pause, snow on the ground, bare trees. Next: phase 11 (medicine and the forest: S3, S4) and phase 12 (free play: I10, S5), then the leftovers (T3, R4, J7, H1).

---

## 6. Open tasks → `TODO.md`

The to-do list has its own file since 9 October 2026: **`TODO.md`** (in this folder). It holds the plan at a glance (the
proposed order), what is waiting on the parent, the queue of decisions with Claude's recommendations, and every open task by
area. Finished tasks are recorded in `PROJECT-LOG.md` and removed from `TODO.md`.

---

## 7. Key numbers right now

Data v0.8: 147 items, 445 nodes, 109 recipes, 38 stations, 78 cards in 13 books, 22 polish jobs, 58 helpers, 28 side quests.
Explorer playthrough: about 21.2 hours, ~1,417 Time Quiz answers, ~1,380 Rest answers; pets at about 1.6 / 5.8 / 12 / 17 / 20 h.
Quiz packs: Farm basics (FRM, 4), Continents (CON, 12), Farm pictures (PIC, 18) + card questions KNW-001…234.
