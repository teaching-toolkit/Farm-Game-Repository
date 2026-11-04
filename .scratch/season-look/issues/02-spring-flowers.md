# 02: Spring has far more flowers, so it looks different from summer

**What to build:** In spring the meadow and farm edges are full of flowers; summer has fewer. A glance tells the two seasons apart.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Many more flowers appear in spring than in summer
- [x] They come and go with the season, not at once
- [x] Uses existing flower pictures; more are listed in `pictures/12`
- [x] Screenshots of spring and summer side by side checked

---

**Feature:** `season-look` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.8]. Filed 23 October 2026.

The parent's words:

> [#23.8] there should be way more flowers in spring to differentiate it from summer

## Result (3 Nov 2026)

Built: flowers in the grass, drawn by the ground (`ground.gd _draw_flowers`), count per season in `rules/66-season-look.json` "flowers": spring 240, summer 24, autumn 0, winter 0. Over the first 10 questions of a season the number moves from the last season's to this season's, one flower at a time (flower i always stands in the same place, so they come and go rather than all at once). Not drawn on fields, buildings, the road or the forest. Uses four existing grass pictures that have flowers (`grass_2/3/4/6`); the new spring flower pictures listed in `pictures/12` do not exist yet. `FarmSeasonLook.flower_count` in `map/season.gd`.

Checked: screenshots spring (question 3) and summer (`season-shots/final-spring.png`, `02-spring-vs-summer.png`): spring clearly fuller. Goldens identical (look only). Note: the ground picture itself still has a few painted flowers in every season, so winter and autumn are not completely flower-free.

Parent to check: whether 240 is "way more" enough (one number in the data).
