# 16: The workbench is empty when it is first built

**What to build:** When the workbench is first built it shows an empty bench everywhere it appears. Today a hammer is on it somewhere (the parent saw it in the test run of 14 Nov 2026). The map already uses the empty picture and lays made tools on it, so find where the picture with the hammer still shows: the place's window, the workshop's inside, the build button, or a tool laid on the bench that has not been made.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The place with the hammer is named in a `## Progress` note (a screenshot of a fresh workbench: map, window, inside)
- [x] Everywhere the bench shows, it is empty until a tool is made, and each made tool then lies on it
- [ ] Smoke test and `check_all.sh --short` pass

## Progress

Cause: `data/farm/places.json` "bench" listed `{"id": "rock", "pic": "stone_hammer"}`; the node `rock` has no cost or requirement, so it counted as done at once and the hammer lay on a fresh bench (map, window and inside alike). The entry is removed (the rock is not made at the bench). `places_test` bench recording differs: re-record. `check_all.sh --short` not run by the agent; no screenshot taken.

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.9]. Filed 14 November 2026.

The parent's words:

> [#14.9] The workbench should be empty at first when it is built first (right now it still has a hammer on it)
