# Read me first

The starting point for a new chat or another AI. It holds no status: **what is being worked on is in `ROADMAP.md`**, the history in
`PROJECT-LOG.md`, and **how to work** in the project skill `.claude/skills/farm-game-session/SKILL.md`.

## 1. The project

**Hazelwood Harvest** (until 0.9.0 *Farm Quiz Game*): an educational farming game for an **8-year-old**. The player rebuilds a
burnt-down farm from a tent and one wheat seed to a master farm, over six chapters, each ending with a Helper (pet) coming home.
Learning *is* the economy:

- **Time Quiz:** general-knowledge questions from packs the parent chooses; each right first answer moves farm time one step.
- **Rest:** mental-arithmetic sums (a curriculum for classes 1–7 with spaced repetition and medals) give energy.
- **Knowledge cards:** cards about real farming and crafts, read and quizzed, unlock what they describe.

A **Godot 4.7** game (GDScript), playable through all six chapters, driven by data. It was designed for an iPad held upright; for now
the parent play-tests with the child on the laptop. The person you work with is the child's parent and the game's designer.

## 2. The folder

| Folder / file | What it is |
|---|---|
| `ROADMAP.md` | **what is now, next and later**, per track (game, story, pictures, sounds, docs) |
| `.scratch/` | **the tracker**: one file per ticket in `<feature>/issues/`, specs as `<feature>/spec.md`; rules in `.scratch/README.md`; `python3 tools/tracker.py` prints the frontier and the parent's queue |
| `PROJECT-LOG.md` | one row per session, every track; the log before 30 Oct 2026 is `archive/log-2026-10.md` |
| `GLOSSARY-MAP.md` | the two word areas: the game (`GLOSSARY.md`, decisions in `docs/adr/`) and the story (`story/GLOSSARY.md`, `story/docs/adr/`) |
| `docs/design/` | **the game's design**, one file per system, with an index |
| `docs/adr/` | lasting decisions (game, and those touching both areas) |
| `docs/architecture-review-2026-10-22.md` | how the game is built (Part A) and the five deepening candidates (Part B) |
| `docs/sources/` | the parent's notes and decision rounds word for word, the play-test notes of 23 Oct, the architecture plan, the price table |
| `.claude/skills/` | the project skills: `farm-game-session` (how to work), `farm-game-check` (Godot, checks, export), `farm-game-content` (questions, texts and German, numbers, sounds, pictures, layout) |
| `CLAUDE.md` | a few lines Claude Code loads by itself |
| `godot-prototype/` | **the game**: `kits/` (reusable parts), `game/farm/` (this game's rules and screens), `data/`, `assets/`, `tests/`, `tools/` |
| `tools/` | project tools: `tracker.py` (frontier and queue), `check_docs.py` (links, tickets, log) |
| `story/` | **the story**, sorted by role (canon, outline, novella, game, archive); start at `story/README.md` |
| `progression/` | the progression explorer with a copy of the data and the bot's pacing report |
| `Update explorer.command` | double-click on the Mac to refresh the explorer (checks the data, lets the bot play ~3 min) |
| `Build web version.command` | double-click on the Mac to re-export the game into `web-build/` (parked) |
| `web-build/` | its own public git repo, ignored by this one (parked) |
| `art-inbox/`, `sound-inbox/` | generated pictures and sounds waiting to be cut, picked or imported |
| `reference-art/` | style references (not used in the game) |
| `archive/` | old design docs, prototypes, the old log and to-do list, rejected pictures: **reference only, do not edit** |

## 3. The parent's standing rules

- Do not try to get round blocked websites or downloads (for example `cdn.openart.ai`): the parent downloads OpenArt pictures into
  `art-inbox/` by hand.
- Never handle passwords, tokens or credentials. Ask before downloading files or deleting anything.
- Pictures: OpenArt project "Farm Quiz Game", model **Nano Banana 2 Lite at 1K**, sprite sheets of several objects, **3 versions per
  sheet**, with an earlier sheet as the style reference. Only about two generations run at a time.
- No words on the map; whole numbers on screen (also with bronze and gold coins); short, simple texts; German with "ss", never "ß".
- **Natural consequences, never stuck:** setbacks are allowed, last a while and can always be corrected; nothing is lost for good,
  Helpers never leave. One deliberate exception: the poisoning in the medicine chapter
  ([ADR-0004](docs/adr/0004-natural-consequences.md); details in `story/game/game-design-round4.md` §C).
- **Use the glossary's words:** say *chore*, not *action*, in tickets, code and messages.
- **Never act on a design until the parent confirms the shared understanding** (the grilling's summary); an easy-to-undo 💡 may be
  taken only as `.scratch/README.md` allows.
- **Golden runs:** after each slice the short run (`check_all.sh --short`); the full run only when a slice touches a late system.
- **Handoff files** go to the temp directory and refer to paths; only durable lessons enter this file.
- **Talk plainly:** no flattery; say when something is weak, and recommend. Questions in rounds of at most three, each with a 💡
  recommendation that "yes" accepts.
- **The parent commits** from the Mac; end each session with a ready commit message.
