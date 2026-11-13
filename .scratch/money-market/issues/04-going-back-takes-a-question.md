# 04: Going back to the farm also takes one time unit

**What to build:** The walk home from the village costs one time unit, as the walk there does: one Time Quiz question has to be answered. (Assumption: "one time unit" means one question, as on the way there.)

**Blocked by:** time-question/04 (the walk home is the purpose `home_from_village` there)

**Status:** done

**Milestone:** prototype

- [x] Back home opens one Time Quiz question that moves time when answered right on the first try
- [x] The trip bot answers it and the pace is re-checked
- [x] The golden runs are re-recorded on purpose (the short and the full pair; not recorded by the session that built this: see `## Progress`)
- [x] If `time-question` is built first, the walk uses its one function

---

**Feature:** `money-market` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.24]. Filed 23 October 2026.

The parent's words:

> [#23.24] going back to the farm should also take one time unit

## What was built (9 Nov 2026)

- **The walk home is a walk.** `🏠 Back home` on the village square (both buttons) opens one Time Quiz question, "🏠 On the way home", through the time question's purpose `home_from_village` (`G.timeq.answered`; its follow-up is `G.trip.leave()`, so the bag empties and the farmer is home only after a right first answer). A wrong first answer keeps the farmer on the square and shows *Next question* (the question comes back after the next one, as on every walk). It costs the question and no energy. A right answer shows the green answer for a moment (`playback.walkRight`), then the pop-up closes and the square closes into the farm. A pop-up closed without an answer (✖) leaves the farmer on the square with everything as it was (so `money-market/05` still holds: closing a window never sends him home, only an answered Back home does).
- **The bot** answers the walk home through `_answer_until_moved("home_from_village")` instead of calling `leave()`.
- **Tests, written first:** `tests/timeq_test.gd` (home_from_village: a wrong first answer leaves time and the farmer on the square with what was bought; a right one moves time one step, empties the bag and sends him home, and costs no energy; it failed before the follow-up existed). `tests/ui_smoke.gd`, the "square:" line, adapted: Back home now opens the question, a closed pop-up keeps the square, a wrong first try keeps it, a right first answer goes home (the line also keeps the `money-market/05` checks: opens without ✖, closing keeps the square, the bag's ✖ and back to the square). The driver got `answer_right()` and `answer_wrong()`.
- **`money-market/06` unchanged:** the two bag bars and the top bar still read `G.trip.carry_fill()` / `home_fill()`; nothing about them moved (smoke line "square bars" passes as before).
- German: "🏠 On the way home" and the "gets you home" line through `tools/i18n.py`.
- A testing flag `--homeq` (with `--square --spot=market`) shows the question for screenshots (checked once at iPad size: title, house picture, four answer buttons, the square window behind it); in `README.md` under the testing shortcuts.
- `docs/design/time-quiz.md` and `money-and-market.md` §5.3b describe the walk home.

## Pace and golden runs (not recorded: the parent or the orchestrator records them)

Every trip now costs two questions (there and back) instead of one, and each is a real step of time. The short golden runs (to the end of chapter 2) change from the first trip on (q13). With this ticket **and** `money-market/02` together (and the bot getting the donkey): seed 1 ends at q523 with 319 lines (before: q396, 304 lines), seed 2 at q508 with 316 lines (before: q547, 447 lines). With this ticket alone: seed 1 q553 with 342 lines, seed 2 q504 with 313 lines (the run is chaotic: one more question per trip shifts every later roll). Chapter 5 over three seeds: see `## Pace`.

## 💡 Decisions to confirm

- 💡 **The walk home costs the question and no energy.** The ticket says "one time unit"; the walk there also costs energy (3 ⚡ before savings), the walk home does not. Undo or change: give the chore a cost (`village_trip` is the walk there; a second chore would be needed).
- 💡 **A pop-up closed without an answer keeps the farmer on the square**, nothing lost, he can press Back home again. (Alternative: send him home on ✖; that would break `money-market/05`.)
- 💡 **Title and wrong-answer line** "🏠 On the way home" / "Not quite: only a right first answer gets you home. Try the next one." (Undo: two texts in `ui/timequiz.gd`.)

## Pace

The bot to chapter 5, seeds 1, 2 and 3, the game before these two tickets against after them (`money-market/04` and `/02` together; the steps are Time Quiz answers):

| seed | answers to chapter 5 before | after | trips to the village before | after |
|---|---|---|---|---|
| 1 | 864 | 1117 | 222 | 231 |
| 2 | 986 | 1016 | 221 | 210 |
| 3 | 852 | 1108 | 222 | 230 |

Chapter 5 now comes after about 1080 answers instead of about 900 (+20 %; 1016 to 1117 against 852 to 986). The rise is the walks home and nothing else: take each run's trips away and the rest is 886, 806 and 878 answers against 864, 986 and 852 before, which is the same pace or a little faster (the donkey and strength of `money-market/02` help a little). So the bot, which goes to the village about every fifth answer, answers about one question more per trip; a child who goes to the village less often will feel it less. The farm itself is not slower or faster per answer, because its progress is limited by energy and by what the bot makes, not by time. The documented range in the check skill (chapter 5 after about 690 to 870 answers) is now outdated; it needs the new numbers once the golden runs are recorded.

## Progress (9 Nov 2026)

Built and checked in a private copy, with `money-market/02` in the same patch. Open: the golden runs. They change on purpose from the first trip on (q13); this session did not record them, as asked. New short golden runs (to the end of chapter 2, both tickets together): **seed 1: 319 lines, ends at q523 (before 304 lines, q396); seed 2: 316 lines, ends at q508 (before 447 lines, q547)**. The four files `tests/golden/bot-seed1-ch3.txt`, `bot-seed2-ch3.txt`, `bot-seed1-ch6.txt` and `bot-seed2-ch6.txt` need `bash tests/golden.sh --short --record` and `bash tests/golden.sh --record` (the full pair was not run). `tests/golden/places.json` changes too, but because of `money-market/02` (the new helper `jans_donkey`). When all are recorded, tick the box above and set the status to done.

## Golden runs recorded (9 Nov 2026, after merging wave 1)

Recorded on purpose on the merged result of five tickets (weeds and stones, the walk home and carrying, the chapter frame, tap notes, the sign picture): short runs 312 and 322 steps (were 304 and 447), full runs 623 and 642 steps (were 636 and 771), places golden with `jans_donkey` (placed at `field`). The new numbers come from all five changes together, not from this ticket alone.

## Pace decision (9 Nov 2026)

With wave 1 merged, the bot reaches chapter 5 after about 1070–1240 Time Quiz answers (seeds 1–3: 1073, 1089, 1243; before 864, 986, 852), about 25 % longer, mostly because the walk home now costs a question. The parent decided: **keep it** ("Keep it"). If it is ever tuned, the knobs are data: how many trips the story needs, or what the walk home costs.

