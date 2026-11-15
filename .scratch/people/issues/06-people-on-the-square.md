# 06: People stand and stroll on the village square

**What to build:** The village square has people: each stall's seller stands at the stall, and one or two villagers stroll between the well, the bench and the stalls. Each can be tapped and says a line that fits them.

**Blocked by:** `people/04`, `money-market/10`

**Status:** done

**Milestone:** prototype

- [x] The three sellers the prototype has (seeds, raw materials, the book cart) and two villagers are people in the data, each with three lines in English and German
- [x] A seller stands by their stall and turns to the farmer; a tap on the seller says a line, a tap on the stall opens its window
- [x] Villagers stroll between points named in the square's data and never walk through a stall
- [x] The farmer is not on the square (the scene is seen through the farmer's eyes)
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

## Progress (14 Nov 2026)

Built by a Sonnet agent, checked by the main chat with a screenshot (`Claude outputs/screens/square-people.png`). Two things the tests could not see were fixed after the look: figures are sized by the scene's width (`figureH` 0.13), and nobody is placed before the scene has a size. The sellers of the raw materials and book stalls appear only while their stall stands. Not yet tried with a real finger: the tap itself (the tests call the function a tap calls).

---

**Feature:** `people` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.2]. Filed 14 November 2026.

The parent's words:

> [#14.2] how can we make them appear (especially in the village square) and walk around
