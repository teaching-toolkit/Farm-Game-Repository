# 👉 READ ME FIRST — for a new chat or another AI

This file is the starting point. Read it fully before touching anything; it says what the project is, how the folder is laid
out, how to work on it, where we left off and what is still open. Last updated: **7 October 2026** (after round 8 and the
2.0 tidy-up).

---

## ⚠️ Standing rule for every conversation: keep the log and the to-do list up to date

This file's **§6 Open tasks** is the project's to-do list, and `PROJECT-LOG.md` is its history. Any chat or AI that works on
this project **must keep both current as it goes, not just at the end**:

- **Start of a session:** read this file and the log, then say which open task(s) you are working on.
- **During the session:** whenever something is finished, started, dropped, split up or newly discovered, update §6 straight
  away (tick off or remove done tasks, add new ones, reword changed ones). Add a row to `PROJECT-LOG.md` for every change to
  the game, the data, the tools or a decision, and add any new unconfirmed assumption to its §2.6. Do not wait to be asked and
  do not save it all for the end; a chat can stop at any time.
- **End of a session (or before a long pause):** update §5 "Where we left off" and §7 "Key numbers", set the "Last updated"
  date at the top, and mention in your last message what you changed in the log and the to-do list.
- If the code, data or web build changed, say so in §5 (for example whether `web-build/` matches the current code).

A task that is not written down here does not exist for the next chat.

---

## 1. The project in a few lines

**Farm Quiz Game** — an educational farming game for an **8-year-old**, played on an **iPad held upright**. The player
rebuilds a burnt-down farm from a tent and five wheat seeds to a master farm, over five chapters, each ending with a pet
coming home (bunny, tortoise, goat, pony, alpaca). Learning *is* the economy:

- **Time Quiz** — general-knowledge questions from packs the parent chooses; each right answer moves farm time one step.
- **Rest** — mental-arithmetic sums (a curriculum for classes 1–7 with spaced repetition and medals) give energy.
- **Knowledge cards** — 67 cards about real farming and crafts, read and quizzed, unlock what they describe.

It is built as a **Godot 4.7 prototype** (GDScript) that is fully playable through all five chapters, driven by one data
file. It also runs in the browser (`web-build/`). The person you work with is the child's parent and the game's designer;
they test on the iPad, pick the generated pictures and decide on design questions. Write to them in plain, friendly English
and keep the game's own texts simple enough for a young reader.

---

## 2. What to read, in order

1. **This file.**
2. `farm-quiz-game-master-design-document.md` — what the game is and why (v2.0; describes the design as built; marks
   *(planned)* and *(idea)*). No history or to-dos in it on purpose.
3. `PROJECT-LOG.md` — the history version by version, every decision taken, assumptions still to confirm.
4. `godot-prototype/README.md` — how to run, test and change the prototype; the picture folders; every setting.
5. `godot-prototype/learnkit/README.md` — the learning kit (Rest sums, quiz engine, learning record, question ids).
6. The numbers: `godot-prototype/data/farm-progression.json` (open `progression/progression-explorer.html` to browse it).
   **The data wins** if it and a document disagree.

---

## 3. The folder

| Folder / file | What it is |
|---|---|
| `00-READ-ME-FIRST.md` | this file |
| `PROJECT-LOG.md` | history and decisions |
| `farm-quiz-game-master-design-document.md` | the design (v2.0) |
| `godot-prototype/` | **the game** — Godot project (`project.godot`), `scripts/`, `data/`, `learnkit/`, `assets/`, `tests/`, `tools/`, `fonts/` |
| `Build web version.command` | **double-click on the Mac** to re-export the game into `web-build/` (needs Godot.app and its export templates installed once) |
| `Publish web version.command` | **double-click on the Mac** to push `web-build/` to the public GitHub repo as one fresh commit (see §4.7) |
| `CLAUDE.md` | short pointer for Claude Code cloud sessions: read this file, keep the log and to-do list current, set up Godot |
| `.gitignore` | what the private repo leaves out (`.godot/` caches, `web-build/`, big archive screenshots, `.DS_Store`) |
| `web-build/` | its own **public** git repo, ignored by the private one; the latest web export (put online on any HTTPS host; see the prototype README) |
| `progression/` | the progression explorer (`progression-explorer.html`) with a copy of the current data |
| `art-inbox/` | generated sprite sheets waiting to be cut (`sheetN-….png`), `ART_LIST.csv` (every picture still needed, with prompts), `ROUND8-PICK-LIST.md` |
| `Claude outputs/` | a transfer folder for update bundles (`*.tgz`); temporary, nothing depends on it |
| `reference-art/` | style references and a free asset pack (not used in the game) |
| `archive/` | old design docs (1.0 – 1.3.8, the briefing), the old HTML5 prototype, the old landscape Godot layout, screenshots of rounds 1–8, rejected pictures (`art-rejected/`), an older zip — **reference only, do not edit** |

