# 03: Which pets help with which chores, and how a pet picks its target

**What to build:** Data: each pet has two care chores it can help with (`54-pets.json`). Code: the owners of `weed`, `pick_stones`, `pick_loose`, `fetch_water`, `clear_snow`, `muck_out` and `collect_animal` register a picker with `register_auto` (the patch with most weeds, the stoniest patch, the pen with most muck, the pen with the most ready, the nearest loose thing, the carried water that has room…). A pet is never set to a chore of a place that is not built.

**Blocked by:** `pets-automation/02`

**Status:** done

**Milestone:** prototype

- [x] Every chore in the spec's list has a picker in its owning system, each tested (returns args when there is work, `{}` when not)
- [x] `54-pets.json` lists two chores per pet; `check_data.py` checks each names a real chore with a picker
- [x] A chore job of a place that is not built is not offered
- [x] Smoke test and `check_all.sh --short` pass; old saves load; the design doc names the chores per pet

---

**Feature:** `pets-automation` · **Spec:** `../spec.md`. Filed 15 November 2026.

## Result (15 Nov 2026)

Pickers: `fields.gd` (weed, pick_stones, clear_snow, fetch_water), `loose.gd` (pick_loose), `animals.gd` (muck_out, collect_animal), `G.actions.auto_chores()`. Data: two hidden chore jobs per pet (bunny weed + pick_loose; tortoise fetch_water + clear_snow; goat weed + muck_out; pony pick_loose + fetch_water; badger pick_stones + muck_out; alpaca collect_animal + muck_out), `needs: coop` for the pen jobs; `pets.chore_jobs(pid)`; `check_data.py` checks them. `pets_test` 76 checks. Golden short identical.
