# 13: Delete the old duplicated checks

**What to build:** The contract step: no caller multiplies a chore's modifier by hand and no system keeps its own "Too tired" check. The price-match test covers every chore. This is the end of the refactor; the final full golden run for both seeds happens here.

**Blocked by:** farm-actions/04, farm-actions/05, farm-actions/06, farm-actions/07, farm-actions/08, farm-actions/09, farm-actions/10, farm-actions/12

**Status:** ready-for-agent

- [ ] Search finds no remaining manual energy multiplier and no remaining "Too tired" copy
- [ ] Every chore is in the price-match test
- [ ] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [ ] The design document and the farm-game session skill describe the actions module
- [ ] A row in `PROJECT-LOG.md`; `GLOSSARY.md` still matches the code words
- [ ] The spec's "late systems" list was checked and each entry is covered by the full run or a hand test noted here
- [ ] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
