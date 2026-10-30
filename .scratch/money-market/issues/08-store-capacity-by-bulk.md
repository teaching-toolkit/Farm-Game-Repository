# 08: Store capacity depends on how bulky things are, like the bag, instead of 10 of everything

**What to build:** Today the store holds 10 of each thing at first. Instead its capacity is counted in load units, like the bag: it holds many feathers and few logs. Upgrades raise it.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** prototype

- [ ] A short plan is written into this ticket first (session skill §3): units, starting numbers, upgrades, saves
- [ ] The store counts the weight classes of M4 instead of a count per item
- [ ] Store upgrades raise the capacity; old saves load
- [ ] Bot and golden runs re-checked (re-recorded on purpose if the pace changes)
- [ ] The store tile or bar shows the room left; German through `tools/i18n.py`

---

**Feature:** `money-market` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.37]. Filed 23 October 2026.

The parent's words:

> [#23.37] capacities for stuff in the storage is 10 for all at first and more later on. It needs to be scaled to the bulk/size/weight or whatever the parameter is called. So it can hold a lot of some things but not others. Similar to the bag.
