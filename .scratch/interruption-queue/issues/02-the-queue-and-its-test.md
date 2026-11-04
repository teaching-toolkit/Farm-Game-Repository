# 02: The interruption queue and its test, with no screen using it yet

**What to build:** The interruption queue exists on the interface side and draws nothing: interruptions are submitted with their kind
and key, busy screens tell it when they open and close, and it says what shows next, following one order list in the data that holds
today's order and waiting rules. No screen uses it yet, so nothing changes for the child.

**Blocked by:** `interruption-queue/01`

**Status:** done

**Milestone:** refactor

- [x] The order list in the data: one entry per kind (note after a pop-up, postcard, celebration, story box, bark) with its place and what it waits for, each with a note; the data checker knows it
- [x] The queue: submit, busy opens and closes, what shows next; the same key twice shows once; a kind not in the list is an error
- [x] Headless test in `check_all.sh`: today's order for each pair of kinds, the chapter-turn and walk pile-ups, sheets, bubbles, busy screens
- [x] Short golden runs identical; smoke test; data checks
- [x] `docs/design/` and the interface README say where the queue is and what it owns

**Feature:** `interruption-queue` · **Source:** `.scratch/interruption-queue/spec.md` and the grilling in `01-grill-and-spec.md`. Filed 2 Nov 2026. Words: `GLOSSARY.md`.

## Result (2 Nov 2026)

The queue is `kits/ui/interruptions.gd` (no farm words, draws nothing). Two ways in: `submit(kind, key, show)` for what is handed over
(celebrations, notes) and `source(name, next)` for lists kept elsewhere (the story's ready pieces, the saved postcards), asked once per
pump. Busy screens are **asked** through one function each, registered once with `watch(name, busy)`, instead of each screen reporting
open and close: the same answer with no report that can be forgotten (an agent's choice, easy to undo). The order list is
`"interruptions"` in `rules/65-feel.json`: six kinds (note, postcard, celebration, discovery, story, bark) and six busy screens (popup,
rest, playback, catchup, sheet, bubble). "playback" and "catchup" are two because today a story piece may come once the farm starts
catching up, while a celebration or postcard waits until the catch-up is over. `check_data.py` checks the list and every kind and
busy name the game's scripts use. `tests/interruption_test` (97 checks, in `check_all.sh`) fails on a broken order list (tried: 5 fails).
`check_all.sh --short` green, short golden runs identical.
