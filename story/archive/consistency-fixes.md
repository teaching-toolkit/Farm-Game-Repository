# Consistency fixes: what the editor did with the 109 findings

14 Oct 2026, Round 6b, consistency pass. Editor's log for `consistency-report.md` (F-001 … F-109, final section "Fix list for the editor"). Method: the live-wire-style rules in Note and Render mode (revise the passage, do not re-plot; read it aloud; a six-year-old must follow it; never explain the joke; warm, never cruel; the body before the named feeling). Every edit was made in the files named below; nothing in `texts/ch1–6.md`, `godot-prototype/`, the game data or `archive/` was touched, and no git command was run.

**Totals:** 80 APPLIED · 1 SKIPPED · 12 PARENT · 9 BUILD-STEP · 7 NOT-NEEDED (= 109). New pieces: still **166** (no piece added or deleted; 3 moved or renamed: `c4_blanket` to `c3_blanket`, `c5_whirligig` to `c6_whirligig`, `c3_stream_n` to `c3_pond_sun`; `c3_north` stayed where it was). By chapter 51 / 29 / 29 / 19 / 14 / 24; by kind 69 moments, 39 discoveries, 32 barks, 17 scenes, 4 visits, 3 beats, 2 letters.

Status words: APPLIED (done in the files), SKIPPED (not done, with the reason), PARENT (the parent decides; where safe, the new pieces were made to work either way and that is said), BUILD-STEP (belongs to the built texts, game data or code, which this pass may not touch), NOT-NEEDED (no change called for).

## 1. The 109 findings

