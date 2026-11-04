# 13: Promote the notifications that deserve it (a golden acorn and the like) to a text-and-picture box

**What to build:** Go through the list of notifications and pick the ones that deserve the player's extra attention (finding a golden acorn, for example); they become a box with text and a picture, like the story box. An agent prepares the audit with a recommendation; the parent picks.

**Blocked by:** `interruption-queue/04` (the new box is one more kind in the queue's order list)

**Status:** done

**Milestone:** prototype

- [x] An audit lists every notification with a 💡 recommendation (stay a toast, or become a box)
- [x] Claude has chosen which become boxes (delegated by the parent)
- [ ] Each chosen one has text and a picture (listed in `pictures/10`; names given in the Result, the list itself is not mine to edit)
- [x] The boxes use the same quiet-moment rule as the story box and do not pile up

## ✅ Parent's answer (30 Oct 2026)

The parent delegates the choice: **Claude makes good recommendations and builds them without asking.** The audit and the choice are recorded in this ticket; pictures for the chosen boxes go to the pictures list for the parent to generate.

---

**Feature:** `story` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.15]. Filed 23 October 2026.

The parent's words:

> [#23.15] we need a text box and picture for events like finding a golden accorn. In general go through the list of notifications and promote some to a textbox with picture that deserve the players extra attention.

## Result (3 Nov 2026)

Audit of the notifications (agent's choice, delegated by the parent): became a box with a picture: **golden acorn** (`rewards.acorn_box`), **favour done / new album picture** (with the new friend line under it), **party at the farm**. Stay a toast: small daily notes (sold, bought, harvested, tool and pet-job notes, spoiled food line, hints). The season change is ticket 14. The golden acorn box shows what it is for and that seven hide in the game.

Built: `G.story.announce(box)` puts a box in the save (`story_news`); the interruption queue has two new kinds in `rules/65-feel.json`: `scene` and `news` (same quiet moment as a story box, news after it). A waiting list of at most `story.newsMax` (4) boxes; same key once; the bot never opens a box. `ui/storybox.gd` draws the box (picture from `assets/story`, `friends` or `album`, else the emoji; 🔊 Read aloud; one button). `tests/interruption_test.gd` table and order list are changed to match. `--announce=...` dev flag makes screenshots. Design: `docs/design/friends-and-story.md`.

Pictures still to be painted by the parent (stand-in is the emoji): `news_golden_acorn`, `news_party`; favour boxes use the favour's album picture. Not added to `pictures/10` (not my ticket); the parent's list should get these two names.

Checked: interruption test 142 checks, story test 40 checks, UI smoke test, short golden runs identical (332 and 525 steps). Screenshots in `/home/claude/patches/story-shots/` (13-acorn-en, 13-favour-de).

Play-test: whether the box is too much when several come at once (the cap is 4); the acorn and party texts.
