# 01: Grill and spec: the question that moves time

**What to build:** Settle candidate 2 of `docs/architecture-review-2026-10-22.md` with the parent, then write the spec and the build tickets. The first-try rule (only a right first answer moves farm time) moves out of four near-copies in the interface into one rules function that the bot also calls, so the golden run finally covers it. About one session; a cheap warm-up if a smaller first slice is wanted. 

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** refactor

- [x] Grilling run with the parent (`/grill-me`, three rounds; glossary updated by hand: walk, purpose); one seam agreed: the part's two jobs
- [x] `spec.md` written in this folder from the `/to-spec` template
- [x] Build tickets filed in this folder with `/to-tickets`, blockers set
- [x] The plan keeps the golden runs identical: this changes no game rule

## Constraint from the parent (30 Oct 2026)

Keep question packs modular: built-in packs and packs the parent pastes in later (`parent-controls/02`) must plug into the Time Quiz the same way, each question with a permanent id (ADR-0007). The module's interface should not care where a pack came from.

## 💡 Recommendation (30 Oct 2026)

Next in the refactor milestone. Run it as `/grill-with-docs` in rounds of three, with the architecture review's Part B §2 as the starting map and the modular-packs constraint above.

## Grilling (started 30–31 Oct 2026, `/grill-me` with the parent)

Facts found first: the first-try rule is written out four times in the interface (Time Quiz, village walk, visit, forest walk); the bot
never answers a question (it only moves time), so no check covers the rule, the retry or the review recording; the four copies drifted
(only the Time Quiz tells of scarecrow, pests, rainbow); question picking uses the farm's one random source.

**Round 1 (✅ parent, 31 Oct 2026: yes to all three)**
1. Questions get their own random source; the bot draws and answers real questions through the same rule; golden runs must stay identical.
2. One rule, one report: every question that moves time tells the same things (rain, rainbow, scarecrow, pests) the same way, picture
   or animation first, a short line under it. Parent's addition: going to the forest or the market needs **no arrival message**; the
   background will show where the farmer is after one time unit has passed.
3. A separate time-question part with two jobs (next question; a question was answered, first try or not, for a purpose); it takes a
   question with its permanent id and pack, and never cares whether the pack is built in or pasted in; one door for adding packs.
   Card reviews stay with the knowledge cards and are drawn in from there.

**Round 2 (✅ parent, 2 Nov 2026: yes to all three)**
4. A right first answer on a walk (to the village, into or out of the forest) closes the pop-up and opens the place itself: no arrival
   line, no extra button. A visit keeps its short scene (that is its content).
5. What happened on the farm (rain, rainbow, scarecrow, pests) shows on the farm through the playback when the pop-up closes, each with
   a short line under its animation; the pop-up shows only right or wrong and time moving (⏳, the question number). After a walk the
   child sees it on coming home.
6. Each use is a named purpose in the rules with its follow-up: farm time, walk to the village, walk home from the village
   (`money-market/04`), visit, into the forest, out of the forest. The bot calls the same purposes.

**Round 3 (✅ parent, 2 Nov 2026: yes to all three)**
7. Words: a question on a walk is a **Time Quiz question** too; new glossary words **walk** and **purpose**. "Time question" is only
   the name of the code part.
8. Two steps: refactor tickets first that change nothing in play (the part, its own random source, the four places and the bot through
   it, golden runs identical); then the visible changes of answers 4 and 5 as their own prototype tickets.
9. One seam: tests sit at the part's two jobs, without the screen (first try moves time and runs the follow-up; wrong doesn't and comes
   back after the next; a card review is recorded as a review; a pasted pack works like a built-in one). The bot plays through it,
   wrong answers included with `--accuracy`. No new screen tests beyond the smoke test.

✅ Parent confirmed the summary (2 Nov 2026). Spec: `.scratch/time-question/spec.md`. Tickets: 02 (farm time through the part,
own random source, bot answers real questions), 03 (one door for packs), 04 (walks as named purposes); prototype 05 (walks open the
place), 06 (farm news on the farm).

---

**Feature:** `time-question` · **Source:** `docs/architecture-review-2026-10-22.md`, Part B, candidate 2 (Strong). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.