| F | Status | What changed | Piece or file |
|---|---|---|---|
| F-001 | APPLIED | c2_barn_done: whole text replaced. No "set alight by you", no hook, no cow; lantern still hangs outside | c2_barn_done |
| F-002 | APPLIED | c2_hilde: Hilde now speaks to you, with {player}; no "she's working hard" | c2_hilde |
| F-003 | APPLIED | c2_otto: "a little girl who didn't cry" becomes "I took you across. You were so small. You did not cry."; two pages | c2_otto |
| F-004 | APPLIED | c4_birthday: no "a year ago"; retitled "The bucket"; two pages | c4_birthday |
| F-005 | APPLIED | c5_badger_job: the card shows a basket, leaves, a cup and a small moon (no written words); kind beat to moment | c5_badger_job |
| F-006 | APPLIED | c6_quilt: "A year of Hazelwood" becomes "All of Hazelwood"; "quilt" becomes "patchwork cover"; "the blue sail" becomes "a scrap of blue" | c6_quilt |
| F-007 | APPLIED | c6_eve: no year, no "only sure that you are"; two pages ending on "Now you are sitting in the middle of it." | c6_eve |
| F-008 | APPLIED | c1_maud: "a relief to everyone" becomes "disappoints everyone, the goat included"; "Berit's chin" becomes "Berit's stubborn self"; {player} added | c1_maud |
| F-009 | PARENT | Left as it was (Q1). Only "I am glad." was dropped from c2_reply (F-061). "Ask Maud about the goat." still points at a goat story that nothing tells | c2_reply, c3_maud_goat |
| F-010 | APPLIED | Covered by F-001: no hook, no cow in c2_barn_done | c2_barn_done |
| F-011 | APPLIED | c2_tortoise_omen: the tortoise is not in the scene; an empty shell house in the sunniest corner of the yard (pond-neutral, so it holds whatever the parent says about F-076) | c2_tortoise_omen |
| F-012 | APPLIED | Three small edits: Maud takes her goat home ("The goat looks back twice."); a hen walks across the list in c3_dread2; "A goat" in the barn piece | c3_maud_goat, c3_dread2, c3_goat_shed |
| F-013 | APPLIED | c4_watch: Pieter holds your new lantern up on the town wall (no gatepost); two pages | c4_watch |
| F-014 | APPLIED | c4_mei: the year-long bundle is now the pickles hand-over and one letter; two pages | c4_mei |
| F-015 | PARENT | Robust edit only: "apparently ten years old" cut; the second hand is "smaller and rounder" and says "She does." (Q2) | c5_n_foxglove |
| F-016 | APPLIED | c5_lamp: "her new lamp" becomes "pours your oil into a lamp"; the lamp-maker is "he"; register W; two pages | c5_lamp |
| F-017 | PARENT | Robust edit: the swing is in the first orchard and shown only as a trace (moving swing, apple core); nobody is seen (Q3) | c6_terraces |
| F-018 | APPLIED | c6_theatre: "village play ... Greenstem plays the cheese" becomes the travelling theatre's lead actor holding your cheese wheel | c6_theatre |
| F-019 | APPLIED | c6_n_last: trigger now `cards>=87 + seen:c6_supper`; "It is empty."; the hand in the margin is "a hand you know so well by now" (no pencil) | c6_n_last |
| F-020 | PARENT | Not changed (Q4). Berit's notes in bought books need an explanation | 21 of the 25 margin notes |
| F-021 | APPLIED | c1_axe: "Your first tool" becomes "Your first axe" | c1_axe |
| F-022 | PARENT | Not changed (Q5). The built c2_letter and c2_cottage say "before the frost" after the c1 winter pieces | c1_summer, c1_autumn, c1_winter, c1_hunger, c1_spring2 |
| F-023 | APPLIED | c1_tower: "by the fence" becomes "at the edge of the field"; only a bell is heard, high and bright | c1_tower |
| F-024 | APPLIED | c1_cleared: trigger now needs clear_weeds, clear_thistles, clear_rocks and clear_stumps | c1_cleared |
| F-025 | APPLIED | c1_quern: trigger `done:quern + has:flour:1` | c1_quern |
| F-026 | APPLIED | c1_winter: "Somebody has been guarding it." cut; Move is Omen | c1_winter |
| F-027 | APPLIED | c1_tom: "on the tent pole" becomes "by the door" | c1_tom |
| F-028 | APPLIED | c1_ella: trigger gets `+ seen:c1_bells` | c1_ella |
| F-029 | APPLIED | The four note openers varied (Next to / At the bottom of / Across the top of / Squeezed in beside) | c1_n_weeds, c1_n_ash, c1_n_chickens, c1_n_market |
| F-030 | APPLIED | c2_stove: "You do not have to eat standing up any more." | c2_stove |
| F-031 | APPLIED | c2_greenstem_hands: trigger `done:d_bread + seen:c2_greenstem + seen:c2_walls`; two pages; "about nothing much" | c2_greenstem_hands |
| F-032 | APPLIED | c2_snug: title "Snow-light" | c2_snug |
| F-033 | APPLIED | c2_n_sleep: the note is "You, too." underlined twice | c2_n_sleep |
| F-034 | APPLIED | c3_tower: "Behind you, the forest"; register A to W; shortened | c3_tower |
| F-035 | SKIPPED | The report is wrong here (see "Where the report was wrong"). A node's chapter label is not a gate: the bot completed north_field_clear in engine chapter 3 (step 629) and c3_north fired there. The piece stays in more-ch3.md; only its register was retagged W (F-066) | c3_north |
| F-036 | APPLIED | c3_board: "WELCOME BACK. WE HAD OUR DOUBTS."; last sentence now "You take it as a compliment." | c3_board |
| F-037 | APPLIED | c3_k_wind: trigger `done:windmill_1 + chance:0.15`; the text was rewritten as well, so it only speaks of sails that turn and then carry on | c3_k_wind |
| F-038 | APPLIED | c3_swing: "young trees" becomes "old trees"; two pages | c3_swing |
| F-039 | APPLIED | c4_receipt: kept with the burnt page, thanks are Pieter's, shortened | c4_receipt |
| F-040 | APPLIED | c4_greenhouse: "cold" and "frost" removed; c4_k_winter gets `+ done:greenhouse` | c4_greenhouse, c4_k_winter |
| F-041 | APPLIED | c4_blanket moved to more-ch3.md as c3_blanket, Move Plant, two pages, Priority 65 (the bot builds the bed late, step 1038) | c3_blanket |
| F-042 | APPLIED | c4_wedding: title "A tall cake"; the lean is "in the middle, where the berry cake meets the apple pie"; no bell simile | c4_wedding |
| F-043 | APPLIED | c4_board: "WHOEVER IS DOING ALL THIS, PLEASE DON'T STOP."; the lost glove still pinned near the bottom | c4_board |
| F-044 | APPLIED | c5_board: "It seems like good advice, and you take it." | c5_board |
| F-045 | APPLIED | c5_dry: "the still-room smells" | c5_dry |
| F-046 | APPLIED | c5_lookalike: ends on the act: taste neither, wrap both leaves, take them to someone who knows | c5_lookalike |
| F-047 | APPLIED | c5_whirligig moved to more-ch6.md as c6_whirligig, "The singing pole", register G, "coop", "not kind" (the move is harmless even though "cannot show in chapter 5" was only partly true) | c6_whirligig |
| F-048 | APPLIED | c5_k_rain: trigger `chapter:5 + chance:0.2` | c5_k_rain |
| F-049 | APPLIED | c5_k_wren: trigger `+ seen:c5_wren_check`; "You do not pick it. It will keep until she has seen it." | c5_k_wren |
| F-050 | APPLIED | c6_board: "nearly all green" removed; "the old one, the lost glove"; "very funny" | c6_board |
| F-051 | APPLIED | Use what was delivered: Agnes with tapenade, the orphanage with jam on bread, flags in red, yellow and blue, the poet is Kit with a scarf | c6_agnes, c6_orphanage, c6_flags, c6_poet |
| F-052 | APPLIED | c6_k_alpaca: "seen more than she lets on" | c6_k_alpaca |
| F-053 | PARENT | Robust edit: the three new notes name no writing material ("thin brown ink" only where the built game already says so). The docs now say ink (F-090). If the parent wants pencil, 4 pieces change (Q6) | c2_n_bread, c5_n_foxglove, c6_n_last |
| F-054 | NOT-NEEDED | Omens can be missed; accepted (a design call, not a defect). No merge | c1_hutch, c1_bowl, c5_tea_set, c2_tortoise_omen |
| F-055 | APPLIED | {player} added in the four pieces named | c1_maud, c2_hilde, c3_pieter2, c4_pieter4 |
| F-056 | APPLIED | Pieter's lantern is in the text, in daylight | c3_pieter2, c3_pieter3, c4_pieter4 |
| F-057 | APPLIED | Kinds changed: c2_bees and c5_badger_job to moment; c2_kitten, c3_baby and c4_window to scene (c3_baby was missed in the first pass and fixed in the second) | c2_bees, c2_kitten, c3_baby, c4_window, c5_badger_job |
| F-058 | APPLIED | All 22 pages over 55 words split or trimmed. Longest page now 54 words, 192 pages, average 32.5 | c6_eve, c3_sails, c2_greenstem_hands, c2_kiln, c2_otto, c2_bees and others |
| F-059 | APPLIED | Partly. satisfaction, reasonable, definitely, particular, difficulty, favourable, unaccountably, apparently, suspicious, committed swapped out. embarrassment, confidence, supervised kept as comic-position words and logged in book-file.md | c1_fire, c1_bench, c1_hens, c3_goat_shed, c5_k_tea, c6_oven and others |
| F-060 | APPLIED | The "check / in case" lines varied | c1_first_card, c1_spring2, c1_k_wave |
| F-061 | APPLIED | "I am glad." dropped from c2_reply | c2_reply |
| F-062 | PARENT | c2_n_bees left untouched (Q2) | c2_n_bees |
| F-063 | APPLIED | c5_petals: neutral "Beside the path a small stream" (no claim where the petals come from) | c5_petals |
| F-064 | APPLIED | "The astronomer ... Vega says" and Kit: no pronoun until the Vega picture is checked | c6_telescope, c6_poet |
| F-065 | NOT-NEEDED | The plan has "my love"; the mother says it first | c6_n_last |
| F-066 | APPLIED | Registers retagged. A is now on 9 pieces: c2_honey, c2_pond, c3_sails, c4_glass, c4_watch, c5_petals, c6_dye, c6_telescope, c6_eve | 18 pieces retagged |
| F-067 | APPLIED | Done although the report called it optional (easy to undo): feelings shown by the body in four pieces ("you stand very still so as not to spoil it", "very pleased with itself", hands on hips) | c2_kitten, c4_wedding, c6_whirligig, c3_goat_shed |
| F-068 | APPLIED | c3_stream_n renamed c3_pond_sun (register W) | c3_pond_sun |
| F-069 | NOT-NEEDED | No piece change; story-delivery.md widened (F-100) | none |
| F-070 | NOT-NEEDED | No change required | c1_trips20, c4_window, c1_n_fire |
| F-071 | APPLIED | Via F-008 ("Berit's chin" is gone); the rest is generic | c1_maud |
| F-072 | BUILD-STEP | chapel to village hall in the node, German and picture prompt (see list) | sq_chapel_roof |
| F-073 | BUILD-STEP | German c2_greenstem without a gendered "die vom Mondrand" (see list) | c2_greenstem |
| F-074 | PARENT | Not changed (Q7). Badger default name is Bramble, the goat's name | pet_badger, pet_alpaca |
| F-075 | BUILD-STEP | Lord's share stays at a half after Quill's answer; one line of code (see list) | c6_quill_answer, lord.gd |
| F-076 | PARENT | Not changed (Q8). c2_tortoise_omen was made pond-neutral so it works either way | pet_tortoise, c2_tortoise |
| F-077 | PARENT | Not changed (Q9). The bot never drained the river meadow; the garden pieces fire at step 1069 and are never seen first | pet_alpaca, c6_free_garden, c6_ajar |
| F-078 | BUILD-STEP | Add the two JSON-only pieces to texts/ch2.md (see list) | c2_berit_note, c2_k_rest |
| F-079 | BUILD-STEP | "On the track by your field" (see list) | c1_seller |
| F-080 | BUILD-STEP | "thatch" and German "Stroh" instead of "Ziegel" (see list) | c2_cottage |
| F-081 | BUILD-STEP | trigger `+ seen:c2_walls` (see list) | c2_greenstem |
| F-082 | BUILD-STEP | "your best field" (see list) | c4_no |
| F-083 | BUILD-STEP | cut one line (see list) | c6_free_garden |
| F-084 | PARENT | Not changed (Q10) | c6_free_miller |
| F-085 | NOT-NEEDED | No change | c3_frame3 |
| F-086 | APPLIED | ladder.md row 2.1 now says the mother adds "Your cousin asks after you" (an early plant, repeated in chapter 3) | ladder.md |
| F-087 | NOT-NEEDED | "Only on Sundays" is a weekday, not a religious word | quiz k_play |
| F-088 | APPLIED | hazelwood-people.md: "child who did not cry"; Hilde "first to say to your face that the village is talking about you, kindly"; long-game.md invention list no longer quotes "she's working hard" | hazelwood-people.md, long-game.md |
| F-089 | APPLIED | code-issues-story-timing.md: the c4_frame4 re-key deleted, with a note why | code-issues-story-timing.md |
| F-090 | APPLIED | "pencil" becomes "thin brown ink" in long-game.md, immersion-triggers.md, book-file.md | three docs |
| F-091 | APPLIED | 00-timeline.md: Y-14 gets "The best field skips its fallow year."; Y-12 keeps "The straw is sold, not composted." | 00-timeline.md |
| F-092 | APPLIED | 00-premise.md row 3: "Granny Maud ... from chapter 1" | 00-premise.md |
| F-093 | APPLIED | berit-and-family.md: "daughter" and "she is only wrong" | berit-and-family.md |
| F-094 | APPLIED | ladder.md 6.7: the "text or a tap" question deleted | ladder.md |
| F-095 | APPLIED | ladder.md 2.7: the lid says "Feed the ground and it feeds you"; the Rest note is c2_berit_note | ladder.md |
| F-096 | PARENT | The false "separated by the loom" claim deleted and the awe state told truthfully (9 tags). The choice between plans is the parent's (Q11); ladder.md:24 untouched | long-game.md |
| F-097 | APPLIED | Snag table rewritten to match the texts; swing sentence added to c5_petals page 2. The c6_ajar light is a build step (list) | long-game.md, c5_petals |
| F-098 | APPLIED | Invention lists corrected in long-game.md, book-file.md and the more-ch headers: yarrow, "Remarks: none" and Mei's partner struck; second hands, stool, rock tower, blanket, bookseller added | long-game.md, book-file.md, more-ch1-6 headers |
| F-099 | APPLIED | Pieter row added to hazelwood-people.md | hazelwood-people.md |
| F-100 | APPLIED | story-delivery.md: Scene triggers on a delivery or a favour | story-delivery.md |
| F-101 | APPLIED | ladder.md names "the seed seller (she)" apart from the gate system's "travelling merchant (he)". PROJECT-LOG.md:259 already speaks of the gate one, so it needed nothing | ladder.md |
| F-102 | NOT-NEEDED | Kept "funeral" out of player text (checked: 0 hits) | none |
| F-103 | APPLIED | "42 pieces" becomes 61 (63 in the game; 78 and 80 with chapter 1) in book-file.md and TODO.md | book-file.md, TODO.md |
| F-104 | APPLIED | book-file.md: "Roughly 9-10 thousand words" | book-file.md |
| F-105 | APPLIED | Stretch-word log filled | book-file.md |
| F-106 | APPLIED | README.md texts row: ch1-ch6 sources, chapters 1-6 built | README.md |
| F-107 | APPLIED | more-ch2.md header now says the orchard node is chapter 2 and the swing waits for chapter 3 on purpose | more-ch2.md |
| F-108 | APPLIED | immersion-triggers.md recounted from the converted JSON (Firsts 8, Builds 44, Seasons 8; kinds and chapters) | immersion-triggers.md |
| F-109 | APPLIED | "nine to twelve game years" in 00-premise.md and 00-timeline.md. The dated log lines in book-file.md and PROJECT-LOG.md stay as history | 00-premise.md, 00-timeline.md |

