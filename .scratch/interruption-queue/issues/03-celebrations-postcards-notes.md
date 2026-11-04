# 03: Celebrations, postcards and the notes after a pop-up go through the queue

**What to build:** A celebration, a postcard and the notes after a pop-up closes are submitted to the interruption queue, and the screens
the child opens (pop-ups, Rest, sheets) and the Time Quiz playback tell it when they are busy. The order decided at the end of closing a
pop-up is gone. The child sees the same things in the same order as before.

**Blocked by:** `interruption-queue/02`

**Status:** done

**Milestone:** refactor

- [x] Celebrations, postcards (also on start and from a new offer) and the notes after a pop-up go through the queue
- [x] Pop-ups, Rest, sheets and the playback report busy and done; no part reads another's flags for these three kinds
- [x] The order after closing a pop-up is no longer written in code
- [x] Screenshots EN/DE of a celebration and a postcard match the ones before; a celebration during the Time Quiz still waits for the farm to catch up
- [x] Short golden runs identical; smoke test; old saves with a waiting postcard show it on start

**Feature:** `interruption-queue` · **Source:** `.scratch/interruption-queue/spec.md`. Filed 2 Nov 2026.

## Result (2 Nov 2026)

New interface part `M.interrupts` (`game/farm/ui/interrupts.gd`): sets up the queue from the order list, watches the busy screens
(pop-up, Rest, playback, catch-up, sheet, bubble) and hands it the saved postcards as a source. A celebration is handed over with
`M.interrupts.celebration(id, show)` (the same id twice is in line once, as before); a Rest medal's note with `M.interrupts.note(text)`;
a new postcard offer only asks for a pump. The `if / elif` after closing a pop-up is gone (it now asks the queue for a pump at the end of
the frame, as the old deferred calls did); `main.celebration_queue` and `main.after_close` are gone; the story box asks the queue
whether a celebration or postcard waits (until `04` removes its own check). Busy screens are asked, not told (see `02`).
Checked: smoke test with a new line (a celebration during the Time Quiz waits in line during the quiz and the catch-up, shows after
it, once); smoke output the same as the code before this ticket (apart from the farmer's walk, which differs between runs anyway);
screenshots of a celebration, a postcard, both at once (the postcard first) and the celebration in German against the code before:
only the farmer's idle animation differs; an old save with a waiting postcard shows it on start; `check_all.sh --short` green, both
short golden runs identical. Screens: `Claude outputs/screens/iq/`.
