# 09: Generate, pick and import the window pictures

**What to build:** The pictures on the list from `pictures/08` are generated, picked by the parent and imported, so every window has one.

**Blocked by:** `pictures/08`: the list and prompts; `pictures/16`: the game must be able to show them

**Status:** needs-parent

**Milestone:** prototype

**Size:** sitting

- [ ] Each window has a picture picked by the parent
- [x] 41 of 58 are imported and shown in their windows (15 Nov 2026, `tools/window_picture_files.json`, `assets/windows/*.webp`, 2.4 MB). The other 17 are windows that are not a place on the farm or have no clear picture yet: `square` (its scene is the picture), `quiz_farm`, `quiz_village`, `rest`, `card`, `intro`, `players`, `newpet`, `water`, `workshop_build`, `visit`, `forest_deep`, `quiz_forest`, `wren`, `settings`, `grownups`, `credits`
- [x] The web build size: 2.4 MB for 41 pictures (768 x 512 webp), well inside W2's plan for large files

## 💡 Recommendation (30 Oct 2026)

Generate in sheets of several windows at once, after `pictures/08` has written the prompts; start with the windows the child sees most (store, market, workshop).

**14 Nov 2026:** the 💡 above is taken; generating, downloading and picking happen in the picture run `pictures/15`. This ticket is done when its pictures are imported.

---

**Feature:** `pictures` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.33]. Filed 23 October 2026.

The parent's words:

> [#23.33] every window needs a generated picture. Like the road, the market, everything. Put that on the list of generated pictures.

## Progress (15 Nov 2026)

Generated, picked and imported by a Sonnet agent with no waiting for the parent (the parent's standing rule: Claude picks; alternatives stay in `art-inbox/alternatives/window-<id>/` so the parent can swap any of them with `python3 tools/import_window_pictures.py <key> <file>`). 630 credits (1020 of 2000 used in all). Checked in the real window with the store and the well: the picture sits across the top at 3:2, the content starts below it, 0 script errors.

Known rough spots, all kept: `scroll` is dark with a cream margin; `barn_seeds` has a small smile on a basket; `windmill` and `log` show tiny distant farmers; `broker` shows merchant figures; `ws_bench` shows a cat and piglets; some pictures show blank signboards with faint squiggles. The **well** window shows a finished roofed well even while the farmer has only the old bucket: the parent may want a ruined-well version for the first chapters (a second picture keyed by stage).

The parent's part: look through the windows when playing and name any that must change (the status stays `needs-parent` for that); the 17 left-out windows can follow in `pictures/15`.
