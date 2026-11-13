# 11: The grandchildren's frame between chapters is a full-screen scene with its own music

**What to build:** Right after a chapter ends and before the next begins, the game shows the grandchildren's story as a full-screen black scene: only text and pictures, no top bar, no farm. The player taps through it. Different music plays there.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The frame between chapters (and the opening) takes the whole screen: no status bar, no farm visible
- [x] It runs right after the chapter's last beat and before the next chapter starts
- [x] Tapping advances page by page; Skip from the second viewing stays; everything stays readable in the 📜 scroll
- [x] A different music track plays and the farm music returns afterwards (an existing track as stand-in; the parent can supply another, see W8)
- [x] Smoke test: it does not open during a quiz, Rest or a pop-up

---

**Feature:** `story` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.11]. Filed 23 October 2026.

The parent's words:

> [#23.11] the story elements with the grand children need to hapen right after the end of a chapter and before the next one begins. It takes up the whole screen. No status bar at the top visible, no farm, just a black screen with text and pictures, tapping through the story between chapters that frames it all. Also, different music there.

## 💡 Decisions to confirm

All easy to undo; the parent can say no to any.

- 💡 **The stand-in music is the calm Rest track** (`data/sounds.json`: track `frame`, file `rest.ogg`, volume -18, `from` the same Kevin MacLeod file so `tools/import_sounds.py` keeps working). To change it: put another file in `sound-inbox/` (W8) and change `frame`'s `from`/`file`, or point `file` at `farm_winter.ogg` (calm, a little magical, but it clashes when the farm is in winter).
- 💡 **The frame closes its chapter by a rule in `G.story`**: nothing of a later chapter is ready until every earlier chapter's frame was shown (`frame_owed`), so the frame cannot be overtaken by the next chapter's first beat (before this, `c2_letter` could show before `c1_frame1`). To undo: delete `frame_owed` and its line in `is_ready`.
- 💡 **The frame waits for the farm to finish catching up after a quiz** (`catchup` in its `waitsFor`), which story boxes do not; the child sees what the last answer did first. To undo: remove `"catchup"` from the `frame` entry in `rules/65-feel.json` (and in the `today` table of `tests/interruption_test.gd`).
- 💡 **Controls:** a tap anywhere goes on; a quiet ⏭ Skip top right from the second viewing (not on the last page); 🔊 bottom left; dots and a breathing → (✔ on the last page) so the child does not need to read an instruction. No ✖. Fade-in per page 0.4 s (`story.frameFade`).
- 💡 **Closing a sheet now asks the queue to pump** (`sheets.close_sheet`), so a frame (or a story box) that waited for the sheet comes at once instead of at the next change on the farm.

## What was built (9 Nov 2026)

- `game/farm/ui/framescene.gd` (`FarmUiFrameScene`, `M.frame_scene`): the full-screen black scene (picture or big emoji, words, title small, ⏭ Skip from the second viewing, 🔊, page dots, → / ✔); a tap on it goes on, the last tap leaves, the farm's music returns and the queue is asked again. Pictures come from the story box (`FarmUiStory.page_picture`, `emoji_of`).
- A new queue kind `frame` (`rules/65-feel.json`, between `scene` and `story`; story, news and bark wait for it); the scene counts as a pop-up for the queue (`interrupts.gd`), so notes, postcards, celebrations and boxes wait while it is open. `storybox.gd` hands pieces of kind `frame` to it, also when read again from the 📜 scroll.
- `G.story.frame_owed(chapter)` (`systems/story.gd`): the frame closes its chapter.
- Music: track `frame` and `music.play.frame` in `data/sounds.json`; `Sound.playing_track()`; `main.gd` keeps the farm music off while the scene is open.
- Tests: `story_test` (+7 checks: 47), `interruption_test` (the new kind in the order, the table, five new checks: 169), `ui_smoke` block "story/11" at the very end (waits for a pop-up, the Time Quiz, Rest and a sheet; covers the screen; own music and the farm's back; tap by page; no Skip the first time; read again from the scroll with Skip), the driver's `frame_*` functions; the smoke test's start closes the opening frame with `D.frame_close()`.
- Docs: `docs/design/friends-and-story.md` §11.6, `game/farm/ui/README.md`, `godot-prototype/README.md` (the `--story=ID` flag).
- The story text is untouched.

Play-test: the opening of a new game (black scene, three pages, then the stalk box); the frame after the bunny (chapter 1 to 2); whether the music change is felt and whether the Rest track is the right stand-in; tapping through with a child's fast fingers (a double tap skips a page: no input lock yet).

