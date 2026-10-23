# 03: The actions module, with one chore: fetch water

**What to build:** The first end-to-end slice of the new farm system `actions`: check and perform, the data entry for a chore (base cost, energy modifier, skill family), effect registration, the report with a reason key and child-friendly sentence, and the doer as an input. Fetch water is the first chore: its button, its "Too tired" copies, the bot and the end-of-chore follow-ups (polish wear, skill practice, save, redraw signal) go through the module.

**Blocked by:** farm-actions/02

**Status:** ready-for-agent

- [ ] The module exists with `check(chore, who, args)` and `perform(chore, who, args)`; check changes nothing
- [ ] Cost is an open dictionary of kinds; a requirement has a reason key and a sentence
- [ ] Fetch water (field and well) uses the module in the button, in the effect and in the bot; its two old "Too tired" copies are gone
- [ ] A chore works with exactly its cost in energy
- [ ] The price-match test harness exists and covers fetch water across season, tools, skill ranks, buffs
- [ ] The doer is an input and nothing in the module reads the farmer directly
- [ ] Golden runs are identical (short and, because the well is shared with late systems, the full pair once)
- [ ] New child-facing text is in German through `tools/i18n.py`
- [ ] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
