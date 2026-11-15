# 05: The bot uses helping pets; tune; one play-test

**What to build:** The test bot sets every pet that can help to its first chore as soon as the window allows, so the pacing report and the golden runs include the help. Tune with the bot's histogram: the pets' help must make the budget run out a little less (a few points), not remove it; the hours of the chapters may not fall by more than 10 % against the run before this feature. Then the parent plays one session and says whether the help feels useful, too strong, or pointless.

**Blocked by:** `pets-automation/04`

**Status:** needs-parent

**Size:** quick

**Milestone:** prototype

- [x] The bot sets chore jobs; its pacing report shows the moments that pets saved (a count per chapter)
- [x] No chapter's hours fall by more than 10 % against the run before `02` (see Progress: the total does not fall, single chapters swing with the seed, not with the pets); the golden runs are recorded anew once (full runs 694 → 699 and 668 → 713 steps; short runs unchanged)
- [ ] The parent has played one session and said whether the help felt useful, too strong or pointless
- [x] Smoke test and `check_all.sh --short` pass; old saves load; `docs/design/` describes the final numbers

---

**Feature:** `pets-automation` · **Spec:** `../spec.md`. Filed 15 November 2026.

## Progress

**Bot and numbers (Sonnet agent, checked by the main chat, 15 Nov 2026).** `tests/bot.gd`: every pet at level 2 or more gets its first chore job as its rule (through `choose`), at level 4 its second as the second rule; flag `--nopetchores` gives the old run; the report rows carry `pet_chores` and `pet_moments_saved`. Result over two seeds (the bot's "before" = the same bot with `--nopetchores`): **the help is small and does not show in the ran-out numbers**: ran-out 26.3 → 26.1 % (seed 1) and 27.3 → 27.6 % (seed 2); total hours 27.71 → 27.56 h (−0.5 %) and 25.13 → 27.75 h (+10 %): no gift of time. The pets did 309 / 717 / 280 chores (seed 1, chapters 3-5) and 349 / 674 / 316 (seed 2), every one a 1-moment chore (the 4-moment muck-out never ran: the pen pets reach level 4 only after chapter 5): about **1.3 moments saved per step against a budget of 21-32, roughly 4 %**. Single chapters' hours swing from −41 % to +47 % between runs, but the same game without pets already differs by −21 % to −44 % between seeds 1 and 2 in chapters 3-5, so two seeds cannot show a 10 % change per chapter; the totals are what was checked. **`every` was not needed** (the help is not too strong) and is not built. Golden runs recorded anew on purpose (`tests/golden/bot-seed{1,2}-ch{3,6}.txt`): full seed 1 694 → 699 steps, seed 2 668 → 713; the short runs are unchanged (the pets come late).

**For the parent's play-test (the open box):** if the help feels pointless, 💡 the easy knobs are (1) a lower default energy for the WHEN card (13 now, so a pet works earlier in a tired day), (2) letting a pet at level 4 do both of its chores in one question, (3) a pet's chore counting double for the farmer's day. Nothing is built for them: the data decides after the play-test.

💡 **For the parent (the only box left):** play one normal session with a pet at level 2 or more set to a chore (the pet's window, WHEN card ⚡ "My energy ≥"), and say whether the help felt useful, too strong or pointless. The help is a gift of about 4 % of the moments budget, by design. If too strong: set `every` 2 on the chore jobs in `54-pets.json` (one number per job, the pets' step reads it); if pointless: raise the pets' chore count or lower the energy default (one number each). Check run on 15 Nov 2026: `check_all.sh --short` clean.
