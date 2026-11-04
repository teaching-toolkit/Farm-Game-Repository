# 03: By default a beginner's first item is Lumpy, not Proper

**What to build:** The first wicker basket you make should be lumpy (wonky), not proper, and the same holds for all items and goods unless there is a reason to deviate. Today a beginner's expected grade is Proper (expected value 1.0). This lowers every beginner's grade, so Lumpy's 60 % price, the pace and the golden runs change. It clashes with the Y1 baseline decided in R2, so the parent should confirm the scope.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The parent has confirmed the scope (all made things, or crafts only; crops too?)
- [x] The baseline in the quality rules is lowered; ranks, tools and good inputs lift the grade as before
- [x] The recipe tile still shows what to expect
- [x] Pace re-checked with the bot (goldens re-recorded on purpose); `quality_test` updated; German

## ✅ Parent's answer (30 Oct 2026)

Yes: everything made at a station (crafts, tools, cooking, baking) starts Lumpy for a beginner; ranks, tools and good inputs lift it as now. Crops and animal products stay Proper.

---

**Feature:** `skills-quality` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.29]. Filed 23 October 2026.

The parent's words:

> [#23.29] The first wicker basket you make should be lumpy/wonky not proper, this should apply to all items and goods by default unless there's a reason to deviate from this.

## Result (3 Nov 2026)

- **Built:** `data/farm/rules/47-quality.json` has a new number `madeStart` (0 = Lumpy, with a note). `quality.gd` reads it through `made_start()`, and both `recipe_expect()` (the "Expect:" line on the recipe tile) and `roll_recipe()` (the grade of a batch) start from it instead of `default` (Proper). Crops, animal products and things bought or given keep `default` (Proper), as the parent answered. Stations (campfire -0.1, oven +0.1 ...), skill ranks (+0.05 each) and the grades of the inputs lift the expected grade as before. A beginner's batch is Lumpy about 93 % of the time (E = 0 gives Lumpy 93 %, Proper 7 % after the 7 % chance of one grade more). No German text changed; the recipe tile shows the lower grade by itself.
- **Agent's choices:** one number for every station (not per recipe or per family), so "unless there is a reason to deviate" can later be a per-recipe override; the old Proper-based design text in `docs/design/making-things.md` now says Lumpy 0 / Proper 1 / Fancy 2.
- **Checked:** `quality_test` now checks that a beginner's recipe has E below 0.5 and Lumpy above 80 %, and that `made_start()` is 0 while `default_grade()` stays 1; all unit tests pass. Short golden runs differ on purpose and were re-recorded: seed 1 reached chapter 3 after 432 bot steps (before: 437), coins at that point 854 (before: 1207); seed 2 after 500 steps (before: 728), coins 1615 (before: 7573). With `madeStart` set to 1 (the old rule) the seed 1 run is identical to the old golden (experiment, then reverted); the earlier helper confirmed the same for seed 2.
- **Full golden runs (ch6) are not re-recorded:** they are outdated by this ticket and need `bash tests/golden.sh --record` (the lead does this after merging). The pace change there is unknown.
- **Play-test:** the first wicker basket and first bread should come out Lumpy (60 % price); check that the early game (first deliveries, Y1 "Proper" deliveries from skills-quality/01) does not feel too slow now, and that the Lumpy-lifting path (oven, rank, Fancy flour) is visible to the child. The bot's pace change is odd for seed 2 (faster, with far fewer coins at the end): worth a look at how it gets there.
