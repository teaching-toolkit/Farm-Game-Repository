# LearnKit — quizzes that interrupt a game

A small, self-contained Godot 4 kit for games in which a child answers sums or questions to move on. The farm game uses it for
its Rest sums and Time Quiz. Copy the whole `learnkit/` folder into another Godot project and it works the same there. It has
no links to the farm game.

| File | What it does |
|---|---|
| `learner.gd` | One child's **learning record**: a readable JSON file (`learning.json`), shared by every game that uses the kit |
| `math_engine.gd` | **Mental maths**: the curriculum (categories → sections → levels), the task generators, spaced repetition for every task, medals |
| `quiz_engine.gd` | **Question packs** (multiple choice): which question comes next, 3–4 answers laid out (also pictures), translations, spaced repetition |
| `srs.gd` | The spaced repetition itself (boxes and gaps counted in answers), used by both engines |
| `quiz_timer.gd` | The timer for a quick answer (2.5 s for a fact learned by heart, more for longer answers) |
| `number_pad_quiz.gd` | A ready-made sums window: the level with its medals, the task, a number pad, a timer bar, hints and kind words |
| `curriculum/math.json` | The maths curriculum from 1st to about 7th class (edit it freely) |
| `tools/learning-editor.html` | A page for viewing and changing a learning record in any browser (no Godot needed) |
| `tools/make_editor.py` | Rebuilds that page after the curriculum changed |

## Use it in a game

```gdscript
const Learner = preload("res://learnkit/learner.gd")
var math = preload("res://learnkit/math_engine.gd").new()
var me = Learner.new()
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	math.load_curriculum()                                   # res://learnkit/curriculum/math.json
	me.open(Learner.file_for("user://players", "Mia"), "Mia")
	math.rec(me.data, ["addsub"])                            # the categories practised

func show_sums(popup: Control) -> void:
	var pad = preload("res://learnkit/number_pad_quiz.gd").new()
	pad.setup(math, me.data, rng, {"scale": 1.0, "streak": true})
	popup.add_child(pad)
	pad.answered.connect(_on_answered)
	pad.before_next.connect(_on_before_next.bind(pad))
	pad.next()

func _on_answered(res: Dictionary) -> void:
	me.save()
	if res["right"]: give_reward(res["quick"])     # the game decides what a right answer is worth

func _on_before_next(pad) -> void:
	if enough_done(): pad.stop("Well done! Back to the game.")
```

A task left on screen (the child closes the pop-up before answering) leaves no trace: the pad puts back the turn counters
it moved when it picked the task (`math.pick_state` / `restore_pick_state`) as soon as it leaves the screen. Call
`pad.abandon()` yourself if you hide the pad without freeing it.

`res` (in `answered`): `q` (the task: `q`, `answer`, `key`, `level`, `limit` …), `typed`, `right`, `quick`, `secs`, `fb` (what
the engine says: `comment`, `hint`, `level_up`, `medals` [{level, medal}], `trophies`, `streak`, `struggling`), `text` (the
feedback line — change it to add your own words) and `wait` (seconds until the next task).

Without the window: `var q = math.question(me.data, rng)`, show `q["q"]`, compare with `math.is_right(q, typed)`, time it
against `q["limit"]`, then `math.result(me.data, q, right, quick, rng)` and `me.save()`.

Question packs: `var Q = preload("res://learnkit/quiz_engine.gd").new()`, `i = Q.pick(me.data, candidates, rng)`,
`var shown = Q.present(candidates[i], rng, 4, Q.load_texts("res://data/i18n/quiz-de.json"), pack_pool)`, show it, then
`Q.record(me.data, Q.key(candidates[i]), first_try)`.

## Questions: ids, answers, pictures, languages

```json
{"id": "PIC-004", "q": "What does a hen give us?", "img": "animals/animal_chicken", "emoji": "🐔",
 "answers": [{"text": "Eggs", "img": "items/egg", "emoji": "🥚"}, {"text": "Milk", "img": "items/milk", "emoji": "🥛"}, "Wool", "Honey"],
 "correct": 0, "right": "Right! Hens lay eggs.", "wrong": "Hens lay something you can cook for breakfast."}
```

- **id**: unique and never changed or reused (pack code + number). The learning record keeps every question under its id, so
  it says how well the child knows *that* question in any language. Old records kept under the question text are moved to the
  id by themselves (`rekey`).
- **answers**: text, or `{text, img, emoji}`. `present()` shows the right one and up to 3 wrong ones (4 answers; the game's
  `quizOptions` setting), mixed up. A pack's `"pool"` (e.g. all seven continents) fills a question with fewer wrong answers.
  When every shown answer has a picture, the game shows big picture buttons (2 × 2); the text is read aloud and used in the
  feedback. `img` is a picture name in the game's assets (folder/name); `emoji` stands in until the picture exists.