## 2. Old and new wording, the fifteen that matter most

| F | Piece | Old | New |
|---|---|---|---|
| F-001 | `c2_barn_done` | "...faintly, of cow. You think about the blackened hook and the corner where the hay was. Then you hang a lantern on a post outside, not on a hook inside... Nothing in there is going to be set alight by you. That much, you decide, is yours to promise." | "The barn is finished. It smells of new pine and fresh straw. You hang a lantern on a post outside, not on a hook inside, and stand back and nod. Hay and flame should live far apart. That is as far as you let yourself think." |
| F-002 | `c2_hilde` | "I hear," she says, not looking at you, "that she's working hard, that one." You look behind you for the one she means. | "I hear things about you in the lane, {player}," she says, not looking at you. "Good things. Nobody has one bad word. It is ruining the lane." |
| F-003 | `c2_otto` | "...I took a little girl who didn't cry." | "The night your family left, I took you across. You were so small. You did not cry." |
| F-004 | `c4_birthday` | "A year ago this week you came here with a bucket and a plan and no idea... You touch it, as you might touch the head of an old dog" | "It was spring when you came here with a bucket and a plan and no idea... You give its rim a pat, the way you would pat a horse that has done a good day's work" (title "A year" becomes "The bucket") |
| F-005 | `c5_badger_job` | On it, in careful claw-scratch: "DIGGING. NIGHT. NO TALKING." Underneath, a drawing of a very small spade. | On it, in careful claw-scratch: a basket, a bunch of leaves, and a cup. Underneath, a very small moon. |
| F-006 | `c6_quilt` | "a quilt... a bit of the blue sail... A year of Hazelwood" | "a patchwork cover... a scrap of blue... All of Hazelwood" |
| F-007 | `c6_eve` | "...A year ago none of this was here. You are not sure that it is *here* now. You are only sure that you are." | Page 2: "...The bucket, by the door, is full of rain. None of this was here when you came. Now you are sitting in the middle of it." |
| F-008 | `c1_maud` | "...which is a relief to everyone... "Berit's chin," she says. "Berit's stubborn chin."" | "...which disappoints everyone, the goat included... "Oh, {player}," she says. "Berit all over. Berit's stubborn self."" |
| F-011 | `c2_tortoise_omen` | "You set the little shell house at the edge of the pond. The tortoise gives it a long, suspicious inspection. Then she steps inside..." | "You set the little shell house down in the sunniest corner of the yard. It is exactly big enough for someone who carries their own roof. You step back and look at it. It looks back, empty and patient." |
| F-013 | `c4_watch` | "Pieter leans on the gatepost and looks out over the marsh." | "Pieter holds your new lantern up on the town wall and looks out over the marsh." |
| F-014 | `c4_mei` | "...a bundle under her arm... Letters. A year's worth, or something like it, tied with string... She wrote them all and I carried them all." | Page 1: "Captain Mei holds the jar of pickles up to the light and nods, as if it had passed an exam. "For the long voyage," she says." Page 2: "Then she sets a letter on your table. "Your mother. She asked me to hand it over myself."" |
| F-016 | `c5_lamp` | "The lamp-maker lights her new lamp... "It's for the marsh road," she says." | "The lamp-maker pours your oil into a lamp and lights it... "It's for the marsh road," he says. "There is a very small light out there some nights, and it is no help at all."" |
| F-017 | `c6_terraces` | "At the top branch, the old swing hangs. Someone is sitting on it, kicking their feet, eating an apple." (in the second orchard, with a sitter) | the old swing "is still moving, just a little, as if somebody has only just got off"; "On the plank lies an apple core, eaten down to the pips. You do not need to know who. The knot holds." (PARENT, Q3) |
| F-018 | `c6_theatre` | "The village play is about a cheese... Greenstem plays the cheese. He holds very still for the whole second act." | "The travelling theatre's play is about a cheese... The lead actor holds your cheese wheel very still for the whole second act." |
| F-019 | `c6_n_last` | trigger `cards>=87`; "nothing printed"; pencil | trigger `cards>=87 + seen:c6_supper`; "It is empty. Only, in the margin, in a hand you know so well by now:" |

