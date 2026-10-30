# Shipped vs written: what the player can meet today and what sits in files

Slice 00, 23 Oct 2026. Counts are computed from the files (not copied from earlier reports): shipped = `godot-prototype/data/farm/story/*.json` (80 pieces); written = `story/staging/more-ch1-6.json`, the JSON built from `story/texts/more-ch1-6.md` (166 pieces, English only, **not in the game**). Registers: G giggle, W warm, T tense, A awe. For the 166, the register is the tag in the file (a tag like `G→W` counts under its first letter, the "lead"). For the 80 shipped pieces the files carry no tag, so the register is **my reading (💡)**. The two sets share no piece id.

## 1. Totals

| | Shipped | Written, not shipped | Together |
|---|---:|---:|---:|
| Pieces | 80 | 166 | 246 |
| Words | 3,383 | 6,243 | 9,626 |
| Longest page | 54 words (rule: 54 or fewer) | 54 | – |
| With German | all 80 (`texts/ch1-6.md`, `data/i18n/data-de.json`; the rhyme lines 2, 3, 4, 6 do not rhyme in German) | none | – |
| With a painted scene | 31 of 80 (35 image files) | 0 | – |
| Pieces where somebody speaks (a quoted line) | 53 | 54 | 107 |

Note the file counts: `texts/ch1-6.md` carries 78 pieces; `c2_berit_note` and `c2_k_rest` exist only in the JSON (build step 4 in `consistency-fixes.md`). The 41 of 166 that do not fire in the headless bot (6 taps, 25 margin notes, 10 pieces tied to optional favours, a gift or a bark chance) are untested in play.

## 2. By chapter and kind

Kinds: shipped beats include the letters (no shipped piece has kind `letter`); frames are the seven bedside scenes. "Event-like" = not a bark, not a margin note (`page:` trigger) and not a frame. Steps are the bot's chapter lengths (`code-issues-story-timing.md`); a human takes longer.

| Ch | Steps | Shipped (kinds) | Written (kinds) | Total | Event-like | Steps per event-like piece |
|---|---:|---|---|---:|---:|---:|
| 1 Ashes | 244 | 17: 5 beat, 3 discovery, 1 visit, 6 bark, 2 frame | 51: 29 moment, 11 discovery, 1 scene, 10 bark | 68 | 44 | 5.5 |
| 2 Homestead | 176 | 13: 6 beat, 2 moment, 2 discovery, 1 visit, 1 bark, 1 frame | 29: 11 moment, 6 discovery, 4 scene, 1 visit, 1 beat, 1 letter, 5 bark | 42 | 30 | 5.9 |
| 3 Smallholding | 227 | 12: 5 beat, 3 moment, 1 visit, 2 bark, 1 frame | 29: 12 moment, 7 discovery, 2 scene, 2 visit, 1 beat, 5 bark | 41 | 28 | 8.1 |
| 4 Village Trade | 196 | 9: 4 beat, 1 moment, 1 discovery, 1 visit, 1 scene, 1 frame | 19: 4 moment, 5 discovery, 3 scene, 1 visit, 1 beat, 1 letter, 4 bark | 28 | 19 | 10.3 |
| 5 Healing | 61 | 11: 6 beat, 1 moment, 1 discovery, 1 visit, 1 scene, 1 frame | 14: 4 moment, 5 discovery, 1 scene, 4 bark | 25 | 17 | 3.6 |
| 6 Master Farm | 164 | 18: 10 beat, 7 moment, 1 frame | 24: 9 moment, 5 discovery, 6 scene, 4 bark | 42 | 34 | 4.8 |
| **All** | 1,068 | **80**: 36 beat, 14 moment, 9 bark, 7 frame, 7 discovery, 5 visit, 2 scene | **166**: 69 moment, 39 discovery, 32 bark, 17 scene, 4 visit, 3 beat, 2 letter | **246** | **172** | 6.2 |

Reading: chapter 4 is the thinnest in density (9 shipped, 10 steps per event-like piece), though chapter 5 is the shortest in steps. Chapter 1 is the richest and most mechanical (firsts, builds, taps). The charter's aim of 25-40 event seeds per chapter is already met in raw numbers for chapters 1, 2, 3 and 6 (counting all 246 pieces), borderline for 4 and 5; the problem is what the pieces are (section 4), not how many.

## 3. What the pieces are made of: triggers

