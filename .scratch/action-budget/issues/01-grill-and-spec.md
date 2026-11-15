# 01: Grill and spec: a limit on how much you can do before time must move

**What to build:** A new idea from the parent: a maximum on how many items you can craft depending on your mastery level, and a global maximum on all actions in a given interval. Each action has a time cost measured in the background that adds to a global sum; when it is reached, all further actions are greyed out until the player moves time forward by one unit through the Time Quiz. Settle it with the parent, then write the spec and the tickets.

**Blocked by:** `farm-actions/01` (the spec): the global time sum is added where actions are checked and paid

**Status:** done

**Milestone:** prototype

- [ ] `/grill-with-docs` run with the parent: what the limit is, how it is shown, and how it fits energy (does it replace or add to energy?)
- [ ] `spec.md` written in this folder with the seams for testing
- [ ] Build tickets filed in this folder with blockers
- [ ] The effect on the pace and on the bot is estimated in the spec

## 💡 Recommendation (30 Oct 2026)

Grill it after the three refactor modules: the limit belongs in the time-question module's rules, which will exist by then.

## 💡 Shared understanding to confirm (14 Nov 2026; replaces the grilling if the parent says yes)

The parent asked Claude to think the balance through (`docs/sources/2026-11-14-parent-notes-testrun.md`).

- **Two things run out, and they mean different things.** *Energy* is how much the body can do; Rest sums refill it. *Time* is how much fits into one step; only a right first Time Quiz answer refills it. The budget adds to energy and replaces nothing.
- **Every chore takes time, in whole "moments":** a light chore 1 (weed, pick up a stone or stick, plant, harvest, collect from an animal), a middle one 2 (fetch water, muck out, a simple recipe), a heavy one 4 (cut a tree, one building step, a big recipe). The number sits beside the chore's energy in the chores file, so `G.actions.check` and `perform` are the only place that counts it.
- **One step holds 24 moments** (a first number, tuned below). That is about 16 to 20 light chores or six heavy ones: the child gets a patch weeded, watered and sown in one step, but not the whole farm.
- **Shown as a ring around the clock symbol** with 12 segments (2 moments each) that fill as the farmer works: green, the last three amber. When it is full the clock rocks gently, every chore button and tile is grey, and a tap on a grey one sends a small spark to the clock (the reason for a grey button, as `interface-feel/02` does it). A right first answer empties the ring with a sweep.
- **Free of time:** looking, reading cards, the bag and the store, Rest, buying and selling on the square, walking. Walks already cost a question.
- **Mastery makes chores quicker, not a second limit.** The parent's "max items crafted by mastery level" becomes: each skill rank takes a moment off that family's middle and heavy chores (never below 1). A master makes more per step than a beginner, with one rule and one display.
- **Pets do not use the farmer's time.** An automated chore (`pets-automation/01`) costs the farmer's energy as the glossary says, but none of the farmer's moments. That is what makes handing a chore to a pet worth it, and why the child's own chores stay worth doing: the child chooses what to spend the 24 moments on.
- **Never stuck:** when the ring is full there is always the Time Quiz; when energy is also empty, Rest. Nothing is lost by running out.
- **The balance, measured not guessed:** the test bot does about 11 chores per step in chapter 1 (1777 chores over 163 questions, `progression/pacing-report.json`). At the weights above that is roughly 15 to 18 moments, so a normal step uses about two thirds of the ring and a busy one hits the end. The first build ticket adds the moments to the bot's report (a histogram per chapter); the number 24 is then set so the bot runs out in about one step of four, and the chapter hours move by less than 10 %.
- **Old saves:** one new key (moments used in this step), 0 in an old save.

**Build tickets once confirmed:** `02` moments in the chores file, counted by the actions module, the bot waits for the next step when out of time, histogram in the pacing report, golden runs recorded anew; `03` the ring, the grey chores and the spark; `04` skill ranks make chores quicker; `05` tune the number with the bot and one play-test.

## ✅ Parent's answer (14 Nov 2026)

**Yes** to the shared understanding above. It stands in for the grilling; the spec is `../spec.md` and the build tickets are `02`–`05`. The glossary gets the word *moment* with `02`.

---

**Feature:** `action-budget` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.4]. Filed 23 October 2026.

The parent's words:

> [#23.4] there could be a max on how many items you can craft depending on your mastery level. And then there could be a global max on all actions in a given interval until everything is greyed out. Each actions needs an amount of time it takes that is measured in the background and contributes to this global time sum and if it reached, all further actions are greyed out until the player moves time forward by one unit through the time quiz.