## 3. Where the report was wrong, or only half right

- **F-035 (c3_north to chapter 4): premise false.** A node's `chapter` is a design label, not a gate. A piece is gated only by its own `chapter` (as a minimum), and the engine's chapter is 1 plus the pets home. In the bot run `north_field_clear` was done at step 629 in engine chapter 3 and `c3_north` fired there. Moving it to chapter 4 would only have delayed it. Skipped; the register was retagged W under F-066. The same fact is recorded in `code-issues-story-timing.md`.
- **F-037 (c3_k_wind):** the trigger fix alone left a text about sails that "slow" with nothing turning; the text was rewritten too.
- **F-041 and F-047 (moves):** the stated reason ("cannot show in that chapter") is only partly true for the same reason as F-035. The moves are harmless and were applied.
- **F-059:** three of the long words (embarrassment, confidence, supervised) are comic-position words (a big word in a silly place) and were kept and logged, not swapped.
- **F-108:** the counts were recounted after the edits. Seasons with barks is 17, not 18, because `c5_k_rain` lost its `season:autumn`. Kinds and chapters match the report's own forecast (69 moments, 17 scenes, 3 beats; 51 / 29 / 29 / 19 / 14 / 24).
- **F-107:** correct; applied. **F-102 / F-087:** correct; nothing to do.
- Not on the report's list, noticed on the way: canon docs still carry two gendered slips about the farmer, `characters/hazelwood-people.md:11` ("You're the Moonedge girl", "remembers her") and `characters/fenna.md:80` ("as a little girl remembers big animals"). The report does not name them, so they were left; they are listed for the parent.
- The skill's `modes/` files were not on disk in this session; the rules were taken from `SKILL.md` alone.

