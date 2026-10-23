# 04: Weed, pick stones and clear snow, including whole-field batches

**What to build:** Three field chores run through the module. A whole-field chore is a batch of single chores: it stops at the first patch that cannot be paid, saves once, redraws once and gives one summary message. The cost stays shown per patch.

**Blocked by:** farm-actions/03

**Status:** ready-for-agent

- [ ] Weed, pick stones and clear snow use the module for button, effect and bot
- [ ] Whole-field versions stop at the first unpayable patch, save once, redraw once, one message
- [ ] The old "Too tired" copies for these chores are gone
- [ ] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [ ] Winter-indoor and the skill family multiplier give the same numbers as before
- [ ] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
