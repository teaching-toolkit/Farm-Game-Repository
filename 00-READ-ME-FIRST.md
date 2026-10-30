# 👉 READ ME FIRST — for a new chat or another AI

This file is the starting point for a new chat or another AI: what the project is, how the folder is laid out, the parent's
rules and where we left off. **How to work on the project** (what to read, the checks, changing content) lives in three
project guides in `claude-skills/`; see §2. Last updated: **24 October 2026**. The game is at version 0.19.0 (all twelve plan
phases built); the open work is in `issues/`, the history in `PROJECT-LOG.md`.

---

## ⚠️ Standing rule for every conversation: keep the log and the to-do list up to date

**`TODO.md`** is the project's to-do list (the index; the tickets are in **`issues/`**, rules in `issues/README.md`), and `PROJECT-LOG.md` is its history. Keep all of them current **as you go, not just at the
end**: a chat can stop at any time, and a task that is not written down in `TODO.md` and `issues/` does not exist for the next chat. What to
update when, and what to do at the end of a session: `claude-skills/farm-game-session/SKILL.md` §4.

---

## 1. The project in a few lines

**Hazelwood Harvest** (until 0.9.0 *Farm Quiz Game*) — an educational farming game for an **8-year-old**, played on an **iPad held upright**. The player
rebuilds a burnt-down farm from a tent and one wheat seed to a master farm, over six chapters, each ending with a pet
coming home (bunny, tortoise, goat, pony, alpaca). Learning *is* the economy:

- **Time Quiz** — general-knowledge questions from packs the parent chooses; each right answer moves farm time one step.
- **Rest** — mental-arithmetic sums (a curriculum for classes 1–7 with spaced repetition and medals) give energy.
- **Knowledge cards** — 87 cards about real farming and crafts, read and quizzed, unlock what they describe.

It is built as a **Godot 4.7 prototype** (GDScript) that is fully playable through all six chapters, driven by one data
file. It also runs in the browser (`web-build/`). The person you work with is the child's parent and the game's designer;
they test on the iPad, pick the generated pictures and decide on design questions. Write to them in plain, friendly English
and keep the game's own texts simple enough for a young reader.

---

## 2. What to read

Don't read every document in full: together they are over 180 KB. Start with:

