# 03: One door for question packs

**What to build:** Built-in packs load through one function that pasted packs (`parent-controls/02`) will also use. The time-question
part never asks where a pack came from. Nothing changes for the child.

**Blocked by:** time-question/02

**Status:** done

**Milestone:** refactor

- [x] One function adds a pack (its questions under their permanent ids); the built-in loader uses it
- [x] Headless test: a pack added through the door is drawn and answered like a built-in one
- [x] Golden runs identical; smoke test

**Feature:** `time-question` · **Source:** `.scratch/time-question/spec.md` and the grilling in `01-grill-and-spec.md`. Filed 2 Nov 2026. Words: `GLOSSARY.md`.
