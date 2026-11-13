# 06: Bug: the bag bar works in the village square, not only on the farm

**What to build:** In the square the bag bar shows the current load and updates as things are sold, bought or handed over. Today it fills only when packing on the farm.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The bag bar updates on every sale, purchase and delivery in the square
- [x] It shows the room left for buying
- [x] Smoke test: sell, buy and deliver and check the bar each time

---

**Feature:** `money-market` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.26]. Filed 23 October 2026.

The parent's words:

> [#23.26] The bag bar doesn't work in the marke square it only fills when on the farm for bringing things

## What was built (9 Nov 2026)

💡 taken as an easy-to-undo choice while the parent was away; **confirmed by the parent on 9 Nov 2026 ("Yes, keep it")**: the ticket asks for one bar that follows sales, purchases and deliveries and shows
the room left, but the rules count the way home separately from the bag (`money-market` §5.3b: the same size as the way there). So:

- **Top bar** (the thin bar under the 🎒 icon, which stays visible above the square window): on the square it shows what is still to sell or hand over *plus* what is
  bought for the way home, so it falls with every sale and delivery and rises with every purchase (`G.trip.carry_fill()`). At home it is the packed load as before.
- **Square window:** two labelled bars at the top, 🎒 "N of M room used" (empties on sales and deliveries) and 🏠 "Room to carry things home: N of M" (the bar fills with
  every purchase; the number is the room left that the shops take). Seeds weigh almost nothing, so buying only seeds moves it a little.
- The capacity rules are unchanged: no change to what can be bought, the bot or the golden runs.

Answered: the parent wants the one bar that goes up and down (the alternative, the top bar showing only the way home, would be one line in `main.gd` `refresh`).
Edge case: top bar red ("full") can show while there is still buying room, because it adds the unsold load to what is bought; the 🏠 bar always tells the truth about buying room.

Checks: `tests/trip_test.gd` (44 checks; the way-home fill, the top bar, a sale, a purchase and a delivery), `tests/ui_smoke.gd` ("square bars" line: the window's two bars and the top bar after
a sale, a purchase and selling the rest; the test was shown to fail when the 🏠 bar is broken), `check_all.sh --short` green, golden short runs identical (304 and 447 steps), German through `ui-de.json`.

