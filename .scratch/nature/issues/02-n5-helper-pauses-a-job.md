# 02: N5: A Helper pauses one job when over-use is ignored

**What to build:** After the advice is ignored and yields sit at their floor, a Helper pauses one job and gives the farmer a look, until the balance is back. Helpers never leave. The advice and the floor are built; the pause is not.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** later

- [x] A Helper pauses one job while a pool stays over-used, and says so
- [x] The pause ends when the balance returns; the Helper stays
- [x] A test covers start and end of the pause; the bot is unaffected or learns it

## Progress

Built. `G.nature` owns the rest: a pool with a `pauses` entry (`rules/56-nature.json`: the pet, the entry id of its blessing or chore, the spot it sits at) goes into
`nature.rest` when it falls below `pauseBelow` (0.2, under the advice's 0.35: the child went on after the advice) and comes out at `pauseUntil` (0.5). `G.pets` asks
`nature.pause_of(pet, entry)` before it does a job: a paused job spends nothing, shows 🌱 at the forest (the existing `why` mechanism: new reason `rest`, "Last question"
line in the pet's window with German), and says so once in the log; it says once again when it goes on. The pony stays and its other jobs go on.
Test: `tests/nature_test.gd` (`_helper_rests`: start at the line, holds until the balance is back, once-only lines, the log is not hauled meanwhile, sticks have their
own job, stones have none, an old save without `rest`) plus a window line in `ui_smoke`. Bot: unaffected (it sets the pets' chores, not log/stick); short golden identical.
💡 Decisions (easy to undo, all data): only sticks (*Leaves a stick*) and trees (*Haul logs*) pause the pony; stones and clay have no Helper job that draws on them and keep
only the floor; numbers 0.2 / 0.5 for every pool. New save key `nature.rest`: `tests/golden/newgame.json` has to be recorded anew (`saves_test -- --seed=1 --record`, adds `"rest": {}` under `nature`).

---

**Id:** N5 · **Feature:** `nature` · **Moved from** `archive/todo-2026-10.md` §10 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **N5. Advice, then consequences** ✅: over-use gets a recommendation first (the book, a Helper's look); ignoring it lowers yields to a
  **floor that always covers the basics** (the campfire is never impossible), and a Helper **pauses one job and gives you a look** until
  the balance is back. Helpers never leave. 🔗 L7, M13 (the Lord's share pushes towards over-use, as it did for the family).
