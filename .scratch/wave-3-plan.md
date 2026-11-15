# Wave 3: the plan for the sub-agents (14 Nov 2026)

How the tickets from the test run of 14 Nov 2026 are built. The parent's wishes: **Sonnet** agents, **one after the other**, each
reading only what its slice needs, each slice with a clear edge and a clear test. The orchestrator (the main chat) keeps the
overview, checks each result and writes the log; agents do not.

## Rules for every agent

- **Model:** Sonnet. **One at a time**, straight in the project folder (no private copies: nothing runs beside it). The orchestrator
  runs the short check between two agents and only then starts the next.
- **The brief names what to read, and that is all the agent reads:** its ticket, at most four code or data files, and at most one
  section of one README. It finds a function with `grep -n '^func'`, not by reading a file whole.
- **Never read:** `archive/`, `story/` (unless the slice is a story slice), `PROJECT-LOG.md`, `ROADMAP.md`, `docs/sources/`, the
  other design files, the other skills. The brief carries the three or four rules that matter (below), so no skill is loaded.
- **Never write:** `PROJECT-LOG.md`, `ROADMAP.md`, golden files (the orchestrator records them), git.
- **The rules the brief repeats in five lines:** say *chore*, not action; a chore's cost lives in the chores file and goes through
  `G.actions.check` / `perform`; new save keys go into the owning system's `save_defaults()`; every text the child sees goes through
  `tr()` and gets its German (with "ss"); no words on the map. New work is a deep module: a small interface, the owner registers.
- **The test is in the brief:** the one test file to extend and the one command to run it
  (`HOME=<throwaway> "$G" --headless --path . res://tests/<x>_test.tscn -- --seed=1`). The agent runs only that; the orchestrator
  runs `check_all.sh --short`.
- **The report is ten lines:** what changed (files), the test's last line, what it could not do, anything the parent must decide.
  The agent also ticks its ticket's boxes and sets the status.
- **Stop rule:** if the slice needs a file outside the brief's list or a design decision, the agent stops and says so. It does not
  widen its own scope.

## Lessons from agent 1 (14 Nov 2026)

- The square chain took 104 000 tokens and four minutes for one ticket, then stopped at the stop rule: the brief's file list was
  right for `09` and too narrow for `10` and `11`. **Before writing a brief, grep which files call into the part being changed**
  and list those functions too (here: who opens and closes the square's window).
- The stop rule worked as meant: nothing was half-built.

## Lessons from agent 3, the figures (14 Nov 2026)

- 143 000 tokens, eleven minutes, both tickets, no stop. Giving the whole design in the brief (the three pieces, each
  interface line by line) worked: the module came back as specified.
- **The tests passed and the screen was wrong twice** (figures three times too big; villagers at 0, 0 because the scene had
  no size at the first draw). Headless runs draw no 3D picture. After any agent that puts something on screen, the
  orchestrator takes one real-window screenshot (on the Mac: no `xvfb-run`, no `timeout`; `perl -e 'alarm 60; exec @ARGV'`
  in front of Godot, with `--nostory --square --shotframes=300 --shot=…`).
- A size given as a share of the scene's height is wrong on a tall screen: sizes follow the scene's width, as the stalls do.

## The order

Chains share files, so each chain is one agent that keeps its context; a new chain is a new agent.

| # | Agent (Sonnet) | Tickets, in order | Reads | Test | Waits for |
|---|---|---|---|---|---|
| 1 | square | `money-market/09` → `10` → `11` | `ui/square.gd`, `ui/places/market.gd`, the "square" block of `rules/49-trip.json`, the `square` row of `ui/README.md` | `trip_test`, the smoke test's square lines | nothing |
| 2 | store bar | `interface-feel/14`, then `crops-and-items/03` (two recipe lines) | the store's sheet, the bag bar's widget in `ui/widgets.gd`, `systems/inventory.gd` (functions only) | smoke test line for the bar; `check_data.py` | nothing |
| 3 | piles | `visible-work/02` → `03` | `ui/mapview.gd`, `systems/inventory.gd`, `rules/46-chores.json` (three entries), `fx.gd` (the fly and bounce functions) | a new `piles_test`; the chores test for the new chore | nothing; goldens re-recorded after 03 |
| 4 | picture list | `pictures/14` | `data/farm/items.json`, `places.json`, the node files' ids and emojis (by script, not by eye), `ART_LIST.csv` header, `tools/window_pictures.json` keys | the new tool runs and its counts are in the ticket | nothing (writes no game code; may run beside 1–3) |
| 5 | look trial | `people/05` | `kits/avatar/avatar.gd`, `data/avatar.json`, `tests/pose_sheet.gd` | three screenshots saved | nothing |
| 6 ✔ | figures | `people/04` → `06` | `kits/avatar/avatar.gd` (interface only), `ui/square.gd`, the condition language's README | a new `figures_test` | the parent's yes to `people/04`; agent 1; the pick from agent 5 only changes one file later |
| 7 | build pieces | `story/25` | `systems/story.gd`, one chapter's story file as the pattern, the list of builds (by script from the node files), `story/game/texts/more-ch*.md` (headings first) | `story_test` | nothing; the orchestrator edits the texts before they ship |
| 8 | overlaps | `interface-feel/15` | `ui/README.md`, the screenshot tool | the list in `interface-feel/12` | last: screenshots are the dearest thing an agent can read |

**Done by the orchestrator, not an agent:**

- `action-budget` `02`–`05` after the parent's yes: it touches the actions module, the bot and every golden run, and the balance
  needs judgement. The ring and the greying (`03`) can go to a Sonnet agent once `02` stands.
- `pictures/15`: the OpenArt connector lives in the main chat; two generations at a time, download, contact sheet.
- `interface-feel/13` (the frontier's smoke test fix on the Mac): small, done between agents.
- After each agent: `check_all.sh --short`; after agents 3 and the action budget: golden runs recorded anew, the explorer synced.
  One `PROJECT-LOG.md` row per finished chain.

## What the parent is asked (14 Nov 2026)

1. `action-budget/01`: yes to the shared understanding (24 moments a step, the ring round the clock, mastery makes chores quicker,
   pets do not use the farmer's time)?
2. `people/04`: yes to people as the farmer's rig behind one figures module, with the look decided from `people/05`'s screenshots?
3. `pictures/15`: yes to Claude generating, picking and importing, with a contact sheet to overrule; and how many credits per run?

Not waiting on an answer: agents 1, 2, 3, 4, 5, 7, 8.
