# 04: Weed, pick stones and clear snow, including whole-field batches

**What to build:** Three field chores run through the module. A whole-field chore is a batch of single chores: it stops at the first patch that cannot be paid, saves once, redraws once and gives one summary message. The cost stays shown per patch.

**Blocked by:** farm-actions/03

**Status:** done

- [x] Weed, pick stones and clear snow use the module for button, effect and bot
- [x] Whole-field versions stop at the first unpayable patch, save once, redraw once, one message
- [x] The old "Too tired" copies for these chores are gone
- [x] The price-match test covers these chores: what check returns equals what perform takes and what the button shows
- [x] Winter-indoor and the skill family multiplier give the same numbers as before
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 23 Oct 2026. `clear_snow`, `weed` and `pick_stones` are chores in `rules/46-chores.json`; effects and requirements sit in `fields.gd` (`register_chores`). New in the module: an optional `amount` callable (the base energy is per unit: weeds pulled, stones picked) and `mult` in the data, and `perform_batch(chore, who, args_list)` (stops at the first unpayable patch, saves once, redraws once, one message about why it stopped). `fields.field_jobs(f, chore)` lists a field's patches for a batch. The old `weed`, `weed_field`, `pick_stones` and `clear_snow` in `fields.gd` are gone; the bot, the buttons and `crops_test` call the module.

**Found, kept as it was:** clearing snow and weeding multiply the energy by the `energy:field` modifier a second time (`ecost` already does it once). It is written as `mult` in the data so no number moves; no tool changes `energy:field` today. A decision for the parent whether to drop it (new ticket if wanted). The single "Too tired to weed / clear the snow" texts are replaced by the generic one; no success message was added for batches.

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
