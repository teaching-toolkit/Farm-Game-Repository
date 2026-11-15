# 08: I15: Build the 166 new story pieces into the game

**What to build:** The parent reads the 166 new pieces aloud and strikes or fixes them; then the German is written, the pieces are copied into the game data, and the checks pass. Hand-testing covers the 41 pieces the bot cannot fire.

**Blocked by:** `story/04` (I17) and `story/05`: the texts change with them

**Status:** done

**Milestone:** story

- [x] (dropped, see Unblocked) The parent has read `story/game/texts/more-ch1.md` to `more-ch6.md` aloud and marked changes
- [x] German translations exist ("ss"); the i18n coverage check passes
- [x] `story/game/staging/more-ch*.json` is copied into `data/farm/story/`; smoke test and bot pass
- [x] Pictures exist or are ticketed (`story/26`) (I11) for the pieces that need one
- [x] (moved to `story/27`, the parent's play-through) The 41 pieces the bot cannot fire are hand-tested (list in `story/archive/consistency-fixes.md` §7)

## ✅ Unblocked (14 Nov 2026)

The parent has read the novella and answered every story question (`story/QUESTIONS-FOR-THE-PARENT.md`). The pieces are no longer read aloud first: they are compressed from the novella chapter by chapter ([story ADR-0001](../../../story/docs/adr/0001-novella-is-the-source.md)), with the staging of `story/25`, and the parent reads each chapter in play. The first box (reading aloud) is dropped.

---

**Id:** I15 · **Feature:** `story` · **Moved from** `archive/todo-2026-10.md` §15 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **I15. Build the 166 new story pieces into the game** 💡 (Round 6b): read `story/game/texts/more-ch1–6.md` aloud and strike or fix; then German translations (`data-de.json`, „ss“), copy `story/game/staging/more-ch*.json` into `data/farm/story/`, run the i18n check, smoke test and bot, and add pictures for the pieces that need one. Until the German exists the coverage check fails, so nothing was put into the game data. Hand-test the 41 pieces the bot cannot fire (taps, margin notes, optional favours; list in `story/archive/consistency-fixes.md` §7). 💡 The consistency pass of 14 Oct 2026 is applied to the texts (`story/archive/consistency-fixes.md`; still 166 pieces: 51 / 29 / 29 / 19 / 14 / 24).

## Progress

24 Oct 2026: the story outline run is closed (`story/README.md`). The master outline keeps these 166 pieces as the base and lists changes to them in `story/game/text-change-requests.md` (ticket `story/20`). Decide which of those rows to take before or while reading the pieces aloud; status unchanged.

14 Nov 2026: chapter by chapter, one Sonnet agent each (brief: the novella's chapter, `chN.md`, `more-chN.md`; keep, rewrite, drop or add; German; `NN-chapter-N-more.json` into the game). **Chapter 1 built:** 63 staged pieces (12 new) and 4 shipped ones rewritten.

14 Nov 2026, evening: **all six chapters are built from the novella.** Shipped pieces rewritten 4 / 7 / 6 / 4 / 6 / 10 of 25 / 16 / 13 / 9 / 11 / 18; staged pieces in the game 63 / 38 / 40 / 32 / 25 / 40 (new from the novella 12 / 12 / 12 / 13 / 12 / 16; dropped 0 / 3 / 1 / 0 / 1 / 0). The name Mumyo appears only in the last frame. The miller's mill is water powered (the parent, same evening). Open and moved to their own tickets: pictures for the new pieces (`story/26`) and the parent's play-through with the list of things to judge (`story/27`).
