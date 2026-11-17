# 03: N7: The season look changes smoothly instead of jumping

**What to build:** When a season ends, the map's colours and snow caps fade into the next season instead of jumping. The shader and the muted winter, golden autumn and snow caps are built. Bare winter trees need new pictures and are part of R4.

**Blocked by:** None (can start immediately)

**Status:** needs-parent

**Milestone:** later

- [x] The shader blends from one season to the next over a short time
- [x] The look checks (screenshots) at the start and end of each season
- [ ] The strength is the parent's check in W9

---

## Progress

Built (agent): `G.seasons.blend()` in `game/farm/systems/seasons.gd` gives `{from, to, t}`; t is a smoothstep of the question number in the season over the first `season.fadeQuestions` (10, `rules/65-feel.json`) questions, 1 from then on and in the first spring. It comes from `G.S["step"]` alone: no clock, no new save key. `FarmSeasonLook.share(b, name)` and `mix(b, table)` (`game/farm/map/season.gd`) turn it into the weight of a season and a blended colour; `ground.set_season(G.seasons.blend(), …)` (called at every question from `main.gd`) feeds the shader's `winter` and `autumn` strengths, and also fades the grass tint (`GRASS_TINT`), the winter white on the grass and the road, and the page colour behind the map (`UI.SEASON_BG`), which used to jump too. The map redraws at each step of the fade (`map.blend`).
Check: `tests/nature_test.gd` `_seasons_fade` (t is 0 at a season's first question, rises, is 1 by question 10 and in the middle, no new save key, winter and autumn weights follow); ui_smoke has no FAIL or SCRIPT ERROR; short golden identical. Screenshots (`--season=winter:0|5|15`, `--timestep=120|135`, `--season=autumn:0`, `--season=summer:0`): autumn to winter starts golden and ends muted with caps; winter to spring starts with caps and frost and ends in full spring; the middle shot is a half way look.
💡 Decisions (easy to undo): fade length 10 questions, the same as the flowers' `changeQuestions`, in `65-feel.json` (the parent's W9 knob); the first spring (new game) does not fade; the flowers keep their own `changeQuestions`.
Left for the parent / pictures: bare winter trees need new pictures (`pictures/` R4, not part of this); the strength of the look and of the fade is the parent's check in W9 (box 3 stays open).

---

**Id:** N7 · **Feature:** `nature` · **Moved from** `archive/todo-2026-10.md` §10 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **N7. Seasons you can see** ✅ (R4): trees and grass look visibly different each season; winter is not just snow but **muted colours**;
  a cheap way to put **snow on every roof** without a new picture for each building. ✅ (R5) **One shader over all map pictures**:
  snow caps on every top edge (roofs, trees, fences), muted colours in winter, green turned golden in autumn; new pictures only where a
  shader can't fake it (bare deciduous trees in winter, R4).
  **Built 13 Oct 2026 (0.10.0):** `kits/ui/season.gdshader` (generic: `winter`, `autumn`, `snow`, `snow_depth` as a part of the picture's height; snow where the picture is see-through just above, muted and cooler colours, greens turn golden by hue) and `game/farm/map/season.gd` (`FarmSeasonLook`: two shared materials; `apply_tree` puts them on every picture of the map except words, panels, buttons and the farmer; `ground.set_season` sets the season). Soil and plants (`meta "flat"`) get the muted winter but no caps and no golden shift. Not yet: smooth change from one season to the next (it jumps), the ground itself stays as it was (snow on the ground comes with N6), bare trees (needs pictures), the farmer and animals are unchanged. Check the strength on the iPad (W9).