---

## 4. How to work on it

### 4.1 Where things run

- The parent's folder is on their **Mac** (`~/Documents/files/diverses/Kinder zeug/Wissensspiele/Farm game`). In a Claude
  Cowork session it is connected as **"Farm game"** and appears in the device shell as `$HOME/mnt/Farm game`.
- So far the work ran in that device shell (a Linux VM on the Mac): a Godot binary at `$HOME/godot/Godot_v4.7.2-stable_linux.arm64`
  (with web export templates installed), a work copy of the project at `$HOME/work/proj`, and helper scripts
  `$HOME/install_update.sh` and `$HOME/shot.sh`. **These live outside the parent's folder and may be gone in a new session** —
  check with `ls $HOME`; if missing, download Godot 4.7.2 (Linux, arm64, standard) and its export templates again, and copy
  `godot-prototype/` to a work folder.
- Edit the real files in `godot-prototype/` (they are what the parent opens). Deleting files in the parent's folder needs
  their permission each session; prefer moving things to `archive/`.

- **Claude Code cloud sessions** work on the private GitHub repo (a mirror of this folder). The machine starts empty, so first run
  `bash godot-prototype/tools/setup_godot.sh` (Godot only; add `--screens` for Xvfb, `--art` for Pillow/numpy/scipy, `--web` for
  the web export templates, ~1 GB download), then import once: `cd godot-prototype && $G --headless --path . --import`.
  Tested 7 Oct 2026: smoke test, bot, screenshot and web export all work this way. `web-build/` is not in the private repo.
  Godot downloads from github.com (redirected to `release-assets.githubusercontent.com`); a restricted network policy must
  allow those two hosts. Cloud gotchas (screenshots, saves left by the bot, harmless warnings): see `CLAUDE.md`.

### 4.2 Run the checks (from the project folder; `G` = the Godot binary)

```bash
timeout 170 $G --headless --path . res://tests/ui_smoke.tscn                 # interface smoke test: expect 0 errors
timeout 170 $G --headless --path . res://tests/bot.tscn -- --chapter=5 --iters=1100   # bot plays; add --flex for dynamic difficulty
timeout 170 $G --headless --path . -s res://tests/learn_sim.gd               # pretend child practises Rest sums
```

