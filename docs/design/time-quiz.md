# The Time Quiz

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 4. Learning systems

### 4.1 The Time Quiz — the farm's clock

The green clock that hangs from the right end of the top bar opens the Time Quiz. **One answer that is right at the first try = one step
of farm time.** It is the only thing that moves time. After a wrong first pick the child keeps trying until the right answer
and its "why" show, but time stays where it was, and that question comes back right after the next one (a pack question as
well as a card review).

- **Where questions come from.** Mostly from the **question packs** the parent switched on (`activePacks` in
  `data/settings.json`; packs are files in `data/quiz_packs/`). A share of the questions (25 % to start, `knowledgeReviewShare`;
  the parent changes it per farm in the grown-up part of ⚙️ Settings, in 5 % steps) are reviews of knowledge cards the child has already learned
  (§4.2); when no card is due, a pack question takes the place. A question asked lately does not come back within
  the next few (`avoidRepeatWithin`, 3).
- **Spaced repetition per question.** The learning record keeps every question: answered wrong, it comes back after 3
  others; right at the first try, it waits 12, then 32, 80, 200 and 480 questions. New questions come before known ones
  most of the time (70 %).
- **Answers.** Each question shows **3–4 answers** (`quizOptions`, 4): the right one and up to three wrong ones, mixed up
  anew each time. A pack can have a **pool** of answers of the same kind (all seven continents) that fills up questions
  written with fewer wrong answers, so the child meets different wrong answers and cannot learn a question by the look of
  its buttons.
- **Pictures.** A question can have a picture above it ("What is this?" 🎃); answers can be pictures, then they are four
  big picture buttons, two by two ("Which one grows under the ground?"). A picture is a name in the game's pictures
  (`items/carrot`, `animals/animal_cow`) with an emoji that stands in until the picture exists.
- **Feedback.** A wrong pick greys out and shows a short hint ("Hens lay something you can cook for breakfast"); the right
  one turns green with a one-line "why". Wrong answers can be retried (`wrongAnswer: retry`); only the first try counts for
  the repetition and only a right first try moves time.
- **Read aloud.** Where the device has a voice, 🔊 reads the question and the answers. A device setting (⚙️ Settings, grown-up part) chooses *off* (no 🔊 buttons), *a button* (the default) or *by itself* (each question and card page is read as it opens; 🔊 reads it again).
- **Every question has an id** that never changes and is never reused: a pack code and a number (`CON-003`, `PIC-012`);
  the knowledge cards' questions are `KNW-001` … `KNW-261`. The learning record and the translations use the id, so the
  record says how well the child knows *that* question in any language, and a question can be reworded without losing
  what was learned.
- **Packs now:** *Farm basics* (FRM, 4), *Continents* (CON, 12), *Farm pictures* (PIC, 18, picture questions). A playthrough
  has about 1,400 Time Quiz answers, so a live set of 40–80 questions, swapped as the child learns (one pack per school
  topic or term), keeps it fresh.

- **The farm after the quiz.** While the quiz is open **nothing on the farm changes** (the screen keeps its old look). After *Back to the
  farm*: a fixed short pause (0.8 s, the same after one question or eight), then what happened plays, mostly together: **rain** first
  (about a second, if it rained), then the plants **flick through every stage in between** (0.3 s each: sped-up time, not a jump), a bar that
  changed (energy, water) pulses with its change floating up (−4), pests and the scarecrow play out (§6.4), and last the short notes, a gift or
  a celebration. **A tap anywhere jumps to the end.** *(planned: a travelling merchant coming down the road, the pets' work)*

A pack file:

```json
{"id": "farm-pictures", "code": "PIC", "title": "Farm pictures", "subject": "Science",
 "pool": ["…optional extra wrong answers of the same kind…"],
 "questions": [
  {"id": "PIC-004", "q": "What does a hen give us?", "img": "animals/animal_chicken", "emoji": "🐔",
   "answers": [{"text": "Eggs", "img": "items/egg", "emoji": "🥚"}, {"text": "Milk", "img": "items/milk", "emoji": "🥛"}, "Wool", "Honey"],
   "correct": 0, "right": "Right! Hens lay eggs.", "wrong": "Hens lay something you can cook for breakfast."}]}
```
