# 11: Bug: the testing (cheat) buttons are on by default; they must be off

**What to build:** A new player never sees the testing buttons unless a grown-up switches them on in Settings. `archive/todo-2026-10.md` J9 says they are off by default, but `data/settings.json` still starts them on (`showCheatButton: true`).

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The starting value in `data/settings.json` is off
- [x] The grown-up setting still switches them on and off
- [x] Tests that rely on the buttons switch them on explicitly
- [x] A device that already saved the setting keeps its choice (say so in the log)

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.38]. Filed 23 October 2026.

The parent's words:

> [#23.38] turn cheating buttons of by default. Right now they are on by default.

## Result (3 Nov 2026)

- `data/settings.json` `showCheatButton` is now `false`; the fallbacks in `game/farm/game.gd` (`load_settings` default and `cheats_visible()`) are `false` too.
- The grown-up switch (⚙️ Settings, grown-up part, "Testing buttons on the farm") is unchanged and still toggles them.
- No test relied on the buttons (the bot and the tests call `G.cheat_max` etc. directly; `--demo`/`--cheat` flags are unaffected). The UI smoke test now switches them on explicitly through the grown-up switch and checks: off at the start, on, off again (`tests/ui_driver.gd` `cheats_shown()`).
- A device that already saved a choice keeps it: the choice lives in `user://device.json` (`cheatButtons`), which wins over the starting value. A device that never touched the switch now starts with the buttons off (the parent's laptop too, unless it was switched once).
- Checked: smoke test line "testing buttons: off at the start true, switched on true, switched off true"; all unit tests OK; short golden runs identical (332 and 525 steps); screenshot of a fresh farm shows no testing buttons.
- Play-test: on the laptop, if the buttons are still there, the device saved the choice earlier; switch them off once in Settings.
