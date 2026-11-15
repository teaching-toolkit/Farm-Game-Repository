# 14: List everything that still has no picture of its own

**What to build:** One list of everything the child sees that has no picture of its own yet: every window and pop-up (going home, the fire, the workbench …), and every thing shown by an emoji that does not fit (the axle is a gear ⚙, the mountains are big rocks). Each gets a line in the art list with a brief and a prompt.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] A tool lists every item, node, place, station, stall and window whose picture file is missing (it reads the data and the assets folder; it can be run again)
- [x] A second list: things whose emoji is shared with another thing or does not show what it is (the agent proposes; axle, mountains, flour and straw, the herb pastes are known)
- [x] Every line is in `art-inbox/ART_LIST.csv` with priority (1 = seen in the first two chapters), size, brief and prompt, grouped into sheets of 6 to 9 things
- [x] The windows of `pictures/08` (`godot-prototype/tools/window_pictures.json`) are not listed twice
- [x] The counts per priority are in a `## Result` note

---

**Feature:** `pictures` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.3]. Filed 14 November 2026.

The parent's words:

> [#14.3] we need a list of stuff that doesn't have it's own picture yet and still needs one. That includes every pop up field like going home, the fire, the work bench, etc. But also stuff that is represented with an emoji right now, that isn't ideal like axel being a gear or mountains being big rocks.

## Result

Tools: `godot-prototype/tools/art_list.py` (extended) and new `godot-prototype/tools/emoji_report.py` (owns the rules: which node kinds the game can show, the generic-emoji rule, the hand list axle / steel / boulder / flour / fine flour / straw / the two herb pastes / sand / plank / clay, and the sheet hint). `art_list.py` imports it. Both can be run again; status stays computed from the file.

Newly listed: celebration pictures for helpers, gear and tools (`assets/helpers/<id>.png`), stations without a corner picture (`assets/interior/`), knowledge cards (`assets/cards/<id>.png`, the card page asks for it), the village square backdrop (`assets/square/square.png`), `assets/ui/`, `assets/piles/`, `assets/construction/`. Items whose emoji does not fit get their own brief plus "[emoji problem: ...; sheet items-emoji-N]"; helpers/gear/tools/stations/cards carry "sheet <kind>-N" (6 to 9 per sheet). Windows (58) are listed once, from `tools/window_pictures.json`.

Counts, `ART_LIST.csv` (788 rows), missing / done by priority: 1: 17/53, 2: 13/73, 3: 27/60, 4: 57/47, 5: 67/106, 6: 42/52, 7: 17/43, 8: 19/52, 9: 14/29. Total 273 missing, 515 done. All 183 items already have a file; the emoji-problem items (14) are listed for a redraw.

Ten worst emoji clashes among things with no picture: 🌾 x6 (hay rack, straw mulch, 4 cards), 🧺 x5, 🍞 x5, ⚙️ x5 (quern, mill, grindstone, 2 cards), 🪵 x4, 🪣 x4, 🧱 x4, 🧀 x4, 🔪 x4, 🍯 x4. 202 of 421 things have no picture file; 40 emoji are shared.

Not shown by the game yet (no code asks for a picture, so no row): books, polish, patch_* nodes, deliveries, merchants (seed_1, raw_1 ...).
