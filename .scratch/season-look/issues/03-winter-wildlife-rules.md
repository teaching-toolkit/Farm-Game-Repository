# 03: No butterflies, slugs or other creatures that would not be out in winter

**What to build:** Each creature on the map has the seasons it can be seen in. Butterflies, slugs and similar do not appear in winter.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Every critter has a `seasons` list in data
- [x] A winter screenshot shows none that do not belong
- [x] The data checker warns about a critter without seasons

---

**Feature:** `season-look` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.18]. Filed 23 October 2026.

The parent's words:

> [#23.18] no butterflies or animals in winter that don't show in winter (e.g. slugs, etc.)

## Result (3 Nov 2026)

Built: every creature has a `seasons` list in `rules/66-season-look.json` "critters" (animals, pets, farm cat, the four pests, butterflies, fireflies). `FarmSeasonLook.critter_out` (`map/season.gd`) is asked where they are drawn: `main.gd` (butterflies, fireflies, farm cat), `mapview.gd critter_spec` (animals, pets), `iso_field.gd` (pests: only kinds out in this season come, and a slug or caterpillar already on the field turns into another kind at the season change). Out of season means not drawn; the rules go on (pests still eat, animals still give). In winter: no butterflies, fireflies, bees, slugs or caterpillars (the birds, rabbits and voles stay). `tools/check_data.py` warns about an animal, pet, pest or map creature without a `seasons` list or with a wrong season name.

Agent's choices: fireflies stay in spring, summer and autumn (so the perk does not seem lost); the tortoise stays in winter because Helpers never leave (a real tortoise hibernates) - see the question below.

Checked: winter screenshot (`season-shots/final-winter.png`) has no butterflies; data check 0 errors; goldens identical.

## Question for the parent

Should the pet tortoise sleep in winter (real, but it would vanish from the map for a season)? Recommendation: keep it out all year, it is a Helper and a vanishing Helper reads as lost.
