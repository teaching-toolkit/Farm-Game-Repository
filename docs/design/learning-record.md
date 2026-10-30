# The learning record, the parent's controls and languages

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

### 4.4 The learning record and the parent's controls

- **One record per child**, shared by every game that uses the learning kit: `players/<name>/learning.json` in Godot's
  user folder (on a Mac: `~/Library/Application Support/Godot/app_userdata/<game>/players/<name>/`). It is plain,
  pretty-printed JSON: every sum and every quiz question (by id) with its box, when it comes back and how it went; every
  level with its medals and the dates they were won.
- **⚙️ → 📊 Learning record** shows a summary, opens the folder, copies the record out and pastes one back in (the way to
  edit it in the web version), and chooses the maths categories.
- **The editor page** `kits/learn/tools/learning-editor.html` opens a record in any browser: tick or untick medals, choose where
  a child starts ("Start here" passes the levels before it), choose the categories, change or delete tasks, see every quiz
  question with its id and text, and download the record again.
- **Settings** for the parent (`data/settings.json`): which packs, how many answers, the share of card reviews, the language,
  the maths categories and timing, dynamic difficulty, place names on the map, the test cheat buttons.
- **The grown-up part of ⚙️ Settings** (the question share, the learning record, dynamic difficulty, a new game) is behind a
  simple password (`parentPassword`, with a hint under the box) and stays open for 5 minutes; "Who is playing" and the log
  stay open to the child. It is a child lock, not a secret.

### 4.5 Languages

The whole game is in **English and German**, and more languages can be added as files. ⚙️ Settings has a button per
language (🇬🇧 English · 🇩🇪 Deutsch); the choice belongs to the device and switches everything at once: the interface, the
farm's names and descriptions, the knowledge cards and their questions, the quiz packs, the Rest sums and their kind words,
and the read-aloud voice. English is written in the code and the data; every other language is a set of files in
`data/i18n/` (`ui-<lang>.json` for the interface, `data-<lang>.json` for the game data, `learn-<lang>.json` for the Rest
sums, `quiz-<lang>.json` for the packs). A text not translated yet shows in English. A new language is a new set of files
and a line in `data/i18n/languages.json`; `tools/i18n.py` collects every text into them. German follows Swiss spelling:
"ss", never "ß".