Trigger families in the 246 pieces (a piece with three conditions counts three times): `done:<node>` 124, `chance` 41, `chapter:` 40, `seen:` 28, `page:` 26 (25 staged margin notes and the shipped `c1_book`), `season:` 18, `step>=` 10, `has:` 10, `after:` 9, `tap:` 7, `lord_shares` 6, `sidequests>=` 5, `forest_trips` 4, `seasons>=` 4, `trips>=` 3, `lord_paid` 2, `start` 2, `cards>=` 2, `forest_poisoned`, `harvests`, `friends` 1 each. Half the story hangs on building something. No piece uses `goals`, `coins`, `friends>=` (only one), `lord_owed`, `forest_checked`, `skill_ranks`, `sold_kinds`, `tap:patch:scrub/marsh`, `tap:pond`, or any negation (the engine has none).

Moves of the 134 non-bark staged pieces (the "Keeper's moves" tag in the files): Reward 41, Notice 26, Arrival 12, Plant 11, Complication 9, Level-up 9, Omen 9, Echo 7, Introduction 3, Lull 3, Consequence 2, Escalation 2. Reward + Notice + Arrival + Level-up = 88 of 134 (66 %): the written layer mostly says "you did a thing, here is a sensory reward or a note". Only Complication, Escalation and Plant (22 of 134, 16 %) put an obstacle in front of someone.

## 4. Registers

**Written (lead letter, 134 non-bark pieces):** W 71, G 44, T 12, A 7. By chapter:

| Ch | G | W | T | A | Story-order string (file order, not play order) |
|---|---:|---:|---:|---:|---|
| 1 | 20 | 19 | 2 | 0 | GWGGGTGWGWGGGWGWWGWWGTGWWWWWWGGWGGWWWGWGG |
| 2 | 8 | 11 | 3 | 2 | WGWGTWGAATGWWWGWWWWGTGWG |
| 3 | 7 | 13 | 3 | 1 | GWGWWWWAGWGWGWTTWWGWTWGW |
| 4 | 3 | 10 | 1 | 1 | WWAWGWWTWWWWGWG |
| 5 | 1 | 5 | 3 | 1 | TWWTTWAWWG |
| 6 | 5 | 13 | 0 | 2 | WWWWGAGWGWWAGWWWWGWW |

The written layer is warm (53 %) and comic (33 %), almost never tense (9 %). From chapter 4 on it is 65 % warm. Tension is carried by the shipped beats alone. Warmth sits in long runs (chapter 1 has six W in a row in the file; chapter 4 has four; chapter 6 has four, then four), so "every W earned by a G or T just before" cannot be guaranteed by the pieces, only by the engine's accidental order.

**Shipped (my reading 💡, in likely play order, the non-bark pieces):**

