# Spec: the Time Quiz question, one rules part that moves farm time

**Status:** ready-for-agent

Words are in `GLOSSARY.md` (Time Quiz, question as a unit of time, pack, card, walk, purpose). Background: the architecture review of
22 October 2026 (Part B, candidate 2) and the grilling in `.scratch/time-question/issues/01-grill-and-spec.md` (three rounds, parent's
answers of 31 Oct and 2 Nov 2026). **Step 1 is a refactor: the golden runs must stay identical.** Step 2 changes what the child sees.

## Problem Statement

The game's central rule, *only a right first answer moves farm time; after a wrong one the question comes back after the next one; a
card review is recorded as a review*, lives in the interface, written out four times: the Time Quiz, the walk to the village, a visit
and the forest walk. The copies have drifted: only the Time Quiz tells the child about the scarecrow, pests and the rainbow. The bot
cannot use the rule, so it only moves time and never answers a question: no check covers the first-try rule, the retry or the review
recording, and a bug there would pass every test. Picking a question uses the farm's one random source, so letting the bot draw real
questions would shift every later roll. The parent will later paste in their own packs (`parent-controls/02`); today the retry and the
recent-question list remember questions by their position in the list, which pasting would break.

## Solution

One rules part, the time question, with two jobs: **give the next Time Quiz question**, and **a question was answered (first try or
not) for a purpose**. It takes any question by its permanent id and pack and never asks where the pack came from; packs, built in or
pasted, come in through one door. Card reviews stay with the knowledge cards and are drawn in from there. Questions are picked with
their own random source. The interface keeps one question pop-up; the four places and the bot all call the same two jobs, so the
golden run finally covers the rule. Afterwards, two visible changes: walks close straight into the place, and what happened on the
farm shows on the farm.

## User Stories

1. As the child, I want a right first answer to move the farm on exactly as now, so that nothing I know changes in step 1.
2. As the child, I want a question I got wrong to come back after the next one, wherever I met it (farm, village walk, visit, forest).
3. As the child, I want a walk to the village, into the forest or out of it to open the place itself after a right first answer, without
   an extra sentence or button (step 2; the background shows where I am).
4. As the child, I want a visit to keep its little scene with the neighbour (it is the visit's content, not an arrival message).
5. As the child, I want rain, the rainbow, the scarecrow and pests shown on the farm when the pop-up closes, picture first with a short
   line under it, the same after every kind of question (step 2).
6. As the child, I want the question pop-up to show only right or wrong and time moving (⏳ and the question number), so it stays short.
7. As the parent, I want my own pasted packs to work exactly like the built-in ones, each question under its permanent id (ADR-0007).
8. As the parent, I want the bot to answer real questions through the real rule, so the checks prove the rule works.
9. As the parent, I want the move to change nothing in play (golden runs identical), and the visible changes as separate tickets I can
   play-test on their own.
10. As a session that adds a new walk later (the walk home from the village, `money-market/04`), I want it to be one more named purpose.

## Implementation Decisions

- **Home.** A new farm system, the time question (`G.timeq` or similar), in the farm layer's systems folder. The knowledge system keeps
  the cards, their reviews and which are due; the time question asks it for a due review when the review share says so.
- **Interface: two jobs.** `next()` returns the next question (a review, a retry, or a pack question). `answered(q, first_try, purpose)`
  records the answer (the learning record for pack questions, the card review for reviews), applies the first-try rule, and returns one
  report: whether time moved, the step's info (rain, rain stopped, pests removed, share eaten …) and what the purpose's follow-up
  returned (a visit's scene). The interface draws from the report only.
- **Purposes are named in the rules**, each with its follow-up: `farm` (nothing more), `to_village` (the trip arrives), `home_from_village`
  (reserved for `money-market/04`), `visit` (the visit happens, returns its scene), `into_forest`, `out_of_forest` (the forest chores
  `forest_enter` / `forest_leave`). A walk's cost is still paid before the question, as now; nothing about costs changes.
- **Wrong first answer:** time stays, nothing of the purpose happens, the question is set to come back after the next one, as now. The
  child is never stuck: a walk waits with its "Answer the question" button.
- **Own random source.** Picking questions (review or pack, which review, which question, the order of the answers) uses its own seeded
  random source, seeded from the test seed in tests and the bot, random otherwise. Not saved (the farm's random source is not saved
  either). The farm's rolls then no longer depend on which question came up.
- **One door for packs.** Built-in packs load through one function that later pasted packs (`parent-controls/02`) will use too. The part
  never asks a pack's source.
- **Permanent ids.** The retry and the recent-question list remember a question by its permanent id (pack questions) or card and
  question index (reviews), not by its position in the list. Old saves: one `SAVE_VERSION` step converts the stored positions to ids;
  the save keys' owner moves from the knowledge system to the time question (`saves_test` checks one owner per key).
- **The bot** calls `next()` and `answered()` for farm time and for every walk, answering right, or wrong at the share `--accuracy` sets.
  It no longer calls `step_time()` and the follow-ups itself.
- **Step 2, the interface only:** walks close the pop-up and open the place; the farm news moves from the pop-up to the playback, with a
  short line under each animation; the pop-up shows right or wrong and ⏳ with the question number.

## Testing Decisions

- **One seam: the two jobs.** Tests call `next()` and `answered()` without the screen, or the bot does. They check what the child or the
  bot can see: time moved or not, the purpose's follow-up happened or not, the question came back after the next one, the learning
  record or card review changed, the report.
- **New headless test:** a right first answer moves time and runs the follow-up, for every purpose; a wrong one doesn't and comes back
  after the next; a card review is recorded as a review; a pack added through the door works like a built-in one; an old save with
  positions loads and keeps its retry.
- **Golden runs.** Step 1 must keep the short and full golden runs identical (the bot now draws real questions from their own random
  source). **If they change, stop and find the cause; do not re-record.** Tell the parent what was found.
- **The screens** get no new tests beyond the smoke test; step 2 gets screenshots (iPad size, EN and DE) and the parent's play-test.
- **Every game change** still needs what `.claude/skills/farm-game-check/SKILL.md` asks for: German, the smoke test, the bot, old saves.

## Out of Scope

- Any change to a number, a rule or a cost (step 1); which packs are active and how the parent pastes them (`parent-controls/02`).
- The walk home from the village itself (`money-market/04`; it only gets its purpose name here).
- The painted backgrounds that show where the farmer is (pictures track); the action budget (`action-budget/01`).
- Rest sums and the curriculum (the learning kit is not touched).

## Further Notes

- Facts found in the code (30 Oct 2026): `ui/timequiz.gd` has four near-copies (`_time_answered`, `_trip_answered`, `_visit_answered`,
  `_walk_answered`); `tests/bot.gd` calls `step_time()` then `trip.arrive()` or the forest chores; `knowledge.gd` holds
  `next_time_question`, `retry_after_next`, `time_result`, `record_card_answer`; `retry_q` is not in any `save_defaults()` (read with a
  default), `recent_q` is in the knowledge system's.
- The review's sketch (Part B §2, "Before / after") is the shape; the names above may change in the build.
