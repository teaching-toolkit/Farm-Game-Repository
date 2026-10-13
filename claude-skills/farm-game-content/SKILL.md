---
name: farm-game-content
description: Use when adding or changing content in the Farm Quiz Game (this project), such as quiz questions and packs, knowledge cards, any text the player sees and its German translation, progression numbers, settings, sounds, pictures from art-inbox or the map layout. Gives the steps and tools for each, so ids, German, the explorer and credits aren't forgotten.
---

# Farm Quiz Game: changing content

Run the tools from `godot-prototype/`. Full formats: `godot-prototype/README.md` ("Changing content", "Pictures", "Moving and
resizing things on the map") and `godot-prototype/kits/learn/README.md` ("Questions: ids, answers, pictures, languages").
After any content change, run the checks (`claude-skills/farm-game-check/SKILL.md`) and add a row to `PROJECT-LOG.md`
(`claude-skills/farm-game-session/SKILL.md` §4).

## Writing for the child

The player is 8 and reads on an iPad. Use short sentences and everyday words, and whole numbers only. Nothing that scolds or
punishes; a wrong answer gets a kind explanation. No words on the map itself. Plurals are two full sentences (singular and
plural), never an "s" added by code.

## Quiz questions (Time Quiz packs)

1. Edit `data/quiz_packs/<pack>.json` (format in the README). For a new pack: give it a unique 3-letter `code` and list its id
   in `activePacks` in `data/settings.json`.
2. Run `python3 tools/quiz_ids.py`. It gives new questions their id (`<CODE>-<number>`) and updates `data/i18n/quiz-en.json`
   and `quiz-de.json`. **Never change, renumber or reuse an id**: the child's learning record and the translations are stored under it.
3. Fill in the German in `data/i18n/quiz-de.json` (an empty text falls back to English).
4. Pictures in questions or answers: `img` is a picture name like `items/carrot`; `emoji` stands in until the picture exists.
5. Smoke test (it checks quiz ids, answers and pictures). Single question on screen: `--qid=<id>`.

## Knowledge cards and their questions

Cards, books and the card questions (ids `KNW-…`) live in `data/farm/nodes/` (the cards in `11-knowledge-cards.json`, the books in `10-books-and-library.json`). After changing card questions, run
`python3 tools/quiz_ids.py` as above. Then follow "Progression numbers" below.

## Any text the player sees

- In scripts: wrap it in `tr("…")` (in static functions `TranslationServer.translate`). Tables of texts are marked `# i18n`.
- Then run `python3 tools/i18n.py`. It adds new texts to every language, flags data texts whose English changed
  (`"stale": true`) and checks that `%s`, `%d` and `{…}` slots match. Translate everything it reports as missing or stale in
  `data/i18n/*-de.json`. `python3 tools/i18n.py --check` must end with exit code 0.
- **German spelling:** whether the game uses "ß" or Swiss "ss" is open question Q-X1 in `TODO.md`. Follow the answer once it is
  decided; until then, match what the files already use.
- Look at the changed screens with `--lang=de`: German texts are longer and must still fit.

## Progression numbers (items, nodes, recipes, chapters, prices, energy)

1. Edit the file in `data/farm/` that holds it (`items.json`, `recipes.json`, `nodes/NN-theme.json`, `rules/NN-system.json`; find it with
   `grep -rn '"<id>"' data/farm`) with targeted edits. Items, recipes and nodes are one per line: don't rewrite a file with a plain
   `json.dump(indent=…)` (`tools/farmdata.py` writes the layout). Node order is game order: a new node goes where it should come.
2. Run `python3 tools/check_data.py` (ids, costs, conditions), then `python3 tools/sync_progression.py` (writes the data as one file into `../progression/` and the explorer).
3. Run the explorer check (command in `farm-game-check` §2) and the bot. Compare the playthrough hours, the answers and
   when the pets arrive with `00-READ-ME-FIRST.md` §7. Report the difference and update §7.
4. If the data and a document disagree, the data wins; fix the document, or ask the parent if the data looks wrong.

## Settings

`data/settings.json`. Every key is explained in the README ("Changing content" → `data/settings.json`). The grown-up password
is only a child lock: the web build is public, so nothing secret goes there.

## Sounds and music

1. The parent (or a download they approved) puts files into `../sound-inbox/`, each folder or file with an entry in its
   `SOURCES.json` (author, licence, web page). **No entry, no use:** the credits page is made from it.
2. `data/sounds.json`: each effect has `from` (glob patterns inside `sound-inbox/`), a volume and a `synth` stand-in; music
   says which track plays where.
3. Run `python3 tools/import_sounds.py`, then import once in Godot (`$G --headless --path . --import`).

## Pictures

- They are generated in OpenArt; the settings (project, model, sheets, versions) are the parent's rules in
  `00-READ-ME-FIRST.md` §4.6. **Don't download from OpenArt yourself**: the parent puts the chosen files into `art-inbox/` by hand.
- What is still needed, with prompts: `python3 tools/art_list.py` writes `art-inbox/ART_LIST.csv`.
- Import: `bash tools/setup_godot.sh --art` once (Pillow, numpy, scipy), add the sheet to `tools/art_sheets.json`, then run
  `python3 tools/import_art.py all` (or `sheet`, `one`, `tile` for single files; see the tool's header). Then import in Godot
  and take screenshots of the places that use the pictures.
- A missing picture is never an error: the game shows the emoji instead.

## Map layout

`data/map_layout.json`. The parent usually moves things with the layout editor, online (its **Send to Claude** button) or offline
(`tools/layout-editor.html`, then a downloaded file or pasted text). After new pictures or a layout change, rebuild the editor
with `python3 tools/make_layout_editor.py`. `python3 tools/default_layout.py` **overwrites** the layout with the starting one:
only on request.