1. **This file:** the standing rule above, §1, §4.6 (the parent's rules) and §5 (where we left off).
2. **`TODO.md`:** §0 (the plan at a glance) and §1 (waiting on the parent), then only your task (`grep -rn "<id>" TODO.md issues`).
3. **`issues/README.md`:** the tracker rules and the flow for new features (§4.8); then the ticket and, if its folder has one,
   `issues/<feature>/spec.md`.
4. **`GLOSSARY.md`:** the project's words (chore, cost, requirement, pet …). Read it before touching chores, costs or pets.
5. **`claude-skills/farm-game-session/SKILL.md`:** what else to read for which kind of task, how to plan bigger steps, how to
   keep the record, git.

The other two project guides come in when needed: `claude-skills/farm-game-check/SKILL.md` (set up Godot, run the checks, screenshots,
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
| `TODO.md` | **the to-do list and plan**: the index of the open tickets (done ones go to the log) |
| `issues/` | **the tracker**: one file per ticket in `<feature>/`, statuses `ready-for-agent` / `needs-parent` / `done`; `README.md` has the rules |
| `GLOSSARY.md` | the project's words for the farm rules (chore, base cost, requirement, check, perform …) |
| `ARCHITECTURE-REVIEW-2026-10-22.md` | how the game is built (Part A) and the five deepening candidates (Part B), now features in `issues/` |
| `PROJECT-LOG.md` | history and decisions |
| `planning/` | the parent's raw notes and the decision rounds, kept word for word (also the play-test notes of 23 Oct); **the architecture plan** (`2026-10-12-architecture-plan.md`); tickets and `TODO.md` point into them |
| `farm-quiz-game-master-design-document.md` | the design (v2.0) |
| `godot-prototype/` | **the game** — Godot project (`project.godot`), `kits/` (reusable parts: learn, ui, avatar, audio, i18n), `game/farm/` (this game's rules and screens), `data/`, `assets/`, `tests/`, `tools/`, `fonts/` |
| `Build web version.command` | **double-click on the Mac** to re-export the game into `web-build/` (needs Godot.app and its export templates installed once) |
| `Update explorer.command` | **double-click on the Mac** to refresh `progression/progression-explorer.html` from the game as it is now: checks the data, lets the test bot play (about 3 minutes) and writes its pacing report into the explorer's Pacing tab (needs Godot.app and python3) |
| `Publish web version.command` | **double-click on the Mac** to push `web-build/` to the public GitHub repo as one fresh commit (see §4.7) |
| `CLAUDE.md` | short pointer that Claude Code loads by itself: start with the session skill |
| `claude-skills/` | **how to work on the project**, three project guides (ordinary files, not installed skills): `farm-game-session` (what to read, planning, keeping the record, git), `farm-game-check` (set up Godot, checks, screenshots, debugging, review, web export), `farm-game-content` (questions, texts and German, numbers, sounds, pictures, layout) |
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

Moved into the project guides on 11 October 2026, so each instruction lives in one place:

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
- **Use the glossary's words** (`GLOSSARY.md`): say *chore*, not *action*, in tickets, code and messages.
- **Never act on a design until the parent confirms the shared understanding** (the grilling's summary); an easy-to-undo 💡 may be
  taken only as `issues/README.md` §2 allows.
- **Golden runs:** after each slice the short run (`check_all.sh --short`); the full run only when a slice touches a late system.
- **Handoff files** go to the temp directory and refer to paths; after `/retro` or a handoff only durable lessons enter this file.

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

### 4.8 New features: the flow

`/grill-with-docs` → `/to-spec` → `/to-tickets` → `/tdd`. The tracker configuration those skills ask for is
`issues/README.md` (it replaces `/setup-matt-pocock-skills`); the flow itself is described there (§4) and nowhere else.

---

## 5. Where we left off

Version 0.19.0: all twelve phases of the implementation plan are built. **Nothing is half-done in the code.** `web-build/` does
**not** match the code (it waits for the iPad test, W9, and the GitHub access, W2; both are in `TODO.md` §1).

Now in progress: the **farm-actions** feature (`issues/farm-actions/`, spec in `spec.md`). Tickets 02 (short golden runs:
`bash tests/golden.sh --short`), 03 (the module `G.actions` with fetch water) and 04 (weed, pick stones, clear snow, whole-field
batches), 05 (plant, harvest, cut tree) 06 (animal chores), 07 (party and visit), 08 (forest trips), 09 (the village trip) and 10 (recipes at stations) 11 (the pay function, shop purchases) and 12 (goal and building payments) and 13 (delete the old duplicates) are done: **the farm-actions refactor is finished**. Open: the needs-parent tickets 14–16 (Wren's coins, the seed-buying path, the orchard multiplier), which wait for the parent (`TODO.md` §18). Next grilling candidates:
`time-question`, then `condition-language`.

Story outline (24 Oct 2026): **the outline run is closed.** The story now has a master outline of all six chapters (`story/outline/master/`), a story bible (`story/outline/story-bible.md`), a seed registry, and lists of what the game and the texts should change (`story/data-wishes.md`, `story/text-change-requests.md`). Start at `story/README.md`. No game code, data or story text was changed. Next, in order: the parent answers the ten questions in `story/QUESTIONS.md` (`story/19`); build the approved data wishes (`story/21`, ready); check the play order with one bot run (`story/22`, ready); build the 166 staged pieces (`story/08`, I15); play with the child; then decide the text changes (`story/20`).

Story pictures (23 Oct 2026): the kept ones are in the game (`story/16`, `story/17`: lossy WebP in `assets/story/`, mapped in
`tools/story_pictures.json`, imported with `tools/import_story_pictures.py`; the story box shows them 520 px high). Waiting on the parent:
`story/18` (the left-out pictures) and I11 (regenerating the fixes). The parent commits the new `.webp.import` files after Godot has
rewritten them on the Mac. Not yet seen on the iPad.

The history of earlier sessions (7 Oct – 23 Oct 2026) is in `PROJECT-LOG.md` §1.1 and its table.

---

## 6. Open tasks → `issues/`

Every open task is a **ticket** in `issues/<feature>/` (one file each, with a status and what blocks it); `TODO.md` is the index
with one line per open ticket, the plan at a glance and what waits on the parent. A done ticket keeps its file; its index line
leaves `TODO.md` and a row goes into `PROJECT-LOG.md`. All rules, including where specs go: **`issues/README.md`**.

---

## 7. Key numbers right now

Data v0.8: 182 items, 461 nodes, 131 recipes, 43 stations, 87 cards in 14 books, 22 polish jobs, 58 helpers, 28 side quests.
Explorer playthrough: about 21.2 hours, ~1,417 Time Quiz answers, ~1,380 Rest answers; pets at about 1.6 / 5.8 / 12 / 17 / 20 h.
Quiz packs: Farm basics (FRM, 4), Continents (CON, 12), Farm pictures (PIC, 18) + card questions KNW-001…261.
