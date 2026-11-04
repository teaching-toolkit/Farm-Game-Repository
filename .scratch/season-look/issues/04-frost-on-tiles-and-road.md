# 04: Frost also sits on the top edge of the field patches and on the road

**What to build:** The frost look that works on roofs, trees and fences also appears on the top edge of the field patch tiles and on the road.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Patch tiles and the road get frost in winter through the season shader
- [x] It fades with the season (together with `nature/03`'s smooth change if built: not built yet, so it switches on and off with the season like the snow caps)
- [x] Screenshots checked; strength is the parent's check in W9

---

**Feature:** `season-look` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.22]. Filed 23 October 2026.

The parent's words:

> [#23.22] the frost visual is nice. You can put frost on the top edge of the field patch tiles as well and the road as well.

## Result (3 Nov 2026)

Built: a thin frost rim on the top edge of the field patches (soil picture and the edging layer) and on the road, through the season shader (`FarmSeasonLook.frost_material` in `map/season.gd`: the snow-cap look, thinner and a bit less white). The road now has its own layer above the ground (`ground.gd make_road_layer`, `farm_map.gd`) so it can carry the material. Depth and whiteness are data: `season.frostDepth` 0.06 and `season.frostStrength` 0.8 in `rules/65-feel.json`. It switches with the season like the snow caps (winter on, else off); the smooth change of `nature/03` (N7) is not built, so there is no fade yet - the frost will fade with it when it is.

Checked: winter screenshots (`season-shots/04-winter*.png`, `final-winter.png`): frost on the patch tops and the road, none in other seasons. Goldens identical.

Parent to check in W9: the strength (`frostStrength`) and depth.
