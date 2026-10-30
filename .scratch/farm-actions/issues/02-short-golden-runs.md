# 02: Short golden runs to the end of chapter 2

**What to build:** A quick safety net for every later slice: `golden.sh` can stop at a chapter, and there are saved short golden files for seeds 1 and 2 that end at chapter 2. Nothing in the game changes.

**Blocked by:** None (can start immediately)

**Status:** done (23 Oct 2026)

**Milestone:** refactor

- [x] `golden.sh` takes a chapter limit (default stays chapter 6)
- [x] New short golden files for seeds 1 and 2 are saved and the short run is identical when repeated
- [x] The full golden files are unchanged and still identical
- [x] `check_all.sh` can run the short pair; the README of the tests folder and the session skill say when to use the short and when the full run
- [x] The note "golden runs do not need to run through all chapters every time" is written where sessions read it

---

**Feature:** `farm-actions` · **Source:** `.scratch/farm-actions/spec.md` in this folder and the decisions in `.scratch/farm-actions/issues/01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
