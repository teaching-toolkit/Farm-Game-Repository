# 04: The walks go through named purposes

**What to build:** The walk to the village, a visit, and the walks into and out of the forest go through the time-question part as named
purposes (`to_village`, `visit`, `into_forest`, `out_of_forest`; `home_from_village` named for `money-market/04`). The four copies
of the rule in the interface become one question pop-up. The bot's walks call the same purposes. Nothing changes for the child.

**Blocked by:** time-question/02

**Status:** done

**Milestone:** refactor

- [x] Each purpose's follow-up is in the rules (trip arrives, visit happens and returns its scene, forest enter or leave)
- [x] One question pop-up in the interface; the trip, visit and walk copies are gone
- [x] The bot calls the purposes for the market trip and the forest instead of `step_time()` and the follow-ups
- [x] Headless test: a right first answer runs each purpose's follow-up; a wrong one doesn't and the walk waits
- [x] Short and full golden runs identical (if not: stop and find the cause); smoke test; `docs/design/` updated for the time question

**Feature:** `time-question` · **Source:** `.scratch/time-question/spec.md` and the grilling in `01-grill-and-spec.md`. Filed 2 Nov 2026. Words: `GLOSSARY.md`.
