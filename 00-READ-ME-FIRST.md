# 👉 READ ME FIRST — for a new chat or another AI

This file is the starting point for a new chat or another AI: what the project is, how the folder is laid out, the parent's
rules and where we left off. **How to work on the project** (what to read, the checks, changing content) lives in three skill
files in `claude-skills/`; see §2. Last updated: **12 October 2026** (phase 1 built: version 0.9.0).

---

## ⚠️ Standing rule for every conversation: keep the log and the to-do list up to date

**`TODO.md`** is the project's to-do list, and `PROJECT-LOG.md` is its history. Keep both current **as you go, not just at the
end**: a chat can stop at any time, and a task that is not written down in `TODO.md` does not exist for the next chat. What to
update when, and what to do at the end of a session: `claude-skills/farm-game-session/SKILL.md` §4.

---

## 1. The project in a few lines

**Hazelwood Harvest** (until 0.9.0 *Farm Quiz Game*) — an educational farming game for an **8-year-old**, played on an **iPad held upright**. The player
rebuilds a burnt-down farm from a tent and one wheat seed to a master farm, over five chapters, each ending with a pet
coming home (bunny, tortoise, goat, pony, alpaca). Learning *is* the economy:

- **Time Quiz** — general-knowledge questions from packs the parent chooses; each right answer moves farm time one step.
- **Rest** — mental-arithmetic sums (a curriculum for classes 1–7 with spaced repetition and medals) give energy.
- **Knowledge cards** — 67 cards about real farming and crafts, read and quizzed, unlock what they describe.

It is built as a **Godot 4.7 prototype** (GDScript) that is fully playable through all five chapters, driven by one data
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
The numbers are in `godot-prototype/data/farm/` (split into files; browse them all in `progression/progression-explorer.html`,
which `Update explorer.command` refreshes with the real game's pacing).
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
| `godot-prototype/` | **the game** — Godot project (`project.godot`; how the code is built: `ARCHITECTURE.md`), `kits/` (reusable parts: learn, ui, avatar, audio, i18n), `game/farm/` (this game's rules and screens), `data/`, `assets/`, `tests/`, `tools/`, `fonts/` |
| `Build web version.command` | **double-click on the Mac** to re-export the game into `web-build/` (needs Godot.app and its export templates installed once) |
| `Publish web version.command` | **double-click on the Mac** to push `web-build/` to the public GitHub repo as one fresh commit (see §4.7) |
| `CLAUDE.md` | short pointer that Claude Code loads by itself: start with the session skill |
| `claude-skills/` | **how to work on the project**, three skill files: `farm-game-session` (what to read, planning, keeping the record, git), `farm-game-check` (set up Godot, checks, screenshots, debugging, review, web export), `farm-game-content` (questions, texts and German, numbers, sounds, pictures, layout) |
| `.gitignore` | what the private repo leaves out (`.godot/` caches, `web-build/`, big archive screenshots, `.DS_Store`) |
| `web-build/` | its own **public** git repo, ignored by the private one; the latest web export (put online on any HTTPS host; see the prototype README) |
| `progression/` | the progression explorer (`progression-explorer.html`) with a copy of the current data |
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

12 Oct 2026 (phase 2 built, version 0.9.1): the restructuring is done and changes nothing in the game (checked step by step
by the golden run). The code now lives in `godot-prototype/kits/` (reusable parts, with `kits/core/`) and `godot-prototype/game/farm/`
(the rules in twelve systems behind `game.gd`, the screen in parts behind `main.gd`); the data in `data/farm/` is split into files;
saves carry a version; `bash tests/check_all.sh` runs every check; **read `godot-prototype/ARCHITECTURE.md` before any code
change**. The explorer shows the real game's pacing (double-click `Update explorer.command`). `web-build/` matches the code
(exported 12 Oct 2026, 0.9.1, tried in a browser). Next: the parent tests 0.9.1 on the iPad and publishes it; phase 3 (interface).

12 Oct 2026 (phase 3 built, version 0.10.0): the new top bar with the hanging clock (no bottom bar), notifications at the top,
cheat buttons and read aloud as grown-up settings, "The whole field" in every patch sheet, Rest after the walk home, the playback
after the Time Quiz, the seasons on every map picture. Checks pass; `web-build/` matches the code (0.10.0, started in a browser).
Next: the parent tests 0.10.0 on the iPad and publishes it; phase 4 (foundations: D4 and D3 on paper first).

---

## 6. Open tasks → `TODO.md`

The to-do list has its own file since 9 October 2026: **`TODO.md`** (in this folder). It holds the plan at a glance (the
proposed order), what is waiting on the parent, the queue of decisions with Claude's recommendations, and every open task by
area. Finished tasks are recorded in `PROJECT-LOG.md` and removed from `TODO.md`.

---

## 7. Key numbers right now

Data v0.8: 141 items, 424 nodes, 106 recipes, 38 stations, 67 cards in 12 books, 22 polish jobs, 58 helpers, 28 side quests.
Explorer playthrough: about 21.2 hours, ~1,417 Time Quiz answers, ~1,380 Rest answers; pets at about 1.6 / 5.8 / 12 / 17 / 20 h.
Quiz packs: Farm basics (FRM, 4), Continents (CON, 12), Farm pictures (PIC, 18) + card questions KNW-001…201.