Expected now: smoke test passes; the bot reaches chapter 3 after about 290–415 questions and chapter 5 (with the first four
pets; the alpaca is chapter 5's own goal, which the bot stops before) after about 680–800. The bot plays randomly, so the
number changes from run to run (7 Oct 2026, cloud: 678, 715, 763, 774, 689, 793; earlier 729). A bot run takes about 75 seconds.
The smoke test prints its findings and ends with a few "leaked" warnings; those are harmless.
If the smoke test prints **nothing** and only stops at the timeout, a script has a parse error (the test then hangs instead
of failing). Find it with `$G --headless --path . --check-only -s res://tests/ui_smoke.gd` (or the script you changed).

### 4.3 Screenshots

Need a virtual screen (Xvfb): `DISPLAY=:99 $G --path . --resolution 834x1194 --rendering-driver opengl3 -- --shot=out.png [--spot=kitchen] [--timestep=20] [--qid=PIC-004] [--lang=de]`.
`--timestep=20` skips the welcome pop-up. All flags: prototype README, *Testing shortcuts*.

In a cloud session, `xvfb-run` starts and stops the virtual screen for you:

```bash
xvfb-run -a -s "-screen 0 1280x1400x24" $G --path . --resolution 834x1194 --rendering-driver opengl3 --audio-driver Dummy -- --newgame --timestep=20 --shot=out.png
```

Put `--newgame` **first** when you want the start of the game: the bot and the smoke test leave their farm in the default
save, and without it the screenshot shows that farm (or use `--player=Shots` to keep screenshots on their own player).

### 4.4 Web export

The parent can do this alone: double-click `Build web version.command` (Mac), then `Publish web version.command` (§4.7). The command below is what it runs, for AI sessions.


`timeout 170 $G --headless --path . --export-release Web ../web-build/index.html` — run it in the foreground in **one**
call (background processes die when the call ends); then check that `web-build/index.pck` changed. The export filter in
`export_presets.cfg` must include every data folder (`data/i18n/*.json` was added in round 8).

### 4.5 After changing content

- Quiz questions: run `python3 tools/quiz_ids.py` (gives new questions ids, updates `data/i18n/`). Never change or reuse an id.
- Progression data: check it in the explorer (copy the JSON to `progression/` too).
- New pictures in `art-inbox/`: `python3 tools/import_art.py all` (needs Pillow, numpy, scipy); then `python3 tools/art_list.py`.
- Update the design document (describe the game, not the change), add a row to `PROJECT-LOG.md`, and update §5–7 of this file
  (see the standing rule at the top: do this as you go, not only at the end).

### 4.6 Rules the parent has set

- Do not try to get round blocked websites or downloads (e.g. `cdn.openart.ai` is blocked): the parent downloads OpenArt
  pictures into `art-inbox/` by hand.
- Never handle passwords, tokens or credentials. Ask before downloading files or deleting anything.
- Pictures: OpenArt project "Farm Quiz Game", model **Nano Banana 2 Lite at 1K**, sprite sheets of several objects, **3
  versions per sheet**, with an earlier sheet as the style reference. Only about two generations run at a time.
- No words on the map; whole numbers on screen; short, simple texts; nothing that punishes the child.

---

### 4.7 GitHub repos

- **Private repo** = a mirror of this whole folder (the parent pushes it from the Mac). The single root `.gitignore` decides
  what stays out. Cloud sessions commit or open pull requests there; the parent pulls them to the Mac. The old
  `Claude outputs/*.tgz` bundles are no longer needed for that.
- **Public repo** = only `web-build/`, which is a separate git repo nested inside this folder (one-time setup:
  `cd web-build && git init -b main && git remote add origin https://github.com/<you>/<public-repo>.git`). GitHub Pages serves it
  (Settings → Pages → Deploy from a branch → `main`, root). `Publish web version.command` replaces the history with one commit
  each time, because `index.pck` (~50 MB) and `index.wasm` (~40 MB) change with every build and would make the repo grow fast.
- Everything in the web build (data, quiz packs, pictures) is public to anyone with the link (accepted for now; see §6).

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

7 Oct 2026 (cloud check): a fresh cloud session was set up and verified (smoke test, bot, screenshot); the cloud notes in
this file and `CLAUDE.md` were corrected (see the log). No game changes; `web-build/` still matches the code.

---

## 6. Open tasks

Grouped by theme; the groups are in the planned order (A first). Ask the parent before starting the bigger ones.
Questions still open with the parent are marked ❓.

### Waiting on the parent

- **W1. Round 8 pictures.** 29 sheets (283 pictures) were generated in OpenArt; the parent saves the best version of each into
  `art-inbox/` under the names in `art-inbox/ROUND8-PICK-LIST.md` (sheets 25–42 are not there yet). Then:
  `python3 tools/import_art.py all`, check them on the map with screenshots (sizes in `data/map_layout.json` may need
  adjusting — the layout editor helps), rebuild the layout editor (`tools/make_layout_editor.py`) and the web build. Sheets
  whose objects come out in the wrong order: fix `tools/art_sheets.json` or skip objects with `-`. In `art-inbox/ART_LIST.csv`
  these 280 pictures have the status `generated - pick sheetNN-….png` until their sheet is in `art-inbox/`; run
  `python3 tools/art_list.py` afterwards and they turn `done`.
- **W2. GitHub repos and the double-click scripts.** The private repo exists. Still to do: the public web repo (§4.7), GitHub
  Pages, the first run of `Build web version.command` and `Publish web version.command` on the Mac, the iPad Home Screen link.
  Cloud sessions can push to the private repo (a 403 on 7 Oct 2026 went away once the Claude GitHub App had write access).
- **W3. Play-test round 8 on the iPad** and collect the parent's findings (pace, picture questions, stoking, loads, the bar
  explanations).

### A. Small fixes and clarity (parent's list, 7 Oct 2026) — done 7 Oct 2026, waiting for the parent's check

A1 planting water bar shows its missing cubes · A2 tapping an overgrown patch says which one, why and what clears it · A3 perks
say why they came · A4 no dark-green forest floor · A5 the knowledge-review share in ⚙️ Settings. Details in `PROJECT-LOG.md`.
Still open: ❓ should parent settings (A5, dynamic difficulty, new game) be protected from the child (e.g. hold a button
3 seconds)? For now they are open.

### B. The opening (parent's list)

- **B1. Start with one usable patch and one wheat seed**; every other patch overgrown. Changes the first minutes of the game:
  re-check the first goals, the bot's numbers, the explorer's start and decision 4 in the log (5 seeds). One seed = **one
  plant** (parent, 7 Oct 2026); make sure the first goals and the market still keep the child moving.

### C. Rest (parent's list)

- **C1. A start screen before the sums** (from the energy bar or the bed/tent): where the child stands in the category (level,
  progress to the next), the medals so far and an empty slot for the next one with a short description, and a
  "Ready, set, go!" start button.
- **C2. The question left on screen when the child goes back to the farm doesn't count** for the spaced repetition (no
  "wrong", no "slow", no change to its interval).

### D. Every window as a grid (parent's list)

- **D1.** The planting window, and then every window with actions, uses a grid of tiles like the store and the market.
  Done before E so each text is touched once.

