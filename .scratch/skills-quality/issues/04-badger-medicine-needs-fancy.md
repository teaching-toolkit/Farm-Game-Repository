# 04: The badger's "really good medicine" is reachable as Fancy, then asks for it

**What to build:** `skills-quality/01` built the grade requirement (`"minGrade": 2` on a node), but the badger's medicine is not set to Fancy because a beginner's Healer's Chest is Fancy only about 6 % of the time (expected grade about 0.0, best case about 0.9). Give medicine a fair route to Fancy (a per-recipe grade bonus in the quality data, or a larger bonus from the healing rank and the still-room; do not change the weights for every recipe), then add `"minGrade": 2` to `pet_badger`.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** later

**Size:** short

- [ ] The numbers: with the healing rank and station the child has when the badger asks (chapter 5), a Healer's Chest is Fancy about 1 time in 3 (probe with `tests/quality_test.gd`; the target is data)
- [ ] `pet_badger` has `"minGrade": 2`; the test refuses a Proper chest and accepts a Fancy one
- [ ] The bot still reaches the badger in the short and full golden runs (they change only on purpose: record on purpose and say so)
- [ ] `docs/design/making-things.md` §8.5 and the log say which numbers were set

💡 Recommendation: a `gradeBonus` per recipe family in `data/farm/rules/47-quality.json` (healing +0.4 on the expected grade) so only medicine moves.

---

**Feature:** `skills-quality` · **Source:** split from `skills-quality/01` on 16 November 2026. Filed 16 November 2026.