- **img / emoji on the question**: a picture above it ("What is this?").
- **Translations**: `quiz-<language>.json` holds `{"<id>": {"q", "answers": [...], "right", "wrong", "why"}}` (answers in the
  pack's order). An empty text falls back to the original. The farm game's `tools/quiz_ids.py` gives new questions their ids and
  writes these files (`quiz-en.json` for translators to read, `quiz-de.json` with empty texts for what is new).

## The learning record

One JSON file per child, pretty-printed so it can be read and edited by hand:

```json
{
  "format": "learnkit-1", "name": "Mia", "updated": "2026-10-06 14:03",
  "math": {
    "n": 412, "active": ["addsub"],
    "items": {"8 + 5": {"lvl": "as.f10", "box": 3, "due": 431, "right": 5, "wrong": 1, "slow": 2, "last_ok": 1791216000}},
    "levels": {"as.f10": {"n": 40, "bad": 9, "bronze": 1791216000, "silver": 0, "gold": 0}},
    "recent": [...], "streak": 4, "best_streak": 17, "quick_total": 301
  },
  "quiz": {"n": 120, "items": {"CON-003": {"box": 2, "due": 140, "right": 2, "wrong": 0}}}
}
```

- **box**: 0 = still learning, 2 or more = quick and right twice in a row, 4 or more = known for good. **due**: the answer
  number at which it comes back. Medals hold the time they were won (seconds since 1970; 0 = not yet).
- **Where the file is**: in Godot's user folder. On a Mac that is
  `~/Library/Application Support/Godot/app_userdata/<game name>/players/<name>/learning.json` (Windows:
  `%APPDATA%\Godot\app_userdata\…`). The farm game opens the folder from ⚙️ Settings → 📊 Learning record.
- **In a web build** the file lives inside the browser. Use ⚙️ → 📊 Learning record → *Copy the record*, change it in the
  editor page, then *Paste* it back.
- **The editor page** (`tools/learning-editor.html`, opens in any browser) shows the levels with their medals and every task.
  You can tick medals, choose where a child starts ("Start here" passes the levels before it), choose the categories, change or
  delete tasks, and download the file again.

## The maths curriculum

`curriculum/math.json` has **categories** (Plus & minus, Times & divide, Numbers, Fractions, Decimals & percent, Measures,
Powers & minus numbers). Each has two **sections**:

- **⚡ By heart**: facts to recall at once (8 + 5, 6 × 7, 1/2 of 16). Quick = 2.5–3 s plus ½ s for each extra digit typed.
- **🧠 Working it out**: too many to learn by heart (32 − 17, 12 × 17, 3/4 of 24). The steps should run smoothly, so the time
  is longer (5–30 s), and a hint after a mistake shows the steps.

Each section has **levels** in the order they are learned. A level is a task generator (`kind` and its settings), the time
for a quick answer, how many different tasks must be learned (`need`), the school class it belongs to, and the level that has
to come first (`after`). All 76 levels are in `curriculum/math.json`; a readable table is in `archive/design-docs/farm-quiz-game-master-design-document-v1.3.8.md` §37.25 (in the farm game folder).

**Medals** for every level: 🥉 **bronze** = passed (enough tasks quick and right twice in a row); 🥈 **silver** = the whole
level quick (by heart: every task, or 70 % of a big level; working it out: 20 different tasks, and 9 of the last 10 quick and
right); 🥇 **gold** = still quick at least a week after silver. 🏆 **Trophy** = a whole section silver; 👑 **crown** = all gold.
Each category also gives a growing title (🌰 Seed → 🌱 Sprout → 🌿 Seedling → 🌳 Young tree → 🌲 Tall tree → 🏔️ Mighty oak).

**Spaced repetition** (`srs` in math.json): a wrong task comes back after 2 others, a slow one after 3; quick and right it waits
3, 8, 20, 60, 180, 500, 1400 answers. A task answered quickly the very first time starts further along (the child knows it).
At most 4 new tasks are being learned at a time, and a new one comes at least every other answer, so the child keeps moving
on. When it is hard going (4 of the last 8 wrong, or 7 of 8 slow), every third task is an easy one the child knows, fewer new
tasks come, and a kind word comes now and then.

To add a level: add it to a section in math.json (with a `kind` that exists in `math_engine.gd` `_gen()`, or write a new
generator there), then run `python3 learnkit/tools/make_editor.py`.