### E. Languages (parent's list; replaces the old "German" task)

- **E1. A language setting in ⚙️** that switches the *whole* game: interface, items, places, recipes, cards, card questions,
  quiz packs. Modular: one file per language (`data/i18n/<lang>.json`), an id for every text, English as the fallback, so a
  new language is just a new file. The quiz packs already work this way (`quiz-de.json`).
- **E2. German texts** (Claude drafts in simple, child-friendly German; the parent proofreads) for everything (about 80 interface lines in the scripts, every name and description in
  `farm-progression.json`, the 67 cards and their 201 questions).

### F. Sound and music (parent's list)

- **F1. Sound effects for everything a game usually has** (taps, buttons, harvest, sell, coins, build, right/wrong answer,
  new thing, level up, animals, water, chopping, digging, footsteps …), open-licence files (CC0 preferred). Today the game makes
  a few sounds itself, only with the "Farm sounds" perk. Parent's decision (7 Oct 2026): the basic sounds and music are on
  from the start; the optional, extra-fun sounds are held back as **perks** (not only Ella's), often paired with something to
  see, like the lightning for quick Rest sums: animals that make a sound when tapped and now and then by themselves, etc.
- **F2. Background music**: open-licence tracks that fit the game, by situation (farm by season, Time Quiz, Rest,
  celebrations), with gentle cross-fades. Licences: CC0 and CC-BY (parent, 7 Oct 2026), with a credits page in ⚙️; every file's
  source, author and licence recorded next to it. The parent listens to a shortlist first. Ask before downloading.
- **F3. Settings:** music on/off (and separately the sound effects). Keep the web build small (Ogg, short loops).

### G. The farmer as an actor (parent's list)

- **G1. Pantomime.** After a tap, the farmer walks to the place and acts out what was ordered (kneeling and pulling weeds,
  sowing, fetching the bucket from the pond and carrying it to the field and emptying it …). The game's numbers have already
  changed; the farmer only catches up. A new tap stops the act (gets up, puts things down) and walks to the new place.
- **G2. Built to grow:** acts as data (a list of steps: walk to, pose, hold a prop, repeat, sound), one player for all acts,
  props as small 3D pieces in the hand; adding an act or a prop needs no new code. Ties in with F (step sounds) and H.

### H. Upgrades that do more than save energy (parent's list)

- **H1. A list of other kinds of benefits** for the upgrades (many now only cut energy): more harvest, better quality/price,
  faster growing, fewer pests, more storage, new recipes, longer freshness, luck, things the farmer can show … For the parent
  to choose from before any data changes. **Written:** `progression/upgrade-benefits-ideas.md` (7 Oct 2026); waiting for the
  parent's choice.

### Later (older tasks)

1. **Dynamic difficulty** (design §10.6) is built but **off by default**. Tune it with play-testing; ideas noted: look at the
   time per goal rather than only the pace; vary *which* dish an order wants rather than how much; a parent's slider for
   strength. `meta.flex` in the data holds every number.
2. **"Make your farmer" screen** at the start (the farmer's look is already data, `data/avatar.json`; keep it per player);
   gear visible on the farmer (fits G2's props); merchants walking about.
3. **Orchard and greenhouse** still use a square patch grid inside their sheets; give them diamond rows like the fields.
4. **Explorer value-check notes** for `rope_straw`, `compost`, `steel` and `jam` (recipes whose value change falls outside the
   expected band) — check whether their inputs or prices should change.
5. **Pixie chest** mini-game (an old idea for random rewards) — not built.
6. **Still-open design questions** (from the old documents):
   - village projects (bundles with substitutes) — still a maybe;
   - cider is alcoholic; rename it "apple must" for young players?
   - art for the 67 card pages, gear and pests; album pictures for favours came in round 8;
   - play-test with real 8-year-olds: how many review questions they tolerate, whether 30 questions per season feels right,
     whether pest pressure is noticeable but not annoying;
   - the assumptions listed in `PROJECT-LOG.md` §2.6.
7. **Keep an eye on the public web build.** Everything in it (game data, quiz packs, pictures) can be downloaded by anyone
   with the link. Fine for now (parent's decision, 7 Oct 2026); revisit if content becomes personal (e.g. the child's name,
   photos, the learning record) or if the art should not be shared. Options then: a private host or a password-protected one.

---

## 7. Key numbers right now

Data v0.8: 141 items, 424 nodes, 106 recipes, 38 stations, 67 cards in 12 books, 22 polish jobs, 58 helpers, 28 side quests.
Explorer playthrough: about 21 hours, ~1,416 Time Quiz answers, ~1,380 Rest answers; pets at about 1.6 / 5.8 / 12 / 17 / 20 h.
Quiz packs: Farm basics (FRM, 4), Continents (CON, 12), Farm pictures (PIC, 18) + card questions KNW-001…201.
