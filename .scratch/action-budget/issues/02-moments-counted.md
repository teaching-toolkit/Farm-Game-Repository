# 02: Chores take moments, and a step holds only so many

**What to build:** Every chore has its moments in the chores file; the actions module counts them, refuses a chore when the step has none left, and a new step starts fresh. Nothing is shown yet except that chores are refused with a reason.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Light, middle and heavy chores have 1, 2 and 4 moments in the chores file; recipes take theirs from their size
- [x] `check` gives "no time left" as a reason; `perform` adds the moments; a step sets them to 0; one save key
- [x] The chores test covers every chore before and after the moments run out
- [x] The test bot answers the Time Quiz when out of moments; its pacing report has the moments per step as a histogram per chapter
- [x] The golden runs are recorded anew once; the chapter hours before and after are in a `## Result` note
- [x] `GLOSSARY.md` has *moment*
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; `docs/design/time-quiz.md` and `energy-and-wellbeing.md` describe it

---

**Feature:** `action-budget` · **Spec:** `../spec.md`. Filed 14 November 2026.

## Result (15 Nov 2026)

**Built** (Sonnet agent, then tuned and checked by the orchestrator): `data/farm/rules/46-chores.json` has `"moments"` per chore (0: walks, looking, visits; 1: water, weed, stones, loose things, plant, harvest, collect; 2: cut a tree, forest find/pick, wren water; 4: muck out, forest dig, throw a party) and a top-level `"moments": {"perStep": 18, "chapterExtra": [0, 3, 8, 14, 14, 14], "bands": …}`: **a step holds 18 / 21 / 26 / 32 moments in chapters 1 / 2 / 3 / 4 and later** (the extra comes from the chapter, `G.chapter()`). Recipes take their moments from their own energy with the bands (1 → 1, up to 3 → 2, more → 4). `G.actions` counts them (`moments_of`, `moments_used`, `moments_left`, `moments_per_step`, `out_of_time`, `time_gate`), refuses with the reason key `time`, the save key `moments` (0 in old saves) is reset by every step. Tests that do many chores in one step reset it where they refill energy (`forest_test`, `crowding_test`).

**Tuning** (test bot, 2 seeds, chapters 1–5; the bot uses every moment, so it is a worst case: a child will run out less often):

| | seed 1 steps / ran out | seed 2 steps / ran out | hours vs the run without moments (seed 1 / seed 2) |
|---|---|---|---|
| chapter 1 | 185 / 23 % | 196 / 26 % | −3 % / +25 % |
| chapter 2 | 216 / 25 % | 220 / 29 % | +72 % / +9 % |
| chapter 3 | 350 / 24 % | 449 / 26 % | −10 % / +47 % |
| chapter 4 | 463 / 28 % | 318 / 30 % | +70 % / +8 % |
| chapter 5 | 206 / 28 % | 120 / 23 % | +72 % / −31 % |
| **all** | 27.7 h | 25.1 h | **+30 % / +15 %** |

A flat 24 was too loose in chapter 1 (9–10 % ran out), a flat 18 too tight in chapters 2–3 (hours +70–90 %), hence the per-chapter extras. The per-chapter hours swing with the seed (the bot's choices change as soon as time is short), so "within 10 %" per chapter cannot be proven by the bot; the totals are +15 to +30 %. Fairness is for the parent's play-test (`action-budget/05`).

**Golden runs** recorded anew on purpose (short and full, both seeds), the saves fixture too (new key `moments`). Proof that nothing else changed: with `perStep` 100000 the short golden run said "same as the golden run" for both seeds before the numbers were set.
