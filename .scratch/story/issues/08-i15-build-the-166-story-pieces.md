# 08: I15: Build the 166 new story pieces into the game

**What to build:** The parent reads the 166 new pieces aloud and strikes or fixes them; then the German is written, the pieces are copied into the game data, and the checks pass. Hand-testing covers the 41 pieces the bot cannot fire.

**Blocked by:** `story/03` (I16) and `story/04` (I17): the texts change with them

**Status:** needs-parent

**Milestone:** story

**Size:** sitting

- [ ] The parent has read `story/game/texts/more-ch1.md` to `more-ch6.md` aloud and marked changes
- [ ] German translations exist ("ss"); the i18n coverage check passes
- [ ] `story/game/staging/more-ch*.json` is copied into `data/farm/story/`; smoke test and bot pass
- [ ] Pictures exist or are ticketed (I11) for the pieces that need one
- [ ] The 41 pieces the bot cannot fire are hand-tested (list in `story/archive/consistency-fixes.md` §7)

---

**Id:** I15 · **Feature:** `story` · **Moved from** `archive/todo-2026-10.md` §15 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **I15. Build the 166 new story pieces into the game** 💡 (Round 6b): read `story/game/texts/more-ch1–6.md` aloud and strike or fix; then German translations (`data-de.json`, „ss“), copy `story/game/staging/more-ch*.json` into `data/farm/story/`, run the i18n check, smoke test and bot, and add pictures for the pieces that need one. Until the German exists the coverage check fails, so nothing was put into the game data. Hand-test the 41 pieces the bot cannot fire (taps, margin notes, optional favours; list in `story/archive/consistency-fixes.md` §7). 💡 The consistency pass of 14 Oct 2026 is applied to the texts (`story/archive/consistency-fixes.md`; still 166 pieces: 51 / 29 / 29 / 19 / 14 / 24).

## Progress

24 Oct 2026: the story outline run is closed (`story/README.md`). The master outline keeps these 166 pieces as the base and lists changes to them in `story/game/text-change-requests.md` (ticket `story/20`). Decide which of those rows to take before or while reading the pieces aloud; status unchanged.
