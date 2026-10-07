# Project log — Farm Quiz Game

What was done when, and the decisions taken along the way. Newest at the bottom of each table.
For what the game *is* now, read `farm-quiz-game-master-design-document.md`; for where things stand and what to do next,
`00-READ-ME-FIRST.md`. Older design documents (with every detail of every round) are in `archive/design-docs/`.

---

## 1. History

| Version / round | What happened |
|---|---|
| **Primer & Briefing** | The first idea notes (the "Primer") and a project briefing written alongside an HTML5 prototype. Archived: `archive/design-docs/farm-game-project-briefing.md`, `archive/html-prototype/`. |
| **Design doc 1.0** | The two sources merged into one master design document; every conflict recorded (decisions 1–6 below). |
| **1.1** | A full production and unlock tree as data (`farm-progression.json` v0.1: 5 chapters, 154 unlockables, 132 items, 94 recipes), paced by a simulation; the **progression explorer**; a review of the HTML prototype; the engine question (HTML5 or Godot). Proposals 7–18. |
| **1.2** (data v0.2) | Energy for every job, growing by chapter; basic materials any time; 9 patch levels, fertilizer, perpetual weeds; water for animal products; 36 optional helpers, 27 side quests, two extra fields; swappable question packs; the alpaca; default pet names. |
| **1.3** (data v0.3) | Knowledge cards, books and the library; "Training" renamed **Rest**, with gear; polish; seasons, freshness, pests, frost stones, firewood, muck, crop rotation; food bonuses, luck, gift cards, little jobs, golden acorns, practice stars, choice slots; whole numbers on screen; steady difficulty instead of fixed hours. **The Godot 4.7 prototype starts** (`godot-prototype/`). |
| **1.3.1** | The prototype becomes a farm map for an upright iPad; the web export; the art pipeline (OpenArt sprite sheets → `import_art.py`). |
| **1.3.2** | The map seen at an angle (isometric); layout as data and the drag-and-drop layout editor; see-through dark-blue shadows. |
| **1.3.3** | The whole farm on one screen (forest and road diagonal, three fields in a column); a house plot with bed, books and kitchen inside; buildings with an inside; pens with modular add-ons. |
| **1.3.4** | No words on the map (every plant, weed and stone drawn; amounts as cubes; hourglasses; things fly to the store); ruins and mysterious signs; nothing beyond the current chapter shown; old bucket and wild pond; a road that brings more merchants; pests that eat a share. |
| **1.3.5** | Clearing land and ruins in steps that give material back; Rest with spaced repetition and instant acceptance; reading shows the card, the quiz only the questions; straw unsellable; gathering at once; full stores bounce; pests played out after the quiz; the season bar and the clock; emoji buttons; the workbench with tools. |
| **1.3.6** | A name per player (own farm, own record); water only by hand; harvests that vary (65 % averages); planting after the weeds are out; big buildings in stages with waits; seeds a few at a time; the farm cat and small helpers; two gift cards at work; celebrations for new things. Explorer estimate: 21 h. |
| **1.3.7** | The **learning kit** (`learnkit/`): one learning record per child, an editor page, a maths curriculum for classes 1–7 (7 categories, 76 levels, medals, trophies, titles); prices from ingredients and a market that wants variety; postcards and gifts from friends; perks; the farmer walking on the map. |
| **1.3.8 = round 8** (data v0.8) | Time Quiz with 3–4 answers, picture questions and picture answers, a *Farm pictures* pack, a pool of answers; **an id for every question** (`CON-003`, `KNW-045`), translation files and German pack texts; the woodpile is stoked first; carrying gear takes bigger loads; rooting out weeds gives fibre; the album shows only the next thing to win, medals big; tap a bar to have it explained; "⬅️ Back to the farm"; orders at the bottom of the market; the old fire spot as rocks and a burnt log; no field shadows; orchard trees can be cut down; road levels 3 and 5 in steps; **dynamic difficulty** (first version, off by default); 29 sprite sheets generated (Nano Banana 2 Lite, 1K, 3 versions each) for the parent to pick. Bot: chapter 3 after ~290–415 questions, chapter 5 with all pets after ~684–744. Explorer: 21.1 h, ~1,416 Time Quiz and ~1,380 Rest answers. |
| **2.0 / round 9** (7 Oct 2026) | Housekeeping. The project folder tidied (old documents, prototypes, screenshots and reference art into `archive/` and `reference-art/`); the master design document rewritten as a clean description of the game (2.0), without history or to-dos; this log and `00-READ-ME-FIRST.md` written. 1.3.8 archived. No game changes. `ART_LIST.csv` now marks pictures generated but not yet picked; leftover duplicate originals, thumbnails and caches deleted. |
| **Build script** (7 Oct 2026) | Added `Build web version.command` in the project root: double-click on the Mac to re-export `web-build/` (finds Godot.app, checks the web templates, imports, exports, compares `index.pck`). Written and syntax-checked in the VM; **not yet run on the Mac**. No game changes. |
| **Build script fix** (7 Oct 2026) | First run on the Mac: Godot 4.7 (no patch number) reported `4.7.stable.official.<hash>` and the script looked for a template folder `4.7.stable.official` instead of `4.7.stable`. Fixed: the folder name is now cut at `stable`/`beta`/`rc`/`dev`, and if the templates are not found the script lists the template folders that do exist. Needs a second run on the Mac. |
| **Repos & cloud** (7 Oct 2026) | Set up for GitHub: root `.gitignore`, `CLAUDE.md`, `Publish web version.command` (pushes `web-build/` to a public repo as one commit) and `godot-prototype/tools/setup_godot.sh` (installs Godot 4.7.2, optionally Xvfb, the art packages and web templates, in a fresh Linux session). Tested in a cloud container: smoke test passes, bot reaches chapter 5 after 729 questions, screenshot and web export work. Decision: private repo = the folder; public repo = `web-build/` only, served by GitHub Pages; the public web build is accepted for now (to-do to revisit). |
| **Cloud check** (7 Oct 2026) | A fresh Claude Code cloud session set up from scratch with `setup_godot.sh --screens`: Godot 4.7.2 downloads (from github.com → release-assets.githubusercontent.com, not tuxfamily), the import is clean, the smoke test passes, the bot reaches chapter 5 with four pets after 678, 715 and 763 questions in three runs (it plays randomly; the documented 684–744 was too narrow, now "about 680–800" after three more runs: 774, 689, 793), screenshots work. Docs fixed: how to start the virtual screen (`xvfb-run`), `--newgame` first (the bot leaves its farm in the default save), harmless warnings, the hosts to allow, "all five pets" → the first four; the prototype README's stale "chapter 4 in about 770" replaced. `setup_godot.sh` now says when Xvfb is already installed. No game changes. |
| **New wishes planned** (7 Oct 2026) | The parent's new list (sound and music, the farmer acting out actions, the whole game in German, the knowledge-review share in Settings, a Rest start screen, the forest overlay, one patch and one seed at the start, patch status, why a perk was given, grid windows, the planting water bar, upgrade benefits beyond energy) sorted into groups A–H in `00-READ-ME-FIRST.md` §6, in the planned order; open questions put to the parent. No game changes. |
| **Answers** (7 Oct 2026) | Sounds and music for everyone from the start; extra fun sounds (animal noises on tap and by themselves, paired effects like the Rest lightning) are kept for perks. Sound and music licences: CC0 and CC-BY, with a credits page. The game starts with one wheat seed = one plant. German: Claude drafts, the parent proofreads. |
| **Group A: small fixes** (7 Oct 2026) | **A1** Planting: when water was short, the plant count dropped to what the water allowed, and with one plant per patch the water cost became 0, so its cubes vanished and "Plant" just went grey; now the water a full patch needs is shown, the missing cubes hollow. **A2** Tapping an overgrown patch opens the field sheet with a note: "Patch 4 is not ready yet: it is still overgrown with weeds" and what clears it (or what is needed first). The what-is-in-the-way logic moved from `iso_field.gd` to `G.patch_wild`. **A3** The new-perk pop-up and the album say why a perk came ("You harvested 40 times!", or the favour). **A4** No dark-green forest floor; the trees stand on the meadow; the outline stays as the tap area (faint dashed line in the layout editor, rebuilt). **A5** ⚙️ Settings: "Where the Time Quiz questions come from", ➖/➕ in 5 % steps, saved per farm (`S.review_share`); `knowledgeReviewShare` is the starting value. New screenshot flags `--water=N`, `--menu`; smoke test checks the share. Found: a parse error in a test script makes the smoke test hang silently (tip in READ-ME §4.2). Web build not re-exported. |
| **Upgrade benefits (H1)** (7 Oct 2026) | `progression/upgrade-benefits-ideas.md`: 119 of ~240 upgrade effects only save energy, and 48 upgrades do nothing else. 15 other kinds of benefit (which the engine already has, which need code), a suggested rule (first tier saves energy, later tiers do something else; gear helps with seasons and shows on the farmer) and one idea per upgrade. For the parent to choose; no data changed. |
| **Grown-up lock** (7 Oct 2026) | The parent wants grown-up settings protected by a simple password whose hint is, for now, the password itself (later the password changes and the hint becomes a reminder). ⚙️ Settings: "Who is playing" and the log stay open; "🔒 Grown-up settings" asks for `parentPassword` (settings.json, now "farm", not case-sensitive, hint `parentHint`), then the question share, the learning record, dynamic difficulty and "Start a new game" are open for 5 minutes ("🔒 Lock again" closes them). Flags `--grownup`, `--password`; smoke test checks it. |
| **B1: the opening** (7 Oct 2026) | The game starts with one cleared patch (`land_start` adds 1 plot instead of 3) and one wheat seed (instead of 5). To keep nine patches, a new first clearing job `clear_thistles` ("Clear the thistles (2 patches)", 4 steps, 6 energy, gives fibre and a stone) comes before *Pull the weeds*; the map shows it as weeds. Welcome text updated. New tools: `tools/sync_progression.py` (data → progression/ and the explorer's built-in copy), `tools/explorer_check.js` (explorer headless), bot `--trace=N` (what happens in the first N questions). Bot: chapter 3 at ~280–300, chapter 5 after 671, 629, 752. Explorer: 21.2 h (was 21.1), 1,417 Time Quiz answers, all checks clear. |
| **C: Rest start page** (7 Oct 2026) | **C1** Rest opens on a start page: category and title, section and level ("level 2 of 13"), a progress bar for the level, the section's medals and an empty slot for the next medal with a one-line "what it takes", the best streak, and a big "🏁 Ready, set, go!" that counts down before the first sum. **C2** Picking a sum moved the turn counters (`turn`, `since_new`) even if it was never answered; the pad now keeps them (`math_engine.pick_state`) and puts them back when it leaves the screen unanswered (`number_pad_quiz.abandon`, also on `_exit_tree`), so a sum left on screen is not wrong, not slow and does not shift the repetition. Smoke test checks both; `--restgo` for screenshots. |
| **D: grid windows** (7 Oct 2026) | Every action in a place's sheet is a tile in a grid like the store and the market: picture or emoji, name, what it gives, its cost cubes, and its button at the bottom (`_tile_button`: full width, pushed down so a row's buttons line up). Converted: station recipes (3 per row; recipes still locked are listed under the grid), planting (one tile per crop, "🛒 Buy seeds" inside), weeds and stones on a patch, goals and optional upgrades (`_node_row(..., tile)` / `_node_grid`, 2 per row), polish (2 per row), animals (Collect and Clean tiles), library cards (`_card_tile`: Read / Quiz / Read again / ⏳). `_grid(cols)` takes the number of columns. |
| **E: languages** (7 Oct 2026) | The whole game can switch between English and German in ⚙️ Settings (per device, `user://language.txt`; `data/settings.json` `language` is the default). `scripts/i18n.gd` loads `data/i18n/ui-<lang>.json` into Godot's TranslationServer (so `tr()` and every label follow it) and lays `data-<lang>.json` / `learn-<lang>.json` over the game data and the Rest curriculum; English is the fallback. `tools/i18n.py` collects every text (`tr("…")` in the scripts, tables marked `# i18n`, the data fields players see) into each language's files, flags changed English, and checks `%s`/`%d`/`{…}` slots. ~500 interface literals were wrapped in `tr()` with a reviewed script; plurals built with an added "s" became two full sentences; a message check that compared English prefixes (`begins_with("🧺 Harvested")`) now matches the translated wording; read-aloud picks a voice in the game's language. German drafted by Claude: 560 interface texts, 2,492 data texts, 125 Rest texts. Two English typos ("..") fixed. Screenshots `--lang=de`. Also fixed: an old error when a toast was removed before it faded. |
| **F: sound and music (system)** (7 Oct 2026) | New autoload `Sound` (`scripts/sound.gd`): effects and music from `data/sounds.json` (40 effects with a stand-in sound the game makes itself or silence, 6 music tracks chosen by situation: farm per season, Time Quiz, Rest; cross-fade), buses Music and SFX, per-device switches in ⚙️ Settings and a 🎼 Credits page (sounds from the catalog, fonts). Hooked in: every button (tap), sheets open/close, quiz right/wrong, Rest right/wrong/level/medal/streak, what arrives (harvest, weeds, stones, wood, cooking, crafting, smithing, building, water, animals), selling, planting, reading, celebrations, postcards, too tired. The basic sounds are for everyone now (parent's decision); the *Farm sounds* perk becomes animal voices (tap a pen; now and then by themselves; birds, the cat), other perks get the sound of what they show. `sound-inbox/` (README with what to download, `SOURCES.json` with the Kenney packs) and `tools/import_sounds.py` (copies files by the catalog's patterns, writes the credits). The sound sites are blocked from the cloud machine, so no files yet. Smoke test checks the names and buses. |
| **G: the farmer acts it out** (7 Oct 2026) | After the game has changed the numbers, the farmer walks to the place and acts out what happened: kneels and pulls weeds, fetches the bucket at the pond and sows and waters, picks with a basket, chops, hammers, stirs, reads, sits to rest, cheers. Acts, poses and props are data (`data/acts.json`), played by `scripts/actor.gd`; the farmer (`scripts/avatar.gd`) got knees, a waist that bends, hands that hold props, and poses that blend into each other. A new act or a tap on the ground interrupts: the farmer puts things down, stands up and goes. Test flags `--act=` and `--shotframes=`, and a pose sheet (`tests/pose_sheet.tscn`). Smoke test passes; bot reaches chapter 5 at step 650. |

