# 08: Forest trips

**What to build:** Each trip in and out of the forest is a chore through the module. Its cost (a Time Quiz question each way) and the basket's room are requirements with reason keys.

**Blocked by:** farm-actions/03

**Status:** ready-for-agent

- [ ] Forest trips use the module for button, effect and bot
- [ ] The old "Too tired" copy in the forest system is gone
- [ ] The basket's room is a requirement with its own reason key
- [ ] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [ ] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [ ] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
