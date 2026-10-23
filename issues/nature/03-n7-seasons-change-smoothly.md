# 03: N7: The season look changes smoothly instead of jumping

**What to build:** When a season ends, the map's colours and snow caps fade into the next season instead of jumping. The shader and the muted winter, golden autumn and snow caps are built. Bare winter trees need new pictures and are part of R4.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] The shader blends from one season to the next over a short time
- [ ] The look checks (screenshots) at the start and end of each season
- [ ] The strength is the parent's check in W9

---

**Id:** N7 · **Feature:** `nature` · **Moved from** `TODO.md` §10 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **N7. Seasons you can see** ✅ (R4): trees and grass look visibly different each season; winter is not just snow but **muted colours**;
  a cheap way to put **snow on every roof** without a new picture for each building. ✅ (R5) **One shader over all map pictures**:
  snow caps on every top edge (roofs, trees, fences), muted colours in winter, green turned golden in autumn; new pictures only where a
  shader can't fake it (bare deciduous trees in winter, R4).
  **Built 13 Oct 2026 (0.10.0):** `kits/ui/season.gdshader` (generic: `winter`, `autumn`, `snow`, `snow_depth` as a part of the picture's height; snow where the picture is see-through just above, muted and cooler colours, greens turn golden by hue) and `game/farm/map/season.gd` (`FarmSeasonLook`: two shared materials; `apply_tree` puts them on every picture of the map except words, panels, buttons and the farmer; `ground.set_season` sets the season). Soil and plants (`meta "flat"`) get the muted winter but no caps and no golden shift. Not yet: smooth change from one season to the next (it jumps), the ground itself stays as it was (snow on the ground comes with N6), bare trees (needs pictures), the farmer and animals are unchanged. Check the strength on the iPad (W9).
