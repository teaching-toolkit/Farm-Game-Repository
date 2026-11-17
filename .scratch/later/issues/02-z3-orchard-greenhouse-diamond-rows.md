# 02: Z3: Orchard and greenhouse sheets use diamond rows like the fields

**What to build:** The orchard and the greenhouse sheets show their patches in diamond rows like the fields instead of a square grid.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** later

- [x] Both sheets use the diamond layout
- [x] Smoke test and screenshots checked

## Progress

- Layout is one shared function now: `IsoField.grid_size/cell_center/grid_cols` (static, `game/farm/map/iso_field.gd`); the field calls it with 9 patches, `game/farm/ui/field_view.gd` with the area's patch count (rows of ceil(√n): 3 spots = 2×2 with one empty, 4 beds = 2×2, 5 = 3+2, 6 = 3×2). The look of one patch is also one function (`IsoField.patch_spec`), and the sheet draws with the field's own `IsoField.IsoPatch` (same soil heap, plants, glow and sway, a tap only on the diamond; a drag still scrolls the sheet).
- 💡 Decisions: no words on the patches any more (the old square grid wrote "tap to plant", "⏳ 3 / 5", "✅ Ready!"; the diamonds have no room for text and the map has none; a tap still opens the patch's own sheet with the numbers). Diamond width 170 in a sheet (144 on the map). `field_view.gd` keeps its name and now serves only the orchard and the greenhouse (its old field branch and overgrown look are gone: those patches are always usable).
- Checked: `ui_smoke` (`later/02` line: orchard 5 spots and greenhouse 4 beds on diamond rows, a tap on the last patch opens it, a planted tree shows; the field uses the shared layout), the short golden is identical, screenshots of both sheets looked at (`--load=res://tests/fixtures/ch3-seed1.json --unlock=orchard,greenhouse --spot=orchard|greenhouse --sheetscroll=9999 --shotframes=120`). The dev flag `--unlock=` now also grows the areas (`ensure_areas`) so a greenhouse screenshot shows its beds.

---

**Id:** Z3 · **Feature:** `later` · **Moved from** `archive/todo-2026-10.md` §17 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **Z3. Orchard and greenhouse** still use a square patch grid inside their sheets; give them diamond rows like the fields. (Was Later 3.)
