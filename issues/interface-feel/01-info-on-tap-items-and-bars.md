# 01: Tapping an item or a bar tells more about it

**What to build:** Tapping an item tile or a bar (energy, water, bag, coins) opens a short note: what it is, the numbers, and what fills or drains it.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] An item tap shows name, a short description, count, grade and how much room it takes
- [ ] A bar tap explains what raises and lowers it, in the child's words
- [ ] Works on the iPad (tap, no hover); read-aloud mode is respected
- [ ] German through `tools/i18n.py`; smoke test checks one item and one bar

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`planning/2026-10-23-parent-notes-playtest.md`), [#23.31]. Filed 23 October 2026.

The parent's words:

> [#23.31] tapping an item or a bar should give additional info. tapping a grayed out button should give some info as why it is grayed out and what it will need.
