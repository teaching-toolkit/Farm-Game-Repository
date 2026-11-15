# The Time Quiz

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 4. Learning systems

### 4.1 The Time Quiz — the farm's clock

The green clock that hangs from the right end of the top bar opens the Time Quiz. **One answer that is right at the first try = one step
of farm time.** It is the only thing that moves time. After a wrong first pick the child keeps trying until the right answer
and its "why" show, but time stays where it was, and that question comes back right after the next one (a pack question as
well as a card review).

- **Moments: how much fits into one step** (`action-budget`, rules in `rules/46-chores.json` `"moments"`). A step holds a fixed number of **moments** (18 in
  chapter 1, 21 in chapter 2, 26 in chapter 3, 32 from chapter 4: `perStep` plus `chapterExtra`; a bigger farm has more to do in one step). Every chore takes
  0 (free: looking, and walks, which already cost a question), 1 (light: one weed, one plant, one harvest), 2 or 4 (muck out, dig in the forest); a recipe's
  moments come from its energy (up to 1 → 1, up to 3 → 2, more → 4), and each skill rank takes one moment off the middle and heavy chores of its family
  (never below 1). When the step's moments are used up no chore can be started (every button and tile is grey, the reason is "No time left for that now.
  Answer the clock's question.") until a right first answer moves time one step and gives a fresh set; a chore that needs more than is left can still be
  started when at least one is left and uses up the rest. Counting is done by `G.actions` only (`moments_of`, `moments_used`, `moments_left`, the unmet
  reason `time`; the save key `moments`, 0 in a new game and an old save, reset by the clock each step). **What the child sees:** a ring of 12 segments round the
  clock fills as moments are used (green, the last three amber; it looks full only when none is left); at full the clock rocks, a tap on a grey chore
  sends a spark to the clock and the usual reason note opens, and a right first answer empties the ring with a quick sweep. No number is ever shown.
  The skill window carries a small 🕰️ per rank and "Quicker with every rank". The bot answers the Time Quiz when no moment is left, and its pacing
  report has per chapter `moments_hist`, `moments_steps` and `ran_out`. The numbers were set so the bot (a worst case: it uses every moment) runs out in
  about one step of five to four in chapters 1 and 2; a child will run out less often. Still to be confirmed by the parent's play-session (`action-budget/05`). **Helping pets** (`pets-automation/05`) take chores off the farmer without using moments; the bot now sets its pets to their chores (rows `pet_chores`, `pet_moments_saved`): they save about 1.3 moments a step (roughly 4 % of the budget), and the bot's ran-out stays at 26-28 %, so the help is a small gift, not a change of pace.
- **The same question everywhere.** Every walk costs one question too: to the village, to a neighbour's farm, into the forest and out of
  it. Each is a *purpose* of the same rule: only a right first answer moves time and lets the walk happen; after a wrong one the walk
  waits with *Next question* and the question comes back after the next one, as on the farm. After a right answer on the way to the
  village, into the forest or out of it, the green answer shows for a moment (1.2 s, `playback.walkRight` in `rules/65-feel.json`) and
  the pop-up closes straight into the place (the square, the forest, the basket at the forest edge): no arrival line, no extra button
  (the background will show where the farmer is). A visit keeps its little scene with the neighbour and its *Back to the farm* button.
  **The walk home from the village is a walk too** (purpose `home_from_village`, `money-market/04`): *🏠 Back home* on the village square opens one question
  ("🏠 On the way home"); a right first answer takes the farmer home (the bag is emptied, the square closes into the farm), a wrong one waits with *Next question*,
  and a pop-up closed without an answer leaves the farmer on the square. It costs the question and no energy.
- **Questions have their own dice.** Which question comes, and the order of its answers, is decided by the quiz's own random source, so
  what the farm rolls (rain, pests, luck) never depends on which question came up. The retry and the recently asked questions are
  remembered by the question's id, so a pack can be added or switched off without mixing them up.
- **One door for packs.** The built-in packs come in through one door; the parent's own pasted packs will use the same one
  (`parent-controls/02`), and from then on nothing treats them differently.

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

- **Energy.** The Time Quiz never gives coins, and its main job is time, not energy. But from chapter 2, every question that moves time also
  changes energy a little: a busy farm and a low mood drain it, helping someone boosts it for a few questions (§5.1b). That change is one of
  the bars that pulse after the quiz (below).
- **The pop-up tells only right or wrong and time moving** (⏳ and the question number). What happened on the farm is shown on the farm.
- **The farm after the quiz.** While the quiz is open **nothing on the farm changes** (the screen keeps its old look). After *Back to the
  farm*: a fixed short pause (0.8 s, the same after one question or eight), then what happened plays, mostly together: **rain** first
  (about a second, if it rained), the **rainbow** if the rain stopped (with its perk), then the plants **flick through every stage in
  between** (0.3 s each: sped-up time, not a jump), a bar that changed (energy, water) pulses with its change floating up (−4), the
  scarecrow and the pests play out (§6.4), and last the other notes, a gift or a celebration. The **farm news** (rain, rainbow,
  scarecrow, pests) comes as its animation first with a short line under it (a note), the same after every kind of question. **A tap
  anywhere jumps to the end**; the news lines not shown yet still come as notes, so nothing is lost.
- **After a walk the news waits** until the farm is seen again (the square's or the forest's sheet is closed); the news of the walk
  there and the walk back is shown together. *(planned: a travelling merchant coming down the road, the pets' work)*

A pack file:

```json
{"id": "farm-pictures", "code": "PIC", "title": "Farm pictures", "subject": "Science",
 "pool": ["…optional extra wrong answers of the same kind…"],
 "questions": [
  {"id": "PIC-004", "q": "What does a hen give us?", "img": "animals/animal_chicken", "emoji": "🐔",
   "answers": [{"text": "Eggs", "img": "items/egg", "emoji": "🥚"}, {"text": "Milk", "img": "items/milk", "emoji": "🥛"}, "Wool", "Honey"],
   "correct": 0, "right": "Right! Hens lay eggs.", "wrong": "Hens lay something you can cook for breakfast."}]}
```
