# Rest

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

### 4.3 Rest — energy from mental arithmetic

Tapping the energy bar opens **Rest** (sleep, food, a sip of water). The child types answers to sums on a number pad (or the
keyboard). The sums come from the **learning kit** (`kits/learn/`), a self-contained part that any game can use.

- **A start page first.** Rest opens on a page that shows where the child stands: the category and its title (🌰 Seed …
  🏔️ Mighty oak), the section and level ("level 2 of 13: 🐥 Take away up to 5") with a bar for how far along it is, the
  medals of the section won so far and an empty slot for the next one with what it takes, and the best streak. A big
  **🏁 Ready, set, go!** counts down (Ready… Set… Go!) and the sums begin.
- **Leaving mid-sum.** Going back to the farm while a sum is on screen leaves no trace: it is not wrong, not slow, and it
  does not change when it comes back.

- **Taking an answer.** The moment the typed number is right it is taken — no ✔ needed. A wrong number only counts when ✔
  is tapped; then the right sum is shown, with the steps for a tricky one (13 − 5: 13 − 3 = 10, 10 − 2 = 8).
- **Energy.** A quick right answer gives the full energy per Rest answer (§5.1), a slower right one half
  (`restSlowShare`), a wrong one nothing. Rest stops by itself when energy is full.
- **The curriculum** (`kits/learn/curriculum/math.json`), planned from class 1 to about class 7 (Swiss Lehrplan 21 and the
  *Schweizer Zahlenbuch*): **7 categories** — Plus & minus, Times & divide, Numbers, Fractions, Decimals & percent,
  Measures, Powers & minus numbers — with **76 levels**. Each category has two sections:
  - **⚡ By heart** — facts to recall at once (8 + 5, 6 × 7, 1/2 of 16). Quick = 2.5–3 s, plus ½ s for every extra digit
    typed.
  - **🧠 Working it out** — too many to learn by heart (32 − 17, 12 × 17, 3/4 of 24). The steps should run smoothly, so the
    time is longer (5–30 s) and a hint after a mistake shows the steps.
  A level opens when the level it builds on is passed (38 + 5 after 8 + 5). Times tables follow the German-language
  practice: core tasks first (×1, ×10, ×2, ×5, squares), the rest derived from them. Only *Plus & minus* is on at first;
  a parent ticks on the next category when the child is ready (⚙️ → 📊 Learning record, or `mathCategories`).
- **Spaced repetition.** Every task is a flash card: wrong → back after 2 others; slow → back after 3; quick and right →
  waits 3, 8, 20, 60, 180, 500, 1,400 answers. A task answered quickly the very first time counts as known already. At
  most 4 new tasks are learned at once and a new one comes at least every other answer, so the child moves forward instead
  of drowning in reviews.
- **When it is hard going** (4 of the last 8 wrong, or 7 of 8 slow): every third task is an easy one the child knows, only
  2 new tasks at a time, and now and then a kind word ("Tricky ones today — take your time"). Praise at 5, 10, 20, 30 quick
  answers in a row and for a sum known for good.
- **Medals for every level:** 🥉 **bronze** = passed (enough tasks quick and right twice in a row); 🥈 **silver** = the whole
  level quick (by heart: every task of a small level or 70 % of a big one, and 9 of the last 10 quick; working it out: 20
  different tasks quick); 🥇 **gold** = still quick at least a week after silver. 🏆 **Trophy** = a whole section silver;
  👑 **crown** = all gold. Each category gives a growing title: 🌰 Seed → 🌱 Sprout → 🌿 Seedling → 🌳 Young tree → 🌲 Tall
  tree → 🏔️ Mighty oak. The album shows the medals won and the next one to win.
- **Timing is generous by default.** The quick time only decides full energy and medals; a slow right answer still counts
  and still gives energy, and the timer bar never punishes. `restTimerScale` stretches every time limit.

How much arithmetic: about 1,400 Rest answers in a playthrough, roughly 60–100 an hour (§10.5) — arithmetic never
disappears and never floods.
