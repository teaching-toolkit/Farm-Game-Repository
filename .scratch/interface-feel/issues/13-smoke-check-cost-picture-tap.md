# 13: The smoke test's check "a cost's picture" fails on the Mac

**What to build:** The smoke test line `info/item` reports `a cost's picture false`, so `check_all.sh` ends red although the game is fine as far as is known. Find out whether the tap on a cost's little picture really gives its note in the game, then make the check reliable (or fix the game).

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [ ] In the running game (not the test), a tap on a cost's little picture in a goal's card shows the note "It needs N. You have M." (try on the Mac and in the Linux shell)
- [x] The cause of the failing check is named
- [x] The smoke test passes on the Mac, three runs (the Linux shell was not tried: no such shell in this session)

---

**Feature:** `interface-feel` · **Source:** found on 10 Nov 2026 (wave 2), looked at on 13 Nov 2026. It passed when `interface-feel/01` was built (9 Nov, Linux shell).

## What is known (13 Nov 2026)

The check (`tests/ui_smoke.gd`, "a cost's little picture is tappable") adds a cost row `{stick: 3}` to the open store sheet and taps its first
entry through the real input path. No note appears (`D.info_note()` is `{}`); the row is still in the tree afterwards.

- The row's place changes while the check runs: 789 px from the top just before `_tap`, 713 px just after. So the sheet is still
  changing its height around the tap (the screen is 1166 wide at that point, an earlier step resized it).
- Three fixes were tried, one at a time, and none helped: moving the row to the top of the sheet; waiting 8 frames before the tap;
  calling `M.sheets.fit_sheet()` and waiting 6 frames before the tap. After three, the debugging rule says stop.
- The mouse filters look right (`UI.cost_row`: the entry is PASS through `UI.info`, its picture and cubes are IGNORE).

**Next idea, not tried:** print in `UI._info_input` whether the entry gets the press and the release at all, and what control is under the
tap (`get_viewport().gui_get_hovered_control()`), to tell a missed tap from a note that is closed again at once (the info layer's `Catcher`
closes a note on any press outside its card). The screenshot flag `--note=item:stick` shows the note without a tap.

## Result (15 Nov 2026)

**Cause:** the store's window slides up by the clock, not by frames, so on a fast machine the check tapped the cost's picture while the row was still moving, and the tap landed beside it. The game is fine. The check now waits until the row has stood still for six frames before it taps. Three runs on the Mac pass. The first box (trying it by hand in the running game) is left to the parent's next play.
