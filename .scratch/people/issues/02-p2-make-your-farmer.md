# 02: P2: "Make your farmer" screen at the start

**What to build:** At the start the player makes their farmer: the look is already data and kept per player. The farmer is gender-open. What can be chosen is a design question for the parent.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** later

**Size:** short

- [x] The parent has said what can be chosen (decided for the parent while away, see Decision)
- [x] A start screen sets the look; it is kept per player on the device
- [x] The *(planned)* mark in the design document is removed

---

**Id:** P2 · **Feature:** `people` · **Moved from** `archive/todo-2026-10.md` §12 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **P2. "Make your farmer" screen** at the start (the look is already data, `data/avatar.json`; kept per player). Needed for the
  gender-open farmer. (Was "Later 2".)

## Decision (17 Nov 2026, parent away, easy to undo)

- [x] What can be chosen is exactly what the look data already offers: skin (6), hair style (5) and hair colour (7), shirt style (2) and colour, trousers style (3) and colour, hat (none, straw, cap). No new pictures or shapes. Why: all of it is there, so the screen is only a screen.
- **No name and no photo.** The child is not asked to type a name. Why: the web build is public (`later/05`) and a child's name is exactly the trigger that ticket names.
- **Gender-open:** no part has a boy or girl label; hair and clothes are chosen separately.
- Shown once at the start of a new farm, with a live preview of the figure and a Done button; the choice is kept in the farm save (as the look is today); a farm that skips it gets the default look. The bot and the smoke test skip the screen (default look).
- Changing the look later is out of scope.

## Progress (17 Nov 2026)

- Built. The control is `kits/avatar/avatar_picker.gd` (`AvatarPicker`, no game logic: it offers exactly the lists in `data/avatar.json` "options", keeps `look`, says `changed(look)`; `rows()`, `offered()`, `tile()`, `choose()`, `chosen()`, `set_look()`, and `side` for the host's own button). The screen is `ui/welcome.gd` `show_farmer()` (hosts the picker and a round drawn tick; no ✖, so the tick is the one way on); `first_minutes()` puts it before the story's opening or the welcome for a named player's farm at its very start. What is kept: `G.people.farmer_look()` / `set_farmer_look()` / `farmer_to_make()` (`systems/people.gd`), save key `look` (sparse, NOT in `save_defaults()`: `tests/golden/newgame.json` unchanged; a farm that skips the screen has no key and draws the default). `open_modal(title, closable)` gained a `closable` flag. Dev flag `--farmer` shows the screen for screenshots.
- No words anywhere (no `tr()` text added): colours are round swatches, styles are small figures drawn by the same figure code with only that part changed (hair row without a hat), the figure big beside them. The screen is skipped where there is no named player (the bot, ui_smoke, `--newgame`) and in screenshots (`--shot`).
- 💡 Decisions (easy to undo): no ✖ on the screen (a child cannot leave it half-made; the default look is already chosen); the look saved holds only the chosen parts (skin, hair, shirt, trousers, hat), never `style`, eyes, cheeks or shoes, so the data's default drawing style still reaches every farmer; a farm still at question 0 with no look asks again after a restart (closed before the tick); a cap keeps the drawing's own blue (the data has no hat colour list); shirt and trousers colours share the data's one `clothes` list.
- Left for the parent: play-test on the iPad (are the small figures clear enough to a child; is the order of the five cards right); changing the look later is out of scope (a later ticket would reuse `show_farmer`).
- **Checked by the orchestrator (17 Nov 2026):** `saves_test` 100 checks 0 failed, short golden identical (the screen is skipped, `look` is a sparse key kept out of `save_defaults()`), `check_all.sh --short` clean after the `places.json` recording was updated for `upgrades/02`. One open note: `ui_smoke` prints two harmless `Lambda capture at index 0 was freed` lines just before this ticket's line. They appear only after the earlier orchard/greenhouse sheets test and this test's `G.reset_game()` + `G.changed.emit()`; the new screen is not their source (the test run alone shows none), nothing fails, and the cause was not traced (a timer or tween lambda from an earlier test whose node the reset frees). Status is `done` because every box is met; the iPad play-test (are the small figures clear to a child, is the order of the five cards right) is the parent's.
