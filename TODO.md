# To-do list — Farm Quiz Game

The project's to-do list and plan. Moved out of `00-READ-ME-FIRST.md` §6 on **9 October 2026**; finished tasks live in
`PROJECT-LOG.md`, not here. **Last updated: 13 October 2026** (phase 1 built and checked, version 0.9.0; phase 2, the restructuring, done (R0–R8); phase 3, the interface, built: version 0.10.0, waiting for the iPad (W9); seven rounds of the
parent's decisions, 10–12 Oct, worked in; §0 is the implementation plan).

**Standing rule** (from `00-READ-ME-FIRST.md`): keep this file current *as you work*. Tick off or remove done tasks (and add a
row to `PROJECT-LOG.md`), add new ones, reword changed ones. A task that is not written here does not exist for the next chat.

**Labels** (as in `story/`): ✅ decided by the parent · 💡 proposed by Claude · ❓ open question · ⚠️ a clash with an existing rule,
decision or file · 🔗 depends on / ties in with.
**Sources:** `[#1]`…`[#16]` (game) and `[#S1]`…`[#S8]` (story) are the paragraphs of the parent's notes of 9 Oct 2026
(`planning/2026-10-09-parent-notes.md`). `[R1]`…`[R7]` are the seven decision rounds of 10–12 Oct 2026, Claude's questions with the
parent's answers, kept word for word in `planning/2026-10-1*-answers-round-*.md`. The decisions are summarised in
`PROJECT-LOG.md` §2.8 and built into the tasks below. Older tasks keep their old ids (W1, H1, I5 …); the old "Later" list is Z1–Z7.

---

## 0. The implementation plan ✅ (agreed 12 Oct 2026, R7)

Twelve phases. **Every phase ends with a game that works**, a version number, a web build and (where the child sees something new) a
play-test on the iPad. Sizes are rough: one session ≈ one longer chat. Two tracks run **alongside** the code from phase 2 on: the
**paper designs** (D1–D4, written before the phase that builds them) and the **story** (Rounds 6–7: texts, German).

| Phase | What | Tasks | Version · test | Size |
|---|---|---|---|---|
| **1. Ready to build** | Godot set up in the Mac's Linux shell; **the round 8 pictures** sorted, imported and checked on the map; version numbers; "ss"; the first-try rule; the game renamed **Hazelwood Harvest**; stale facts in the design document | ✅ done 12 Oct 2026, except the iPad test (W3) | **0.9.0** · iPad | 2–3 |
| **2. Restructuring** ✅ done 13 Oct 2026 | Slices R0–R8 of the architecture plan, none of which changed the game: safety net and golden run, folders, content out of code, core, rules split, interface split, map, versioned saves, data split, pacing from the real engine, the explorer updated by a script | T2 | 0.9.x · golden run, no iPad test needed | 10–14 |
| **3. Interface in the new structure** ✅ built 13 Oct 2026 (the iPad test is W9) | Whole-field section (no field sign), Rest walk, the playback after the quiz, phone-like notifications, read-aloud setting, the new top bar (no bottom bar), cheat buttons, **the season shader** (snow caps, muted winter, golden autumn: looks only) | J2–J6, J8, J9, N7 | **0.10** · iPad | 3–4 |
| **4. Foundations** | What is shown when (frozen/hidden per system); item weights; **quality**; **skills and ranks**; **bronze and gold** and the realistic prices (after D3) | O1–O3, M4, Y1, Y2, M1, M2 | 0.11 · bot and explorer | 4–6 |
| **5. Story engine** | Opening panels and frame, the 📜 scroll, bubbles, first-tap stories, chapter 1 texts (needs Rounds 6–7) | I8a, I9, I7 (ch 1) | 0.12 · iPad | 3–4 |
| **6. Store and market** | The store as a grid with filters and packing; the bag; the signpost, trips and the market square; the travelling merchant as a figure; trust; coin animations; season prices | M11, M5–M9, M3, M8, M12, P1 | **0.13** · iPad | 5–7 |
| **7. The new chapter 1** | One stalk, saving seed, crafts to sell, hay, winter wheat and onions, the first trip for carrot seeds, the axle and the first cart (D2 first) | D2, U1–U5 (ch 1), M14 | **0.14** · iPad (the big one: the whole new start) | 4–6 |
| **8. Six chapters, pets, the Lord's share** | Renumbering, the badger placeholder, pets visible with job board levels 1–2, **the Lord's share with Pieter** from chapter 2/3, the rest of the chapters re-checked for the new economy | S1, S2, M13, I6 parts | 0.15 · iPad | 5–7 |
| **9. Wellbeing and energy** | The energy model, the six parameters, the face and the dashboard, drain and happy boosts, the body-and-mind books | L1–L8, K4 (part) | 0.16 · iPad | 4–6 |
| **10. Nature and winter** | Resources that deplete and regrow (trees ↔ stumps, stones, clay, water), advice and floors, snow that settles and must be cleared, winter sowing (winter kale in chapter 2), the season texts | N1–N6, N8, U5 (rest) | 0.17 · iPad | 4–5 |
| **11. Medicine and the forest** | Chapter 5: the still-room, remedies, the Healer's Herbal, the Wren check, the forest screen | S3, S4 | 0.18 · iPad | 6–8 |
| **12. Free play** | After chapter 6: loose-end goals, job board levels 3–4, more side quests and perks | I10, S5 | **1.0** · iPad | 3–4 |
| always | Curriculum (when the parent's list is there), sounds, upgrades' benefits (H1, alongside phase 4), the parent's checks and proofreading | K1–K5, W5, W8, H1 | – | – |

**Why this order.** Phase 1 clears what is waiting (the pictures) and the three changes that don't touch the big scripts, so the child
gets something new right away. Phase 2 comes next because every later phase adds code, and adding it to the restructured game is
cheaper and safer than restructuring later. Phase 3 brings the visible interface fixes as soon as there is a good place for them.
Phase 4 builds the shared foundations (what is shown when, weights, quality, skills, money) that the market, chapter 1, wellbeing and
nature all use. The story engine (5) precedes the market (6) because the market's limits need story reasons the player is told, and
both precede the new chapter 1 (7), whose whole shape depends on the first trip. Chapters, pets and the Lord's share (8) come once the
economy works; wellbeing (9) and nature (10) once there is a farm big enough to strain; the medicine chapter (11) last among the systems,
because it is where carrying, energy, skills, nature and the forest all meet.

**Rules for every phase:** plan bigger steps in this file before building (the session skill §3); one slice at a time, each passing the
checks; the bot learns every new mechanic; the explorer gets updated by its script; the design document describes the game as it is;
a log row per change; `web-build/` exported at the end of the phase.

**Every game change also needs** (details: `claude-skills/farm-game-check/SKILL.md` and `claude-skills/farm-game-content/SKILL.md`):
German through `tools/i18n.py`; the smoke test; the bot (it must learn any new mechanic, e.g. market trips, packing, the Lord's share);
the explorer (pace in hours, Time Quiz and Rest answers per hour); the design document; a log row. **Old saves must keep loading.**

**T3. The bot plays to the end of chapter 5** (and later chapters' free play). It stalls in chapter 5 (energy 0 after about 800 questions; the alpaca's goals
  need things it does not make). Then the explorer's own simulation and its checks can be replaced by the bot's report and the data checker (the R7 decision). The
  bot also has to learn every new mechanic as it arrives (market trips, packing, the Lord's share …).

**T2. Architecture and restructuring** ✅ (R5, R6). **Plan written: `planning/2026-10-12-architecture-plan.md`** (read it before any
code work). In short: a small **core** (data loading, modifiers, conditions, the clock, versioned saves, events, a seedable random
source), **kits** that each do one job and know nothing about farming (learn, progression, knowledge, items & trade, crafting & skills,
needs & energy, resources, seasons & weather, story, rewards, world, avatar, ui, audio, i18n), and **the farm** on top. Reuse target ✅
(R6): a **spin-off** where another character starts a **quarry, mine and smithy** from scratch at the other end of Hazelwood (less story,
similar unlocking, building, energy, time and books); every kit must make sense for it, farm-only rules stay in the farm. Done in nine
slices that don't change the game, each checked by a **golden run** (the bot plays a fixed-seed game; the farm's state after every
question must match):
- ✅ **R0** safety net (`--seed`, golden run, save fixtures, an interface test driver, screenshot flags out of `main.gd`; done 12 Oct 2026,
  `bash tests/check_all.sh`) · ✅ **R1** folders
  (`kits/`, `game/farm/`; done 12 Oct 2026) · ✅ **R2** farm content out of code (done 13 Oct 2026: `data/farm/places.json`; pets, animals and
  the chapter rule now come from the nodes and `chapters[].pet`; checked by `tests/places_test.tscn`, which is part of `check_all.sh`) · ✅ **R3** core
  (done 13 Oct 2026: `kits/core/` modifiers, conditions, rng, clock; events come with R4, saves with R7, data loading with R8) · ✅ **R4** `game.gd` split into 11 systems in `game/farm/systems/` (done 13 Oct 2026; `G.<system>.<function>`; see its README; left: the lists of
  node types `GOAL_TYPES` in `main.gd`, `NOT_AUTO`, `MAIN_TYPES`, `DEFAULT_CAT` in `game.gd` → data, with R8) · ✅ **R5** `main.gd` split into a composition root and 25 parts in `game/farm/ui/`
  (done 13 Oct 2026; own README; the generic hosts become kits with phase 3) (was T1) · ✅ **R6** map (done 13 Oct 2026: `farm_map.gd` split into ground, critters, cat and walker; the pests are drawn once: the copy in `field_view.gd` was dead code and is gone; no `kits/world` yet) · ✅ **R7** saves with versions and upgrade steps (done 13 Oct 2026: `kits/core/saves.gd`, `SAVE_VERSION` 1, `save_defaults()` per system, `tests/saves_test.tscn`) ·
  ✅ **R8** (done 13 Oct 2026): the data in files (`data/farm/`, `kits/core/data.gd`, `tools/farmdata.py`), a data checker (`tools/check_data.py`), pacing from the real
  engine: the bot's `--report=FILE` (per chapter: Time Quiz answers, Rest answers, card questions, actions, hours), shown in the explorer's Pacing tab, refreshed
  by `Update explorer.command` (= `tools/update_explorer.sh`). **Left from the R7 decision:** the explorer still has its own simulation (labelled as the older model)
  until the bot plays all of chapter 5 and free play: see T3.
- ✅ Decided (R7): **pacing from the real engine**: the bot reports hours, questions and Rest answers per chapter; the explorer no longer
  simulates its own copy of the rules but shows the data and that report, refreshed by **a script the parent can run** (a double-click
  `Update explorer.command`, like the web build's) whenever the game has changed; the explorer is a nice-to-have, not a priority.
  **The interface fixes come after the split**, except J1, J10, J11. **The Godot project is renamed *Hazelwood Harvest*** in phase 1; the
  folder stays `godot-prototype/`. The spin-off games are **very hypothetical**: kits are only as general as the farm needs, cleanly
  separated so that reuse stays possible.
- Afterwards: `godot-prototype/ARCHITECTURE.md` from the plan; a "where new code goes" section in `claude-skills/farm-game-session`.

---

## 1. Waiting on the parent

- **W1. Round 8 pictures:** ✅ imported 12 Oct 2026 (log). Left for the parent: look at them in the game; the second version of the
  add-ons sheet is kept as `art-inbox/sheet30-addons-alt.png` (rename it to `sheet30-addons.png` and re-import to swap).
- **W2. GitHub repos and the double-click scripts.** ⚠️ With the round 8 pictures `web-build/index.pck` is 89 MB; GitHub refuses
  files over 100 MB, so the next big batch of pictures needs a plan (compressing the pictures for the web, or Git LFS). The private repo exists. Still to do: the public web repo
  (`00-READ-ME-FIRST.md` §4.7), GitHub Pages, the first run of `Build web version.command` and `Publish web version.command` on the
  Mac, the iPad Home Screen link. Cloud sessions can push to the private repo (a 403 on 7 Oct 2026 went away once the Claude GitHub
  App had write access).
- **W3. Play-test round 8 on the iPad** and collect the findings (pace, picture questions, stoking, loads, the bar explanations).
  Several notes of 9–12 Oct came from this (J2–J5, J8–J10); keep adding.
- **W4. Check what was built on 7 Oct 2026** (details in `PROJECT-LOG.md`):
  - A1–A5 small fixes (planting water bar, overgrown patch note, why a perk came, no dark forest floor, the question share) and the
    grown-up lock (password "farm", hint shows it for now; later a real password and a reminder as the hint).
  - B1 the opening: one cleared patch, one wheat seed, the new *Clear the thistles* job (the opening changes again with D2).
  - C1 the Rest start page, C2 a sum left on screen leaves no trace.
  - D every window as a grid. Not converted: the woodpile's "+ Stick" chips, "Weed all / Pick stones" (Weed all / Pick stones moved with J2 ✅), the quest
    book. The store becomes a compact grid anyway (M11).
  - G the farmer's acts: watch them on the iPad and say which look wrong or too fast (each is a few numbers in `data/acts.json`).
- **W5. German proofreading** (easiest in the game with the language on Deutsch, or in `data/i18n/*-de.json`). ✅ "ss", never "ß":
  switched everywhere on 12 Oct 2026.
- **W6. The curriculum** [#S1]: find out what the curriculum is and which broad frameworks of knowledge to prioritise; the parent
  provides these frameworks and the critical knowledge ("I will let you know when I've made some progress", R1). Unblocks K2–K5.
- **W7. Answer the open questions in §2.**
- **W8. Sounds still missing** (system done 7 Oct; 83 files in `assets/sounds/`, 31 of 40 effects and all 6 music tracks): cow,
  sheep, goat, pony, bees, cat, birds, `extras/party`, `extras/wind` (stand-ins play until then). The Mudchute cow and sheep in
  `sound-inbox/unused/` are CC-BY-SA (share-alike): use only if the parent accepts that licence; the BigSoundBank/OpenGameArt CC0
  cow and sheep are better. The two "for now" music tracks are credited by artist and site only (farm: Zane Little, OpenGameArt, CC0;
  quiz/Rest: Kevin MacLeod, incompetech, CC BY 4.0); add the track titles to `sound-inbox/SOURCES.json` if known. **Nobody has
  listened yet** (volumes in `data/sounds.json`). The cloud machine cannot reach kenney.nl, opengameart.org, bigsoundbank.com or
  incompetech.com (7 Oct 2026): the parent downloads what `sound-inbox/README.md` lists, or allows those domains; then
  `python3 tools/import_sounds.py` and `$G --headless --path . --import`, listen, adjust volumes.
- **W9. Play-test version 0.10.0 on the iPad** (publish with `Publish web version.command`; `web-build/` does not match the code yet). Look at: the new top bar and no bottom bar (J8, does anything feel cramped?); notifications (J5: swipe one away, are they too small or gone too fast?); the *The whole field* section in a patch's window and the 🔨 above the first field (J2); the Rest walk, is the pause before the window right (J3, `rest.go_rest`); the playback after the Time Quiz, are the pause, the rain and the flicking plants right, does a tap skip (J4, constants at the top of `playback.gd`); read aloud *by itself* (J6, does the iPad voice work?); snow caps, muted winter and golden autumn on the real screen (N7, `kits/ui/season.gdshader`: how deep the snow caps reach, how strong the colours). Also: the cheat buttons are off by default now; switch them on in the grown-up settings.

---

## 2. Open questions

None right now: everything asked between 9 and 12 Oct is answered (`PROJECT-LOG.md` §2.8). New questions go here as the phases bring
them up, each with a 💡 recommendation.

---

## 3. Paper first (D) — before the big systems are built

- **D1. The design document's *(planned)* chapters**, one per new system, describing the game as it will be (not the change):
  the energy model and wellbeing (L), trips, packing and the store (M), quality and skills (Y), seeds (U), money, prices and the
  Lord's share (M), sustainability and seasons (N), what is shown when (O). Including the rule changes decided in R1–R4 (§2.8 of the
  log): the Time Quiz can give and drain energy; natural consequences instead of "nothing punishes"; quality stars are back; deliveries
  ride in the bag; a right *first* try moves time.
- **D2. The new chapter 1 as a sequence on paper** ✅ (R3): one stalk grows into one plant → a card about saving seed (the grain is
  the seed) → a few patches of wheat, porridge (clearing more patches before the village is fine) → crafts from what is at hand: fibre
  rope, reed or wicker baskets, the first clay → the farmer avoids the village until something forces a trip: **carrot seeds** (there
  are no carrots anywhere, so a first seed must be bought; carrots only flower in their second year) → the first trip: sell crafts and
  porridge, buy carrot seeds → the travelling merchant passes by; barter for an **axle** (expensive); the first cart → the bunny comes
  home. Output: every node, its cost, card and unlock, with first numbers; then checked in the explorer before any data changes.
- **D3. A realistic price table** ✅ (R1, R2): today's Swiss prices for things the child knows (bread, eggs, milk, a basket, a
  hammer), old-world ratios for the rest; how much wheat a bowl of porridge really takes; seeds sold by the bag (a handful is cheap); an
  axle is expensive. In bronze (100 bronze = 1 gold). 🔗 M1, Y2 (the novice/master rule for what is worth making).
- **D4. The hidden/frozen/visible table, complete** (O1): every system, what it does before it is shown, and when it is shown. Start:

  | System | Before it is shown | Shown when |
  |---|---|---|
  | Item weight and carrying | works, unexplained (the bag simply fills) | the first market trip |
  | Energy drain and wellbeing | frozen | chapter 2 (the face appears) |
  | The bed's energy | shown plainly from chapter 1 ("+1 ⚡ per right sum"); that it goes through *sleep* is never said | – |
  | Happy boost from helping | works, unexplained | a book explains it |
  | Sustainability (forest, water, clay) | frozen | chapter 2–3, through a note in the grandmother's book |
  | Market prices changing | frozen | the first season with market news |
  | Merchant favour and trust | works, unexplained | the merchant says so ("for you, a better price") |
  | Skills and practice | works, unexplained | the first rank-up (Y2) |
  | The Lord's share | does not exist | chapter 2 or 3 (M13) |
  | Forest screen | does not exist, not even visible | chapter 5 |

---

## 4. Interface and feel (J) — small, can be done one by one

- **J2. Whole-field actions without the field sign** [#8] ✅ (R1). Today the farmer walks to the **sign** for a whole-field job and acts
  there. Remove the field sign; at the bottom of a patch's window a titled section **"The whole field"** with *Harvest all*, *Pick all
  weeds*, *Pick all stones* (and *Clear the snow*, N6), then the field's upgrades, then the pests line. The farmer walks to the field
  (patch to patch while acting). Notes: today *Weed all* / *Pick stones* are in `patches.part_field`, *Harvest all* in `patches.part_area` and at the
  storage basket (`pantry._harvest_everything`), in `game/farm/ui/`; `deco/signpost.png` goes unused; all three fields.
  **Built 13 Oct 2026 (0.10.0):** the sign is gone from `map_layout.json` (and `tools/default_layout.py`). A patch's window ends with `placesheet.part_field_below()`: section *The whole field* (🧺 Harvest all · 🌿 Pick all weeds · 🪨 Pick all stones, each with the number of patches it is for, greyed when 0), then *To do here* (clearing, new land), the field's polish and upgrades, then the pests line (`patches.part_pests`). Tapping an overgrown patch opens the same list as a window of its own (with the "why it is not ready" note). The first field gets a small 🔨 when something can be done (`map.set_field_badge`). Each patch plays its own act, so the farmer walks from patch to patch. *Clear the snow* (N6) joins the section when N6 is built. Smoke test checks one tap weeds the patch. Found: the polish card "Mend the fence" says "At full polish: pestBlock +0" (a raw key, like J12).
- **J3. Rest: the farmer goes home** [#9]. When Rest starts, the farmer walks to the tent or house. The code already starts a "rest" act
  at the house (`rest.show_rest` in `game/farm/ui/rest.gd`), but the Rest window covers the farm. Check on the iPad; 💡 open the window when the farmer
  arrives (or after about half a second).
  **Built 13 Oct 2026 (0.10.0):** `rest.go_rest()` (the energy pill and the bed button): the house window closes, the map scrolls to the house, the farmer walks there and the Rest window opens when he has arrived (after 0.4 s at the earliest, 1.6 s at the latest). `show_rest()` stays the window itself (tests). Check the timing on the iPad.
- **J4. Back on the farm after the Time Quiz** [#10] ✅ (R2, R3). While the quiz is open, nothing on the farm changes. After "Back to
  the farm": a fixed short pause (0.7–1 s, the same after one question or eight), then the changes play, mostly together, some
  staggered: **rain first** (if it rained; a big global event that draws attention), then the **plants flick quickly through every
  in-between stage** (sped-up time, not a jump), together with weeds, pests and a travelling merchant coming down the road; the **energy
  change** gets its own animation (e.g. the bar pulses and a "−4" floats up and fades), so it is noticed but easy to ignore once known;
  short explanations pop up. ✅ Order (R5): 0–0.7 s pause → about 1 s of rain if it rained → plants flicking through their stages (about
  0.3 s each) together with weeds, pests and an arriving merchant → last the energy bar's pulse and floating number, short notes. **Any tap
  jumps to the end.** Notes: the pests are already played after the quiz (`mapview.play_fx` →
  `map.play_pending()`); the rules engine must record a small snapshot per question. Later the same playback shows the pets' work (S2).
  **Built 13 Oct 2026 (0.10.0):** `game/farm/ui/playback.gd` (`M.playback`). The Time Quiz opening starts the hold: `main.refresh()` does nothing while `playback.held`, so top bar and map keep the old look (the rules have moved on). On closing: 0.8 s pause → rain (`map.play_rain()`, 1.2 s, only if it rained in any answered question) → one `refresh()` in which plants that moved on go through every stage in between at 0.3 s each (`IsoField.refresh(flick)`) while a bar that changed (energy, water) pulses with a number floating up → pests and the scarecrow (`play_pending`) → the notes, a gift or a celebration last. A tap anywhere skips to the end (`playback.finish()`). No answered question: no pause. Not built yet: the travelling merchant (comes with M-phase), the pets' work (S2); today a question does not change energy, so the pulse shows once cold houses and meals use it. The smoke test checks hold, wait, catch-up, the tap and the flick.
- **J5. Notifications like a phone's** [#12] ✅ (R4): they stack from the top, just below the top bar; a swipe sends one away if it
  doesn't leave fast enough; smaller; a duration per kind. Today (`notes.toast` in `game/farm/ui/notes.gd`): 6.5 s each (bar hints 3 s), max 3, centred above
  the bottom bar, taps go through them (`MOUSE_FILTER_IGNORE`). Same look family as the barks' speech bubbles (`story/story-delivery.md`).
  **Built 13 Oct 2026 (0.10.0):** `kits/ui/notifications.gd` (a generic stack: `notify(text, secs)`, a swipe of 70 px sends a card away); `notes.toast(text, secs := 5.0)` in the game; smaller text (17 pt), at most 4, the stack starts just below the top bar; taps outside the cards go through. `--toasts` shows a stack in screenshots.
- **J6. Read aloud in the grown-up settings** [#13] ✅ (R1): one setting with three choices: *off* (no 🔊 buttons) · *button* (as now)
  · *automatic* (reads each question and card page as it opens; the 🔊 button stays to repeat). Today: 🔊 in the Time Quiz and on card
  pages (`timequiz.speak` in `game/farm/ui/timequiz.gd`). Later the story boxes too (I8).
  **Built 13 Oct 2026 (0.10.0):** ⚙️ Settings, grown-up part → a *device* card: three buttons (🔇 Off / 🔊 A button / 🗣️ By itself), kept on the device (`kits/core/prefs.gd`, `Game.read_aloud_mode()`); the Time Quiz and card pages obey it.
- **J12. The pet corner shows a raw key.** The sheet lists each pet with its bonus; the tortoise's reads "Mossy — fetchWater +1" (the effect key,
  not words; the bunny's reads properly, "+1 carrot per harvest"). Found 13 Oct 2026 while checking R2; the same in the old code. 💡 Give the
  pet effects readable lines (`widgets.effect_text` in `game/farm/ui/widgets.gd`, German through `tools/i18n.py`) and check the goat's and the pony's too.
- **J7. Stale facts left** (the rest fixed 12 Oct 2026): the design document's §1.1 premise (tent, bucket, pot, one seed, a box with a
  book) vs the story (bucket, pot and book come in Berit's box; the seed is found on the one live patch; the tent is borrowed): fix
  together with I9. `story/characters/lark.md` has Lark turn up "the day the market stall opens" (chapter 2); the ladder has him walk up
  the new gravel road (`road_3`, 2.5): pick one in I6.
- **J8. A new top bar** ✅ (R4; the parent checked: there is plenty of space). The **Time Quiz button moves up**: the green circle with
  the watch face hangs from the bottom edge of the bar in the right corner. The **next goal's text** fills the whole width and height
  between the energy bar and the 🎒 bag icon. The 🎒 bag with its fill bar (M11), 📜 scroll, 📖, 🖼️, ⚙️; the wellbeing face or icon is
  fitted in when it appears (L4). ✅ (R5) **The bottom bar goes**, and the map grows by its height (the layout editor's frame changes
  with it).
  **Built 13 Oct 2026 (0.10.0):** the bar has the coin count, water and energy bars (rows of boxes), the goal text across the middle at full height, the five icon buttons at the right and the clock hanging from the bar's right edge; no bottom bar (the map runs to the bottom edge); the quiz button is `main._place_quiz_button()`; toasts start under the bar. The bar fits any width from 744 (iPad mini) up: `main._fit_hud()` shrinks the cubes of the two bars (a fresh game was 35 px too wide at 834 before; the smoke test checks 834 and 744).
- **J9. Cheat buttons** ✅ (R4): the cheat button and the +100 button leave the bar for good. A grown-up setting switches them on or off;
  when on, they float below the bar in the top-left corner. The coin button gives **+50 bronze**. New: a cheat to **skip the quiz of
  any knowledge card waiting for its quiz**.
  **Built 13 Oct 2026 (0.10.0):** ⚙️ Settings, grown-up part → "Testing buttons on the farm (cheats)" (on the device, `Game.cheats_visible()`); three buttons float at the top left (Cheat, +50, Quizzes = `knowledge.cheat_skip_card_quizzes()`).

---

## 5. Pictures (R)

- **R1. Straw needs its own picture** [#15]. Generated, waiting to be picked (`items/straw.png`, sheet 45; part of W1). Straw, wheat
  and flour all use the emoji 🌾: give straw and flour their own stand-in emoji. Hay (U1) needs a picture too.
- **R2. Seeds** [#16]. For grains, beans and peas the harvest *is* the seed (U2), so no seed picture is needed there. For the others
  (carrot, onion, beet …): 💡 one "seed bag" picture with the crop's small picture on it, rather than one picture per crop.
- **R3. Rules for story pictures** ✅ [#S5], [#S6], (R1): the farmer is **never** in a painted picture. Pictures are seen through the
  farmer's eyes (a few panels may show **a hand reaching out from the camera**), or show the **silhouette of a farmer with a hat, from
  behind, backlit**. Avatars drawn by the game in the player's own look (village-square scenes, visits) are fine. Add to
  `story/story-delivery.md` and the prompt rules for `ART_LIST.csv`.
- **R4. New map pictures:** the **signpost with a village symbol** by the road (M6); the **carrying device standing beside it**: backpack,
  basket, later cart, each in a few fill levels (filled with generic sacks, so one set works for any load); the travelling merchant's
  **cart** in fill levels; **trees, stumps and saplings** at the forest edge (N3); **bare trees** for winter (N7).
- Art for the 67 card pages, gear and pests: see Z6.

---

## 6. Crops and items (U)

- **U1. Hay as its own crop** ✅ (R1) [#15]: a meadow-grass crop that gives **hay** (cut grass gives hay, not straw; and the fire began in
  the hay). Straw stays a by-product of wheat and oats. Hay and straw are partly interchangeable (✅ table, R2):

  | Use | Hay | Straw |
  |---|---|---|
  | Animal food | good | poor (filler) |
  | Bedding | yes | yes |
  | Compost | yes | yes |
  | Thatched roof, beehive skeps | no | yes |
  | Mulch | no (its seeds bring weeds) | yes |

  Straw is unsellable today (`noSell`); ❓ can hay be sold? (💡 yes, to the village's animal keepers.)
- **U2. Seeds from your own harvest** ✅ (R2, R3, R4):
  - The harvested **grain is the seed** (wheat, oats, beans, peas …): one item you can plant, mill or cook. No conversion step. Medieval
    fields gave about 3–5 grains back per grain sown, so about 5 is honest (an ear has 30–50 grains).
  - **Every crop can make its own seed.** Carrots, onions, beets and other biennials only flower in their second year: a plant left to
    seed must **stay in the ground through one winter**, then gives a lot of seed in spring. Meanwhile the patch grows nothing else.
  - Each way of making seed is **learned from a knowledge card** first (K4).
  - **Seeds of every unlocked crop can always be bought**; buying is mostly for starting a new crop.
  - The **Seed Library** (chapter 5) keeps only its heirloom role. Data: seeds are a separate count today (`S["seeds"]`); grains become
    plantable items; the others get seed items.
- **U3. Quality on items** (Y1): crops, dishes, crafts and medicine exist in three qualities; raw materials (sticks, stones, clay …)
  don't. The store shows them on one tile (M11).
- **U5. Winter crops** ✅ (R5, R6): **winter wheat**, a new crop, sown in autumn or winter, slow through the winter (a quarter speed),
  its seed bought first and then saved from its own harvest; **winter kale or cabbage**, a new crop that grows so slowly and gives so
  little that it only pays in winter. ✅ (R7) **Chapter 1:** winter wheat (a card in *The Little Farm Book*, "Wheat for winter: sow in
  autumn", seed bought on a village trip; the first autumn's season text points to it; the first winter comes near the end of chapter 1)
  and onions. **Chapter 2:** the beans count as broad beans; **winter kale** comes with the cows and *Soil & Seasons*, as winter fodder
  and winter food. **Chapter 4:** the glass cloches and the greenhouse let anything grow in winter. 🔗 N6.
- **U4. Made things to sell** ✅ (R2): deliveries and unlocks stay as they are (a fine crafted pot can replace a dish here and there).
  New: tools, baskets, pots, rope and other made things can be made **again and again and sold**. The first one made still unlocks what it
  unlocks. The early game leans on crafts from what is at hand (rope, reed baskets, clay pots, later herbs and medicine) as much as on food.

---

## 7. Money and the market (M)

### Money and prices

- **M1. The economy, rebuilt on realistic prices** [#6] ✅ (R1, R2). Today pizza costs 166 coins because the pricing rule
  (`meta.pricing`) multiplies the mark-up again at every stage (porridge 4, omelette 16, honey cake 49, apple pie 72, pizza 166,
  cheese board 212). New: prices from D3 (Swiss prices for familiar goods, old-world ratios for the rest), then adjusted so the game
  works; the formula's mark-up for dishes made from dishes made smaller, or added instead of multiplied. Include the explorer's
  value-check notes for `rope_straw`, `compost`, `steel` and `jam` (was "Later 4"). 💡 The rule from Y2: for a made thing, the market's
  price lies between what it costs a beginner to make (inputs + energy + time) and what it costs a master, so buying beats making for a
  beginner and making pays for a master. Re-run the explorer and the bot; re-check dynamic difficulty (`meta.flex`).
- **M2. Bronze and gold coins** ✅ (R1): **100 bronze = 1 gold**, like Rappen and Franken (a real-world skill). The game starts in bronze
  only; gold appears once numbers get big; from then on both are shown (2 🟡 35 🟤). Whole numbers on screen stay. Needs: the top bar,
  prices on tiles, the rounding rule (§5.8: stocks down, costs up) for two coins; the +50 bronze cheat (J9).
- **M3. Coin animations** [#7] ✅ (R1): paying, the coins fly to the merchant; selling, they come from him; more than 10 fly in tight bunches
  of 10 (27 → 10 + 10 + 7). Plain flying coins for everyone; the *Coin shower* perk becomes the fancy version (a shower, sparkle, sound).
  🔗 P1 (a merchant figure), M2 (bunches of bronze).
- **M12. Prices that change** ✅ (R1): announced at **each change of season** (a short news line, together with the season's text, N8):
  supply and demand, the season itself, and possibly dynamic difficulty. Also per person: a merchant who likes you gives a better price
  (M8); better quality fetches more (Y1). Costs of goals (buildings, books) never change once shown.
- **M13. The Lord's share** ✅ (R4). From **chapter 2 or 3** (until then the farm is under the Lord's radar: a ruined, abandoned plot).
  Due each season; **it grows with the number of plantable patches, whatever they yield** (the logic that drove the family to extract more
  and more); the fraction **rises chapter by chapter**, as in the origin story; in chapter 6 the Lord asks for "a half" again, and Quill's
  numbers bring it down to "a tenth". **If it can't be paid, nothing else can be bought until it is.** Never stuck: seeds can be self-made
  and selling still works. ✅ (R5) Counted per cleared patch on what the Lord assumes it should give (a patch resting under clover counts
  too), **and per building** ✅ (R6): the ones that produce or process (mills, lumbermill, smithy, kiln, press, workshop, the barn once it holds
  animals), each by its level; not the home, storage, pens or the pet corner. **A person from the village comes to the gate at the end of
  each season** to collect (✅ R7: **Pieter the night watchman**). While unpaid, anything bought with coins is blocked; selling, making, farming, trips and
  barter go on. Never more than about a quarter of a typical season's sales at the planned pace. 🔗 N (the pressure to over-use the land).
- **M14. What coins are spent on, again and again** ✅ (R4): books, animals, materials the farm can't make (iron ore, salt, glass,
  sand), parts (axle, wheels, nails), the coin part of buildings, first seeds of a new crop, the Lord's share (M13), and **made things
  bought instead of made** (a beginner buys a hammer; a master smith makes and sells them; Y2). 💡 Small services too: borrowing a donkey
  for a trip, a helper, repairs (R1 mentions the donkey as a favour from someone you helped).

### The market trip

- **M4. Every thing gets a weight (bulk)** [#1]: how hard it is to carry. Works hidden from the start (D4). 💡 A few classes (feather,
  light, normal, bulky, heavy) rather than exact numbers; straw is light but bulky; logs, stones and iron ore are heavy. Seed items too.
- **M5. Carrying and the trip's energy** [#1], [#2]: how much the farmer can carry depends on the carrying device (backpack → basket →
  cart; the existing carrying gear for gathering can count too), and on **strength** (L2). The trip's energy is a farmer number too: a
  flat cost that gets cheaper with a better road, a better cart, boots, strength, or a borrowed donkey (a favour). Later: the wheelbarrow,
  the hand cart, the **pony** (job card "carry surplus to market and sell it", S2).
  💡 The room counts **each way separately** (a full load there, a full load back), the same size both ways (proposed in R1; the
  answer reshaped the trip and didn't say; confirm when D1 is written).
- **M6. The village signpost and the trip** ✅ (R1–R4) [#1]. No merchant at the farm at the start, and no market needed at first (D2).
  A **signpost** by the road at the top right, pointing to the village, with a village symbol. Beside it stands the current carrying
  device (R4), filling up as you pack. The trip:
  1. **Pack** in the store (M11): the bag fills; nothing is spent yet.
  2. **Confirm** at the signpost: the trip's **energy** is taken, and **exactly one Time Quiz question** opens (the walk; the rule "time
     only moves with right answers" stays; a wrong first try doesn't move time, as everywhere).
  3. The **market square** opens straight away (not the farm): sell what you brought, deliver dishes or goods for goals, buy within the
     room left. Unsold goods come home.
  4. **Back home** with the usual short pause (J4).
  Trips with an empty bag (only to buy) are allowed. **Deliveries ride in the bag and take room** like anything else (✅ R1; this replaces
  the earlier proposal to keep them out of the bag).
- **M7. The travelling merchant** ✅ (R1, R3): comes to the gate **now and then** (slightly random; more often the better the road). No
  trip, no energy. **Tap him** to see what he will buy and how much room his cart has left; his cart fills up visibly as you sell. He has a
  big cart, so it is the easy way to sell in bulk; ✅ he pays a little less than the market (his cut). **Barter** with him early (the axle
  for the first cart, D2). Later upgrades make merchants come very regularly (they leave and arrive again after every question), which
  stands for a settled trade. His first appearance: he **passes by on the road once** as a story moment (✅ R1).
- **M8. Trust and why the village sells only some things** ✅ (R1, R2): the village **distrusts** the farmer: the farm burnt down, and
  the whole family was distrusted (that is part of why it scattered; nobody in the village is related to the farmer). The village is also
  **poor**: the Lord squeezed everyone, and others dug their wells too deep. Poverty sharpens the distrust (a scarcity mindset). What
  wins them over: the farmer **turning burnt, barren land around** and being **kind without expecting anything back**. Mechanics:
  **each person has their own trust**, plus a **village-wide reputation** that rises as the farm visibly recovers; trust changes **what is
  on offer** and **the price**. Granny Maud and young Greenstem are kind from the start. Favour rewards come as **surprises**, not promised on
  the button. The existing gates stay: dishes and goods delivered = trust; the road = who can bring goods to your gate; cards = what you
  can use.
- **M9. The market square picture** [#1]: one painted village square, used for trips and for the delivery scenes
  (`story/story-delivery.md` §7); a first look at it can be shown before the first trip.
- **M10. Notice board and Import Broker:** (the data checker found 13 Oct 2026: seven reward nodes have the slot `board` and so land at the field place, because
  `places.json` has no rule for it: `lucky_horseshoe`, `brass_bell`, `wind_chime`, `bird_feeder`, `lavender_bunch`, `sq_stray_kitten`, `barn_cat`; decide here whether they belong to the
  notice board.) Decide where they stand now that the market is in the village (the notice board's little jobs
  and favours; the broker came with the pony and the paved road).
- **M11. The store and packing** ✅ (R2–R4):
  - **The store** is a compact grid of small tiles: picture, a **short text in a smaller font**, count, a stale badge, small dots for the
    quality levels. **No sell buttons.** A **row of filters** on top (the categories at first: food, crafts and tools, materials, crops …;
    a filter row leaves room for other filters later).
  - **Tapping a tile** opens a small panel: eat, compost, feed, and **🎒 + 1 / + all** (💡 accepted by silence in R4).
  - **Packing doesn't take things out of the store**: they stay there marked as packed (a small 🎒 on the tile), can be unpacked any time
    for free, and can still be eaten until you leave (💡 accepted by silence in R4).
  - The **🎒 bag icon** in the top bar fills as you pack: 💡 a thin bar under it, like the energy and water bars (accepted by silence);
    the numbers ("8 of 12") in the bag window.
  - **Tapping the bag icon, or the carrying device beside the signpost,** opens the bag window: a grid of what is packed, **sorted by how
    much room each thing takes**, where things can be taken out again.

---

## 8. Skills and quality (Y)

- **Y1. Quality** ✅ (R2, R3, R5): three levels, **Lumpy / Proper / Fancy**; German **Naja / Tiptop / Picobello!**. Mostly predictable from the tools, the
  ingredients' quality and practice (Y2), with a small chance of one level up or down; the recipe tile shows what to expect before you
  make it; every skill rank raises the chances a bit (Y2). Crops (from soil, weeds, patch level), dishes, crafts and medicine have it; raw materials don't. Lumpy sells for about 60 %,
  Fancy for about 150 %. Some key deliveries ask for at least Proper; the badger's "really good medicine" (`story/game-design-round4.md`
  §C) is simply **Fancy**. ⚠️ Reverses the old decision "Quality stars: no" (log §2.4). Upgrade idea 12 in
  `progression/upgrade-benefits-ideas.md` becomes real.
- **Y2. Skills and mastery** ✅ (R4, R5). The parent: honing a skill (and better tools and buildings) lowers energy and raises
  carrying, as decided, but some learning also means **less waste of inputs** (fewer reeds for the same basket), and less time and
  energy. Becoming good at everything is possible in theory, but it should pay to **specialise**, master some areas first and **buy the
  rest** (making steel from bought iron ore is possible, but needs much knowledge, training and upgraded tools, so it only pays on the
  metal path). Practice is **tracked even when not visible**, "in a way that doesn't get out of hand", usable without losing detail.
  - **Eight families** ✅: planting and harvesting · animal tending · cooking and baking · fibre and weaving · woodwork and construction
    · pottery and glass · smithing · healing and preserving. Every batch (or job) counts for its family, so similar work trains it too.
  - **Five ranks** (💡, accepted by silence in R5): Beginner → Handy → Skilled → Expert → Master. A rank needs a number of batches (e.g.
    10 / 30 / 80 / 200) and, from Skilled on, a gate the game already has: a card (Skilled), a tool tier (Expert), a station or building
    (Master), so grinding cheap recipes can't make a master early.
  - **What every rank brings** ✅ (R5):
    - **fewer inputs at every rank**, with diminishing returns, and **more for construction and crafting** than for cooking or healing;
    - **a bit better quality chances at every rank**, Master included;
    - plus Handy: less energy; Master: faster.
    - Field and animal work gain **less** from training (buildings, tools and books already cover much), mostly through **fewer
      beginner's mistakes** (dropped eggs, a seedling pulled with the weeds) and better quality.
  - **How savings show:** amounts stay exact underneath (the game already works that way); a saving that hasn't reached a whole piece yet
    shows as the faint grey cubes the cost bars already use for upgrade savings, so no decimals appear.
  - **Every saving says why** ✅ (R6): when training, an upgrade or new knowledge reduces the inputs, time or energy, a line explains it in
    the world's terms ("You drop the eggs less often now", "Your hands know baskets: 5 reeds instead of 6").
  - **No beginner's mishaps when making things** ✅ (R6): there, a beginner's "mistake" is a Lumpy result; materials are not lost.
  - **Shown when it first matters:** the first rank-up comes with a small celebration ("Your hands know baskets now"); then the rank
    shows on recipe tiles and a skills page appears (in the farmer's dashboard or the album).
  - **No fading, no hard limit** on how many families reach Master; time and energy limit it naturally.
  - **The price rule** (M1): a made thing's market price lies between a beginner's cost to make it and a master's, so buying pays for a
    beginner and making pays for a master.
  - **Replaces the per-station practice stars** that exist today (`meta.practice`: −5 % energy per star at 10/40/120 uses).
  - First numbers go into D1 and are tuned in the explorer.

---

## 9. Wellbeing and the energy model (L) — "a bit like The Sims" [#2], [#4]

✅ All systems run from the start; wellbeing is frozen until chapter 2 (D4). ✅ The Time Quiz may now **give and drain** energy (R1:
symbolic; the bulk of energy still comes from the arithmetic; health and kindness are mostly there to **prevent** drain, which grows
with the farm). ✅ Natural consequences instead of "nothing punishes" (R1; L7).

- **L1. The energy model** ✅ (R2, R3): the **home sets the base** (energy maximum and energy per right sum, as today: tent 20/5 …
  farmhouse sun room 65/9); the **parameters work like a dial on top** (e.g. ×0.7 to ×1.3; how much is base and how much dial can be
  shifted later) and also set the **gain or drain per Time Quiz question** (0 by default). Write the formula and its numbers into the
  design document (D1) before any code; check it in the explorer.
- **L2. The parameters** ✅ (R1, R3): **sleep** → energy per right sum (the bed feeds it); **food** (variety) and **strength** → the
  maximum (strength also carrying, M5); **friends**, **calm** and **play** → gain or drain per question. The face on the farmer shows the
  overall mood. **Play** gives reasons to build or buy a musical instrument, something for making art, to throw a party at the farm now
  and then, or to say yes to an invitation to visit another farm (costs time and energy, gives nothing back at once). ✅ A visit works
  like a market trip: a scene that costs a question and energy.
- **L3. Opened by reading** [#2]: at first the player sees none of the parameters and has no idea why, for example, helping someone makes
  the farmer feel better. Books and their quizzes open the **dashboard** and, step by step, more numbers and more ways to improve them
  (meditation, endurance training …). 🔗 K4.
- **L4. Where it opens** ✅ (R1, R4): tapping **the farmer**, and an icon in the top bar (fitted in when it appears, J8).
- **L5. The drain** ✅ (R2, R3): starts in **chapter 2**, together with the face; grows mostly with **how much runs on the farm and how
  much you carry** (other candidates kept open: buildings, animals, patches, chapter); its **maximum is about 1.5 right sums' worth per
  question** (so the strain stays the same across the game; it rarely gets that bad); parameters **sink slowly, with a warning** from the
  face, and **recover a little faster** than they sank; **at zero energy the drain stops**, no debt. The energy change after the quiz is
  always shown (J4).
- **L6. The happy boost** ✅ (R2): helping someone shifts the per-question rate upwards for a while (e.g. 0 → a small gain for a few
  questions; −2 → +1), calibrated per chapter.
- **L7. Natural consequences** ✅ (R1): setbacks are allowed when they follow naturally (chopping too much wood, using too much water,
  neglecting your health); they last a while, and the player can always correct course and recover. The game doesn't impose them on
  purpose, and doesn't pull its punches either. Nothing is lost for good; Helpers never leave. Replaces "nothing that punishes the child"
  in `00-READ-ME-FIRST.md` §4.6 (the poisoning stays as decided).
- **L8. Story ties** 💡: Berit's note *Rest the field. Rest yourself.* (ch 2); the badger's "tea first"; Wren's "You never stop, do you?";
  ✅ the chapter 5 low point (you collapse from overwork) stays a story beat and is the moment the dashboard's rest and calm levers open.

---

## 10. Nature, sustainability and seasons (N) [#5]

- **N1. The aim** ✅: the game and the story address farming's impact on the environment. The slow reveal of what made the land dry
  stays (`story/world/lease-and-collapse.md`); on top, numbers about sustainability, **frozen until a note in the grandmother's book in
  chapter 2–3** (D4).
- **N2. Which resources** ✅ (R1): the forest edge (sticks, stones), **water**, **clay**; later forest herbs ("take only a third") and the
  woodlot (hazel coppicing). Metal and big stones come from the market, so sustainability doesn't apply there.
- **N3. Trees, stumps, saplings** ✅ (R1, R2): felling trees at the forest edge is the early source of logs. Trees become stumps, stumps
  saplings, saplings trees again over a number of questions, fairly quickly; cut too many in a short time and the corner shows mostly
  stumps, almost no full trees and too few saplings, and the wood yield drops. Needs the pictures (R4).
- **N4. Stones and clay** ✅ (R2): loose stones at the forest edge slowly run out and don't come back; frost stones in the fields stay;
  big amounts come from the quarry merchant. The clay pit refills slowly.
- **N5. Advice, then consequences** ✅: over-use gets a recommendation first (the book, a Helper's look); ignoring it lowers yields to a
  **floor that always covers the basics** (the campfire is never impossible), and a Helper **pauses one job and gives you a look** until
  the balance is back. Helpers never leave. 🔗 L7, M13 (the Lord's share pushes towards over-use, as it did for the family).
- **N6. Winter** ✅ (R4): **snow falls like rain and then stays**; patches must be **cleared of snow** before planting (a whole-field
  action, J2); fewer crops in winter ✅ (R5): outdoors only a few hardy crops can be sown (✅ winter wheat, onions, beans as broad beans,
  winter kale; U5); every other crop's tile shows ❄️ "too cold to sow", with "try the greenhouse" only once a greenhouse exists; crops already in the ground grow at **a
  quarter** of their speed. The greenhouse and the cloches get a real job. **Winter wheat** becomes a new crop (U5).
- **N7. Seasons you can see** ✅ (R4): trees and grass look visibly different each season; winter is not just snow but **muted colours**;
  a cheap way to put **snow on every roof** without a new picture for each building. ✅ (R5) **One shader over all map pictures**:
  snow caps on every top edge (roofs, trees, fences), muted colours in winter, green turned golden in autumn; new pictures only where a
  shader can't fake it (bare deciduous trees in winter, R4).
  **Built 13 Oct 2026 (0.10.0):** `kits/ui/season.gdshader` (generic: `winter`, `autumn`, `snow`, `snow_depth` as a part of the picture's height; snow where the picture is see-through just above, muted and cooler colours, greens turn golden by hue) and `game/farm/map/season.gd` (`FarmSeasonLook`: two shared materials; `apply_tree` puts them on every picture of the map except words, panels, buttons and the farmer; `ground.set_season` sets the season). Soil and plants (`meta "flat"`) get the muted winter but no caps and no golden shift. Not yet: smooth change from one season to the next (it jumps), the ground itself stays as it was (snow on the ground comes with N6), bare trees (needs pictures), the farmer and animals are unchanged. Check the strength on the iPad (W9).
- **N8. A text at the start of each season** ✅ (R4): what changes now (growth, weeds, pests, rain, what can be sown), together with the
  market news (M12).

---

## 11. Opening and what unlocks when (O) [#3]

✅ (R1) All systems are in place from the very beginning, running in the background; each becomes visible and open to the player at a
certain point. Until then it is either **frozen** at a stable value or its influence is **real but unexplained**, chosen per system (D4).
Things that don't exist yet (the forest screen before chapter 5) aren't visible at all.

- **O1. An unlock schedule for the interface:** every button, bar, icon and window, and when it appears (example: after the Home Field
  is cleared completely, a window opens that wasn't there before). Start with an audit of the first screen. 🔗 D4, J8.
- **O2. The engine runs from the start, the numbers wait** (frozen or hidden, per D4).
- **O3. Triggers:** 💡 reuse the story's trigger language (`story/story-delivery.md` §6: `done:<node>`, `chapter:<n>`, `step>=<n>`,
  `seen:<id>` …) so unlocks and story pieces share one system, and an unlock can come with a story box that explains it.

---

## 12. People on the farm (P)

- **P1. Other characters as avatars** [#11]: the travelling merchant first (M7: walks or drives in, his cart, coins fly to him); the
  story's **Visits** (Greenstem, Granny Maud, the miller, Wren, Master Quill, Lark, Captain Mei; `story/story-delivery.md` §7). Same
  system as the farmer (`kits/avatar/avatar.gd`, `data/avatar.json`, `data/acts.json`). No words on the map: they are known by their look.
- **P2. "Make your farmer" screen** at the start (the look is already data, `data/avatar.json`; kept per player). Needed for the
  gender-open farmer. (Was "Later 2".)
- **P3. Gear visible on the farmer** (fits the acts' props; upgrade idea 15). (Was "Later 2".)

---

## 13. Knowledge and curriculum (K) [#S8], [#S1]

A **secondary** goal ✅: never at the cost of a fun, not overwhelming, still challenging game and a story that makes you care.
✅ (R1) No in-world framing is needed for modern knowledge: the Time Quiz questions can be shown without any context.

- **K1. The frameworks** ✅ come from the parent (W6). The parent's examples: what the world is made of (molecules, crystalline structures,
  metals); nested scales (atoms → electrons, protons, neutrons; planet → solar system → galaxy → galaxy cluster → universe); history of
  our world in broad strokes; fundamental facts about the body. Ways for an eight-year-old to understand chemistry, physics and any
  framework that makes learning easier.
- **K2. Map hooks in the existing 67 cards and 201 card questions** (can start before K1): photosynthesis (the parent's example; check
  whether it is in already); compost and soil life; bread rising (yeast is alive); smelting and steel (metals, melting); quartz and salt
  (crystals); glass from sand; dyes and colour mixing (light); rain and evaporation; the moonstones "fallen from the sky" (meteorites,
  the solar system); the first night under the stars; the medicine chapter (the body); the wellbeing books.
- **K3. Augment the cards:** add a question to a card or add to a card. New ids through `tools/quiz_ids.py`; never change or reuse an id;
  German through `tools/i18n.py`.
- **K4. New books and cards:** body and mind (opens the wellbeing dashboard, L3); land and water (sustainability, N); *The Healer's Herbal*
  (chapter 5); **saving seed** (grain is seed; letting biennials flower through a winter; U2); 💡 crafts books for the skill families (Y2).
- **K5. The external pool:** what can't be fitted into cards goes into Time Quiz packs (one per framework or school topic). The more lives
  in the game, the stronger the motivation, because the relevance is obvious.

---

## 14. Upgrades (H)

- **H1. Upgrades that do more than save energy.** `progression/upgrade-benefits-ideas.md` (119 of ~240 effects only save energy; 15
  other kinds; one idea per upgrade). ✅ (R2) As a **rule of thumb, not a hard rule**: the first tier often saves energy, but sometimes
  does something else (a better basket carries more); later tiers do something visible. Next: go through the 48 energy-only upgrades
  together, now with quality (Y1), carrying (M5), skills (Y2) and the sleep parameter (L2) available as benefits.

---

## 15. Story (I) — files in `story/`, worked in rounds (see `story/README.md`)

- **I4 (leftovers of Round 4).** Plant facts still to be fully checked and reviewed by the parent before anything ships. Rename
  `sq_chapel_roof` to the village hall (texts, German, picture prompt "waving from the dry chapel").
- **I5. Round 5: outline** — the five questions are answered ✅ (R1): the low point in chapter 5 stays; the Lord's letter stays, and his
  climb-down comes **through Quill's numbers**; the cousin's accusation at the Fair stays, and **the cousin is a girl** (the default for
  now); the thing left unsaid at the night garden stays; awe on the first night stays. ✅ The chapter 6 bend triggers **automatically**,
  like every chapter end (no *Sit down / Tell* tap). Update `story/outline/ladder.md` in Round 6.
- **I6. Round 6: loop back** (reconcile story and game), now with everything decided 10–12 Oct:
  - the **collector** of the Lord's share ✅ **Pieter the night watchman** (R7): the village's nearest thing to an official, made to do
    it, dislikes it, warms to you; his favour in chapter 4; he has seen a tiny light over the marsh (the night garden);
  - the village's **distrust of the whole family** and its **poverty** (M8); the farmer's kindness without expecting anything back;
  - the **Lord's share from chapter 2 or 3** (M13): ✅ Pieter collects at the gate at the end of each
    season; Quill comes in chapter 4 to count patches and buildings himself; the rising fraction mirrors the origin story; the ladder's
    beats 4.1 and 6.1 adjust;
  - the **new chapter 1** (D2): no merchant, the farmer avoids the village; the travelling merchant **passes by on the road** (replaces
    ladder 1.6 "at your campfire"); the reason for the first trip;
  - crafts as a strand next to food (U4); the sustainability note in Berit's book (N1); wellbeing as the farmer's flaw made playable (L8);
  - **no epilogue chapter** (I10);
  - where Lark first appears (J7).
- **I7. Round 7: texts** (chapter 1 first, read aloud, then German through `tools/i18n.py`; "ss").
- **I8. Round 8: build.** (a) `data/story.json`, the story box, the 📜 scroll, first-tap problem stories, frame scenes; (b) then pets'
  jobs, the medicine chapter, favour-giver renames, pictures (`ART_LIST.csv`); tests and web build.
- **I9. The opening: story panels and the frame** [#S3] ✅. The current opening text (the farm burnt down, only a tent is left;
  `welcome.show_welcome` in `game/farm/ui/welcome.gd`, and `well_1`) doesn't fit the story. The game starts with a few **story panels** (pictures and text) that
  explain the situation, including the frame: grandchildren looking up at you, asking for the story again, one they have heard many times.
  ✅ They know the farm story, but **you always stopped at the Fair**: tonight, for the first time, you tell what happened in the barn.
  Between chapters they poke you to go on; some **blurt out foreshadowing** ("Is this the part where …?") and get **hushed** (about the farm,
  never the secret). ✅ A **Skip** button from a player's second viewing on; everything stays re-readable in the 📜 scroll. Keep what the
  current welcome teaches (tap places; the Time Quiz moves time; tap ⚡ to rest) somewhere.
- **I10. Free play after chapter 6** ✅ (R1, R2): **no epilogue as story.** The last frame scene plays when chapter 6 ends; after that,
  free play, outside the grandparent's story. Free-play goals still show a short box when they tie up a loose end (the cousin and the
  family, the Lord and Quill, Greenstem and Wren, the letters home, the miller, Lark naming the squirrel), without the grandchildren.
  The night garden's unsaid thing stays unsaid. More side quests, add-ons and perks; the pets' job board levels 3–4 give "putting the
  Helpers to use" real play.
- **I11. Story pictures follow R3.**
- **I12. The title** ✅ (R1, R2): **Hazelwood Harvest**, the same name in German. A quick web search found no game of that name (only a
  town festival in Missouri, "Hazelwood Harvestfest"); still to check: the app stores. Then rename the game (`project.godot`, the web
  page title, the documents).
- **I13. Plot details in the game are flexible** ✅ [#S4] as long as the pacing stays sensible.

---

## 16. Six chapters, the pets' jobs, medicine, the forest (S) — from `story/game-design-round4.md` §E

Decided in Round 4 ✅ (six chapters; chapter 5 *Healing* with the badger; ~25 hours fine; job board to level 4; forest in and out a Time
Quiz question each; the Wren check and the poisoning exception).

- **S1. Six chapters in the data**: renumber (old 5 → 6), the badger as a placeholder, `pet_alpaca` and `import_broker` re-pointed to
  `pet_badger`, `sq_healer_garden`, `sq_lamp_maker` and `copper_still` into chapter 5; pet lists in `game/farm/game.gd` (two places); bot and
  explorer re-run. 💡 From the outline: `pet_tortoise` to require `pond`, `pet_alpaca` to require `river_meadow_drain` (decide in I6).
- **S2. Pets visible and their job board level 1–2** (they walk and act; today's bonuses become level 1). 🔗 J4 (the playback shows their
  work), M5 (the pony carries to market).
- **S3. The medicine chapter**: the still-room (`ruins_stillroom`), stations, remedies, *The Healer's Herbal* (K4), the Wren check and
  the poisoning; the badger needs **Fancy** medicine (Y1). 🔗 L (energy), N2 (herbs: take only a third), Y2 (the Healing family).
- **S4. The forest screen** (doesn't exist and isn't visible before chapter 5). 🔗 M5 (the basket's room), N (over-picking), L (energy).
- **S5. Pets' job board levels 3–4** (WHEN cards, a second rule), if play-testing says the child wants them; a parent setting could
  switch the WHEN cards off. 🔗 I10 (free play uses them).

---

## 17. Later (Z) — parked, older tasks

- **Z1. Dynamic difficulty** (design §10.6) is built but **off by default**. Tune it with play-testing; ideas noted: look at the time
  per goal rather than only the pace; vary *which* dish an order wants rather than how much; a parent's slider for strength. `meta.flex`
  in the data holds every number. 🔗 M1, M12 (prices may follow it). (Was Later 1.)
- **Z2.** Was Later 2: now P2 (make your farmer), P3 (gear visible) and P1 (merchants walking about).
- **Z3. Orchard and greenhouse** still use a square patch grid inside their sheets; give them diamond rows like the fields. (Was Later 3.)
- **Z4.** Was Later 4 (explorer value-check notes): now part of M1.
- **Z5. Pixie chest** mini-game (an old idea for random rewards), not built. (Was Later 5.)
- **Z6. Still-open design questions** (from the old documents; was Later 6):
  - village projects (bundles with substitutes): still a maybe;
  - cider is alcoholic; rename it "apple must" for young players?
  - art for the 67 card pages, gear and pests (album pictures for favours came in round 8);
  - play-test with real 8-year-olds: how many review questions they tolerate, whether 30 questions per season feels right, whether pest
    pressure is noticeable but not annoying;
  - the assumptions listed in `PROJECT-LOG.md` §2.6.
- **Z7. Keep an eye on the public web build.** Everything in it (game data, quiz packs, pictures) can be downloaded by anyone with the
  link. Fine for now (parent's decision, 7 Oct 2026); revisit if content becomes personal (e.g. the child's name, photos, the learning
  record) or if the art should not be shared. Options then: a private host or a password-protected one. (Was Later 7.)
