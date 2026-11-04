# 14: Each change of season gets a text-and-picture box

**What to build:** When a season changes, a box with a picture and a short text tells what changes now. Today the text is a note next to the market news (N8).

**Blocked by:** `interruption-queue/04` (the new box is one more kind in the queue's order list)

**Status:** done

**Milestone:** prototype

- [x] One box per season change with a picture (placeholder until `pictures/12` has them) and the season text
- [x] The N8 text and the market news line move into or beside it without being said twice
- [x] Shown only at a quiet moment; Skip and re-reading in the 📜 scroll as for the story box
- [x] German through `tools/i18n.py`

---

**Feature:** `story` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.7]. Filed 23 October 2026.

The parent's words:

> [#23.7] season changes need a text and picture box

## Result (3 Nov 2026)

Built: a change of season makes one news box (`seasons.season_box`): title "It's summer!", the season's intro text (N8), the plenty line and the market news in the small line, the picture `season_<name>` (until `pictures/12` is painted: the season's emoji). The market news is no longer a separate note (`trade.season_news` now returns the line). A newer season box replaces one still waiting. The 📜 scroll has a *Seasons* section to read the boxes again (it is also open when only seasons have passed). German through `data/i18n/*.json`. Design: `docs/design/seasons.md`, `friends-and-story.md`.

Checked: story test (summer box arrives with the market news and picture name; no second note; replaced / capped), market test 24 checks, short golden runs identical. Screenshots: `/home/claude/patches/story-shots/14-season-en.png`, `14-season-de.png`, `14-scroll-en.png`.

Not done: a Skip button (the box has one button, "Got it"; a season box is one page, so Skip adds nothing). Play-test: the season box at each of the four changes.
