# 01: Autumn: real leaf pictures drift down and flip from side to side as they fall

**What to build:** In autumn, leaves drift and fall across the farm, each flipping side to side as it goes. They use pictures of actual autumn leaves (the picture list is `pictures/12`); until those exist, a placeholder leaf is used.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Leaves fall only in autumn and stop smoothly at the season's end
- [x] Each leaf flips side to side while drifting
- [x] Uses leaf pictures when they exist, a placeholder before
- [x] No slowdown on the iPad; the amount is data (the amount is data; iPad speed not measured here: play-test)

---

**Feature:** `season-look` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.1]. Filed 23 October 2026.

The parent's words:

> [#23.1] we need pictures of actual fall leaves and have them flip side to side as they drift and fall.

## Result (3 Nov 2026)

Built: in autumn about 20 leaves drift down over the whole farm map and flip from side to side (they squash sideways like a turning leaf), sway with a little wind, and stop when autumn ends (the ones in the air land and fade). Code: the map's effects layer (`game/farm/fx.gd`, `MapFx`, fed by `farm_map.gd`); numbers (count, size, fall speed, wind, flips per second, picture names) are data in `rules/66-season-look.json` "leaves". Agent's choice: the leaf pictures `assets/deco/leaf_1 ... leaf_4` do not exist yet (`pictures/12`), so a drawn stand-in leaf (pointed, with a stem, four autumn colours) is used; the real pictures are picked up by name as soon as the files are there, no code change.

Checked: `--season=autumn` screenshot (`season-shots/final-autumn.png`: leaves in the air and on the ground, the farm still readable); smoke test and all unit tests green; goldens (short) identical. Not measured on a real iPad: 20 small drawn leaves per frame is modest; **play-test on the iPad** and lower `count` if it stutters.

Parent to check: how the flip looks with real leaf pictures (`pictures/12` still open).
