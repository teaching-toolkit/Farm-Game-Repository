---
name: farm-game-session
description: Use at the start of, during and at the end of any work on the Farm Quiz Game (this project). Says what to read for which task, how to plan bigger steps, how to work from the tickets in issues/, how to keep TODO.md and PROJECT-LOG.md current, and how to handle git.
---

# Farm Quiz Game: working session

The Farm Quiz Game is an educational farming game for an 8-year-old, played on an iPad held upright. It is built in Godot 4.7
(GDScript) in `godot-prototype/` and also runs in the browser. The person you work with is the child's parent and the game's
designer: they test on the iPad, pick the pictures and decide design questions. Write to them in plain, friendly language.

This is one of three skill files in `claude-skills/`. The other two:
- `claude-skills/farm-game-check/SKILL.md`: set up Godot, run the checks, screenshots, debugging, review, web export.
- `claude-skills/farm-game-content/SKILL.md`: questions, cards, texts and German, numbers, sounds, pictures, map layout.

They are ordinary files, not installed skills: `CLAUDE.md` (loaded automatically in Claude Code) and
`00-READ-ME-FIRST.md` both send every session here first.

## 1. Where the project is

- **Linked computer (Cowork, device shell):** the folder is connected as "Farm game", at `$HOME/mnt/Farm game`. Edit the real
  files there; the parent opens them on the Mac.
- **Claude Code cloud session:** the private GitHub repo, same layout, starting from an empty machine.

## 2. Read only what the task needs

Don't read every document in full. Together they are over 180 KB, and reading all of them costs a large part of the session
before any work starts.

