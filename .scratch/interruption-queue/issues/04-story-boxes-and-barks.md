# 04: Story boxes and barks go through the queue

**What to build:** Story boxes and barks are shown when the interruption queue says it is quiet for them; the story box's own quiet check
is gone. `G.story` still decides which piece is ready and how often. The child sees the same story at the same moments as before.

**Blocked by:** `interruption-queue/03`

**Status:** done

**Milestone:** refactor

- [x] Story boxes and barks go through the queue; the story box no longer checks other parts' state
- [x] A Discovery still comes over an open sheet; other story boxes still wait for it; a bark still waits only for another bubble
- [x] The welcome at the very start still shows when no story piece is ready
- [x] Screenshots EN/DE of a story box match the ones before; the smoke test's story checks pass
- [x] Short and full golden runs identical; `docs/design/` (story delivery) describes the queue; the `interruption-queue` feature is done

**Feature:** `interruption-queue` · **Source:** `.scratch/interruption-queue/spec.md`. Filed 2 Nov 2026.

## Result (3 Nov 2026)

The story is a source of the queue (`story.candidate()`: the next ready piece as a bark, a Discovery or a story box); the story box's own
quiet check is gone, and `story.queue_pump()` and every refresh only ask the queue for a pump. The start of a new game asks
`story.pump()` before its welcome; it shows only story pieces (`pump(only)` in the queue), so anything else waiting comes after the
welcome, as before.

**Independent review (fresh agent), and what came of it:**
- Fixed, a real bug in the first version: `story.pump()` showed every kind, so at the start of a new game a waiting celebration could
  show and be covered at once by the welcome (lost). New smoke line checks it (fails with the old version: tried).
- Fixed: a wiring mistake (a busy screen not watched, a kind not in the list) only printed an ERROR line. The farm part now checks that
  every busy screen of the list is watched; `check_all.sh` fails on any `ERROR: interrupt…` line of the smoke test (tried with the
  sheet unwatched); the data checker also checks the kinds that scripts ask about.
- Fixed: the queue test now pins today's waiting rules in a table of its own (a change to the order list must change it on purpose).
- Fixed: the smoke test's new checks come last, so every older line is again identical to the code before this feature.
- Fixed, small: a note asks for a pump; the end of a catch-up asks for a pump (a walk's news has no "after" step).
- Not changed: a missing order list makes the queue show nothing (the data checker catches it); postcards open at the end of the frame,
  not at once (the reviewer found no path where this shows).

**Small differences on purpose (none seen in the checks):** the whole queue is asked on every refresh, and when a catch-up ends; before,
a celebration that arrived during a walk's catch-up waited until the next pop-up closed, now it comes when the farm has caught up.

**Checked:** `tests/interruption_test` 105 checks; smoke test no FAIL, its output identical to the code before this feature apart from
the new lines (and the farmer's walk, which differs between runs anyway); a celebration through the quiz and the catch-up; story box
EN and DE pixel for pixel identical to before; `check_all.sh --short` green; short and full golden runs identical in strict mode (full
runs in the cloud copy: the Mac's Linux shell was too slow tonight).
