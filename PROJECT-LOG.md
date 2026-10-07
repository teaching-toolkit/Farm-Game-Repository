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
| **Cloud check** (7 Oct 2026) | A fresh Claude Code cloud session set up from scratch with `setup_godot.sh --screens`: Godot 4.7.2 downloads (from github.com → release-assets.githubusercontent.com, not tuxfamily), the import is clean, the smoke test passes, the bot reaches chapter 5 with four pets after 678, 715 and 763 questions in three runs (it plays randomly; the documented 684–744 was too narrow, now "about 680–765"), screenshots work. Docs fixed: how to start the virtual screen (`xvfb-run`), `--newgame` first (the bot leaves its farm in the default save), harmless warnings, the hosts to allow, "all five pets" → the first four; the prototype README's stale "chapter 4 in about 770" replaced. `setup_godot.sh` now says when Xvfb is already installed. No game changes. |

---

## 2. Decisions

### 2.1 From merging the Primer and the Briefing (1.0)

| # | Topic | Decision |
|---|---|---|
| 1 | Rest on a wrong or slow answer | No energy for a wrong answer (the "+1 safety net" was dropped). Later (1.3.4): a slow right answer gives half. |
| 2 | Energy per right answer | +5 then; now set by the home (5–9) plus bed, pillow, bottle. |
| 3 | First recipe | **Porridge** at the tent (fire + tin pot); bread later with an oven. |
| 4 | Starting seeds | 5 wheat. |
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

---

## 3. How the work has been done

- The parent (the designer) gives a list of wishes and test-run findings each round; Claude (the AI assistant) builds them,
  runs the smoke test, the bot and the learner simulation, re-checks the data in the explorer, exports the web version and
  updates the documents.
- Code changes reach the project directly (Cowork sessions edit the folder on the Mac; cloud sessions commit to the private
  GitHub repo). The older way, bundles in `Claude outputs/<name>.tgz`, is no longer needed.
- Pictures are generated in OpenArt (project "Farm Quiz Game"); the parent downloads the chosen versions into `art-inbox/` by
  hand, and `tools/import_art.py all` cuts them in.
