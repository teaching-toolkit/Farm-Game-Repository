# 01: Grill and spec: a limit on how much you can do before time must move

**What to build:** A new idea from the parent: a maximum on how many items you can craft depending on your mastery level, and a global maximum on all actions in a given interval. Each action has a time cost measured in the background that adds to a global sum; when it is reached, all further actions are greyed out until the player moves time forward by one unit through the Time Quiz. Settle it with the parent, then write the spec and the tickets.

**Blocked by:** `farm-actions/01` (the spec): the global time sum is added where actions are checked and paid

**Status:** needs-parent

**Milestone:** prototype

- [ ] `/grill-with-docs` run with the parent: what the limit is, how it is shown, and how it fits energy (does it replace or add to energy?)
- [ ] `spec.md` written in this folder with the seams for testing
- [ ] Build tickets filed in this folder with blockers
- [ ] The effect on the pace and on the bot is estimated in the spec

---

**Feature:** `action-budget` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.4]. Filed 23 October 2026.

The parent's words:

> [#23.4] there could be a max on how many items you can craft depending on your mastery level. And then there could be a global max on all actions in a given interval until everything is greyed out. Each actions needs an amount of time it takes that is measured in the background and contributes to this global time sum and if it reached, all further actions are greyed out until the player moves time forward by one unit through the time quiz.
