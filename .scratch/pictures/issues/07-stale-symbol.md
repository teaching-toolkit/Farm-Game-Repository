# 07: A better picture or symbol for things going stale

**What to build:** The mark that shows a thing is going stale gets a clearer symbol. The parent picks or generates it.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The picture exists: `assets/ui/stale_leaf.png` (a wilted leaf; `stale_flower.png` is the alternative), picked by Claude for the parent, 14 Nov 2026
- [x] It replaces the 🍂 mark on the store's tiles (the agent) and on a place's small sign on the map (the main chat, `map/slot.gd`); 🍂 inside sentences stays
- [ ] Screenshots checked (not done: the smoke test passes, nobody has looked at it on screen yet; the parent sees it in play)

## 💡 Recommendation (30 Oct 2026)

A small wilting-leaf picture in the game's style instead of the 🍂 emoji, drawn on the tile's corner; an agent writes the prompt, you generate it with the next sheet.

**14 Nov 2026:** the 💡 above is taken; generating, downloading and picking happen in the picture run `pictures/15`. This ticket is done when its pictures are imported.



## Progress

Store tile (`pantry.gd`) now shows `ui/stale_leaf` (emoji if missing). The map sign (`mapview.badge()` returns the text "🍂" to `slot.set_state`, `farm_map.set_road_badge/set_field_badge`, `interiors.gd`) is NOT done: it is plain text passed through files outside the brief. Screenshots not checked.

---

**Feature:** `pictures` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.21]. Filed 23 October 2026.

The parent's words:

> [#23.21] better picture/symbol for things going stale
