# 05: New condition words for the story (C5, C6)

**What to build:** The words the story-timing issues ask for, each registered by the system that owns what it reads: `pests` (pests on
the field now), `rain` (it rained in this question), `energy`, `open:<goal>` (the goal can be started now: what it needs is there and it
is not done), `stones` (stones picked so far). With `not:` from 02 this settles C5 and C6; no story piece uses them yet (`story/07`).

**Blocked by:** condition-language/02, condition-language/03

**Status:** done

**Milestone:** refactor

- [x] The five words registered with a note and an example, and in the word list file
- [x] Headless test: each new word answers as the farm's state says (pests added, rain on, energy and water set, a goal opened, stones picked)
- [x] Golden runs identical (no data uses the words yet); data checks pass
- [x] `story/game/code-issues-story-timing.md`: C5 and C6 marked as solved in code, with the words available; `story/07` can use them

**Feature:** `condition-language` · **Source:** `.scratch/condition-language/spec.md` and the grilling in `01-grill-and-spec.md`. Filed 2 Nov 2026. Words: `GLOSSARY.md`.

## Result (2 Nov 2026)

`rain` (seasons), `energy` (needs), `open:<node>` (progression: what it needs is there and it is not done; false for a node that doesn't
exist), `stones` (fields); `pests` came with 04. 45 words in all. The conditions test checks each new word against the farm's state.
