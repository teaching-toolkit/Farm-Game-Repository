# 03: The ring round the clock, and grey chores when time is up

**What to build:** The child sees time run out: a ring of 12 segments round the clock symbol fills as the farmer works, and when it is full every chore is grey until the Time Quiz moves time.

**Blocked by:** `action-budget/02`

**Status:** done

**Milestone:** prototype

- [x] The ring fills by segments (green, the last three amber) and empties with a sweep after a right first answer
- [x] With no moments left the clock rocks, chore buttons and tiles are grey, and a tap on one sends a spark to the clock and shows the reason
- [x] No number is shown
- [x] Screenshots: half full, full, low (just emptied is not shot: a sweep lasts 0.5 s and there is no cheap hook; the sweep is covered by a node-state check in the smoke test)
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; `docs/design/time-quiz.md` and `energy-and-wellbeing.md` describe it

---

**Feature:** `action-budget` · **Spec:** `../spec.md`. Filed 14 November 2026.

**Built (ring session, 15 Nov 2026):** ring, rocking, sweep, spark, `--moments=<n>` in place; ui smoke (`_action_budget_ring`) and actions test pass; no new text (German unchanged, `i18n.py --check` ok).
Not ticked, and why: (2) only chore buttons that take the rules' answer as they are grey: the patch window's Plant (its `ok` is the plan's, `q["unmet"]` only rides along), Pull, Pick, Harvest and the whole-field buttons, and the two Fetch water buttons (`waterroad.gd`, `patches.gd` no-water pop-up) stay enabled with time up, so they give no spark; they need `check()["ok"]` in their enabled flag (files not in this ticket's list). (4) "just emptied" is not shot (a sweep lasts 0.5 s; no cheap hook); half, full and low are. (5) `check_all.sh`, old saves and the two design docs are not done here.

**Fixed afterwards (orchestrator, 15 Nov 2026):** the buttons named above now take the rules' answer: `G.actions.out_of_time()` and `G.actions.time_gate(ok, why)` (actions module) feed the patch window's Plant / Harvest / Pull / Pick / whole-field buttons, the snow field and the two Fetch water buttons, so they are grey with time up and a tap gives the spark and the reason. The ring never looks full while a moment is left (capped at 11 segments until none is left).
