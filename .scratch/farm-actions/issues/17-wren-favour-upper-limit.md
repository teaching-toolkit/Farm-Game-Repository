# 17: Decide: an upper limit on what Wren takes

**What to build:** Wren's favour is worth about 30 bronze, but every dish and remedy is worth at least 60, and she always takes the
one closest to 30, however dear it is. If the store holds only a cheese board (2500) or the remedies the child just made, she takes
those. Decide whether she takes only things up to a limit and asks for the bucket of water otherwise.

**Blocked by:** farm-actions/14

**Status:** done

**Milestone:** refactor

- [x] The parent decided
- [x] The data and the forest test match; full golden runs re-recorded on purpose if the behaviour changes

## 💡 Recommendation (30 Oct 2026)

**Yes, a limit of 3 × her worth (90 bronze), written in the data next to her worth.** She then takes porridge (60) or flatbread (75);
for anything dearer she asks for the bucket of water (2 ⚡, 5 💧), and if that can't be done she checks for free. She never takes a
remedy the child just made for the cough, which would feel like a punishment. The bucket will come up more often in chapter 5.

Other options: (b) 2 × (60): only porridge; the bucket almost always. (c) No limit, as now: simplest, but a dear dish can go for a
tiny favour.

## ✅ Parent's answer (30 Oct 2026)

Yes: a limit of 3 × her worth (90 bronze).

## Done (30 Oct 2026)

`forest.wren.maxWorth` = 90 in `rules/57-forest.json`; dearer dishes and remedies are not offered, so she asks for the bucket instead
(or checks for free). Forest test: 31 checks (new: only bread in the store → the bucket). Full golden runs re-recorded on purpose:
seed 1 differs from step 869, seed 2 from step 995 (both chapter 5); the story ends at 893 and 1015 answers. Short golden identical.

---

**Feature:** `farm-actions` · Found by the independent review of `farm-actions/14` (30 Oct 2026).
