# 10: Chapter 2: the farmer no longer wonders what caused the fire; he notices a clue and looks troubled

**What to build:** The farmer was there as a child when the farm burnt, so he cannot wonder what caused it. Reword that beat and similar ones: the farmer notices a clue and looks troubled, and it stays open whether he is unsure of what happened. The beat "Where the fire began" (`c2_barn`) says "You do not know what", and the frame line "Did you find out who started it?" (`ch2`) is similar.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] `c2_barn` and the frame line in chapter 2 are reworded as described, English and German ("ss")
- [x] All story texts (ch1–6, `more-ch1–6`) are searched for the same kind of line; each is reworded or listed as fine
- [x] The canon (`story/canon/00-premise.md`, the characters) says plainly that the farmer was there as a child
- [x] Story test, i18n coverage check and the bot pass

---

**Feature:** `story` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.3]. Filed 23 October 2026.

The parent's words:

> [#23.3] the story has the farmer wondering what caused the fire in chapter 2, which doesn't make sense since the farmer was there when it happened as a child. Reword this part and similar ones to the farmer noticing a clue and looking troubled, leaving it open if the farmer in unsure of what happened.

## Result (3 Nov 2026)

Built: the c2_barn beat now has the farmer look at the low corner, hands go cold, carry the beam out, "Not yet"; c2_hook says "You know this hook. Your hands go still."; the chapter-2 frame asks "And the corner in the barn? What did it mean?" and the answer is "Not then ... Later." English and German (ss) in `data/farm/story/15-chapter-2.json`, `data/i18n/data-de.json` and `story/game/texts/ch2.md`. Canon: `story/canon/00-premise.md`, `characters/fenna.md` ("Never in the texts") and `story-bible.md` (locked facts, Q13) say the farmer was there as a child (8) and never wonders what caused the fire.

Search: all `story/game/texts/ch1-6.md` and `more-ch1-6.md` searched for "who started / what caused / wonder / do not know what / didn't want to know"; no other line has the farmer wonder about the fire (the hits in ch6 and more-ch2 are about other things). Agent's choice: it stays open whether the farmer is unsure ("Not yet", "Later").

Checked: story test 40 checks, data checker 0 errors, translations ok, short golden runs identical. The data checker warns that `c2_barn` now has 72 words (boxes are 35-45); left as is, one trim would change the text in four places.

Play-test: read c2_barn, c2_hook and the chapter-2 frame once for tone.
