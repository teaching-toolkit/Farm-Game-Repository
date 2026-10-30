---
name: farm-game-session
description: Use at the start of, during and at the end of any work on the Farm Quiz Game (Hazelwood Harvest), on any track (game, story, pictures, sounds, docs). Says what to read for which task, how to take work from the tracker in .scratch/, the ask-matt flow, the end-of-session rule, and git.
---

# Farm Quiz Game: working session

An educational farming game for an 8-year-old, built in Godot 4.7 (GDScript) in `godot-prototype/`. The person you work with is
the child's parent and the game's designer: they play-test with the child (on the laptop for now), pick the pictures and decide design
questions. Write to them in plain, direct language (their rules: `00-READ-ME-FIRST.md` §3; they win over anything here).

This is the only place that says **how to work**. The other two project skills: `farm-game-check` (set up Godot, run the checks,
screenshots, debugging, web export) and `farm-game-content` (questions, cards, texts and German, numbers, sounds, pictures, map).

## 1. Where the project is

- **Linked computer (device shell):** the folder "Farm game", at `$HOME/mnt/Farm game`. Edit the real files there.
- **Cloud session:** the private GitHub repo, same layout, starting from an empty machine.

## 2. Read only what the task needs

**Always, at the start:** `00-READ-ME-FIRST.md` (one page), `ROADMAP.md` (one page), then `python3 tools/tracker.py` for the
frontier and the parent's queue. Take work from the **frontier** (`ready-for-agent`, blockers `done`); never build a
`needs-parent` ticket. Say in one line which ticket you work on, then read it. Tracker rules: `.scratch/README.md`.

**Then, by task:**

| The task is about | Read |
|---|---|
| A code change or a new mechanic | the `docs/design/` file the ticket names (index: `docs/design/README.md`), `GLOSSARY.md`, the ADRs in `docs/adr/` it touches, `godot-prototype/README.md` and the systems' READMEs, then the scripts. Where code goes: §4 below and `docs/sources/2026-10-12-architecture-plan.md` |
| An architecture module (`time-question`, `condition-language`, `interruption-queue`) | `docs/architecture-review-2026-10-22.md` Part B, the feature's `01-grill-and-spec.md`, and the `codebase-design` skill |
| Questions, cards, texts, German, numbers, sounds, pictures | the `farm-game-content` skill |
| Rest sums, the quiz engine, the learning record | `godot-prototype/kits/learn/README.md` |
| The story | `story/README.md`, `story/GLOSSARY.md`, `story/docs/adr/`; keep the labels ✅ 💡 ❓ 🔒 |
| Why something is the way it is | `docs/adr/` and `story/docs/adr/`; for older detail search `archive/log-2026-10.md` §2 (don't read it whole) |
| Pace and balancing | `godot-prototype/data/farm/` and the explorer. **The data wins** over any document |

For a long file, list its headings (`grep -n '^#'`) and read only what you need; in scripts, `grep -n '^func'`. Never edit
`archive/` or `story/archive/`.

## 3. The flow (ask-matt)

- **New feature or module:** `/grill-with-docs` with the parent (it updates `GLOSSARY.md` and offers ADRs) → `/to-spec` writes
  `.scratch/<feature>/spec.md` → `/to-tickets` writes the numbered tickets → build each frontier ticket with `/tdd`, one at a time,
  each passing the checks before the next. Refactors keep the golden runs identical.
- **Bigger step inside a ticket** (adds a mechanic, touches more than two scripts, changes the save data or the data files'
  structure): write a short plan into the ticket first (goal, files, what happens to old saves, what the bot must learn, how it is
  checked).
- **Questions for the parent:** a `needs-parent` ticket with a 💡 recommendation (two or three options with trade-offs where it is
  not obvious) and a **Size** (*quick*, *short*, *sitting*). When the parent is there, ask in rounds of at most three, each
  worded so that "yes" accepts the recommendation, and write each answer into its ticket and the log. When they are away, take an
  easy-to-undo 💡 and say so in the ticket and the log row; anything hard to undo waits.

## 4. Where code goes

Prefer new systems in new scripts over a longer `main.gd` or `game.gd`. A rule goes into the system in `game/farm/systems/` that owns
the thing (a new system registers its per-step work in `Game.setup_clock()`); shared parts (modifiers, conditions, rng, clock) are
in `kits/core/`; a screen or interface part gets its own script in `game/farm/ui/`; content is data, not code. Call other systems as
`G.<system>.<function>`. Old saves must keep loading: a new key goes into its system's `save_defaults()`, a changed layout needs a
`SAVE_VERSION` step in `Game.save_steps()`.

**Chores and prices** ([ADR-0013](../../../docs/adr/0013-one-farm-actions-module.md)): anything the farmer does that costs energy,
water or items is a chore of `G.actions`: its base cost in `data/farm/rules/46-chores.json`, its effect and requirements in the
owning system's `register_chores`; buttons, the bot and tests call `G.actions.check` / `perform`. Never multiply a cost by hand or
write a second "too tired" check. Coins leave the purse only through `G.lord.pay_coins`. Add a new chore to `COVERED` and a
price-match test in `tests/actions_test.gd`.

## 5. The end-of-session rule (every session, every track)

Do these as you go, not only at the end; a chat can stop at any time.

1. **The ticket:** tick its boxes; finished → `**Status:** done`. A new job is a new ticket (with a milestone); a stop halfway adds a
   `## Progress` note.
2. **One row in `PROJECT-LOG.md`** (date, track, what happened, the tickets by `feature/NN`).
3. **`ROADMAP.md`** only if "Now" changed.
4. **`docs/design/<system>.md`** when the game's behaviour changed: describe the game as it now is.
5. Words or lasting decisions settled → `GLOSSARY.md` / an ADR (game or story area).
6. Run `python3 tools/check_docs.py` (links, statuses, milestones, log rows), and for game changes the checks of `farm-game-check`.
7. **Last message:** what changed, what the parent should play-test, and a ready commit message.

If a command or rule in these skills turns out wrong, fix it here and say so in the log row.

## 6. Git

- **Cloud session:** commit after each finished slice; push or open a pull request as the session is set up to.
- **Linked computer:** no git commands that write (`commit`, `add`, `stash`, `checkout`, `pull`, `reset`); use
  `GIT_OPTIONAL_LOCKS=0 git status` / `git diff`. The parent commits from the Mac. Deleting files there needs one permission request
  per session; ask once, for everything you plan to delete.
