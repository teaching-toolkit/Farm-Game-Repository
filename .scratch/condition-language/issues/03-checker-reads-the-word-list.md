# 03: The data checker reads the game's word list, with one validator

**What to build:** The game writes its list of condition words (each with the kind of argument it takes) to a file next to the data.
The data checker reads it and checks every condition (story pieces, reveals, golden acorns, perks) with one validator, so a condition
valid in one place is valid in all. A check fails when the file no longer matches the code. The data says each thing one way:
`has:` becomes `item:`, `chapter:N` becomes `chapter<N+1`, and the luck events' `"when": "<chore>"` becomes `"on": "<chore>"`.
Nothing changes for the child.

**Blocked by:** condition-language/02

**Status:** done

**Milestone:** refactor

- [x] One command writes the word list; a check (in the quick checks) fails when it is out of date
- [x] The checker no longer reads the front door's source; one validator for every place a condition is used; an unknown word is an error
- [x] `has:` → `item:`, `chapter:N` → `chapter<N+1` (8 story pieces), luck events `when` → `on`; `has:` and `chapter:` are no longer words
- [x] Data checks pass with 0 errors; short and full golden runs identical; the explorer still reads the data

**Feature:** `condition-language` · **Source:** `.scratch/condition-language/spec.md` and the grilling in `01-grill-and-spec.md`. Filed 2 Nov 2026. Words: `GLOSSARY.md`.

## Result (2 Nov 2026)

`data/farm/condition-words.json` is written by `tests/conditions_test.tscn -- --seed=1 --write-words`; the test fails when it no longer
matches the code. `check_data.py` reads it; one validator (`condition_ok`) for story pieces, reveals (`when` and `whenAny`), acorns, perks and
the words' own examples; it no longer reads `game.gd`. The luck events and the lucky acorn say `"on"`; a `when` on a luck event is an error.
Planted mistakes (unknown word, `has:`, `chapter:5`, `coins` without a comparison, a wrong item or season, a bad number, `not:` of an unknown
word, a node that doesn't exist) are all reported; the real data has 0 errors.