| Ch | Strip | Notes |
|---|---|---|
| 1 | `W W W A | G T G W | W T G` (frame0, stalk, book, night, bells, ledger, seller, board, bunny, bell_out, frame1) | the first four boxes are warm-warm-warm-awe; the first giggle is the fifth piece (the silly pile of sticks); no tension in the first hour except the stalk's question and the ledger |
| 2 | `T G G T G T | W W W | T W` (letter, walls, greenstem, stumps, lark, barn, compost, cottage, tortoise, hook, frame2) | healthy; one run of three warm (compost, cottage, tortoise); the tortoise (W) comes after two quiet Ws |
| 3 | `T T W G T W G W T G` (letter, Pieter, paid, forge, bell, stream, dance, goat, scarecrow hat, frame3) | the best-alternating chapter |
| 4 | `T G T T G W W T W` (Quill, count, lease, no, library, pizza, pony, quill_out, frame4) | `T T` at the peak, then `W W` (pizza, pony) with no giggle before the pony's warm beat |
| 5 | `T W T A W T T T W T G` (cough, stillroom, Wren, conch, tea, poison, page, collapse, badger, letter, frame5) | a run of three T (poison, page, collapse), no giggle for ten pieces (the first is the frame's joke about badger tea); three of those T are the same wound told three ways |
| 6 | `T G A W W T W W W G A W` + free play `W W W W G W` | warm-warm-warm after the bend; the last three main pieces are G, A, W (supper, garden edge, frame), so the book ends warm and aloof, not funny; the six free-play pieces that pay off the cousin, Quill, the miller and the squirrel are optional |

**Awe** (shipped): the first night (`c1_night`), the conch (`c5_conch`), the night garden (`c6_garden`), the edge of the garden (`c6_ajar`). Written A-lead: 7 (`c2_honey`, `c2_pond`, `c3_sails`, `c4_glass`, `c5_petals`, `c6_dye`, `c6_telescope`); 9 carry an A tag in any position (add `c4_watch` T→A and `c6_eve` W→A). The ladder promised three (chapters 1, 5, 6); the long-game plan allows ten (F-096 is still unanswered).

## 5. The longest silences

**In steps** (measured by the instrumented bot, `immersion-triggers.md` §2, seed 1; I did not re-run the game because `godot-prototype/` is in the frozen zone and the other agents are using it):

| Ch | Shipped only (before the 166) | With the 166 | Longest gap between non-bark pieces with the 166 |
|---|---:|---:|---:|
| 1 | 231 | 12 | 36 |
| 2 | not measured (13 shipped pieces over 176 steps: expect 40-60 between the bench and the barn) | 10 | 25 |
| 3 | 138 | 14 | 37 |
| 4 | not measured (9 shipped over 196 steps: expect 60-90 after the lease until the pony) | 13 | 53 |
| 5 | 43 | 13 | 13 |
| 6 | not measured | 15 | 28 |

So the shipped game alone goes silent for 138 to 231 steps (most of a chapter) in chapters 1 and 3, and probably 60-90 steps in chapters 2 and 4. The 166 pieces fill the gaps with reactions, not with story steps: the longest gap between *non-bark* pieces is still 36, 37 and 53 steps in chapters 1, 3 and 4.

**By story strand** (what the player hears about each thread, shipped + written, in play order; "-" is a stretch with nothing):

| Strand | What exists | The silences |
|---|---|---|
| Berit and the family's past | Berit's name once (`c5_cough`); her margin notes (25 staged, all behind a bought-book trick); `c1_maud`, `c2_jan`, `c6_agnes` (staged) say a line each | Berit is a handwriting for four chapters. The player is never told she raised them, died, or left the box |
| Mother and the letters | `c2_letter`, `c3_letter`, `c2_reply` (staged), `c4_mei` (staged), `c6_fair_letter` | chapters 1 and 5; no father, no siblings, no town named |
| The cousin | "your cousin asks after you" (`c2_letter`, `c3_letter`, `c3_goat_out`), `c6_fair_letter`, `c6_crisis`, `c6_bend`, `c6_free_family` | a name, a face, a voice: none before the Fair. The cousin first speaks in the accusation |
| The Lord and the share | `c1_ledger`, Pieter (ch3, 4 staged), `c4_quill`, `c4_lease`, `c4_no`, `c4_quill_out`, `c5_letter` (seal), `c6_lord`, `c6_quill_answer` | chapter 5's share (a third) has no piece; the Count is never named; the Lord never speaks and his name (Wexley) is in no piece |
| Mumyo's traces | bells (`c1_bells`, `c1_bell_out`, `c1_k_bell`), sticks, tower of rocks, `c3_bell`, `c3_goat_out`, `c3_dance`, `c4_count` (paper boat), `c4_watch`, `c5_lamp`, `c5_petals` (swing), `c6_terraces`, `c6_garden`, `c6_ajar` | chapter 2 has no trace at all (`mumyo.md` promised a hammer on the roof corner and weeds pulled into a smiley face; neither was written); chapter 5 shipped has none (only the staged swing and petals); the long middle (ch2) is where the pranks stop |
| The melody | `c1_night` ("a tune ... you find you are humming it") and `c6_supper` ("You know the tune") | **one piece in chapter 1, one in chapter 6, nothing between**; Lark never names it (Q11 missing) |
| Lark | `c2_lark`, `c4_no`, `c4_library`, `c6_broker`, `c6_supper`, `c6_free_lark` | chapters 1, 3 and 5 |
| The Helpers after their return | a return beat each; `c3_goat_shed`, `c4_k_pony`, `c5_badger_job`, `c6_k_alpaca`, `c1_k_nibbled` | pieces that mention each Helper (shipped / all 246): bunny 3/3, tortoise 1/1, goat 3/12 (nine are Maud's goat or a nibbled list), pony 1/2, badger 4/4, alpaca 1/2. They are events, not characters |
| The forest and the shell | `c1_night` (white stones), `c1_forest_tap`, `c5_conch`, `c5_petals` | a 4-chapter silence between the first night and the forest in chapter 5 |
| The village goes on | seasonal barks (staged), `c2_board`, `c3_board`, `c4_board`, `c5_board`, `c6_board`, wedding, school window, theatre, flags | no festival is anticipated in chapters 1 to 5; no almanac; one dance, one wedding, one Fair |

## 6. What this means for the run (short)

- The 80 shipped pieces are a spine of beats (36 of them). The 166 are a skin of reactions. The outline needs the **middle layer** that is missing: people with wants, a bite in the clocks, and the clue steps that join beat to beat.
- Everything that has to survive the first hour (chapter 1, 17 shipped pieces) is carried by a handful of boxes: the frame, the stalk, the book, the night. See the dossier for what they do not say.
- Any outline seed that wants to hang on chapter 5 has few node hooks (20 nodes in all) and a very short play time (about 60 bot steps); it will need `forest_trips`, cards, `seen:`/`after:` chains or the share counters.
- Re-running the bot for a clean shipped-only silence table is a task for the game team, not this run.
