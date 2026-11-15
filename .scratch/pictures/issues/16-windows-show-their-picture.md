# 16: A window shows its painted picture at the top

**What to build:** Every window (the road, the market, the store, every station …) shows its painted picture across the top, as the story boxes do, when the picture file exists (`assets/windows/<key>.webp`, the keys of `godot-prototype/tools/window_pictures.json`). Without a file the window looks as it does today. A small tool imports a generated window picture (trim, 768 × 512, webp).

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] One function gives the picture key of the window that is open (from the sheet's kind and the place), and one place draws the picture; no window draws its own
- [x] The picture is as wide as the window, at most a third of its height, and scrolls away with the content
- [x] A window without a picture file is unchanged; the smoke test checks one of each
- [x] `tools/import_window_pictures.py` (the pattern is `tools/import_story_pictures.py`) brings a picture from `art-inbox/` to `assets/windows/`
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

---

**Feature:** `pictures` · **Source:** the parent's notes of 23 October 2026 ([#23.33]) and of 14 November 2026 ([#14.3], `docs/sources/2026-11-14-parent-notes-testrun.md`). Filed 14 November 2026: `pictures/14` found that no code asks for a window picture yet, so the 58 listed pictures could not be seen. `pictures/09` (generating them) waits for this.

The parent's words:

> [#23.33] every window needs a generated picture. Like the road, the market, everything.