**Always, at the start:**
- `00-READ-ME-FIRST.md`: the standing rule at the top, §1, §4.6 (the parent's rules) and §5 (where we left off).
- `TODO.md`: §0 (the plan at a glance) and §1 (waiting on the parent). Then only your task: find it with
  `grep -rn "<task id>" TODO.md issues` (for example `M5`, `I14`). The line in `TODO.md` links the ticket; the ticket holds the old
  task's text and what blocks it. Entries that are decided and built stay in `TODO.md` in full.
- `issues/README.md`: the tracker rules (layout, the three statuses, the frontier, specs, what to do when a ticket is done).
  Take work from the **frontier**: `ready-for-agent` tickets whose blockers are all `done`. Never build a `needs-parent` ticket.

**Then, by task:**

| The task is about | Read |
|---|---|
| A code change or a new mechanic | First `planning/2026-10-12-architecture-plan.md` (where code goes and the restructuring under way; later `godot-prototype/ARCHITECTURE.md`); then the design document's section for it (list the headings first: `grep -n '^#' farm-quiz-game-master-design-document.md`), the parts of `godot-prototype/README.md` it touches, then the scripts |
| Questions, cards, texts, German, numbers, sounds, pictures | `claude-skills/farm-game-content/SKILL.md` |
| Rest sums, the quiz engine, the learning record | `godot-prototype/kits/learn/README.md` |
| The story | `story/README.md`, then the files it points to (keep its labels ✅ 💡 ❓ 🔒) |
| Why something is the way it is | `PROJECT-LOG.md` §2 (search it; don't read it whole) |
| Pace and balancing | the files in `godot-prototype/data/farm/` (`rules/`, `nodes/`, `items.json`, `recipes.json`) and the explorer. **The data wins** if it and a document disagree |

For any long file: list its headings with `grep -n '^#'`, then read only the sections you need. In the two big scripts
(the rules are in `game/farm/systems/*.gd` and the interface in `game/farm/ui/*.gd`, 50–400 lines each, see their READMEs; `main.gd` is the 400-line composition root), find functions with
`grep -n '^func'` and read those. Never edit anything in `archive/`.

Then say in one line which ticket(s) you are working on.

## 3. Plan bigger steps before building

A step is "bigger" if it adds a mechanic, touches more than two scripts, or changes the save data or the structure of
the data files in `data/farm/`. For those:

1. Write a short plan into the ticket (`issues/…`), under its checkboxes, at most about 15 lines: the goal, the files, what happens to existing
   saves (old saves must keep loading: a new key goes into its system's `save_defaults()`, a changed layout needs a `SAVE_VERSION` step in `Game.save_steps()`), what the bot must learn to play it, and how it will be checked.
2. Make each open design question a `needs-parent` ticket (with a line in `TODO.md`) with a 💡 recommendation. For a new
   feature use the flow in `issues/README.md` §4 (`/grill-with-docs`, `/to-spec`, `/to-tickets`, `/tdd`). If the parent is there, ask
   them (multiple choice if possible). If they are away, go ahead with the 💡 option only when it is easy to undo, and record
   it as an assumption in `PROJECT-LOG.md` §2.6. Anything that can't be undone waits for the parent.
3. Build in small slices. Each slice passes the checks (`farm-game-check`) before the next one starts. Golden runs do not need to run through all chapters every time: `check_all.sh --short` after every slice, the full run when a slice touches a late system.
4. Prefer new systems in new scripts over making `main.gd` and `game.gd` even longer. **Where new code goes:** a rule goes into the system of
   `game/farm/systems/` that owns the thing (or a new system file there; it registers its per-step work in `Game.setup_clock()`); shared parts
   (modifiers, conditions, rng, clock) are in `kits/core/`; a screen or interface part goes into its own script in `game/farm/ui/` (see its README), not into `main.gd`; content
   (places, pets, numbers, texts) is data, not code. Call other systems as `G.<system>.<function>`.
   **Chores and prices:** anything the farmer does that costs energy, water or items is a *chore* of `G.actions`: write its base cost in `data/farm/rules/46-chores.json`, register its effect and requirements in the owning system's `register_chores`, and let buttons, the bot and tests call `G.actions.check` / `perform`. Never multiply a cost by hand or write a second "too tired" check. Coins leave the purse only through `G.lord.pay_coins`. Add the new chore to `COVERED` and a price-match test in `tests/actions_test.gd`.

Small fixes (one script, no new rules) need no written plan.

## 4. Keep the record as you go (the standing rule)

A chat can stop at any time, so update these when something happens, not at the end:

- `issues/` and `TODO.md`: tick the boxes of the ticket you work on; a finished ticket gets `Status: done`, its line leaves
  `TODO.md` and a row goes into the log (the file stays); a new job becomes a new ticket with a line in `TODO.md`; reword changed
  ones. A task that is not written down in both does not exist for the next chat. Details: `issues/README.md` §6.
- `PROJECT-LOG.md`: one row in §1 for every change to the game, the data, the tools or a decision; new unconfirmed
  assumptions in §2.6.
- The design document: describe the game as it now is, not the change. Mark *(planned)* and *(idea)*.
- `story/`: keep its files current in the same way when story work happens.
- These skill files: if a command, number or rule in them turns out wrong or outdated, fix it here (and log it), so the next
  session doesn't repeat the mistake.

**At the end of a session (or before a long pause):**
- `00-READ-ME-FIRST.md` §5: rewrite it to the current state and the next step (no dated changelog; the history is the log's
  table and §1.1) and say whether `web-build/` still matches the code. Update §7 "Key numbers" if the data changed. Set the "Last updated" date at the top of `00-READ-ME-FIRST.md` and `TODO.md`.
- In your last message: what you changed in the log and the to-do list, what the parent should test on the iPad, and a
  ready-to-use commit message.

## 5. Git

- **Cloud session:** commit after each finished slice with a clear message; push or open a pull request as the session is set up to.
- **Linked computer (Cowork):** don't run git commands that write (`commit`, `add`, `stash`, `checkout`, `pull`, `reset`).
  File deletion is blocked there, so git leaves lock files behind that break the parent's git on the Mac. Read-only commands
  are fine; use `GIT_OPTIONAL_LOCKS=0 git status` and `GIT_OPTIONAL_LOCKS=0 git diff` so even those write nothing. The parent
  commits; give them the commit message.

## 6. Rules

The parent's rules are in `00-READ-ME-FIRST.md` §4.6 (part of the "always" reading above); they win over anything here.
Decisions marked ✅ were taken by the parent: don't change them without asking.
