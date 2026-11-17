# 04: Watered soil is dark and dries pale over the next steps

**What to build:** A patch that has just been watered shows dark soil, and the soil gets lighter step by step as the plants grow, until it is the soil you know. The child sees from the ground, without a symbol, which patch was done lately. No new pictures: the existing soil picture is tinted.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

**Size:** quick

- [x] One curve in the data (`rules/10-farming.json` `wetShade`: growth steps since watering → how light the soil is, 1 = dry) says how dark the soil is and how many steps it takes to dry; the rule that reads it lives in the fields system (`Fields.soil_shade`), the field and the orchard/greenhouse sheets only draw the number
- [x] Nothing new is saved: the soil is wet when the patch was planted (its water is spent then) and when it rains; it dries with the growth the patch already counts
- [x] A test checks that right after watering the soil is dark, that it rises and never falls again to the dry value within the steps the data names, and that ripe, bare, regrowing and flowering patches are dry
- [x] A screenshot before and after watering shows the difference; the short golden run is identical (draw only)
- [x] The `docs/design/farming.md` section for patches says what the soil shows

## Finding (16 Nov 2026): the game did not do it

The patch has no wetness of its own: the water is carried in the farmer's bucket and spent when the crop is planted (`fields.gd` `_plant_effect`; `_auto_water` says the same). The soil picture was the same for every worked patch. What exists, and is read here: the patch's `growth` (steps since planting, so also since its water) and `G.S["rain"]` (rain waters the fields until the next question).

## Progress

Built 16 Nov 2026 (the parent was away and said "take your order"; ★ kept). The curve is `[[0, 0.55], [1, 0.72], [2, 0.88], [3, 1.0]]`: dark at planting, dry after 3 growth steps (the growth counter is about one per question; in winter it is a quarter of that, so the soil stays damp longer, which is right). Rain makes every worked patch of the field and the orchard dark for that question (not the greenhouse; in winter it snows). A ripe patch, a regrowing one (no new water) and one left to flower are dry. `soil_shade` is in `systems/fields.gd`; `IsoField.patch_spec` carries it as `shade` and `IsoPatch.show_state` multiplies it into the soil picture's colour. Two dev flags for screenshots: `--wet` (potatoes planted 0, 1, 2 and 3 steps ago) and `--rain`. 💡 If the dark looks too strong or too weak, change only the numbers in the curve.

---

**Feature:** `visible-work` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.7]. Filed 16 November 2026 from `visible-work/01` idea 7.

The parent's words:

> [#14.7] I have noticed that stuff that changes visually when the player performs work like clearing the field from weeds, and of course, crops is inherently satisfying. Please check the game for easy wins on adding more things that could be made visually visible.
