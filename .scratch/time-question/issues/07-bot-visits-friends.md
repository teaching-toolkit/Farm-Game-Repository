# 07: The bot visits friends when invited

**What to build:** The bot never visits a neighbour when a friend invites it, so the golden runs and the pacing report don't cover the
visit (its cost, its question and what it changes in wellbeing). The bot accepts an invitation now and then and walks there through
the time question's `visit` purpose, like the trip and the forest. Found in the independent review of `time-question/04`.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The bot visits when invited and it can pay the walk, through the `visit` purpose
- [x] Golden runs re-recorded on purpose (the play changes); the log says from which step they differ
- [x] Bot still reaches chapter 5 within the usual range

**Feature:** `time-question` · Filed 2 Nov 2026. Words: `GLOSSARY.md`.

## Result (2 Nov 2026)

The bot visits when a friend has invited it and it has 10 energy or more (about 30–40 visits in a full run). Golden runs re-recorded:
seed 1 differs from step 247, seed 2 from step 245 (both chapter 2; the first invitation is taken). Full runs: 641 and 712 bot turns
(were 654 and 742), the story ends after 904 and 1009 answers (were 893 and 1015). Short runs: 332 and 525 turns (seed 2 was 344: with
visits it builds much more before chapter 2's pet comes home, 180 goals instead of 104, then finishes the story sooner). Pace with
random seeds unchanged within the usual spread: chapter 3 at 525/542/325 turns with visits vs 344/487/361 without (seeds 2–4); chapter 5
at 671 and 754 (seeds 11, 12).
