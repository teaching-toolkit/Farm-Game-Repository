# 02: Farm time goes through the time-question part, and the bot answers real questions

**What to build:** The new time-question part with its two jobs (next question; answered for a purpose) and its own random source. The
Time Quiz on the farm uses it; the bot draws and answers real questions through it for farm time (right, or wrong at the `--accuracy`
share). Nothing changes for the child. Retry and recent questions are remembered by permanent id; old saves are converted.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** refactor

- [ ] The part exists with `next()` and `answered(q, first_try, purpose)` returning one report; purpose `farm` works
- [ ] Questions are picked with their own seeded random source (test seed in tests and the bot)
- [ ] The Time Quiz pop-up calls the part; its own copy of the rule is gone
- [ ] The bot plays farm time through the part instead of calling `step_time()` itself
- [ ] Retry and recent questions by permanent id; a `SAVE_VERSION` step converts old saves; save keys have one owner
- [ ] Headless test: first try moves time, wrong doesn't and comes back after the next, a card review is recorded as a review, an old save keeps its retry
- [ ] Short and full golden runs identical (if not: stop, find the cause, tell the parent; do not re-record); smoke test; old saves load

**Feature:** `time-question` · **Source:** `.scratch/time-question/spec.md` and the grilling in `01-grill-and-spec.md`. Filed 2 Nov 2026. Words: `GLOSSARY.md`.
