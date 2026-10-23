# 11: Bug: the testing (cheat) buttons are on by default; they must be off

**What to build:** A new player never sees the testing buttons unless a grown-up switches them on in Settings. `TODO.md` J9 says they are off by default, but `data/settings.json` still starts them on (`showCheatButton: true`).

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] The starting value in `data/settings.json` is off
- [ ] The grown-up setting still switches them on and off
- [ ] Tests that rely on the buttons switch them on explicitly
- [ ] A device that already saved the setting keeps its choice (say so in the log)

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`planning/2026-10-23-parent-notes-playtest.md`), [#23.38]. Filed 23 October 2026.

The parent's words:

> [#23.38] turn cheating buttons of by default. Right now they are on by default.
