# 04: Icons next to items (hand axe, sticks and so on) are small versions of their pictures, not emojis

**What to build:** Wherever an item appears in a cost row, list or tile, it shows a small version of its own picture. The emoji is used only for an item that has no picture yet.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Cost rows, recipe tiles, the bag and the store use the item's picture when it has one
- [x] Emoji is the fallback only
- [x] No visible slowdown on the iPad (pictures cached)
- [x] Screenshots of a cost row and the store checked

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.36]. Filed 23 October 2026.

The parent's words:

> [#23.36] the icons next to the things like hand axe or sticks need to be small versions of the pictures and not emojis

## Result (3 Nov 2026)

- **Built:** `Art.icon(folder, keys, px)` (`kits/ui/art.gd`) cuts a picture to its edges, scales it down once (cubic, at most 64 px)
  and keeps it; `M.widgets.pic(k)` picks the picture of an item (`assets/items/`), of a tool or gear (`assets/tools/`, via the
  bench's `pic` name: the hand axe shows `stone_axe.png`), and of "any …" tags the same choice as the emoji. Used by: cost rows
  (`UI.cost_row` got an optional `icon` callable; without a picture it shows the emoji as before), recipe tiles (the tile picture,
  what the recipe gives, "keeps …"), goal cards (the name has the small picture in front; also a step's "→ …"), the store's tiles,
  the bag, the square's sell and buy tiles and the gate. Energy, water, fire and coins keep their symbols (no pictures for them).
- **Agent's choices:** buildings in goal cards keep their emoji (the ticket names items; their map pictures are wide scenes and read
  badly at 30 px); the store's big header picture in the item panel stays full size; the barter lines ("1 × … for …") are text
  and keep emoji; things flying over the map still use the full pictures. All easy to change in `widgets.pic`.
- **Speed:** all 141 item pictures as icons: about 0.3 s more than loading them (≈2 ms each, once); a second time 0.4 ms for all.
- **Checked:** smoke test without errors; all 21 unit tests OK; screenshots (834×1194): kitchen recipe tiles (EN), the workshop's
  goal cards with the Hand Axe, sticks, stones and rope as pictures (EN), the store (DE), the bag (EN). New text "keeps" (DE "behält").
- **Play-test:** whether the small pictures are readable on the iPad at that size (24 px in cost rows), especially sticks vs. logs.
- **Two small bugs fixed on the way (wrap-up, in `pantry.gd`, `market.gd`, `waterroad.gd`):** the store's Herbs filter shows the translated name (`_filter_name` had no "herbs"; DE "Kräuter"); the bag, the square's bag line and the gate's cart show whole numbers (room used rounds up, room left rounds down, per-item "room N" rounds up). Screenshots: `hud-shots/wrap-*.png`.
