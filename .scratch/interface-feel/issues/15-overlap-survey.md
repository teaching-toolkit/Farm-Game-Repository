# 15: An agent photographs every screen and lists the wrong overlaps

**What to build:** The step `interface-feel/12` asks for before the parent is asked again: an agent takes a screenshot of every screen and window in a few farm states and lists each place where something is drawn in front of or behind the wrong thing.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Screenshots of the farm (early, mid, late), the square, the forest, every window type and the story boxes
- [x] A list in `interface-feel/12` of every wrong overlap found, with the screenshot's name
- [x] The plain cases are fixed here; the others are named for the parent
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated (no new text; `docs/design/map-and-interface.md` has the rounded picture; the final `check_all.sh --short` is in the log row)

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), the 💡 of `interface-feel/12` (30 Oct 2026). Filed 14 November 2026.
