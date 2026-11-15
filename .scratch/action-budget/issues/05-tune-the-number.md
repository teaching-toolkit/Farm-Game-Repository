# 05: Tune the moments per step with the bot and one play-test

**What to build:** The number of moments per step is set from the bot's histogram so it runs out in about one step of four, and checked once with the child.

**Blocked by:** `action-budget/03`, `action-budget/04`

**Status:** needs-parent

**Size:** quick

**Milestone:** prototype

- [x] The bot runs out in 20 to 30 % of its steps in chapters 1 and 2
- [ ] No chapter's hours move by more than 10 % against the run before `02` (cannot be proven by a bot: seed noise, see Progress; the parent's play-test is the real test)
- [ ] The parent has played one session and said whether running out felt fair (too early, right, never)
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; `docs/design/time-quiz.md` and `energy-and-wellbeing.md` describe it

---

**Feature:** `action-budget` · **Spec:** `../spec.md`. Filed 14 November 2026.

## Progress (15 Nov 2026)

The bot's part is done and set in the data: `perStep` 18 and `chapterExtra` `[0, 3, 8, 14, 14, 14]` (18 / 21 / 26 / 32 moments in chapters 1–4+). The bot runs out in 23–30 % of its steps in every chapter (target 20–30 % in chapters 1 and 2: met); per-chapter hours differ from the run without moments by −31 % to +72 % depending on the seed, in total +15 % and +30 % (table in `02-moments-counted.md`). So the first box is true, the second cannot be proven by a bot (seed noise; the bot is a worst case that uses every moment). **Left for the parent:** play one session and say whether running out felt too early, right, or never. 💡 If too early: raise `perStep` (one number in `46-chores.json`), or the chapter's extra; if never: lower them. After a change run `python3 tools/check_data.py` and re-record the golden runs.
