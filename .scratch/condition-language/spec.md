# Spec: one condition language

**Status:** ready-for-agent

Words are in `GLOSSARY.md` (condition, condition word, trigger, chore, goal). Background: the architecture review of 22 October 2026
(Part B, candidate 3) and the grilling in `.scratch/condition-language/issues/01-grill-and-spec.md` (four rounds, parent's answers of
2 Nov 2026). **It is a refactor: nothing changes for the child and the golden runs stay identical.** New condition words change nothing
until data uses them; moving story pieces to them is `story/07`.

## Problem Statement

"When" in the data (story pieces, interface elements that appear, golden acorns, perks) is meant to be one small language, but it is
spread over four places kept in step by hand. The core kit parses the grammar, while every word is a branch of two large `match` blocks
in the Game's front door (27 counters, 9 terms) that grow with every new system. The pets' WHEN cards have a second little language of
their own, with "fewer than", that nothing else can use. The data checker reads the counter names out of the front door's source text
and has two validators that disagree, so one condition can be valid in a story piece and an error in a perk. The language cannot say
"not" or "fewer than", and has no words for pests, rain, energy, water or "a goal can be started now". That is what the story-timing
issues C5 and C6 ask for, and they wait on it.

## Solution

One condition module owns the whole language: the grammar (at least, fewer than, `not:`, one argument per word, a list meaning all) and
a register of condition words. Each farm system registers its own words next to the data they read; the front door keeps only the
Game's own. The module lists its words, the game writes the list to a file next to the data, and the checker reads that file with one
validator for every place a condition is used. The pets' WHEN cards become ordinary conditions with a gap for the child's number. The
luck events' "when" (a trigger) is renamed "on". New words: pests, rain, energy, water, open goal, stones, the most weeds on a patch,
empty patches.

## User Stories

1. As the child, I want the game to play exactly as before, so that nothing I know changes.
2. As the child, I want my pets' WHEN cards to look and work as before (picture, name, slider), and my saved choices to stay.
3. As the parent writing story pieces, I want to say "not yet done" (`not:done:barn`) and "fewer than" (`water<5`).
4. As the parent, I want story words for pests, rain, energy, water and a goal that can be started now, so a piece can come at the right moment.
5. As the parent, I want one way to say each thing (`item:carrot>=3`, never `has:carrot:3`; `chapter<4`, never `chapter:3`).
6. As the parent, I want a typo in a condition to be an error in the data checker, and never to show a piece at once in play.
7. As the parent, I want a condition that is valid in a story piece to be valid in a perk, an acorn and a reveal too.
8. As a session adding a system, I want to add its condition words in its own file, next to its data, without touching the front door.
9. As a session adding a word, I want the checker to know it after one command, and to be told when I forgot that command.
10. As anyone reading the data, I want `when` to always be a condition, and a chore that just happened to be written `on`.

## Implementation Decisions

- **The module** stays in the core kit and knows nothing about the farm: the grammar, the register (`register(word, reader, info)`:
  the kind of argument it takes, a note, an example) and `vocabulary()` (every word with its info). Readers return a number or yes/no.
- **Grammar.** `<word>[:<arg>]>=<n>`, `<word>[:<arg>]<<n>`, a yes-or-no word with or without argument (`rain`, `season:winter`),
  `not:<condition>`, a list = all. `done:` / `unlocked:` and `seen:` stay. The reveals keep `whenAny`. No `or`, brackets, `<=`, `==`.
  A condition that uses a word nobody registered is false as a whole, also behind `not:`.
- **Who owns which word.** The Game: `step`, `chapter`, `coins`, `goals`, `start`, `chance:`, `done:`/`unlocked:`, `seen:`. Every other
  word moves to the system that owns what it reads (seasons, fields, inventory `item:`, trade, rewards, needs, knowledge `page:`, story
  `tap:` `after:` `story_seen`, trip, skills, well, forest, lord, pets). The two `match` blocks in `game.gd` go.
- **New words.** `pests`, `rain`, `energy`, `water`, `open:<goal>`, `stones`, `weeds_max`, `empty_patches`. No frost word, no `stat:`.
- **Data changes (same meaning).** `has:<item>:<n>` → `item:<item>>=<n>`; `chapter:N` → `chapter<N+1` in the 8 story pieces; the luck
  events' `"when": "<chore>"` → `"on": "<chore>"`.
- **Pets' WHEN cards.** Each card keeps emoji, name, min, max, step, default and gets `"when": "<condition with {n}>"`
  (`weeds_max>={n}`, `empty_patches>={n}`, `water<{n}`, `item:compost<{n}` …) instead of `stat` / `item` / `op`. The save keeps card + number.
- **The checker.** A tool run of the game writes the word list (each word with its argument kind: none, number, item, goal/node, season,
  story piece or interface element, place, card) to a file next to the data. `check_data.py` reads it and uses one validator for story,
  reveals, acorns, perks and the pets' cards (with `{n}` filled in). A check fails when the file no longer matches the code.

## Testing Decisions

- **One seam: the condition module** ("does this condition hold?", "which words are there?").
- **New headless test:** every registered word answers without error on a new game and on each fixture, and has a note and an example;
  the grammar (`>=`, `<`, `not:`, argument, unknown word false also behind `not:`, lists); every pet WHEN card answers as the old code did
  for each number of its slider, on a new game and on the fixtures.
- **Golden runs** short and full identical; if not, stop and find the cause. Smoke test; save fixtures; data checks.
- Story pieces, reveals, acorns and perks get no tests of their own for this (they only pass their conditions through).

## Out of Scope

- Retiming story pieces with the new words (`story/07`, after this feature), and the other story-timing issues (C1, C2, C4, C7–C9).
- Changing what the pets do or when, and the automated chores (`pets-automation`).
- The interruption queue (what takes the screen next).

## Further Notes

- Facts found in the code (2 Nov 2026): grammar in `kits/core/conditions.gd`; `counter()` and `term()` in `game.gd`; `holds()` in
  `systems/pets.gd`; `condition_ok` and `story_condition` in `tools/check_data.py` (the counter list is read with a regex from
  `game.gd`). Conditions are read in `systems/story.gd`, `systems/reveal.gd`, `systems/rewards.gd` (acorns, perks).
- The review's sketch (Part B §3, "Before / after") is the shape; names may change in the build.
