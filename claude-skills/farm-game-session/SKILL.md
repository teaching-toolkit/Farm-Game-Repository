---
name: farm-game-session
description: Use at the start of, during and at the end of any work on the Farm Quiz Game (this project). Says what to read for which task, how to plan bigger steps, how to keep TODO.md and PROJECT-LOG.md current, and how to handle git.
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
- `TODO.md`: §0 (the plan at a glance) and §1 (waiting on the parent). Then only the section of your task: find it with
  `grep -n "<task id>" TODO.md` (for example `J3`, `M2`, `Q-L1`).

**Then, by task:**

| The task is about | Read |
|---|---|
| A code change or a new mechanic | First `godot-prototype/ARCHITECTURE.md` (how the code is built and where new code goes; the reasons are in `planning/2026-10-12-architecture-plan.md`); then the design document's section for it (list the headings first: `grep -n '^#' farm-quiz-game-master-design-document.md`), the parts of `godot-prototype/README.md` it touches, then the scripts |
| Questions, cards, texts, German, numbers, sounds, pictures | `claude-skills/farm-game-content/SKILL.md` |
| Rest sums, the quiz engine, the learning record | `godot-prototype/kits/learn/README.md` |
| How the code is built, **where new code goes** | `godot-prototype/ARCHITECTURE.md` (read before any code change) |
| The story | `story/README.md`, then the files it points to (keep its labels ✅ 💡 ❓ 🔒) |
| Why something is the way it is | `PROJECT-LOG.md` §2 (search it; don't read it whole) |
| Pace and balancing | `godot-prototype/data/farm/` (the data, split into files) and the explorer. **The data wins** if it and a document disagree |

For any long file: list its headings with `grep -n '^#'`, then read only the sections you need. In the two big scripts
(the screen in `game/farm/ui/*.gd` and `ui/places/*.gd`, 15–340 lines each, built by `game/farm/main.gd`; the rules in `game/farm/systems/*.gd`, 30–380 lines each, behind the front door
`game/farm/game.gd`), find functions with `grep -n '^func'` and read those. New rule code goes into its system. Never edit anything in `archive/`.

Then say in one line which task(s) from `TODO.md` you are working on.

## 3. Plan bigger steps before building

A step is "bigger" if it adds a mechanic, touches more than two scripts, or changes the save data or the structure of
the data in `data/farm/`. For those:

1. Write a short plan into `TODO.md` under the task, at most about 15 lines: the goal, the files, what happens to existing
   saves (old saves must keep loading), what the bot must learn to play it, and how it will be checked.
2. Put open design questions into the decision queue (`TODO.md` §2) with a 💡 recommendation. If the parent is there, ask
   them (multiple choice if possible). If they are away, go ahead with the 💡 option only when it is easy to undo, and record
   it as an assumption in `PROJECT-LOG.md` §2.6. Anything that can't be undone waits for the parent.
3. Build in small slices. Each slice passes the checks (`farm-game-check`) before the next one starts.
4. Prefer new systems in new scripts over making `main.gd` and `game.gd` even longer.

Small fixes (one script, no new rules) need no written plan.

## 4. Keep the record as you go (the standing rule)

A chat can stop at any time, so update these when something happens, not at the end:

- `TODO.md`: remove finished tasks (they go to the log), add new ones, reword changed ones. A task that is not written down
  does not exist for the next chat.
- `PROJECT-LOG.md`: one row in §1 for every change to the game, the data, the tools or a decision; new unconfirmed
  assumptions in §2.6.
- The design document: describe the game as it now is, not the change. Mark *(planned)* and *(idea)*.
- `story/`: keep its files current in the same way when story work happens.
- These skill files: if a command, number or rule in them turns out wrong or outdated, fix it here (and log it), so the next
  session doesn't repeat the mistake.

**At the end of a session (or before a long pause):**
- `00-READ-ME-FIRST.md` §5: add one dated paragraph saying what changed and whether `web-build/` still matches the code.
  Update §7 "Key numbers" if the data changed. Set the "Last updated" date at the top of `00-READ-ME-FIRST.md` and `TODO.md`.
- In your last message: what you changed in the log and the to-do list, what the parent should test on the iPad, and a
  ready-to-use commit message.

## 5. Git

- **Cloud session:** commit after each finished slice with a clear message; push or open a pull request as the session is set up to.
- **Linked computer (Cowork):** don't run git commands that write (`commit`, `add`, `stash`, `checkout`, `pull`, `reset`).
  File deletion is blocked there, so git leaves lock files behind that break the parent's git on the Mac. Read-only commands
  are fine; use `git --no-optional-locks status` and `git --no-optional-locks diff` so even those write nothing. The parent
  commits; give them the commit message.

## 6. Rules

The parent's rules are in `00-READ-ME-FIRST.md` §4.6 (part of the "always" reading above); they win over anything here.
Decisions marked ✅ were taken by the parent: don't change them without asking.
