# 02: Tapping a greyed-out button says why it is grey and what it needs

**What to build:** A greyed-out button answers a tap with a short note: why it cannot be used now and what it will need (energy, an item, a card, a season).

**Blocked by:** the whole `farm-actions` feature: its "what would this cost, and can I do it?" answer carries the child-friendly reason (the parent can lift this block if they want it sooner)

**Status:** ready-for-agent

**Milestone:** prototype

- [ ] Every greyed-out action button gives a reason on tap, never a silent grey
- [ ] The reason comes from the same rule that greys the button, so button and rule cannot disagree
- [ ] German through `tools/i18n.py`; a test covers at least one reason per kind (energy, item, season, unlock)

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.31]. Filed 23 October 2026.

The parent's words:

> [#23.31] tapping an item or a bar should give additional info. tapping a grayed out button should give some info as why it is grayed out and what it will need.
