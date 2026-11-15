# 02: A pet can do a chore: the module

**What to build:** In `54-pets.json` a job can have `"kind": "chore"` with `"chore": "<id>"`; `pets.gd` runs it in `_work` through `G.actions.check` and `perform` with the pet as the doer, so the farmer pays the effective energy (and water or items), no moments are used, and no skill practice or tool wear happens. When `check` is not ok the rule waits (`why: "tired"` or the unmet key). Nothing the child sees changes yet except the job list data.

**Blocked by:** `action-budget/02` (done), `farm-actions/13` (done)

**Status:** done

**Milestone:** prototype

- [x] A chore job runs once per question through `G.actions`; the farmer's energy is spent at the effective cost, moments stay as they are
- [x] A pet's chore gives no skill practice and wears no tool (test: rank and wear before and after)
- [x] With too little energy or an unmet requirement the rule waits, spends nothing and says why
- [x] `G.actions.register_auto(chore, picker)` exists: the picker returns the chore's args or `{}`; a chore with no picker is not offered
- [x] The pets' test covers a chore job (runs, waits tired, waits with nothing to do); `GLOSSARY.md` keeps *automated chore*; smoke test and `check_all.sh --short` pass; old saves load; `docs/design/progression.md` §10.3 describes it

---

**Feature:** `pets-automation` · **Spec:** `../spec.md`. Filed 15 November 2026.

## Result (15 Nov 2026)

`actions.gd`: `run`, `register_auto`, `auto_args`, `pet_doer`; `wear`/`practice` only for the farmer (the weed's hoe wear moved from `fields.gd` into `46-chores.json`). `pets.gd`: the `chore` kind in `_work` (`why` *tired* when the farmer's energy is missing), `hidden` jobs left out of `jobs_of`. One hidden test job `helps_weed` on the bunny. `tests/pets_test.gd` 48 checks. Golden short identical.
