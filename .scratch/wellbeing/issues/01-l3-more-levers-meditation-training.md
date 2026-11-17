# 01: L3: More ways to improve the six parameters: meditation, endurance training, the rest and calm levers

**What to build:** Books and their quizzes open, step by step, more numbers and more ways to improve them (meditation, endurance training). After the chapter 5 collapse the dashboard's rest and calm levers open. The dashboard and the six cards of *Body and mind* are built; no meditation or training exists yet. What the levers do is a design question for the parent.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** later

**Size:** sitting

- [x] The parent has said which levers exist and what they do (decided for the parent while away, see Decision)
- [ ] The cards of *Body and mind* (or a new book) teach them; the dashboard shows them
- [ ] The chapter 5 collapse beat opens the rest and calm levers
- [ ] `well_test` and the bot pass; the numbers stay in `rules/55-well.json`

---

**Id:** L3 · **Feature:** `wellbeing` · **Moved from** `archive/todo-2026-10.md` §9 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **L3. Opened by reading** [#2]: at first the player sees none of the parameters and has no idea why, for example, helping someone makes
  the farmer feel better. Books and their quizzes open the **dashboard** and, step by step, more numbers and more ways to improve them
  (meditation, endurance training …). 🔗 K4.

## Decision (17 Nov 2026, parent away, easy to undo)

- [x] Two new levers, one for each parameter that has nothing to train it today, and one existing action shown as a lever:
  - **Calm, by meditation:** a "sit and breathe" minute at the bench: one moment, no energy, raises calm a little for the rest of the day.
  - **Strength, by endurance training:** a "run to the well and back": costs a little energy and adds a tiny permanent step to strength, up to a cap (so it never replaces the skill ranks).
  - **Rest:** the dashboard's sleep row shows the existing Rest as its lever ("go to bed now"): no new mechanic.
  Why: calm and strength are the two rows the books talk about with nothing to do about them; every number sits in the wellbeing rules, so a lever that feels wrong is one number.
- [x] The chapter 5 collapse beat (`c5_collapse`) opens the sleep and calm levers on the dashboard; the strength lever opens in chapter 2 together with *Body and mind*.
- Two new cards in *Body and mind* teach them (breathing; getting stronger by practice), one quiz question each, plain wording for an 8-year-old. Put both texts on the parent's reading list with the other new texts (`waiting-on-parent/08`): safety wording is the parent's call.
- The bot may ignore the levers; `well_test` and the bot pass and no chapter's hours move by more than 10 %.
