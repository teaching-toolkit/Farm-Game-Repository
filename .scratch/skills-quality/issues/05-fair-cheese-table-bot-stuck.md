# 05: Chapter 6: the test bot never gets its second Proper cheese board (Fair cheese table)

**What to build:** Find out why the bot cannot finish the Harvest Fair cheese table (`d_fair_cheese`, `minGrade` 1, cost 2 cheese boards and 2 tapenade) and fix the cause. Found on 17 Nov 2026 when the explorer was regenerated: in both bot seeds chapter 6 never completes. Seed 1 ran 3000 iterations (5467 steps, 85 hours of bot time in chapter 6, `pet_chores` 9898) and the last open main goal was still `d_fair_cheese`; a probe run (`--end --iters=1000 --stuck`) says `stuck: d_fair_cheese needs cheese_board 1.0/2.0`, with the recipe open, the station built and nothing lacking. `d_fair_cloth` (also `minGrade` 1) waits behind it.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** later

**Size:** short

- [ ] Say which it is, with a probe: (a) the bot eats, sells or spends the boards (a cheese board has a `buff`), (b) a cheese board is Proper too rarely (made at `prep_table_2` from Lumpy-made inputs: aged cheese, jam, bread), or (c) both. Use `--why=d_fair_cheese`, count the grades of boards made, and run `tests/quality_test.gd`
- [ ] Fix the cause: (a) teach the bot to keep boards for a goal that asks a grade; (b) a per-recipe `gradeBonus` or a lighter table (data in `47-quality.json` or `minGrade` on the node), as `skills-quality/04` does for medicine. A child must be able to reach it by normal play, so the number is a 💡 for the parent if it changes the game
- [ ] `bash tools/update_explorer.sh` ends with chapter 6 complete for both seeds (it took about 55 minutes on 17 Nov because chapter 6 never ends: allow for that)
- [ ] Golden runs change only on purpose: record anew and say so in the log

💡 Recommendation: probe first (the first box). If it is (a) it is a bot-only fix and the game stays as it is. If it is (b), take the same route as `skills-quality/04` (a recipe bonus so only the Fair dishes move).

## Evidence (17 Nov 2026)

- `bot_stuck` probe, seed 1, chapter 6 at iteration 1000: 690 steps in chapter 6, 14.57 hours, the pets did 1498 chores; open main goals `["d_fair_cheese"]`; one step away: `d_fair_cloth`, `k_colour_mixing`.
- Chapters 1 to 5 of the same runs finish (3.61, 4.27, 6.88, 7.54 and 2.58 hours for seed 1).
- The committed pacing report (before wave 3) also stopped inside chapter 6 (step 1251, `complete` false), so this is not new proof that `skills-quality/01` caused it, but `minGrade` on the Fair tables is the open requirement now.

---

**Feature:** `skills-quality` · **Source:** found while closing pass 2, 17 November 2026. Filed 17 November 2026 (not started: the parent asked to wrap up).
