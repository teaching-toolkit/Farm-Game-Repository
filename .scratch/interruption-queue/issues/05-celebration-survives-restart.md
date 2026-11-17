# 05: A celebration waiting when the game closes shows after loading

**What to build:** If the game closes while a celebration of something new is still waiting for its turn, it shows after the game is
loaded again, instead of being lost. Today it is lost (rare: it shows as soon as a pop-up closes).

**Blocked by:** `interruption-queue/04`

**Status:** done

**Milestone:** later

**Size:** quick

- [x] A waiting celebration is kept in the save and shows after loading, once
- [x] Old saves load; save fixtures pass

## 💡 Recommendation (2 Nov 2026)

Build it as described, but only when the prototype stands: it is rare and nothing is lost but the confetti. Alternative: drop it.

**Feature:** `interruption-queue` · **Source:** grilling round 2, question 5 (`01-grill-and-spec.md`). Filed 2 Nov 2026.

## Decision (17 Nov 2026, parent away, easy to undo)

- [x] Take the 💡: build it as described (do not drop it). Why: it was the parent's own answer in grilling round 2; the cost is one small list in the save, and a missing list simply means "nothing waiting", so old saves and a later undo are both safe.

Spec for the builder:

- The save keeps one small list of the celebrations still waiting (what the queue holds, nothing more), in the flat save (R7): no new file, no version bump.
- After loading, each waiting celebration goes back into the queue and shows once, after any story box; when it has shown, it leaves the list.
- A save fixture with a waiting celebration is added; an old save without the list loads as "nothing waiting".
- Build it last among the ready tickets: it is rare and only the confetti is at stake.

## Progress (17 Nov 2026)

Built. `G.rewards` owns the sparse key `celebrations_waiting` (`celebrations_waiting()`, `keep_celebrations(ids)`; deliberately NOT in `save_defaults()`, so
`newgame.json` and old saves stay as they are, no version bump). `ui/interrupts.gd` keeps it in step with the queue (`celebration()` writes the list when one
goes in line, its `show` wrapper takes it out and saves once) and `restore()` puts the saved ones back in line, after a story box that is ready (`pump_story()`
first). `restore()` runs at the end of `main._ready`, after `welcome._player_chosen` and after the menu's new game (there it only drops what waited for the old farm).
Tests: `ui_smoke` (the "interruptions/05" lines: kept in the save, lost without it, back after loading, shows once and leaves the save, old save = nothing waiting,
story box first) and `saves_test` (sparse key, fixtures, old save). 💡 Decisions (easy to undo): "after any story box" = a story box that is ready when the save is
loaded; a later story box still waits for a celebration in line, as the order list says. The key is not in `save_defaults()` (the brief's "sparse"); the fixtures were
not extended with a file, the tests build the save with the key. The shown celebration saves the farm at once so "once" also holds if the game closes right then.