---

## 2. Decisions

### 2.1 From merging the Primer and the Briefing (1.0)

| # | Topic | Decision |
|---|---|---|
| 1 | Rest on a wrong or slow answer | No energy for a wrong answer (the "+1 safety net" was dropped). Later (1.3.4): a slow right answer gives half. |
| 2 | Energy per right answer | +5 then; now set by the home (5–9) plus bed, pillow, bottle. |
| 3 | First recipe | **Porridge** at the tent (fire + tin pot); bread later with an oven. |
| 4 | Starting seeds | 5 wheat. Changed 7 Oct 2026 (parent): **1 wheat seed** and one cleared patch. |
| 5 | Sunflower, pumpkin | In the crop list. |
| 6 | Barn and storage | Separate buildings. Storage = capacity; barn = big animals, cellar, stable. |
| — | Starting coins | 0 in the design (the old prototype's 200 was a test convenience). |
| — | Tool tiers | A new tier replaces the old one. |

### 2.2 Proposed in 1.1, accepted

| # | Topic | Decision |
|---|---|---|
| 7 | Manure | A compost loop: hungry crops need compost; straw, weeds and manure make it. |
| 8 | Bees | Need flowering crops; never fed. Comb → honey + wax. |
| 9 | Sugar | From beets only. |
| 10 | The "extra" slot | The Lumbermill; the windmill makes flour, later the wind pump. |
| 11 | Barn | Tiers carry cows and sheep, the cellar, the stable. |
| 12 | Watering tools | Save water (−25 / −50 %). |
| 13 | Import Broker | Comes with the 4th pet and opens chapter 5. |
| 14 | Silk | Dropped: linen and plant-dyed wool → the Rainbow Quilt. |
| 15 | Bread | Cottage + oven + sourdough starter (kept); flatbread in chapter 1. |
| 16 | Big buildings | Built in visible stages. |
| 17 | Pets | Bunny, tortoise, goat, pony, alpaca. |
| 18 | Storage | Per-item caps 10 / 25 / 60. |

### 2.3 In 1.2

- Default pet names **Pip, Mossy, Bramble, Hazel, Alfie**; the player may rename them.
- Quiz content is swappable packs chosen by the parent ("the game architect").
- The amount of arithmetic is right (then ~1,980 answers per playthrough); the lever is energy per Rest answer.

### 2.4 In 1.3

| Topic | Decision |
|---|---|
| Food | A bonus that lowers energy costs for 1–2 questions; never restores energy. |
| "Training" | Renamed **Rest**; gear either gives more per answer or makes work cheaper. |
| Card reviews in the Time Quiz | Yes, `knowledgeReviewShare` 0.25. |
| Seasons | Light: some things slower, some plentiful; nothing dies. |
| Freshness | Checked at the change of season, with a warning one season ahead. |
| Pests | Reduce plants (never below 1), visible, chased by the scarecrow's looks. |
| Farm layout bonuses | **No.** |
| Quality stars | **No.** |
| Gift cards | Pick 1 of 3 (later replaced by postcards from friends, 1.3.7). |
| Swappable ingredients | "Any of a kind" for everyday recipes; signature dishes fixed; different sweeteners make differently named dishes. |
| Endless upgrades | Yes, from chapter 1, as polish with diminishing returns. |
| Cards | One idea per card; unlock, boost or both. |
| Paying for knowledge | Coins + reading time + showing the knowledge in a quiz; no second currency. |
| Length | No hour target; steady difficulty (minutes per goal rise gently, Rest per hour in a band). |
| Numbers | Exact underneath, whole on screen. |
| Engine | **Godot** (the HTML5 prototype is archived). |

### 2.5 In the Godot rounds (1.3.1 – 1.3.8)

| Round | Decision |
|---|---|
| 1.3.1 | iPad portrait first; the browser export is how it reaches the iPad; art style C (bold cartoon), made with OpenArt as sprite sheets. |
| 1.3.2 | Isometric map, pictures placed by their feet, taps only on visible pixels; the layout is data and edited by hand in the layout editor. |
| 1.3.3 | Everything on one screen, no scrolling; final pictures without upgrades, upgrades as add-ons; house, barn and workshop have an inside. |
| 1.3.4 | The parent's layout is the game's layout. No words on the map; amounts as cubes. Nothing beyond the current chapter is shown. Water is scarce and carried. Rest typed on a number pad with a 2.5 s "quick" time. Avatar: try a 3D figure drawn into the 2D map first (option B). |
| 1.3.5 | Clearing and ruins in steps that give material back; Rest takes a right answer at once, wrong only on ✔; gathering gives at once and refills by question; straw cannot be sold. |
| 1.3.6 | Each name has its own farm; water only by hand; yields are averages with a spread; buildings in stages with waits; seeds come a few at a time; the farm cat is a helper, not named by the player; two gifts at work. |
| 1.3.7 | Learning lives in a reusable learning kit with one plain JSON record per child that a parent can edit. Medals bronze/silver/gold; no leagues, no breakable daily streaks. Prices follow ingredients; the market pays less for piles of one thing. Gifts only come from friends and cannot be bought. Perks are cosmetic only. |
| 1.3.8 | Questions are tracked by a permanent id (never changed or reused) so records survive rewording and translation; 4 answers by default with a pool to vary wrong answers. Fuel is stoked by hand, never auto-stacked. Carrying gear multiplies loads rather than lowering energy. Dynamic difficulty adjusts only coins and big amounts, fixed when a goal appears, following the pace only in part (^0.4, ×0.8–1.25), and is **off by default** until play-tested. Recipes keep fixed amounts. |
| 2.0 | The master design document describes the game only; history and decisions live here; open tasks and the working guide in `00-READ-ME-FIRST.md`. |
| 2.0 (repos) | Two GitHub repos: a private mirror of this folder (work, cloud sessions) and a public one with only `web-build/` (GitHub Pages, for the iPad). Its contents being public is accepted for now. |

### 2.6 Assumptions made along the way (not yet confirmed by the parent)

- The two starting patches start with a few weeds and a stone each. (1.3.5)
- "Fence remnants" means broken pieces and lone posts round the outside of the fields. (1.3.5)
- The other crops' yields were scaled like wheat (65 %); rain keeps planting free. (1.3.6)
- Sums start at level 1 for everyone (fast track skips what is known); only Plus & minus is on at first. (1.3.7)
- A slow answer counts like a wrong one for repetition but still gives half the energy. (1.3.7)
- Perks come from the first four favours and from achievements. (1.3.7)
- "3–4 options" means 4 by default, settable to 3 (`quizOptions`). (1.3.8)
- Cutting down an orchard tree costs 3 energy and gives a log and 2 sticks. (1.3.8)
- "The water bar in the planting window doesn't show the empty cubes" meant the case where water is short (the cubes vanished).
  (A1, 7 Oct 2026)
- The knowledge-review share is kept per farm (not per device) and goes in 5 % steps. (A5, 7 Oct 2026)
- German: "ß" (as in the quiz packs), the child addressed as "du"; postcards say "Hallo {player}" (no gendered "Liebe/r"). (E, 7 Oct 2026)
- The language is chosen per device, not per player. (E, 7 Oct 2026)
- Sound and music switches are per device; the tap sound is on every button; music volume −14 dB (farm), −18 dB (quiz, Rest). (F, 7 Oct 2026)
- The farmer's acts only show what already happened (numbers change first); any new act or tap interrupts the one playing. (G, 7 Oct 2026)
- The two patches lost from the start come back as a new first clearing job, *Clear the thistles*. (B1, 7 Oct 2026)
- The grown-up lock: password "farm"; "Who is playing" and the log stay open to the child; once typed it stays open for 5
  minutes. (7 Oct 2026)

---

## 3. How the work has been done

- The parent (the designer) gives a list of wishes and test-run findings each round; Claude (the AI assistant) builds them,
  runs the smoke test, the bot and the learner simulation, re-checks the data in the explorer, exports the web version and
  updates the documents.
- Code changes reach the project directly (Cowork sessions edit the folder on the Mac; cloud sessions commit to the private
  GitHub repo). The older way, bundles in `Claude outputs/<name>.tgz`, is no longer needed.
- Pictures are generated in OpenArt (project "Farm Quiz Game"); the parent downloads the chosen versions into `art-inbox/` by
  hand, and `tools/import_art.py all` cuts them in.