## 4. Questions for the parent

Each: what is open, the options, my recommendation. Nothing here was decided by the editor.

1. **The goat thread (F-009).** `c2_reply` ends with "Ask Maud about the goat." and nothing tells that story. A: pay it off in `c3_maud_goat` with one more page: "Your mother wrote to me, you know. She said I should tell you about a goat. I have quite forgotten which." (💡 new invention: the mother and Maud write to each other.) B: cut "Ask Maud about the goat." from `c2_reply`. **Recommend A**: it is funny, warm, and costs one page.
2. **The second hand in Berit's notes (F-015, F-062).** `c2_n_bees` ("in a different pen: "I mean it, B."") and `c5_n_foxglove` ("smaller and rounder: "She does."") imply someone else wrote in the book. A: it is you as a child on the farm, and the bees note is signed that way (it fits the hidden truth that you were the child). B: cut both lines. **Recommend A.** The age ("apparently ten years old") is already cut either way.
3. **No visible sitter on the swing (F-017).** `c6_terraces` shows only a moving swing and an apple core. A: keep it a trace, nobody seen (matches "Mumyo is never seen"). B: show somebody. **Recommend A.**
4. **Berit's notes in bought books (F-020).** 21 of the 25 margin notes are in books the farmer buys or finds, so how did Berit write in them? A: the bookseller says so, in `c1_bookcart_tap` or a bark: "Some of these came from up your way. Well read, every one." B: keep the notes only in Berit's own book and the books she left. C: nobody asks. **Recommend A.**
5. **"Before the frost" (F-022).** `c2_letter` and `c2_cottage` (built) say "before the frost", but the new chapter 1 winter pieces have already had a winter. A: "before the next frost" (two English strings and two German; see the build list). B: leave. **Recommend A.**
6. **Ink or pencil (F-053).** The built game says "thin brown ink" for Berit; the new docs said pencil. I made the docs say ink and gave the three new notes no material. A: ink (nothing more to do). B: pencil: change `c1_n_fire`, `c1_n_ash`, and the built `c1_book` and `c2_berit_note` with their German (Quill's pencil in `ch4.md` stays his). **Recommend A.**
7. **The badger's name (F-074).** `pet_badger` has `defaultName: "Bramble"`, which is the goat's name, while its own description says "Bracken". A: **Silverpaw** (canon in `book-file.md:84` and `helpers.md`, from The Forest Within). B: Bracken. Also `pet_alpaca` says "Pet 5"; it is pet 6. **Recommend A and the fix.**
8. **The tortoise and the pond (F-076).** `pet_tortoise` does not require `pond`, but `c2_tortoise` says "the pond". A: add `pond` to its requirements (the bot did the pond at step 368, the tortoise at 422, so it costs no pace). B: change the text. **Recommend A.** (`c2_tortoise_omen` works either way.)
9. **The alpaca and the night garden (F-077).** `pet_alpaca` does not require `river_meadow_drain`. In the bot run the river meadow was never drained, and `c6_free_garden` and `c6_ajar` fire at step 1069, describing a garden the player has not seen. A: add `river_meadow_drain` to the alpaca's requirements (this is C9 in `code-issues-story-timing.md`). B: leave and let the ending tell it. **Recommend A.**
10. **The mill (F-084).** Sails or wheel? `c3_sails` and `c3_k_wind` say sails; `c6_free_miller` in the built text must agree. Open since 14 Oct. **No recommendation; defer to the picture decision.** Until then the new pieces only say "sails" where the node is `windmill_1`.
11. **One awe plan (F-096).** The ladder promises awe three times (ch 1, 5, 6); `long-game.md` plans about ten; the pieces now carry 9 A tags (ch2 2, ch3 1, ch4 2, ch5 1, ch6 3). A: keep the long-game plan and drop "never adjacent". B: cut to three. **Recommend A.** The false "separated by the loom" claim is already gone.

## 5. For the build step

Not touched by this pass. Exact files, ids and wording; do these when the pieces go into the game (TODO I15, I17).

1. **F-072, chapel to village hall.** `godot-prototype/data/farm/nodes/09-side-quests.json`, `sq_chapel_roof`: name "Fix the chapel roof" to "Fix the village hall roof"; emoji ⛪ to 🔔; desc and `reward/picture` "...waving from the dry chapel" to "...waving from the dry village hall". `godot-prototype/data/i18n/data-de.json` (about lines 2642–2653): "Das Kapellendach reparieren" to "Das Dach des Gemeindehauses reparieren"; desc and picture "...winkt aus der trockenen Kapelle" to "...winkt aus dem trockenen Gemeindehaus". Change the picture prompt to match (planned in `TODO.md:553`).
2. **F-073, no gender in the German greeting.** `data-de.json` (about line 11876) and the German under `c2_greenstem` in `story/texts/ch2.md`: „Du bist die vom Mondrand“, sagt er. to „Du bist doch von Moonedge“, sagt er.
3. **F-075, the Lord's share after Quill's answer.** `godot-prototype/game/farm/systems/lord.gd`, `fraction()`: nothing ever sets `eased`, so the share stays at a half (0.50) after `c6_quill_answer`. Change `if bool(_s().get("eased", false)):` to `if bool(_s().get("eased", false)) or G.story.seen("c6_quill_answer"):` (`easedFraction` 0.10 already exists in `rules/53-lord.json`). Test: the share after the answer is a tenth.
4. **F-078, two pieces only in the JSON.** Add `c2_berit_note` (discovery, `seen:face`) and `c2_k_rest` (bark) from `data/farm/story/15-chapter-2.json` and `data-de.json` into `story/texts/ch2.md`, so that the text file is the source again; update `story/README.md` counts (ch2.md then has 13).
5. **F-079, the seller's place.** `story/texts/ch1.md:74`, `10-chapter-1.json` `c1_seller` and its German: "On the village square a seller sniffs the air." to "On the track by your field a seller sniffs the air." (German likewise: „An der Strasse bei deinem Feld ...“).
6. **F-080, the roof.** `ch2.md:73/75`, `15-chapter-2.json` `c2_cottage`, German: "taps on the tiles" to "taps on the thatch"; „auf die Ziegel klopft“ to „auf das Strohdach klopft“. If the parent says yes to Q5, also "before the frost" to "before the next frost" (title "A roof before the frost" too), German „vor dem nächsten Frost“.
7. **F-081, Greenstem needs the wall.** `15-chapter-2.json` and `ch2.md`, `c2_greenstem`: `when` `done:d_stone_soup` to `done:d_stone_soup + seen:c2_walls`.
8. **F-082, the field.** `ch4.md`, `22-chapter-4.json`, German, `c4_no`: "the North Field" to "your best field" (German „dein bestes Feld“).
9. **F-083, the unsaid thing.** `ch6.md`, `30-chapter-6.json`, German, `c6_free_garden`: cut "You open your mouth. You close it again." The unsaid thing belongs to `c6_ajar`.
10. **F-097, the third appearance of the tiny light.** `ch6.md:132`, `30-chapter-6.json`, German, `c6_ajar`: the middle sentence becomes "Somewhere in the white flowers a tiny bell moves, and is still, and a very small light goes out."
11. **After the parent's answers:** Q7 (`06-main-path-chapter-5.json` lines 20–21: `defaultName` "Bramble" to "Silverpaw", desc "Pet 5 (default name Bracken)" to "Pet 5 (default name Silverpaw)", alpaca "Pet 5" to "Pet 6", and the German in `data-de.json`); Q8 (add `pond` to `pet_tortoise` requires); Q9 (add `river_meadow_drain` to `pet_alpaca` requires); Q10 (`c6_free_miller`); Q1 (add page 2 to `c3_maud_goat`); Q6 (if pencil).
12. **The 166 pieces themselves** (TODO I15): German translations (`ss`, no ß), copy `story/staging/more-ch*.json` into `data/farm/story/`, i18n check, bot, pictures. Note the order the bot saw: `c4_watch` (step 911) fires after `c5_lamp` (892), and `c4_window` at 911, because optional favours are done late. The tiny-light snag therefore may reach the player in either order; both pieces read fine in either.

## 6. Flagged inventions 💡

New in this pass, to accept or overrule (earlier ones are in each `more-ch` header and in `book-file.md`):

- Hilde: "Nobody has one bad word. It is ruining the lane." (`c2_hilde`).
- The lantern hung on a post outside the new barn, "Hay and flame should live far apart." (`c2_barn_done`); the plant for the fire.
- The badger's job card as a picture: basket, leaves, cup and a small moon (`c5_badger_job`).
- The swing moving by itself (`c5_petals` page 2) and the apple core on the plank (`c6_terraces`).
- "The goat looks back twice." (`c3_maud_goat`); a hen walks across the paper (`c3_dread2`).
- Mei admires the pickles "as if it had passed an exam", and brings one letter (`c4_mei`).
- Berit's note "You, too." underlined twice (`c2_n_sleep`).
- The sails that "slow, creak, and stop, like someone who has forgotten the next word" (`c3_k_wind`).
- You pat the bucket's rim "the way you would pat a horse that has done a good day's work" (`c4_birthday`).
- The sunniest corner of the yard for the empty shell house (`c2_tortoise_omen`).
- Kit as a child poet who reads aloud to a cow, in canon already; the rainbow scarf; red, yellow and blue flags (`c6_poet`, `c6_flags`).
- The lavender smell that returns in `c6_quilt` (`c3_blanket` plants it); the folded blanket itself.
- Previously unflagged, now listed: the stool (`c1_trips20`), the rock tower (`c1_tower`), the bookseller as a man (`c1_bookcart_tap`), a second hand in two notes (Q2).
- Q1's offered page (the mother writes to Maud) is only an offer; it is not in the texts.

## 7. Verification

- **Converter:** `python3 md_to_story_json.py` from `story/staging`: "no validation errors"; 51 / 29 / 29 / 19 / 14 / 24 = 166 pieces (69 moments, 39 discoveries, 32 barks, 17 scenes, 4 visits, 3 beats, 2 letters). 192 pages; the longest is 54 words (before: 22 pages over 55); average 32.5 words. About 6.2 thousand English words in the 166.
- **Bot** (work copy `$HOME/work/proj` with the six JSON files copied in as `91–96-more-ch*.json`; `--end --seed=1 --iters=6000`; the Mac project was not given the JSON): longest silence between story pieces of any kind, in steps: ch1 12, ch2 10, ch3 14, ch4 13, ch5 13, ch6 15 (unchanged from the draft run; before the new pieces: 231 in ch1, 138 in ch3). Between non-bark pieces: ch1 36, ch2 25, ch3 37, ch4 53, ch5 13, ch6 28.
- **Never fired in the final run: 41 of 166** (125 fired): 6 taps (`c1_weeds`, `c1_rocks_tap`, `c1_forest_tap`, `c1_road_tap`, `c1_market_tap`, `c1_bookcart_tap`); 25 margin notes (the bot does not read cards): `c1_n_fire`, `c1_n_weeds`, `c1_n_ash`, `c1_n_chickens`, `c1_n_market`, `c2_n_bread`, `c2_n_bees`, `c2_n_frost`, `c2_n_play`, `c2_n_sleep`, `c3_n_wind`, `c3_n_ferment`, `c3_n_weaving`, `c3_n_pests`, `c3_n_irrigation`, `c4_n_steel`, `c4_n_glass`, `c4_n_mulch`, `c4_n_masonry`, `c5_lookalike`, `c5_n_foxglove`, `c5_n_grownup`, `c6_n_seed`, `c6_n_worms`, `c6_n_soil`; and 10 tied to optional favours, a gift or a bark chance: `c1_bowl`, `c2_jan`, `c4_wedding`, `c4_mei`, `c6_agnes`, `c6_orphanage`, `c6_well`, `c6_poet`, `c6_k_alpaca`, `c6_k_garden` (`c6_k_garden` needs the garden, see Q9). All need a hand test.
- **Seen in the bot's timeline:** `c3_north` at step 629 (engine chapter 3), `c3_baby` 614 as a scene, `c3_sails` 623 and `c3_k_wind` 624, `c3_blanket` 1039 (the bot builds the bed at 1038), `c6_whirligig` 932, `c6_n_last` 1069 after `c6_supper`.
- **Greps over `more-ch1–6.md`:** religious or churchy words (god, church, chapel, prayer, holy, saint, priest, bless, heaven, angel, amen, sacred, altar, funeral, miracle, temple, Sunday and more): 0 hits. "ß": 0. The farmer in the third person (the farmer, that one, working hard, Moonedge girl): 0. Every he/she/her/him (35 lines) belongs to a villager or an animal. The Helpers do not speak (the only "says" near an animal is children at the school window). `{player}` is used in `c1_maud`, `c2_hilde`, `c3_pieter2`, `c4_pieter4`. No year is counted anywhere in the 166.
- **Read aloud:** I cannot play or speak audio here, so the read-aloud test was done as a silent reread for rhythm (sentence length, stumbles, repeated sounds) after each edit, page by page for the split pieces. The parent's real read-aloud (TODO I15) is still needed.
- **Docs changed:** see the final list in `PROJECT-LOG.md` and `book-file.md` (session log, 14 Oct 2026, Round 6b, consistency pass).

