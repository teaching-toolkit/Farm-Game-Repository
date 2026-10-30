# Story consistency report

Date: 14 Oct 2026

Scope: the 166 new pieces in `story/texts/more-ch1.md` to `more-ch6.md` (written 14 Oct 2026), the 78 built pieces in `story/texts/ch1.md` to `ch6.md` and the game JSON they became, the canon documents under `story/`, and the numbers quoted in the docs.

Status: read-only audit. Nothing was fixed. This file is the only file written. No git write command was run. Nothing under `archive/` or `godot-prototype/` was touched.

Severity: **BLOCKER** contradicts a ✅ parent decision or hard canon. **MAJOR** a child or the parent would notice. **MINOR** drift, repetition, polish. **NOTE** an observation, or it needs the parent's decision.

Actions: **EDIT** change wording or data. **CUT** remove a piece. **RETIME** move a piece or change its trigger. **KEEP-AND-DECIDE** leave as it is until the parent decides. **PARENT?** marks every finding that only the parent can settle. In this pass no finding proposes a CUT (where a piece repeats another, the proposed fix is a rewrite; a cut is the editor's choice).

Ids run F-001 to F-109 through groups A to D, most severe first inside each group. Line numbers refer to the files as they stood on 14 Oct 2026.

## Summary

| Group | BLOCKER | MAJOR | MINOR | NOTE | Total |
|---|---:|---:|---:|---:|---:|
| A. New pieces (`more-ch*.md`) | 7 | 13 | 40 | 11 | 71 |
| B. Existing in-game pieces and game data | 2 | 4 | 6 | 4 | 16 |
| C. Canon documents against each other | 0 | 2 | 10 | 3 | 15 |
| D. Numbers and docs to correct | 0 | 0 | 6 | 1 | 7 |
| **All findings** | **9** | **19** | **62** | **19** | **109** |

Group E lists 8 things that were not checked, and why. Actions: EDIT 86, KEEP-AND-DECIDE 20, RETIME 3, CUT 0. 12 findings are flagged PARENT? (F-009, F-015, F-017, F-020, F-022, F-053, F-062, F-074, F-076, F-077, F-084, F-096).

### The five worst problems

1. F-001 — c2_barn_done has the farmer promise that nothing in the new barn will be "set alight by you", which tells the player in chapter 2 who may have started the fire (a 🔒 hidden truth that is first told in chapter 6, by the cousin and then by the farmer).
2. F-002, F-003 — c2_hilde ("she's working hard, that one") and c2_otto ("a little girl who didn't cry") talk about the farmer in the third person with gendered words, which the ✅ voice rule forbids; they were copied from two canon docs (F-088), and the built German c2_greenstem has the same slip in "Du bist die vom Mondrand" (F-073).
3. F-004, F-006, F-007 — c4_birthday, c6_quilt and c6_eve count "a year" of game time (✅ D11: years are never counted), and c4_birthday's "A year ago this week" is also false by the game's own clock.
4. F-005 — in c5_badger_job the badger writes "NO TALKING" on a card, although the Helpers do not talk (✅ rule 10), and the card gives him digging instead of his job, medicine.
5. F-020 — 21 of the 25 new margin-note pieces sit on cards of books that the farmer buys at the book cart, but only the free "Little Farm Book" can carry Berit's handwriting (the parent must decide how the notes get into bought books).

In the built game, the two items to fix first are F-072 (sq_chapel_roof is still a chapel with a church emoji, in English and German; the rename was planned on 8 Oct and never done) and F-075 (the Lord's share is never lowered after c6_quill_answer, because the `eased` flag is never set; the share stays at a half).

### Decisions only the parent can make

- F-009 · MAJOR · c2_reply — Decide: pay off "Ask Maud about the goat" in c3_maud_goat (Option A) or cut it from c2_reply (Option B).
- F-015 · MAJOR · c5_n_foxglove — Cut "apparently ten years old" ("smaller and rounder"); parent to say whether the second hand is the farmer's.
- F-017 · MAJOR · c6_terraces — Swing is in the first orchard; show a trace (moving swing, apple core), not a seen figure. Parent: confirm no visible sitter.
- F-020 · MAJOR · c1_n_* … c6_n_* (21 of the 25 margin-note pieces) — Decide how Berit's notes get into books bought at the cart (A: the seller says they came from up the hill; B: restrict; C: ignore).
- F-022 · MINOR · c1_summer, c1_autumn, c1_winter, c1_hunger, c1_spring2 — Decide whether "before the frost" (c2_letter, c2_cottage) stays after the c1 winter pieces; option: "before the next frost".
- F-053 · MINOR · c2_n_bread, c5_n_foxglove, c6_n_last (and c2_n_bees) — Make every Berit note "thin brown ink" (three edits: c2_n_bread, c5_n_foxglove, c6_n_last).
- F-062 · NOTE · c2_n_bees — Decide who the second hand in c2_n_bees and c5_n_foxglove is (the child farmer?), or cut both.
- F-074 · MAJOR · pet_badger, pet_alpaca — pet_badger defaultName must not be Bramble (goat); choose Bracken or Silverpaw and align the desc; pet_alpaca "Pet 5" becomes "Pet 6".
- F-076 · MAJOR · c2_tortoise — Data: pet_tortoise should require pond (ladder.md:156), or c2_tortoise must not say "the pond"; parent decides (pace).
- F-077 · MAJOR · c6_free_garden, c6_ajar, c6_frame6 (night garden) — Data (C9): pet_alpaca must require river_meadow_drain, else c6_free_garden and c6_ajar describe a garden the player has never seen; parent decides (pace).
- F-084 · NOTE · c6_free_miller — Decide the mill type (open since 14 Oct); then c6_free_miller says "sails" or "wheel".
- F-096 · MINOR · ladder.md  vs  long-game.md — Decide the awe plan (3 as in ladder.md:24, or ~10 as in long-game.md:15-20) and delete the false "separated by the loom" claim at long-game.md:22.

## A. The 166 new pieces (`story/texts/more-ch1.md` to `more-ch6.md`)

Sorted by severity, then by chapter and line. Entries that touch several pieces are listed last in their severity.

### F-001 · BLOCKER · c2_barn_done · story/texts/more-ch2.md:62-65 · EDIT

**Piece:** `c2_barn_done` · **File:** `story/texts/more-ch2.md:62-65`

**What is wrong.** The farmer says out loud that the new barn must not be "set alight by you" and that this is "yours to promise". That tells the player in chapter 2 that the farmer is responsible for the fire. The cause is a hidden truth (🔒) that is told only in chapter 6, by the cousin and then by the farmer. It also contradicts the farmer's state of mind in c2_barn, who decides not to know yet.

**Evidence, the new text:**

> more-ch2.md:65: "Nothing in there is going to be set alight by you. That much, you decide, is yours to promise."

**Evidence, the canon or the other side:**

> story/README.md:56 (rule 3: the hidden truth "is written only in `00-premise.md` §3 and the world bible, never in player-facing texts before its reveal"). `00-premise.md:157` (Q12 "Who started the fire?" is answered in chapter 6). `outline/ladder.md:71` (2.10, "If not lightning, then what?"). Game `15-chapter-2.json` c2_barn, page 2: "You do not know what. And you find that you do not want to know. Not yet." Game c6_crisis and c6_bend (`30-chapter-6.json`): the cousin says it, then the farmer tells it.

**Proposed fix.** Cut the sentence that says who might set the barn alight. Keep the lantern hung outside as an act (it is the Plant named in `outline/long-game.md:34`), not as a statement. The same replacement also removes the two sequence errors in F-010.

**Exact replacement wording:**

```
The barn is finished. It smells of new pine and fresh straw. You hang a lantern on a post outside, not on a hook inside, and you stand back and nod. Hay and flame do not belong together. You do not think any further than that. Not yet.
```

**Action:** EDIT · **PARENT?** no

### F-002 · BLOCKER · c2_hilde · story/texts/more-ch2.md:77-80 · EDIT

**Piece:** `c2_hilde` · **File:** `story/texts/more-ch2.md:77-80`

**What is wrong.** Hilde talks about the farmer in the third person and with a gendered pronoun ("she's working hard, that one"). The joke that follows ("You look behind you for the one she means") only works because of the third person. This is word for word the example that the voice rule forbids.

**Evidence, the new text:**

> more-ch2.md:80: "“I hear,” she says, not looking at you, “that she's working hard, that one.”"

**Evidence, the canon or the other side:**

> `characters/fenna.md:13`: "Nobody talks *about* you in the third person where the player can hear it ("she works hard", "er ist fleißig"): people talk *to* you." `story-delivery.md:55` (✅): "no gendered word for the farmer; nobody talks *about* you in the third person". `book-file.md:12`. The docs `characters/hazelwood-people.md:36` and `outline/long-game.md:62` quote the phrase as wanted; they are wrong (see F-088).

**Proposed fix.** Rewrite so that Hilde speaks to the farmer. The joke (you look round, it is you) survives.

**Exact replacement wording:**

```
Hilde hangs the last sheet, and it flaps like a flag from a very small country. “I hear things about you in the lane,” she says, not looking at you. “Good things. It is very annoying.” You look behind you, in case she means somebody else. She does not. It seems that Hazelwood has been talking about you for weeks.
```

**Action:** EDIT · **PARENT?** no

### F-003 · BLOCKER · c2_otto · story/texts/more-ch2.md:82-85 · EDIT

**Piece:** `c2_otto` · **File:** `story/texts/more-ch2.md:82-85`

**What is wrong.** Otto says "a little girl who didn't cry". That is a gendered word for the farmer and a third-person remark about the farmer. (A reader could also take it for the cousin, who is a girl; either way it is wrong.) The farmer's gender is open in every player text.

**Evidence, the new text:**

> more-ch2.md:85: "The night your family left, I took a little girl who didn't cry."

**Evidence, the canon or the other side:**

> `characters/fenna.md:16`: "For us, the architects, the character stays **Fenna, female**, in these files. It is a working name." `story-delivery.md:55` (✅). `characters/hazelwood-people.md:22` carries the same slip ("Remembers the little girl who did not cry"), so the new piece copied it from the doc (see F-088). Checked: the ferry itself is compatible with `world/00-timeline.md:50` (the family leaves the district together, then Fenna and Berit go on to the hill cottage).

**Proposed fix.** Talk to the farmer: "I took you across." The same edit changes "his new bridge" to "the mended bridge" (the farmer mended it; `sq_bridge` is "Mend the footbridge").

**Exact replacement wording:**

```
Otto crosses the mended bridge, slowly, and stops in the middle to look down at the water. “I used to take people over that,” he says. “With a pole. The night your family left, I took you across. You were so small, and you did not cry.” He looks at you, then at the water. “I've never forgotten it.” You say nothing. Neither does he. The river says a good deal.
```

**Action:** EDIT · **PARENT?** no

### F-004 · BLOCKER · c4_birthday · story/texts/more-ch4.md:55-58 · EDIT

**Piece:** `c4_birthday` · **File:** `story/texts/more-ch4.md:55-58`

**What is wrong.** The title is "A year" and the text says "A year ago this week". Game time is never counted (✅ D11), and the count is also false by the game's own clock: this piece fires in the first spring of chapter 4, which is steps 720 to 749 (30 steps a season, 120 a year), so about six game years after the start.

**Evidence, the new text:**

> more-ch4.md:58: "A year ago this week you came here with a bucket and a plan and no idea."

**Evidence, the canon or the other side:**

> `00-premise.md:38` and `:214` (D11 ✅ "never counted in the text"). `world/00-timeline.md:9`: "No in-game text gives a year or Fenna's age after the opening; winters simply come round." `book-file.md:18`. Clock: `seasons = floor(step/30)`, spring is season 24 at steps 720-749; chapter 4 is steps 649-844 (`code-issues-story-timing.md:3`).

**Proposed fix.** Say that it was spring when the farmer came (true: the game starts in early spring, `world/00-timeline.md:53`), and rename the piece "The bucket".

**Exact replacement wording:**

**Title:**

```
The bucket
```

**Text:**

```
It was spring when you came here with a bucket and a plan and no idea. You look around. The plan has changed. The bucket is still by the door. You touch it, as you might touch the head of an old dog, and go out to see what the day wants.
```

**Action:** EDIT · **PARENT?** no

### F-005 · BLOCKER · c5_badger_job · story/texts/more-ch5.md:55-58 · EDIT

**Piece:** `c5_badger_job` · **File:** `story/texts/more-ch5.md:55-58`

**What is wrong.** The badger writes words on a card: "DIGGING. NIGHT. NO TALKING." The Helpers do not talk (✅ rule 10): they make sounds, nod, stare. The existing badger piece is careful ("he seems to say"). Digging is also not one of the badger's jobs (his job is medicine: collect, dry, mix, tea), and the joke "NO TALKING" is spoken by someone who is not supposed to speak at all.

**Evidence, the new text:**

> more-ch5.md:58: "in careful claw-scratch: “DIGGING. NIGHT. NO TALKING.” Underneath, a drawing of a very small spade."

**Evidence, the canon or the other side:**

> `world/shell-and-magic.md:38` (✅ rule 10): "The Helpers do not talk (parent, 8 Oct 2026). They bleat, snort, squeak, nod, stare. The farmer ... understands them from a nod, a strange look, or how the sound sounds." `characters/helpers.md:55` (Job: medicine). `game-design-round4.md:73` (job list: gather a herb, turn the drying rack, make a tea or syrup). Game c5_badger (`25-chapter-5.json`): ""Tea first," he seems to say."

**Proposed fix.** Make the card pictures only, and use the badger's real jobs (herbs, tea) with a moon for "at night".

**Exact replacement wording:**

```
Pinned to your door, held on by a thorn, is a card. On it, in careful claw-scratch: a basket, a bunch of leaves, and a cup. Underneath, a very small moon. You look into the dark yard. Two eyes look back, level, patient. You pin the card back up. It seems rude not to.
```

**Action:** EDIT · **PARENT?** no

### F-006 · BLOCKER · c6_quilt · story/texts/more-ch6.md:70-73 · EDIT

**Piece:** `c6_quilt` · **File:** `story/texts/more-ch6.md:70-73`

**What is wrong.** Ends with "A year of Hazelwood", which counts game time (✅ D11). Two smaller faults in the same sentence block: "a bit of the blue sail" names a sail that was never described blue (the blue in chapter 6 is the dye vat, c6_dye), and the word "quilt" collides with the item `rainbow_quilt` that the alpaca costs.

**Evidence, the new text:**

> more-ch6.md:73: "A year of Hazelwood, sewn together by people you have not quite caught doing it." and "a bit of the blue sail"

**Evidence, the canon or the other side:**

> D11 ✅ as in F-004. `godot-prototype/data/farm/nodes/06-main-path-chapter-5.json:21`: `pet_alpaca` costs `golden_honey_cake`, `rainbow_roast` and `rainbow_quilt` (item in `items.json:131`, recipe in `recipes.json:93`). c6_dye (`more-ch6.md:28`) is where cloth turns blue.

**Proposed fix.** Drop the year; keep the blue generic (the dye vat may not exist yet); call it a patchwork cover so it is not confused with the alpaca's quilt.

**Exact replacement wording:**

```
Spread across the linen on your bed, a patchwork cover, every square a different cloth. You can pick out a few: Maud's checked apron, a scrap of blue, something that smells faintly of lavender. All of Hazelwood, sewn together by people you have not quite caught doing it.
```

**Action:** EDIT · **PARENT?** no

### F-007 · BLOCKER · c6_eve · story/texts/more-ch6.md:75-78 · EDIT

**Piece:** `c6_eve` · **File:** `story/texts/more-ch6.md:75-78`

**What is wrong.** Says "A year ago none of this was here." That counts game time (✅ D11) and is false: chapter 6 starts at step 906, about seven and a half game years in. The last two sentences ("You are not sure that it is *here* now. You are only sure that you are.") are also abstract for a six-year-old and come close to the 🔒🔒 layer that must never be in the text (the listener's own wholeness, `book-file.md:59`); that part is a judgement call.

**Evidence, the new text:**

> more-ch6.md:78: "A year ago none of this was here. You are not sure that it is *here* now. You are only sure that you are."

**Evidence, the canon or the other side:**

> D11 ✅ as in F-004. `book-file.md:59`: "The melody comes from the conch (🔒🔒 the listener's own wholeness, projected; never in text)". Chapter 6 = steps 906-1069 (`code-issues-story-timing.md:3`). The text is also the longest single page of the 166 (77 words; the longest existing page has 47).

**Proposed fix.** Drop the year and the abstract ending, and keep the exact echo of c1_fire ("the ash around it glows a little, as if it remembers something", wanted by `outline/long-game.md:58`). The new ending is plain and shorter.

**Exact replacement wording:**

```
Evening. You light the fire in the yard, the first thing you ever lit here. The spark takes on the first try. The ash around it glows a little, as if it remembers something. You sit with your back against the fence you built. The bucket, by the door, is full of rain. None of this was here when you came. Now it is, and you are sitting in the middle of it.
```

**Action:** EDIT · **PARENT?** no

### F-008 · MAJOR · c1_maud · story/texts/more-ch1.md:147-150 · EDIT

**Piece:** `c1_maud` · **File:** `story/texts/more-ch1.md:147-150`

**What is wrong.** The text says the goat "is not your goat, which is a relief to everyone". The canon says the opposite: Maud's goat is not Bramble, "which disappoints everyone", and the running snag "the goat that is not Bramble" only works as a small letdown.

**Evidence, the new text:**

> more-ch1.md:150: "The goat is not your goat, which is a relief to everyone."

**Evidence, the canon or the other side:**

> `characters/hazelwood-people.md:12`: "Her goat keeps running off (and the goat is *not* Bramble, which disappoints everyone)." `outline/long-game.md:45` (snag "The goat that is not Bramble", ch1 c1_maud to ch3). In the same sentence block, "Berit's chin" describes the farmer's body (see F-071); the replacement removes it.

**Proposed fix.** Use the canon wording, and drop the chin.

**Exact replacement wording:**

```
The goat is not your goat, which disappoints everyone, the goat included. Granny Maud takes your face in both hands. “Berit all over,” she says. “Berit's stubborn self.” Her eyes are wet. She blames the goat.
```

**Action:** EDIT · **PARENT?** no

### F-009 · MAJOR · c2_reply · story/texts/more-ch2.md:30-35 · KEEP-AND-DECIDE · PARENT?

**Piece:** `c2_reply` · **File:** `story/texts/more-ch2.md:30-35`

**What is wrong.** The mother's letter ends "Ask Maud about the goat." That is an instruction to a child with no payoff: no later piece sends the player to Maud, Maud may not have been met (sq_lost_goat is an optional favour) and c3_maud_goat never mentions the mother. A thread left open.

**Evidence, the new text:**

> more-ch2.md:35: "Under that, in smaller letters: “Ask Maud about the goat.” You do not know what that means."

**Evidence, the canon or the other side:**

> `09-side-quests.json:4` (sq_lost_goat is one of the optional favours). `more-ch3.md:63` (c3_maud_goat: no reference to the letter). `outline/long-game.md:45` (the goat snag does not list the mother).

**Proposed fix.** Either pay it off in c3_maud_goat (Option A, a small joke that keeps Maud in character and also fixes F-012), or cut the line (Option B). The parent decides; Option A is what I would pick.

**Exact replacement wording:**

**Option A: c3_maud_goat as two pages (replaces more-ch3.md:63; also solves "The goat stays"):**

```
Page 1. Granny Maud's goat sits in your yard looking pleased with itself. “She keeps coming here,” says Maud, with the air of someone solving a crime. “Do you suppose it's a clue?” You do not, and say so. Maud nods sadly. “It is, though.”

Page 2. “Your mother wrote to me, you know. She said I should tell you about a goat. I have quite forgotten which.” She pats your arm, takes the rope, and leads the goat home. The goat looks back twice.
```

**Option B: c2_reply page 2 without the last line:**

```
Page 2. “I am glad. I am not going to say 'I told you so', because I never told you anything. Eat properly. The table is still long.” You put the letter with the other one.
```

**Action:** KEEP-AND-DECIDE · **PARENT?** yes, the parent must decide

### F-010 · MAJOR · c2_barn_done · story/texts/more-ch2.md:65 · EDIT

**Piece:** `c2_barn_done` · **File:** `story/texts/more-ch2.md:65`

**What is wrong.** The text speaks of two things that do not exist yet when it fires. "The blackened hook" is found only later, by c2_hook, which waits for `seen:c2_tortoise`. "Faintly, of cow": the cow (animal_cow) needs the finished barn, so she arrives after barn_1. A reader meets a hook and a cow that the story has not shown.

**Evidence, the new text:**

> more-ch2.md:65: "It smells of new pine and, faintly, of cow. You think about the blackened hook and the corner where the hay was."

**Evidence, the canon or the other side:**

> `texts/ch2.md:88-91` (c2_hook, `seen:c2_tortoise`): "In the new barn frame you find an old iron hook. It is black with soot ..." Nodes: `animal_cow` requires `barn_1` and `crop_clover`; `pet_tortoise` requires `animal_cow` (`03-main-path-chapter-2.json:37`). The order is barn_1, then the cow, then the tortoise, then the hook.

**Proposed fix.** Same replacement as F-001: no hook, no cow.

**Replacement:** *(see F-001)*

**Action:** EDIT · **PARENT?** no

### F-011 · MAJOR · c2_tortoise_omen · story/texts/more-ch2.md:92-95 · EDIT

**Piece:** `c2_tortoise_omen` · **File:** `story/texts/more-ch2.md:92-95`

**What is wrong.** The piece fires on `has:shell_house:1`, that is, while the farmer holds the shell house and before the tortoise exists, but its text has the tortoise inspect the house, step in and sit like a landlady. The arrival beat c2_tortoise ("Something very slow is crossing the yard") is then the second first meeting. The pet's cost is consumed when she comes home, so the omen can only ever show before her.

**Evidence, the new text:**

> more-ch2.md:95: "The tortoise gives it a long, suspicious inspection. Then she steps inside, turns round and sits in the doorway like a landlady."

**Evidence, the canon or the other side:**

> `godot-prototype/data/farm/nodes/03-main-path-chapter-2.json:37`: `pet_tortoise` cost = `garden_platter` 1, `shell_house` 1 (consumed). Game c2_tortoise (`15-chapter-2.json`): "Something very slow is crossing the yard." The sibling omens are written correctly: c1_hutch "You do not know who it is for" (`more-ch1.md:180`), c5_tea_set "Nobody comes" (`more-ch5.md:53`).

**Proposed fix.** Write it as an omen: the house is set out, nobody is in it. (The pond may not exist yet either; see F-076.)

**Exact replacement wording:**

```
You set the little shell house at the edge of the pond, door towards the water. It is exactly big enough for someone who carries their own roof. You step back and look at it. It looks back, empty and patient.
```

**Action:** EDIT · **PARENT?** no

### F-012 · MAJOR · c3_maud_goat, c3_dread2, c3_goat_shed · story/texts/more-ch3.md:63, … · EDIT

**Piece:** `c3_maud_goat, c3_dread2, c3_goat_shed` · **File:** `story/texts/more-ch3.md:63 / 78 / 53`

**What is wrong.** Three chapter-3 pieces disagree about whether a goat lives at the farm before Bramble comes home. c3_maud_goat ends "The goat stays", and c3_dread2 has "the goat" step on the farmer's list, but chapter 3 is exactly the stretch before pet_goat (chapter 4 starts when the goat is home) and c3_k_nibbled correctly says "You have no goat". The goat's real arrival (c3_goat, "A goat trots up the path") would then be the second one. In c3_goat_shed the goat is not said to be anyone's.

**Evidence, the new text:**

> more-ch3.md:63 "The goat stays."; more-ch3.md:78 "Then the goat steps on the paper"; more-ch3.md:128 (c3_k_nibbled, `chapter:3`) "You have no goat."; more-ch3.md:53 "The goat walks in, walks out, climbs on the roof".

**Evidence, the canon or the other side:**

> `game/farm/game.gd:517-522`: the chapter number is 1 + the number of pets at home, so `chapter:3` ends the moment pet_goat is done. `outline/ladder.md:85` (3.7): "The goat (once back) eats your list, then your new list." Game c3_goat: "A goat trots up the path and straight into the brambles". `characters/hazelwood-people.md:12` (Maud's goat is not Bramble). c3_dread2 fires `after:c3_letter:16`, about 16 questions into chapter 3.

**Proposed fix.** Keep c3_k_nibbled as it is (it is the right first step of the list snag). Make Maud's goat leave. Take the goat out of c3_dread2. In c3_goat_shed make the goat "a goat" (Maud's before Bramble, Bramble after).

**Exact replacement wording:**

**c3_maud_goat, last sentences (or use Option A in F-009):**

```
Maud nods sadly. “It is, though.” She pats your arm, takes the rope, and leads the goat home. The goat looks back twice.
```

**c3_dread2, last sentence:**

```
Then a hen walks across the paper, and you have to start over, and it somehow feels better.
```

**c3_goat_shed, second sentence:**

```
A goat walks in, walks out, climbs on the roof, and looks down at you with great satisfaction.
```

**Action:** EDIT · **PARENT?** no

### F-013 · MAJOR · c4_watch · story/texts/more-ch4.md:45-48 · EDIT

**Piece:** `c4_watch` · **File:** `story/texts/more-ch4.md:45-48`

**What is wrong.** The favour is "A lantern for the night watchman" and the album picture is Pieter "holding your glowing lantern on the town wall". The text has Pieter at a gatepost, with no lantern from the farmer, saying a light "doesn't move like a lantern". The reward and the scene do not match.

**Evidence, the new text:**

> more-ch4.md:48: "Pieter leans on the gatepost and looks out over the marsh."

**Evidence, the canon or the other side:**

> `09-side-quests.json:23` (sq_night_watch: "A lantern for the night watchman"; picture "Night watchman Pieter holding your glowing lantern on the town wall"; requires glass_kiln, anvil, pet_goat). `characters/hazelwood-people.md:47` (tiny light over the marsh).

**Proposed fix.** Put the new lantern in his hand and him on the wall; keep the tiny light and the line "paid to notice, not paid to say".

**Exact replacement wording:**

```
Pieter holds your new lantern up on the town wall and looks out over the marsh. “There's a light out there,” he says. “Some nights. Very small. It doesn't move like a lantern.” He rubs his eyes. “I'm paid to notice, you see. I'm not paid to say.” He says it anyway, and then walks off whistling, so you will not ask.
```

**Action:** EDIT · **PARENT?** no

### F-014 · MAJOR · c4_mei · story/texts/more-ch4.md:50-53 · EDIT

**Piece:** `c4_mei` · **File:** `story/texts/more-ch4.md:50-53`

**What is wrong.** Four problems. (1) "A year's worth" of undelivered letters and "I'm sorry I didn't carry them quicker" contradict the letters Mei already brought on time (c2_letter, c2_reply, c3_letter), and it counts a year (D11). (2) It ignores its own trigger: sq_long_voyage is "Pickles for a long voyage" and the album picture is Mei waving a jar of pickles from her boat; no pickles appear. (3) The header and the docs promise "Mei ... no pronoun for her partner"; there is no partner in the text. (4) The kind is `letter`, but no letter is read: Mei comes ashore like a visit.

**Evidence, the new text:**

> more-ch4.md:53: "Letters. A year's worth, or something like it, tied with string. “Your mother,” she says. “She wrote them all and I carried them all. I'm sorry I didn't carry them quicker.”

**Evidence, the canon or the other side:**

> `15-chapter-2.json` c2_letter: "Mei from the barge nods, hands it over and rows on." more-ch2.md:33 (c2_reply: "Mei nods as before"). `20-chapter-3.json` c3_letter. `09-side-quests.json:24` (sq_long_voyage: "Pickles for a long voyage"; picture "Sailor Mei waving a jar of your pickles from the deck of her boat"). Header `more-ch4.md:3`, `outline/long-game.md:62`, `book-file.md:189` (partner). D11: F-004.

**Proposed fix.** Make it the pickles hand-over, with one letter from the mother (the letter strand is "about once a chapter", `characters/berit-and-family.md:26`). The partner invention is not written; strike it from the docs or add it later (F-098).

**Exact replacement wording:**

```
Captain Mei holds the jar of pickles up to the light and nods, as if it had passed an exam. “For the long voyage,” she says. Then she sets a letter on your table. “Your mother. She asked me to hand it over myself.” She does not stay for tea. She does stay for a very long look at the letter.
```

**Action:** EDIT · **PARENT?** no

### F-015 · MAJOR · c5_n_foxglove · story/texts/more-ch5.md:25-28 · EDIT · PARENT?

**Piece:** `c5_n_foxglove` · **File:** `story/texts/more-ch5.md:25-28`

**What is wrong.** The second hand is "apparently ten years old". That gives an age; the text never counts ages (✅ D11, `00-timeline.md:9` "no in-game text gives ... Fenna's age"). It also adds an invention that the header does not list (a child's hand in Berit's book, which can only be the farmer's own). Whether the farmer wrote "She does." as a child is a lovely idea, but it is the parent's call.

**Evidence, the new text:**

> more-ch5.md:28: "Underneath, in another hand, smaller, apparently ten years old: “She does.”"

**Evidence, the canon or the other side:**

> `world/00-timeline.md:9`; `00-premise.md:38`. `more-ch5.md:3` (header lists no invention). The material of the first hand is also wrong, see F-053.

**Proposed fix.** Take out the age; leave the second hand open. The same edit sets the ink (see F-053).

**Exact replacement wording:**

```
Beside the foxglove, in thick brown ink, pressed hard: “LOOK, DON'T TOUCH. I MEAN IT. — B.” Underneath, in another hand, smaller and rounder: “She does.”
```

**Action:** EDIT · **PARENT?** yes, the parent must decide

### F-016 · MAJOR · c5_lamp · story/texts/more-ch5.md:45-48 · EDIT

**Piece:** `c5_lamp` · **File:** `story/texts/more-ch5.md:45-48`

**What is wrong.** The lamp-maker is "Old lamp-maker Ferdinand" and the favour is olive oil for his lamp. The text has "her new lamp" (wrong pronoun, and the lamp is not new: the farmer brought oil). The long-game snag table also counts this piece as the second appearance of the tiny light, but there is no light over the marsh in it.

**Evidence, the new text:**

> more-ch5.md:48: "The lamp-maker lights her new lamp ... She says it lightly. She has plainly thought about it a great deal."

**Evidence, the canon or the other side:**

> `09-side-quests.json` sq_lamp_maker: "Oil for the old lamp-maker"; picture "Old lamp-maker Ferdinand holding a lamp filled with your olive oil, glowing." `characters/hazelwood-people.md:50`. `outline/long-game.md:50` (tiny light: ch5 c5_lamp).

**Proposed fix.** Ferdinand is a "he", the farmer's oil is what burns, and the tiny light of the snag table (`outline/long-game.md:50`) gets its second appearance.

**Exact replacement wording:**

```
The lamp-maker pours your oil into a lamp and lights it. The light is round and yellow and steady. “It's for the marsh road,” he says. “There is a very small light out there some nights, and it is no help at all. People shouldn't have to feel their way.” He says it lightly. He has plainly thought about it a great deal.
```

**Action:** EDIT · **PARENT?** no

### F-017 · MAJOR · c6_terraces · story/texts/more-ch6.md:10-13 · EDIT · PARENT?

**Piece:** `c6_terraces` · **File:** `story/texts/more-ch6.md:10-13`

**What is wrong.** Two problems. (1) The swing is in the wrong orchard: c3_swing hangs it in the first orchard (`done:orchard`), but c6_terraces says the old swing hangs "at the top branch" of the second orchard, which has only just been planted (`orchard_2`, "Orchard terraces"). (2) "Someone is sitting on it, kicking their feet, eating an apple" puts a figure in front of the farmer. The only occupant the canon allows is Mumyo, who is "no bigger than a hand" and whom Fenna "never sees again after the fire" (✅); a hand-sized creature cannot kick its feet on a child's swing, and the farmer would be seeing him. If it is meant to be somebody else (the cousin only arrives for the Fair), the text names nobody.

**Evidence, the new text:**

> more-ch6.md:13: "At the top branch, the old swing hangs. Someone is sitting on it, kicking their feet, eating an apple. You cannot see who. You do not need to. The knot holds."

**Evidence, the canon or the other side:**

> `characters/mumyo.md:7` ("No bigger than a hand"), `:14` ("Fenna never sees him again after the fire", ✅), `:18` ("He has no voice", 💡). `outline/long-game.md:49` (snag: "c6_terraces (someone sits on it)"). `more-ch3.md:143` (c3_swing: "the thickest branch" of the first orchard). Node `orchard_2` (chapter 6, "Orchard terraces").

**Proposed fix.** Keep the snag and the secret, as a trace (like every other Mumyo moment): the swing is still moving, an apple core lies on the plank, nobody is seen. Put the swing back in the first orchard. If the parent wants a visible child, that is a decision about the ✅ rule, so it is flagged.

**Exact replacement wording:**

```
The second orchard goes in, row on row, a green stair up the hill. Down in the first orchard, the old swing is still moving, just a little, as if somebody has only just got off. On the plank lies an apple core, eaten down to the pips. You do not need to know who. The knot holds.
```

**Action:** EDIT · **PARENT?** yes, the parent must decide

### F-018 · MAJOR · c6_theatre · story/texts/more-ch6.md:30-33 · EDIT

**Piece:** `c6_theatre` · **File:** `story/texts/more-ch6.md:30-33`

**What is wrong.** The favour is cheese for the travelling theatre, and the picture is the lead actor taking a bow with your cheese wheel. The text makes it "the village play" with Greenstem as the cheese, and never shows the farmer's cheese.

**Evidence, the new text:**

> more-ch6.md:33: "The village play is about a cheese ... Greenstem plays the cheese."

**Evidence, the canon or the other side:**

> `09-side-quests.json` sq_theatre_cheese: "Cheese for the travelling theatre"; picture "The lead actor taking a bow while holding your cheese wheel high." `characters/hazelwood-people.md:54` ("the travelling theatre ... come through for the Fair"). "committed to a dairy product" also uses a stretch word (F-059).

**Proposed fix.** Make it the travelling theatre and put the farmer's cheese in the actor's hands.

**Exact replacement wording:**

```
The travelling theatre's play is about a cheese. It is a great cheese. It gets lost, and found, and mistaken for the moon. The lead actor holds your cheese wheel very still for the whole second act. You have never seen anyone so serious about a cheese.
```

**Action:** EDIT · **PARENT?** no

### F-019 · MAJOR · c6_n_last · story/texts/more-ch6.md:95-98 · EDIT

**Piece:** `c6_n_last` · **File:** `story/texts/more-ch6.md:95-98`

**What is wrong.** The header says the final note must not come before the supper, but the trigger `cards>=87` does not ask for the supper. A discovery ranks below every beat, so it waits only while a beat is ready; it can show before the alpaca, the supper and the garden. "There is nothing printed on it" also makes the book a printed one (see F-020), and the pencil is wrong (see F-053).

**Evidence, the new text:**

> more-ch6.md:3 (header): "The final margin note is the book's last word; do not move it before the supper." more-ch6.md:96: `cards>=87`.

**Evidence, the canon or the other side:**

> `game/farm/systems/story.gd:8` (kind order frame, beat, discovery, ...). Game c6_supper `seen:c6_alpaca`; c6_ajar `seen:c6_supper`; c6_frame6 `seen:c6_ajar`. 87 cards exist (`nodes/11-knowledge-cards.json`, checked).

**Proposed fix.** Add `seen:c6_supper` to the trigger. After the supper and the end frames the note shows in free play, which is outside the frame (✅ no epilogue chapter, `outline/ladder.md:166`), so it still reads as the book's last word.

**Exact replacement wording:**

**When:**

```
cards>=87 + seen:c6_supper
```

**Text:**

```
You turn to the last page in the book. It is empty. Only, in the margin, in thin brown ink, in a hand you know so well by now: “Well. Look at that. You read all of it. Go and put the kettle on, my love.”
```

**Action:** EDIT · **PARENT?** no

### F-020 · MAJOR · c1_n_* … c6_n_* (21 of the 25 margin-note pieces) · several files · KEEP-AND-DECIDE · PARENT?

**Piece:** `c1_n_* … c6_n_* (21 of the 25 margin-note pieces)` · **File:** `story/texts/more-ch1.md … more-ch6.md` (lines: 190-210, 100-120, 88-108, 63-78, 28-33, 83-93)

**What is wrong.** Berit's notes sit on cards that belong to books the farmer buys at the book cart, not to Berit's own book. Only the free "Little Farm Book" (book_basics, "Was already in the box in the tent") is hers; it holds 4 of the 25 note pieces (k_fire, k_weeds, k_ash, k_chickens). The other 21 are on cards of bought books (book_village for k_market, book_kitchen "Grandma's Kitchen" for k_bread, book_animals, book_soil, book_body, book_smith, book_cloth, book_cellar, book_glass, book_orchard, book_herbal, book_master). Berit died before the game; a freshly bought book cannot carry her handwriting. The c6_n_last text also says "nothing printed", which makes the book a printed one.

**Evidence, the new text:**

> c1_bookcart_tap (more-ch1.md:48): "You check your own book" (one book). Game c1_book: "The book in the box is old. On the first page, in thin brown ink". `00-premise.md:114`: "the farm book in the matriarch's handwriting". `characters/berit-and-family.md:10`: her voice is "her handwriting in the book".

**Evidence, the canon or the other side:**

> `godot-prototype/data/farm/nodes/10-books-and-library.json` (book_basics free; every other book `requires book_cart` and costs coins; book_cart "Comes with the travelling merchant"). Card to book: `11-knowledge-cards.json` (k_* `requires` the book).

**Proposed fix.** A decision for the parent, three options: (A) the cart sells books that came from Berit's own shelf (one line added to c1_bookcart_tap, below); (B) only the Little Farm Book carries notes (cut 21 pieces, or move them to cards in book_basics); (C) treat the game's books as the chapters of one book and say nothing. A is the cheapest and adds a quiet mystery.

**Exact replacement wording:**

**Option A, c1_bookcart_tap (more-ch1.md:48):**

```
The book cart smells of dust and the inside of a hat. The bookseller looks up. “Reading is the one thing you cannot do wrong,” he says, “unless it is upside down.” You check your own book. The right way up. Good. “Some of these came from up your way,” he adds. “They are well read.”
```

**Action:** KEEP-AND-DECIDE · **PARENT?** yes, the parent must decide

### F-021 · MINOR · c1_axe · story/texts/more-ch1.md:65-68 · EDIT

**Piece:** `c1_axe` · **File:** `story/texts/more-ch1.md:65-68`

**What is wrong.** The text says "Your first tool", but four tools unlock together (stone knife, hand axe, wooden shovel, stick hoe: all need `workbench` + `k_tools`), so the axe is not necessarily the first.

**Evidence, the new text:**

> more-ch1.md:68: "Your first tool. It fits your hand as if it had been waiting for one."

**Evidence, the canon or the other side:**

> Nodes `stone_knife`, `stone_axe`, `wooden_shovel`, `stick_hoe` (all chapter 1, all require `workbench` and `k_tools`).

**Proposed fix.** Say what is true.

**Exact replacement wording:**

```
Chip, chip, chip. The flake that comes off is sharp enough to split a hair. Your first axe. It fits your hand as if it had been waiting for one.
```

**Action:** EDIT · **PARENT?** no

### F-022 · MINOR · c1_summer, c1_autumn, c1_winter, c1_hunger, c1_spring2 · story/texts/more-ch1.md:70-73, … · KEEP-AND-DECIDE · PARENT?

**Piece:** `c1_summer, c1_autumn, c1_winter, c1_hunger, c1_spring2` · **File:** `story/texts/more-ch1.md:70-73, 95-98, 110-118, 125-128`

**What is wrong.** Chapter 1 now counts its seasons aloud: "The first summer", "The first autumn", "Snow came in the night", "Spring again". Chapter 1 lasts until the bunny comes home, which in the test run was steps 1-244, eight seasons, two winters in a tent. Then c2_letter says "Come home before the frost ... The frost is far away. Isn't it?" and c2_cottage says "A real roof, before the frost". For a slow player this is the third frost. The farmer asked for "a few weeks".

**Evidence, the new text:**

> more-ch1.md:113 "Snow came in the night, without a sound."; more-ch1.md:128 "Spring again."; ch2 JSON c2_letter ("Come home before the frost, my love ... The frost is far away. Isn't it?"); `texts/ch2.md:70` (c2_cottage).

**Evidence, the canon or the other side:**

> D11 ✅ (nobody counts) allows seasons to turn; `00-premise.md:36-38` has the farmer ask for "a few weeks" and the game cover many seasons. `code-issues-story-timing.md:3`: chapter 1 = steps 1-244. `game/farm/systems/seasons.gd`: the season comes from the question count, not from the chapter.

**Proposed fix.** Not a hard error: the letter's frost can be read as "this coming one". If the parent wants it airtight, change the built c2_letter to "before the next frost" (one word in English and German) or leave as is.

**Action:** KEEP-AND-DECIDE · **PARENT?** yes, the parent must decide

### F-023 · MINOR · c1_tower · story/texts/more-ch1.md:75-78 · EDIT

**Piece:** `c1_tower` · **File:** `story/texts/more-ch1.md:75-78`

**What is wrong.** Two small slips. (1) "by the fence": the stick fence is a later build (c1_fence, `done:stick_fence`); `clear_rocks` needs only the wooden shovel, so no fence need exist. (2) "a very small sound, like a laugh, or a bell": a laugh is a voice, and Mumyo has no voice in this game, only bells.

**Evidence, the new text:**

> more-ch1.md:78: "You heap the rocks by the fence ... Only a very small sound, like a laugh, or a bell."

**Evidence, the canon or the other side:**

> `characters/mumyo.md:18` ("He has no voice in this game. Only bells.", 💡). Nodes `clear_rocks` (requires `wooden_shovel`) and `stick_fence` (requires `workbench`, `k_birds`). The first trace piece c1_bells (`texts/ch1.md:57-61`) uses a bell only.

**Proposed fix.** Say "at the edge of the field" and make the sound a bell only.

**Exact replacement wording:**

```
You heap the rocks at the edge of the field. By morning the heap is a tower, each stone balanced on the one below, the smallest on top like a hat. Nothing is missing. You look around. Nobody. Only a very small sound, high and bright, like a bell.
```

**Action:** EDIT · **PARENT?** no

### F-024 · MINOR · c1_cleared · story/texts/more-ch1.md:80-83 · EDIT

**Piece:** `c1_cleared` · **File:** `story/texts/more-ch1.md:80-83`

**What is wrong.** The text says "No thistles. No rocks. No stumps. Where the weeds stood ..." but the trigger is `done:clear_stumps` alone. Stumps need the hand axe, rocks the wooden shovel, thistles nothing: a player can clear stumps first and read that all four are gone while rocks and thistles are still on the field.

**Evidence, the new text:**

> more-ch1.md:81: `*When:* done:clear_stumps` and :83 "No thistles. No rocks. No stumps."

**Evidence, the canon or the other side:**

> Nodes (`/godot-prototype/data/farm/nodes/`): `clear_stumps` requires `stone_axe`; `clear_rocks` requires `wooden_shovel`; `clear_thistles` requires nothing; `clear_weeds` is a requirement of `workbench`.

**Proposed fix.** Wait for all four.

**Exact replacement wording:**

```
When: done:clear_weeds + done:clear_thistles + done:clear_rocks + done:clear_stumps
```

**Action:** EDIT · **PARENT?** no

### F-025 · MINOR · c1_quern · story/texts/more-ch1.md:85-88 · EDIT

**Piece:** `c1_quern` · **File:** `story/texts/more-ch1.md:85-88`

**What is wrong.** The text is about the quern ("The quern grinds ... What comes out is flour"), but the trigger is `has:flour:1`, which is true whenever flour is in the bag, from whatever source.

**Evidence, the new text:**

> more-ch1.md:86-88: `*When:* has:flour:1` ... "The quern grinds with a noise like a cart on a bad road."

**Evidence, the canon or the other side:**

> Node `quern` (station "Hand Quern", requires `workbench`, `clear_rocks`, `k_grinding`).

**Proposed fix.** Make the trigger match the object.

**Exact replacement wording:**

```
When: done:quern + has:flour:1
```

**Action:** EDIT · **PARENT?** no

### F-026 · MINOR · c1_winter · story/texts/more-ch1.md:110-113 · EDIT

**Piece:** `c1_winter` · **File:** `story/texts/more-ch1.md:110-113`

**What is wrong.** The winter prints carry the answer to the chapter's mystery in words: "Somebody has been guarding it." The reveal belongs to c1_bunny, page 2 ("Now you understand. The patch stayed green because somebody looked after it."). c1_winter is gated `chapter:1`, so it can only fire before the bunny, i.e. it spoils the page-2 moment. Borderline: the footprints are the planned Omen, the explaining sentence is the spoiler.

**Evidence, the new text:**

> more-ch1.md:113: "Round it, in the snow: long prints, short prints, three times round. Somebody has been guarding it. The prints stop at the edge of the forest."

**Evidence, the canon or the other side:**

> `texts/ch1.md:89-102` (c1_bunny, page 2): "The patch stayed green because somebody looked after it." `outline/long-game.md:35` (Omen = "footprints"). `story-delivery.md:47` (a Turn is a reveal and should be a Beat).

**Proposed fix.** Keep the footprints, cut the explanation.

**Exact replacement wording:**

```
Snow came in the night, without a sound. The green patch is the last green thing for miles. Round it, in the snow: long prints, short prints, three times round. The prints stop at the edge of the forest.
```

**Action:** EDIT · **PARENT?** no

### F-027 · MINOR · c1_tom · story/texts/more-ch1.md:135-138 · EDIT

**Piece:** `c1_tom` · **File:** `story/texts/more-ch1.md:135-138`

**What is wrong.** The horseshoe is hung "on the tent pole", but the piece has no chapter gate. The favour (`sq_cold_shepherd`) only needs the campfire, so it can be done late; once the cottage stands, the tent is gone.

**Evidence, the new text:**

> more-ch1.md:138: "You hang it on the tent pole anyway."

**Evidence, the canon or the other side:**

> Node `sq_cold_shepherd` (requires `campfire`, optional); `cottage` replaces `tent` (`03-main-path-chapter-2.json`).

**Proposed fix.** A place that exists in every chapter.

**Exact replacement wording:**

```
Tom the shepherd boy has stopped shivering. He presses a bent horseshoe into your hand. “Lucky,” he says. “It never worked for me.” You hang it by the door anyway.
```

**Action:** EDIT · **PARENT?** no

### F-028 · MINOR · c1_ella · story/texts/more-ch1.md:152-155 · EDIT

**Piece:** `c1_ella` · **File:** `story/texts/more-ch1.md:152-155`

**What is wrong.** The piece says "You listen for the other bell, the small high one" as if the player had heard it. That bell is c1_bells (`done:clear_thistles`), a discovery that is not guaranteed to have been seen: `sq_miller_basket` needs only the workbench.

**Evidence, the new text:**

> more-ch1.md:155: "You listen for the other bell, the small high one. This is not that bell."

**Evidence, the canon or the other side:**

> `texts/ch1.md:57-61` (c1_bells, `done:clear_thistles`). Node `sq_miller_basket` (requires `workbench`).

**Proposed fix.** Add the condition.

**Exact replacement wording:**

```
When: done:sq_miller_basket + seen:c1_bells
```

**Action:** EDIT · **PARENT?** no

### F-029 · MINOR · c1_n_fire, c1_n_weeds, c1_n_ash, c1_n_chickens, c1_n_market · story/texts/more-ch1.md:190, … · EDIT

**Piece:** `c1_n_fire, c1_n_weeds, c1_n_ash, c1_n_chickens, c1_n_market` · **File:** `story/texts/more-ch1.md:190, 195, 200, 205, 210`

**What is wrong.** Five margin notes in a row open with the same words, "In the margin, in thin brown ink:". Read as five boxes over one chapter, the frame gets in the way of the voice. (Judgment call; the repetition is the only issue.)

**Evidence, the new text:**

> more-ch1.md:190, 195, 200, 205, 210: "In the margin, in thin brown ink: ..." (five times).

**Evidence, the canon or the other side:**

> Chapters 2 to 6 vary the opening ("Beside the bread page", "Next to the bees", "Under it", "Beside the page about sleep").

**Proposed fix.** Keep the first as it is; vary the other four. The wording of the notes stays.

**Exact replacement wording:**

**c1_n_weeds:**

```
Next to the weeds, small and slanted: “Weeds are only plants nobody invited. Some of my best friends were weeds. — B.”
```

**c1_n_ash:**

```
At the bottom of the ash page, in the same brown ink: “Ash feeds the soil. The soil does not hold a grudge. Take notes. — B.”
```

**c1_n_chickens:**

```
Across the top of the hen page, written in a hurry: “Do not name the hens. You will name the hens. — B.”
```

**c1_n_market:**

```
Squeezed in beside the prices: “A fair price is one both sides complain about equally. — B.”
```

**Action:** EDIT · **PARENT?** no

### F-030 · MINOR · c2_stove · story/texts/more-ch2.md:15-18 · EDIT

**Piece:** `c2_stove` · **File:** `story/texts/more-ch2.md:15-18`

**What is wrong.** The last sentence talks about the farmer in the third person ("Whoever lives here now"), in a book where every other line says "you"; the "now" also invites the question of how long. Neutral, but it is the voice slip the rule is about.

**Evidence, the new text:**

> more-ch2.md:18: "Whoever lives here now does not have to eat standing up."

**Evidence, the canon or the other side:**

> `characters/fenna.md:13`; `story-delivery.md:55` (✅): "nobody talks *about* you in the third person".

**Proposed fix.** Speak to the farmer.

**Exact replacement wording:**

```
The stove ticks as it warms up, the way a cat ticks when it is thinking. The smell of the cottage changes. Wood, and iron, and a pot that is nearly ready to be a soup. You do not have to eat standing up any more.
```

**Action:** EDIT · **PARENT?** no

### F-031 · MINOR · c2_greenstem_hands · story/texts/more-ch2.md:37-40 · EDIT

**Piece:** `c2_greenstem_hands` · **File:** `story/texts/more-ch2.md:37-40`

**What is wrong.** The visit says "The boy with the herbs turns up" and "for a person who built that wall", which only work after c2_greenstem (Greenstem's first visit, `done:d_stone_soup`) and the cottage walls. The trigger `done:d_bread` does not ask for either. The single page has 72 words (35-45 is the form).

**Evidence, the new text:**

> more-ch2.md:38 `*When:* done:d_bread`; :40 "... a good loaf, “for a person who built that wall.” "

**Evidence, the canon or the other side:**

> `texts/ch2.md:23-30` (c2_greenstem, `done:d_stone_soup`: "Why is that wall crooked?"). Node `d_stone_soup` requires `seed_3`; `book-file.md:16` (35-45 words).

**Proposed fix.** Add `seen:c2_greenstem` to the trigger; split into two pages; drop the stretch word "particular".

**Exact replacement wording:**

**When:**

```
done:d_bread + seen:c2_greenstem
```

**Page 1:**

```
The boy with the herbs turns up as the loaf comes out, which is luck or a very good nose. You break it. He holds his half in both hands and breathes it in with his eyes shut. “Rosemary does that,” he says seriously, about nothing much.
```

**Page 2:**

```
He eats the whole half in four bites. “It is a good loaf,” he says, “for a person who built that wall.”
```

**Action:** EDIT · **PARENT?** no

### F-032 · MINOR · c2_snug · story/texts/more-ch2.md:87-90 · EDIT

**Piece:** `c2_snug` · **File:** `story/texts/more-ch2.md:87-90`

**What is wrong.** The title says "The first snow-light", but the chapter 1 winter piece already has snow (c1_winter: "Snow came in the night"), and the trigger `season:winter + chapter:2 + done:cottage` can be the second or third winter. Titles show in the scroll.

**Evidence, the new text:**

> more-ch2.md:87: "## c2_snug · moment · The first snow-light"

**Evidence, the canon or the other side:**

> more-ch1.md:113 (c1_winter); `story-delivery.md:11` (pieces stay in the scroll, so titles are read again).

**Proposed fix.** Drop "first".

**Exact replacement wording:**

```
Title: Snow-light
```

**Action:** EDIT · **PARENT?** no

### F-033 · MINOR · c2_n_sleep · story/texts/more-ch2.md:117-120 · EDIT

**Piece:** `c2_n_sleep` · **File:** `story/texts/more-ch2.md:117-120`

**What is wrong.** The note says what the built game's c2_berit_note already says ("Rest the field. Rest yourself. — B."), in other words: two boxes in chapter 2 for one idea. The rest strand (ladder: Berit's note ch2, the field rests ch4, you rest ch5) is better served by a short echo than a repeat.

**Evidence, the new text:**

> more-ch2.md:120: "Beside the page about sleep: “Even the field sleeps. Don't be prouder than the field.” "

**Evidence, the canon or the other side:**

> `godot-prototype/data/farm/story/15-chapter-2.json`, c2_berit_note: "Between two pages of the old book there is a note in thin brown ink: “Rest the field. Rest yourself. — B.”" `outline/ladder.md` (strand table, "Rest").

**Proposed fix.** A one-line echo that only works because the other note exists.

**Exact replacement wording:**

```
Beside the page about sleep, in thin brown ink, underlined twice: “You, too.”
```

**Action:** EDIT · **PARENT?** no

### F-034 · MINOR · c3_tower · story/texts/more-ch3.md:30-33 · EDIT

**Piece:** `c3_tower` · **File:** `story/texts/more-ch3.md:30-33`

**What is wrong.** Geography and register. (1) "Hazelwood is small and clear below you ... Beyond it the forest": the forest lies west and north of the farm, the village road comes from the east, so the forest is behind you, not beyond the village. (2) Register A, immediately followed by c3_sails (A to W): the two are consecutive builds (windmill_1 requires windmill_tower), and the plan promises awe pieces are never adjacent. Page is 58 words.

**Evidence, the new text:**

> more-ch3.md:33: "Hazelwood is small and clear below you ... Beyond it the forest, and beyond that, more."

**Evidence, the canon or the other side:**

> `world/hazelwood.md:7` ("forest in from the top left, village road from the top right"), `:10` ("The Moonstone Forest: to the west and north"). `outline/long-game.md:22` (awe never adjacent). Node `windmill_1` requires `windmill_tower`.

**Proposed fix.** Turn the forest round, shorten, and set Register to W.

**Exact replacement wording:**

```
The tower stands, taller than anything you have made yet, with nothing at the top. A round, empty room full of wind. You climb to the last step. Hazelwood lies small and clear below you, like a map drawn with great care. Behind you, the forest, and beyond that, more.
```

**Action:** EDIT · **PARENT?** no

### F-035 · MINOR · c3_north · story/texts/more-ch3.md:55-58 · RETIME

**Piece:** `c3_north` · **File:** `story/texts/more-ch3.md:55-58`

**What is wrong.** The piece fires on `done:north_field_clear`, a chapter 4 node (requires `iron_hoe`, `barn_2`), so it cannot show in chapter 3, and the file header says it fills chapter 3's drought. It belongs in chapter 4. (Chapter 4's c4_no, `texts/ch4.md:37`, already mentions the North Field "resting under clover", see B.)

**Evidence, the new text:**

> more-ch3.md:56: `*When:* done:north_field_clear`

**Evidence, the canon or the other side:**

> Node `north_field_clear`: chapter 4, requires `iron_hoe`, `barn_2`. `more-ch3.md:3` ("these fill [the drought]").

**Proposed fix.** Move it, rename it, keep the text.

**Replacement:** *(move to more-ch4.md as c4_north; text unchanged)*

**Action:** RETIME · **PARENT?** no

### F-036 · MINOR · c3_board · story/texts/more-ch3.md:110-113 · EDIT

**Piece:** `c3_board` · **File:** `story/texts/more-ch3.md:110-113`

**What is wrong.** Tone drift (judgment call). "WELCOME BACK, WE SUPPOSE." is the chapter 1 village, but the farmer has by now been thanked (c2_board "THANK YOU, KEEP IT"), praised in the lane (c2_hilde) and thanked by Pieter (c3_pieter_paid). The closing "You do not ask" repeats c3_scarecrow2 ("not to ask any questions").

**Evidence, the new text:**

> more-ch3.md:113: "“WELCOME BACK, WE SUPPOSE.” ... You are not sure what it means. You do not ask."

**Evidence, the canon or the other side:**

> `more-ch2.md:125` (c2_board); `texts/ch3.md:19` (c3_pieter_paid: "Thank you."); `more-ch3.md:43`.

**Proposed fix.** Keep the firm hand and the goat, make the welcome grudging but warm.

**Exact replacement wording:**

```
The board in the square has a new notice, in a very firm hand: “WELCOME BACK. WE HAD OUR DOUBTS.” It is not signed. Under it someone has drawn a small goat. You are not sure what it means. You take it as a compliment.
```

**Action:** EDIT · **PARENT?** no

### F-037 · MINOR · c3_k_wind · story/texts/more-ch3.md:115-118 · EDIT

**Piece:** `c3_k_wind` · **File:** `story/texts/more-ch3.md:115-118`

**What is wrong.** The bark ("The sails turn once, creak, and stop") fires on `done:ruins_windmill`, when the old mill is only cleared. The sails come with `windmill_1` / `canvas_sails`.

**Evidence, the new text:**

> more-ch3.md:116: `*When:* done:ruins_windmill + chance:0.15`

**Evidence, the canon or the other side:**

> Nodes `ruins_windmill` ("Clear the old mill") then `windmill_tower`, then `windmill_1`, `canvas_sails`. `texts/ch3.md:51-58` (c3_bell: the old mill is a ruin with a rusty nail).

**Proposed fix.** Wait for the windmill.

**Exact replacement wording:**

```
When: done:windmill_1 + chance:0.15
```

**Action:** EDIT · **PARENT?** no

### F-038 · MINOR · c3_swing · story/texts/more-ch3.md:140-143 · EDIT

**Piece:** `c3_swing` · **File:** `story/texts/more-ch3.md:140-143`

**What is wrong.** The swing is found "among the young trees", but the node is "Clear the old orchard", with old trees; saplings come with later seeds (seed_4: apple saplings, "apples need the old orchard cleared"). A rope on "the thickest branch" of a young tree does not work.

**Evidence, the new text:**

> more-ch3.md:143: "Among the young trees you find a rope hanging from the thickest branch."

**Evidence, the canon or the other side:**

> Node `orchard` (chapter 2 field, in `04-main-path-chapter-3.json`): name "Clear the old orchard", desc "Special patch 1: room for 3 fruit or nut trees." Node `seed_4` desc: "apple saplings (apples need the old orchard cleared)". Also see D on the chapter field.

**Proposed fix.** Old trees.

**Exact replacement wording:**

```
Among the old trees you find a rope hanging from the thickest branch. A plank, worn smooth. Somebody once sat here. The knot at the top has been retied, and not well, and not long ago. You test the swing with one hand. It holds. You do not know who retied it. You do not sit down. Not yet.
```

**Action:** EDIT · **PARENT?** no

### F-039 · MINOR · c4_receipt · story/texts/more-ch4.md:10-13 · EDIT

**Piece:** `c4_receipt` · **File:** `story/texts/more-ch4.md:10-13`

**What is wrong.** Three small things. (1) "next to the pressed flower": there is no pressed flower anywhere in the story. What the farmer keeps is the burnt ledger page (c1_ledger: "You fold the page small and keep it"; c4_lease holds it beside the lease). A receipt beside the burnt page is the better rhyme: both are paper from the Lord's side. (2) "Someone, at the other end of all that paperwork, took the trouble" leaves open who wrote "Thank you"; the plan makes it Pieter's gesture. (3) The page has 62 words. (Kind `beat` is defensible here: it is the end of the Pieter strand.)

**Evidence, the new text:**

> more-ch4.md:13: "You put the receipt in the book, next to the pressed flower." and "Someone, at the other end of all that paperwork, took the trouble."

**Evidence, the canon or the other side:**

> `texts/ch1.md:64-69` (c1_ledger, "You fold the page small and keep it"), `texts/ch4.md:30` ("You take out the burnt page from the workshop and hold it beside it"). `outline/long-game.md:44` (snag: the lantern ends in `c4_receipt`), `:62` ("Pieter's flask; the receipt"). No search hit for "pressed flower" in any text.

**Proposed fix.** Burnt page instead of flower; make the thanks Pieter's (with a child's doubt); shorten.

**Exact replacement wording:**

```
Pieter gives you a receipt. You have never had one. It says what you paid and what it was for, and in one corner, in tiny letters: “Thank you.” Somebody took the trouble. You hope it was Pieter. You fold it small and keep it with the burnt page.
```

**Action:** EDIT · **PARENT?** no

### F-040 · MINOR · c4_greenhouse, c4_k_winter · story/texts/more-ch4.md:20-23, … · EDIT

**Piece:** `c4_greenhouse, c4_k_winter` · **File:** `story/texts/more-ch4.md:20-23, 85-88`

**What is wrong.** c4_greenhouse says the cold stays outside and "the first tomato of the year ... in the middle of a frost", but its trigger `done:greenhouse` has no season; built in July the frost is wrong. The bark c4_k_winter ("Frost on the glass in the greenhouse") does not ask for the greenhouse at all, only `season:winter + chapter:4`.

**Evidence, the new text:**

> more-ch4.md:23: "the cold stays outside like a dog that has been told ... in the middle of a frost"; :86 `*When:* season:winter + chapter:4 + chance:0.2`.

**Evidence, the canon or the other side:**

> Node `greenhouse`: chapter 4, requires `greenhouse_frame`, `glass_kiln`; no season. `game/farm/systems/seasons.gd` (the season comes from the step count).

**Proposed fix.** Take the weather out of the piece; add the node to the bark.

**Exact replacement wording:**

**c4_greenhouse:**

```
You step in and shut the door, and the weather stays outside like a dog that has been told. Warm air. Wet air. Green air. Rows of leaves reach for the glass. The first tomato has chosen to be here, whatever the season outside, and you take your hat off to it.
```

**c4_k_winter, When:**

```
season:winter + chapter:4 + done:greenhouse + chance:0.2
```

**Action:** EDIT · **PARENT?** no

### F-041 · MINOR · c4_blanket · story/texts/more-ch4.md:25-28 · RETIME

**Piece:** `c4_blanket` · **File:** `story/texts/more-ch4.md:25-28`

**What is wrong.** Filed in chapter 4, but its node `wool_mattress` is a chapter 3 build, so a player who builds it in chapter 3 gets the "somebody has folded the blanket" moment only after the goat has come home. The Move is labelled Omen, but nothing is coming: the lavender is picked up again by c6_quilt, so it is a Plant. The giver cannot be Mumyo ("He never helps with work"), so it is the village, which is what c6_quilt says.

**Evidence, the new text:**

> more-ch4.md:26: `*When:* done:wool_mattress` · `*Move:* Omen`; :28 "Somebody has folded the blanket ... a faint smell of lavender."

**Evidence, the canon or the other side:**

> Node `wool_mattress`: chapter 3 (requires `straw_bed`, `hand_loom`). `characters/mumyo.md:55` ("He never helps with work"). `more-ch6.md:73` (c6_quilt: "something that smells faintly of lavender ... sewn together by people you have not quite caught doing it"). `more-ch3.md:3` (chapter 3 has the long drought).

**Proposed fix.** Move to chapter 3 (it fills the drought), change the Move to Plant. Text unchanged.

**Replacement:** *(move to more-ch3.md as c3_blanket; Move: Plant; text unchanged)*

**Action:** RETIME · **PARENT?** no

### F-042 · MINOR · c4_wedding · story/texts/more-ch4.md:40-43 · EDIT

**Piece:** `c4_wedding` · **File:** `story/texts/more-ch4.md:40-43`

**What is wrong.** (1) The cake has "three tiers" and a "middle tier", but the delivery is two things (a berry cake and an apple pie) and the album picture shows one cake. (2) The simile "as if a bell had rung" spends the bell motif (Mumyo's small high bell, the hall bell) on a cheer.

**Evidence, the new text:**

> more-ch4.md:40 title "A cake with three tiers"; :43 "The cake leans a little, in the middle tier ... everyone cheers as if a bell had rung."

**Evidence, the canon or the other side:**

> Node `sq_wedding_cake` cost `berry_cake` 1, `apple_pie` 1; picture "The bride and groom holding your cake between them, laughing." `outline/long-game.md:46` (snag: "the cake's middle tier" as a crooked thing).

**Proposed fix.** Keep the crooked middle (the snag wants it), say where it comes from, drop the bell.

**Exact replacement wording:**

```
Title: A tall cake

The cake leans a little, in the middle, where the berry cake meets the apple pie. Nobody mentions it. The couple cut it together, and the knife goes in with a small, soft sound, and everyone cheers as if they had been waiting all day. You stand at the back with a plate and a crumb on your nose, a person who made something that people are happy about.
```

**Action:** EDIT · **PARENT?** no

### F-043 · MINOR · c4_board · story/texts/more-ch4.md:80-83 · EDIT

**Piece:** `c4_board` · **File:** `story/texts/more-ch4.md:80-83`

**What is wrong.** The snag table has the unclaimed glove on the boards of chapter 2, 4 and 6, but the chapter 4 board has no glove. And its notice, "THANK YOU, WHOEVER IS DOING ALL THIS", is the third "thank you" before the receipt that is meant to be the biggest one (c2_board "THANK YOU, KEEP IT" is a joke and fine; c3_pieter_paid says "Thank you" too).

**Evidence, the new text:**

> more-ch4.md:83: "One of them, near the top, simply says “THANK YOU, WHOEVER IS DOING ALL THIS.” You look at it for a while."

**Evidence, the canon or the other side:**

> `outline/long-game.md:44` and `:47` (snags: the receipt; "The unclaimed glove | ch2 board | ch4 board | c6_board"). `texts/ch3.md:19` (c3_pieter_paid: "Thank you."). `more-ch2.md:125`.

**Proposed fix.** Keep the board's warmth without the words, and put the glove back.

**Exact replacement wording:**

```
The board is so full now that notices have started to climb on each other. One of them, near the top, simply says “WHOEVER IS DOING ALL THIS, PLEASE DON'T STOP.” Near the bottom, the lost glove is still pinned there. You straighten the notice. You leave the glove.
```

**Action:** EDIT · **PARENT?** no

### F-044 · MINOR · c5_board · story/texts/more-ch5.md:5-8 · EDIT

**Piece:** `c5_board` · **File:** `story/texts/more-ch5.md:5-8`

**What is wrong.** The board says "and please stop eating things you find. You feel personally addressed, which is odd, because you never do." But c5_poison (`forest_poisoned>=1`) is the scene where the farmer did eat something found in the forest; a player who has just been through it reads "you never do" as false. The note about "NUMBER 4" is harmless but unique: no other piece numbers houses (judgment call).

**Evidence, the new text:**

> more-ch5.md:8: "You feel personally addressed, which is odd, because you never do."

**Evidence, the canon or the other side:**

> `texts/ch5.md:48-57` (c5_poison, `forest_poisoned>=1`: "What were you thinking?" ... "Next time, the basket comes to me first.").

**Proposed fix.** Make it true whether or not the poisoning has happened, and drop the stretch word "personally".

**Exact replacement wording:**

```
The notices on the board have changed. Fewer ladders, more spoons. “HONEY FOR A COUGH, ASK AT NUMBER 4.” “IF YOUR CHILD HAS A FEVER, SEND FOR WREN.” Someone has also written, smaller: “and please stop eating things you find.” It seems like good advice, and you take it.
```

**Action:** EDIT · **PARENT?** no

### F-045 · MINOR · c5_dry · story/texts/more-ch5.md:10-13 · EDIT

**Piece:** `c5_dry` · **File:** `story/texts/more-ch5.md:10-13`

**What is wrong.** The drying rack hangs in the still-room, not the kitchen (`drying_rack` requires `ruins_stillroom`; c5_cough puts the still-room "behind your kitchen"). "The kitchen smells like a meadow" names the wrong room.

**Evidence, the new text:**

> more-ch5.md:13: "In a week the kitchen smells like a meadow that has gone indoors."

**Evidence, the canon or the other side:**

> Node `drying_rack` requires `ruins_stillroom`, `k_drying`. `texts/ch5.md:12`: "Berit's old still-room is behind your kitchen."

**Proposed fix.** Name the room.

**Exact replacement wording:**

```
You hang the first bunch of herbs to dry. In a week the still-room smells like a meadow that has gone indoors. Dried leaves crumble in your fingers, soft as old paper. A thing that was green and loud is now brown and quiet and exactly as useful as before. Perhaps more.
```

**Action:** EDIT · **PARENT?** no

### F-046 · MINOR · c5_lookalike · story/texts/more-ch5.md:20-23 · EDIT

**Piece:** `c5_lookalike` · **File:** `story/texts/more-ch5.md:20-23`

**What is wrong.** The chapter's plant rule is: look, ask a grown-up, never taste on a guess; the file header promises that every plant piece keeps it "in the voice". The one piece about look-alikes ends on "the whole difficulty ... in your hand" and gives the child nothing to do. Omission, not contradiction; but it is the one place where a child expects the answer.

**Evidence, the new text:**

> more-ch5.md:23: "One makes a good tea. The other would make a very bad day. That is the whole difficulty, and it is in your hand."

**Evidence, the canon or the other side:**

> `more-ch5.md:3` (header: "look, ask a grown-up, never taste on a guess. Every piece that touches plants keeps that rule in the voice, never as a lecture"). `texts/ch5.md:26-30` (c5_wren_check: "Bring me your basket. Every time. Before you use anything in it."; "Plants have twins, and some twins are poison."). Node `pet_badger` requires `k_ask_grownup`.

**Proposed fix.** Two short sentences that show the rule as an act. Also removes the stretch word "difficulty".

**Exact replacement wording:**

```
You lay two leaves side by side on the table. Same shape, same size, nearly the same green. One makes a good tea. The other would make a very bad day. You taste neither. You wrap them in a cloth and take them to someone who knows.
```

**Action:** EDIT · **PARENT?** no

### F-047 · MINOR · c5_whirligig · story/texts/more-ch5.md:40-43 · RETIME

**Piece:** `c5_whirligig` · **File:** `story/texts/more-ch5.md:40-43`

**What is wrong.** (1) The trigger `done:wind_pump` is a chapter 6 node (requires `windmill_2`, `k_wind_pump`), so the piece cannot show in chapter 5. (2) The title says "The bell on the pole" but the text has no bell (just as well: the bell is Mumyo's and the hall's). (3) The hens complain "from the barn"; the hens live in the coop. (4) First sentence has 29 words, and "favourable" is a stretch word. Register G to A would add a tenth awe piece to chapter 6 (see F-066).

**Evidence, the new text:**

> more-ch5.md:41 title; :43 "From the barn, the hens give an opinion about the noise. It is not favourable."

**Evidence, the canon or the other side:**

> Node `wind_pump`: chapter 6, requires `windmill_2`, `k_wind_pump`. `book_master` ("wind pumps"). Node `coop_1` (Chicken Coop); c1_coop, c1_hens.

**Proposed fix.** Move to chapter 6, rename (the id `c6_whirligig` and title "The singing pole"), set Register to G.

**Exact replacement wording:**

```
Title: The singing pole

The wind pump spins. The pole sings a small, silly song, and the water comes up out of the ground as though it had been waiting for its turn. You stand there pleased with yourself and with the sound. From the coop, the hens give an opinion about the noise. It is not kind.
```

**Action:** RETIME · **PARENT?** no

### F-048 · MINOR · c5_k_rain · story/texts/more-ch5.md:65-68 · EDIT

**Piece:** `c5_k_rain` · **File:** `story/texts/more-ch5.md:65-68`

**What is wrong.** The bark needs `season:autumn + chapter:5`. In the test run chapter 5 is steps 845 to 905 and autumn starts at step 900, so the window is about 6 steps and the bark almost never shows. The text works in any season.

**Evidence, the new text:**

> more-ch5.md:66: `*When:* season:autumn + chapter:5 + chance:0.2`

**Evidence, the canon or the other side:**

> `story/code-issues-story-timing.md:3` (chapter ranges of the test run); `game/farm/systems/seasons.gd` (season = floor(step/30) mod 4, spring first).

**Proposed fix.** Drop the season (chapter length is the player's, so this is a window of luck, not a bug).

**Exact replacement wording:**

```
When: chapter:5 + chance:0.2
```

**Action:** EDIT · **PARENT?** no

### F-049 · MINOR · c5_k_wren · story/texts/more-ch5.md:70-73 · EDIT

**Piece:** `c5_k_wren` · **File:** `story/texts/more-ch5.md:70-73`

**What is wrong.** The bark says "as Wren taught you. You do not touch it." Wren's rule is about using a plant (bring the basket to her before you use anything), not about touching; "look, don't touch" is Berit's foxglove note. And `forest_trips>=2` does not require that Wren has taught anything yet (c5_wren_check is a rationed visit).

**Evidence, the new text:**

> more-ch5.md:71-73: `*When:* forest_trips>=2 + chance:0.15` ... "as Wren taught you. You do not touch it."

**Evidence, the canon or the other side:**

> `texts/ch5.md:26-30` (c5_wren_check): "Bring me your basket. Every time. Before you use anything in it." `more-ch5.md:28` (c5_n_foxglove: "LOOK, DON'T TOUCH").

**Proposed fix.** Say what Wren taught; wait for the lesson.

**Exact replacement wording:**

**When:**

```
forest_trips>=2 + seen:c5_wren_check + chance:0.15
```

**Text:**

```
You stop to look at a plant, as Wren taught you. You do not pick it. It will keep until she has seen it. It looks almost disappointed.
```

**Action:** EDIT · **PARENT?** no

### F-050 · MINOR · c6_board · story/texts/more-ch6.md:5-8 · EDIT

**Piece:** `c6_board` · **File:** `story/texts/more-ch6.md:5-8`

**What is wrong.** (1) "The board is nearly all green now": no notice colour was ever established. (2) "Near the bottom is the first one, the lost glove": the first notices (c1_board) are the basket and the lost goat; the glove first appears at c2_board. (3) "unaccountably" is a stretch word.

**Evidence, the new text:**

> more-ch6.md:8: "The board in the square is nearly all green now ... Near the bottom is the first one, the lost glove. It is still there. Nobody ever claimed it. You find this unaccountably funny."

**Evidence, the canon or the other side:**

> `texts/ch1.md:84` (c1_board: "Somebody needs a basket. Somebody has lost a goat."); `more-ch2.md:125` (c2_board: the lost glove); `outline/long-game.md:47`.

**Proposed fix.** Plain words, true order.

**Exact replacement wording:**

```
The board in the square is crowded now with notices in a dozen hands. Near the bottom is the old one, the lost glove. It is still there. Nobody ever claimed it. You find this very funny.
```

**Action:** EDIT · **PARENT?** no

### F-051 · MINOR · c6_agnes, c6_orphanage, c6_flags, c6_poet · story/texts/more-ch6.md:35-38, … · EDIT

**Piece:** `c6_agnes, c6_orphanage, c6_flags, c6_poet` · **File:** `story/texts/more-ch6.md:35-38, 45-48, 40-43, 60-63`

**What is wrong.** Four favour pieces describe something other than what the player delivered, which a child who made the goods will notice: Agnes seasons "the roast" (the favour is tapenade, pumpkin soup and bread); the orphanage eats jam from jars with spoons (the favour is jam and bread, picture "children cheer with sandwiches", Matron Elsie holds the jar); the flags are "red and yellow and one that is nobody's colour" (the dyes are red, yellow, blue); the poet's scarf is "the colour of a thought" (it is a rainbow scarf, for "Kit the little poet", which the text turns into "her" and a grown poet).

**Evidence, the new text:**

> more-ch6.md:38 "sprinkles the thyme on the roast"; :48 "the jam jars go round. Spoons clink."; :43 "red and yellow and one that is nobody's colour"; :63 "wraps the scarf three times round her neck ... the colour of a thought I almost had".

**Evidence, the canon or the other side:**

> Nodes (`09-side-quests.json`): `sq_elders_feast` cost `tapenade`, `pumpkin_soup` x2, `bread` x2, picture "Elder Agnes holding up your tapenade bowl"; `sq_orphanage_jam` cost `jam` x4, `bread` x4, picture "Matron Elsie holding your jam jar while the children cheer with sandwiches"; `sq_festival_flags` cost `red_dye`, `yellow_dye`, `blue_dye`; `sq_poet_scarf` cost `rainbow_yarn`, `wool_cloth`, "Little poet Kit reciting proudly in your rainbow scarf". `characters/hazelwood-people.md:51-58`.

**Proposed fix.** Make each piece use the delivered goods; use Kit's name (no pronoun is given in the canon).

**Exact replacement wording:**

**c6_agnes:**

```
Elder Agnes sprinkles the thyme over your tapenade as though dealing cards. “Your grandmother put this in everything,” she says. “She had a saying. 'If in doubt, thyme.'” You wait for the rest. There is no rest. That was the whole saying. Somehow it is enough to keep.
```

**c6_orphanage:**

```
At the long table by the orphanage window, the jam goes round on thick slices of your bread. Nobody speaks, because everyone's mouth is full. One small child puts the empty jar to her ear, as though a little of the summer might still be in there. Matron Elsie pretends not to see.
```

**c6_flags, second sentence:**

```
The flags go up between the houses, a hundred small triangles, red and yellow and blue and one that is nobody's colour.
```

**c6_poet:**

```
Kit wraps the rainbow scarf three times round and declares it “every colour of every thought I almost had.” Then Kit writes it down. Then Kit reads it aloud, to you, to the cow, and to a passing man who was only asking the way. He says it is very good, and that the way is left.
```

**Action:** EDIT · **PARENT?** no

### F-052 · MINOR · c6_k_alpaca · story/texts/more-ch6.md:110-113 · EDIT

**Piece:** `c6_k_alpaca` · **File:** `story/texts/more-ch6.md:110-113`

**What is wrong.** “She has seen more of the year than you” is unclear (a year is not a thing one sees more of) and brushes against the rule that years are not counted.

**Evidence, the new text:**

> more-ch6.md:113: "She has seen more of the year than you. She is not telling."

**Evidence, the canon or the other side:**

> `00-premise.md:38` (D11 ✅). `texts/ch6.md:110` (c6_alpaca: the note "that woke the whole farm that night").

**Proposed fix.** Plain and safe.

**Exact replacement wording:**

```
The alpaca looks at you with enormous patience. She has seen more than she lets on. She is not telling.
```

**Action:** EDIT · **PARENT?** no

### F-053 · MINOR · c2_n_bread, c5_n_foxglove, c6_n_last (and c2_n_bees) · several files · EDIT · PARENT?

**Piece:** `c2_n_bread, c5_n_foxglove, c6_n_last (and c2_n_bees)` · **File:** `story/texts/more-ch2.md / more-ch5.md / more-ch6.md` (lines: 100 / 28 / 98)

**What is wrong.** Berit's handwriting is "thin brown ink" in the built game and in five new notes, but "pencil" in three new notes and in three documents, and "a different pen" in a fourth. One writer, three materials.

**Evidence, the new text:**

> Ink: `texts/ch1.md:38` and game c1_book ("in thin brown ink"), game c2_berit_note ("a note in thin brown ink"), more-ch1.md:190, 195, 200, 205, 210. Pencil: more-ch2.md:100 ("in pencil"), more-ch5.md:28 ("in thick pencil"), more-ch6.md:98 ("in pencil"). Pen: more-ch2.md:105 ("in a different pen"; that one is fine, it is somebody else's).

**Evidence, the canon or the other side:**

> Pencil in docs: `outline/long-game.md:62`, `immersion-triggers.md:15`, `book-file.md:189`. Ink in the game already shipped. The docs and three notes were written on 14 Oct; the game text is older and already in German.

**Proposed fix.** Ink wins (3 text edits instead of 7 plus a German retranslation); fix the three documents (F-090). If the parent likes pencil, change the other 7 instead; the choice is one word each way.

**Exact replacement wording:**

**c2_n_bread (more-ch2.md:100):**

```
Beside the bread page, in thin brown ink, in a hand you have only just got to know: “Not so much yeast. Patience does the rest.”
```

**c5_n_foxglove (more-ch5.md:28):**

```
see F-015
```

**c6_n_last (more-ch6.md:98):**

```
see F-019
```

**Action:** EDIT · **PARENT?** yes, the parent must decide

### F-054 · MINOR · c1_hutch, c1_bowl, c5_tea_set (and c2_tortoise_omen) · several files · KEEP-AND-DECIDE

**Piece:** `c1_hutch, c1_bowl, c5_tea_set (and c2_tortoise_omen)` · **File:** `story/texts/more-ch1.md / more-ch5.md` (lines: 177-185 / 50-53)

**What is wrong.** The pet omens fire on `has:<gift>:1`, and the pet's cost items are consumed the moment the pet comes home, so the window is only the time between making the item and handing it in. The kind is `moment`, which is rationed (one per 3 questions) and waits while any sheet is open. For c1_hutch and c1_bowl (two moments, same priority, one pet) the second can only show if the bunny is not claimed within about 3 questions. A player who makes the second item and claims the pet in one sitting never sees the omen. Not a continuity error, but the only pieces whose condition can disappear before they are read.

**Evidence, the new text:**

> more-ch1.md:178 and 183: `has:straw_hutch:1`, `has:bunny_bowl:1`; more-ch5.md:51: `has:tea_set:1`.

**Evidence, the canon or the other side:**

> Nodes `pet_bunny` (cost `bunny_bowl`, `straw_hutch`), `pet_tortoise` (`garden_platter`, `shell_house`), `pet_badger` (`healers_chest`, `tea_set`), all consumed. `game/farm/systems/story.gd:9` (RATIONED = moment, visit, letter; RATION_STEPS 3). `game/farm/ui/storybox.gd` `_quiet()` (a sheet being open blocks everything but a discovery).

**Proposed fix.** Accept the loss (the omens are optional colour) or make the two bunny omens one piece. The parent need not decide; if nothing is done, "Omen" in the fix list means "if it shows, it shows".

**Replacement:** *(no text change)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-055 · MINOR · all 166 pieces · several files · EDIT

**Piece:** `all 166 pieces` · **File:** `story/texts/more-ch1.md ... more-ch6.md` (lines: see list)

**What is wrong.** `{player}` appears 0 times in the 166 new pieces (the built game uses it in c1_seller, c3_pieter and c5_cough). The new pieces have villagers talking to the farmer many times without ever using the name. Not an error, but one of the voice rules is that people use the player's chosen name.

**Evidence, the new text:**

> Checked by search: 0 hits for `{player}` in `more-ch1.md` ... `more-ch6.md`. Pieces where a villager speaks to the farmer: c1_maud, c2_hilde, c2_otto, c3_pieter2, c3_pieter3, c4_pieter4, c4_mei, c5_lamp.

**Evidence, the canon or the other side:**

> `story/book-file.md:10` ("people use the player's chosen name"); header of every `ch*.md` ("`{player}` for the name").

**Proposed fix.** Four small uses, one each in chapters 1 to 4.

**Exact replacement wording:**

**c1_maud (more-ch1.md:150), replaces the speech:**

```
“Oh, {player},” she says. “Berit all over.”
```

**c2_hilde (more-ch2.md:80), replaces the speech:**

```
“I hear things about you in the lane, {player},” she says, not looking at you.
```

**c3_pieter2 (more-ch3.md:8):**

```
“It's the same as last time, {player},” he says, “only more.”
```

**c4_pieter4 (more-ch4.md:8):**

```
“I wanted to say, {player},” he says, and stops.
```

**Action:** EDIT · **PARENT?** no

### F-056 · MINOR · c3_pieter3, c4_pieter4 · several files · EDIT

**Piece:** `c3_pieter3, c4_pieter4` · **File:** `story/texts/more-ch3.md / more-ch4.md` (lines: 10-13 / 5-8)

**What is wrong.** The lantern in daylight is the running snag of Pieter (plan: appears in c3_pieter, c3_pieter2/3, c4_pieter4, ends in the receipt). Only c3_pieter and c3_pieter2 show it. c3_pieter3 and c4_pieter4 do not, and c4_pieter4's title is "The same lantern".

**Evidence, the new text:**

> more-ch4.md:5 title "The same lantern"; :8 "Pieter comes up the road with his book under his arm" (no lantern); more-ch3.md:13 (flask, no lantern).

**Evidence, the canon or the other side:**

> `outline/long-game.md:44` (snag row "Pieter's lantern in the daylight": ch3 c3_pieter, ch3 c3_pieter2/3, ch4 c4_pieter4, c4_receipt).

**Proposed fix.** Add the lantern to both.

**Exact replacement wording:**

**c3_pieter3:**

```
“It's a long road,” says Pieter, and sits on your fence without being asked. He sets his lantern down beside him, still lit in broad daylight. Then he takes a flask from his coat and offers it to you, which is not in his book either. It is cold tea, very sweet. You each take a sip. “Same time next season.”
```

**c4_pieter4:**

```
Pieter comes up the road with his lantern swinging and his book under his arm, and for the first time he does not open it at the gate. He just stands there. “I wanted to say,” he says, and stops. “It's heavy. I know. I'm the one who carries it.” You nod. It is the nicest thing anyone has said all week.
```

**Action:** EDIT · **PARENT?** no

### F-057 · MINOR · c2_bees, c2_kitten, c3_baby, c4_window, c5_badger_job · several files · EDIT

**Piece:** `c2_bees, c2_kitten, c3_baby, c4_window, c5_badger_job` · **File:** `story/texts/more-ch2.md / more-ch3.md / more-ch4.md / more-ch5.md` (lines: 25-28, 67-70 / 65-68 / 35-38 / 55-58)

**What is wrong.** Five optional pieces are typed `beat`. A beat is "a plot step of the chapter ... the critical path ... not missable", and beats hang only on nodes that must be done. These five hang on optional things (an animal, three optional favours, and a filler that follows the badger). As beats they are also unrationed and outrank discoveries, letters and moments, so they can push a waiting piece back. (c2_barn_done, c3_sails and c4_receipt are beats too; barn_1 and windmill_1 are on the critical path, so they are defensible. c5_badger_job also needs F-005.)

**Evidence, the new text:**

> more-ch2.md:25 `beat` · `done:animal_bees`; :67 `beat` · `done:sq_stray_kitten`; more-ch3.md:65 `beat` · `done:sq_baby_blanket`; more-ch4.md:35 `beat` · `done:sq_school_window`; more-ch5.md:55 `beat` · `seen:c5_badger + after:c5_badger:3`.

**Evidence, the canon or the other side:**

> `story-delivery.md:11` (Beat table row), `:24` (priority Frame > Beat > Discovery > Letter > Moment > Bark), `:33-34` ("Beats hang only on those [must-do nodes]"). `game/farm/systems/story.gd:8-9`. Nodes `sq_stray_kitten`, `sq_baby_blanket`, `sq_school_window`: `optional: true`.

**Proposed fix.** Kind `moment` for the bees (an animal) and the badger card, kind `scene` for the three favours (as c2_jan and c2_hilde do). Also read F-089 before touching c4_window.

**Replacement:** *(kind only: c2_bees moment; c5_badger_job moment; c2_kitten scene; c3_baby scene; c4_window scene; text unchanged)*

**Action:** EDIT · **PARENT?** no

### F-058 · MINOR · all pieces (worst: c6_eve, c3_sails, c2_greenstem_hands, c2_kil… · several files · EDIT

**Piece:** `all pieces (worst: c6_eve, c3_sails, c2_greenstem_hands, c2_kiln, c2_otto, c2_bees)` · **File:** `story/texts/more-ch1.md ... more-ch6.md` (lines: see list)

**What is wrong.** 59 of the 136 non-bark pages are longer than 45 words, and 22 are longer than 55. The form is "2-4 sentences, 35-45 words" a box (✅ form; the numbers are 💡). Longest: c6_eve 77, c3_sails 73, c2_greenstem_hands 72, c2_kiln 66, c2_otto 66, c2_bees 65, c2_barn_done 65, c4_mei 64, c4_window 63, c3_pieter2 62, c4_receipt 62, c3_pieter3 60, c4_wedding 60. (Judgment call; the fixes above for otto, barn_done, mei, receipt and others already shorten their pages.)

**Evidence, the new text:**

> Counted by script over the English text of the 134 non-bark pieces (136 pages), words without the "Page n." labels.

**Evidence, the canon or the other side:**

> `book-file.md:16` ("about 10-12 boxes each (2-4 sentences, 35-45 words)"). The built pieces `texts/ch1.md` ... `ch6.md` mostly keep to it.

**Proposed fix.** Split long pages in two instead of cutting words (the box shows one page at a time). Three examples; the editor can do the rest the same way.

**Exact replacement wording:**

**c3_sails, page 1:**

```
You fix the last sail and step back. For a moment, nothing. Then the whole thing groans, like an old person getting up, and begins to turn. Slowly. Then not slowly.
```

**c3_sails, page 2:**

```
The flour begins to fall in a quiet white rope. The wind is working for you. It has never done that before, as far as you know. It was waiting to be asked.
```

**c2_kiln, page 1:**

```
You light the kiln and shut the little door. For a long while nothing happens. Then the cracks in the door glow orange, like the edge of a sunrise.
```

**c2_kiln, page 2:**

```
In the morning you open it, and the soft, sulky clay has become something that rings when you flick it. Clay can change its mind, it seems. It only needs a lot of fire.
```

**c2_bees, page 1:**

```
You carry the hive to the sunny corner of the yard and set it down. A hum comes out of it, low and enormous, as if the box were holding a thought too big for itself.
```

**c2_bees, page 2:**

```
Several thousand tiny creatures have just agreed to live here. They did not ask you. You did not ask them. It seems best to be polite.
```

**Action:** EDIT · **PARENT?** no

### F-059 · MINOR · c1_fire, c1_bench, c1_hens, c3_goat_shed, c5_k_tea, c6_oven (an… · several files · EDIT

**Piece:** `c1_fire, c1_bench, c1_hens, c3_goat_shed, c5_k_tea, c6_oven (and others)` · **File:** `story/texts/more-ch1.md ... more-ch6.md` (lines: see list)

**What is wrong.** The language rule is "a six-year-old can follow every sentence ... A small budget of stretch words". The stretch-word log (`book-file.md:113`) is "none yet". The new texts use at least these long words: embarrassment (c1_fire), confidence (c1_bench), supervised (c1_hens), satisfaction (c3_goat_shed), reasonable (c5_k_tea), definitely (c6_oven), and, already fixed above: particular (c2_greenstem_hands), difficulty (c5_lookalike), personally (c5_board), favourable (c5_whirligig), unaccountably (c6_board), apparently (c5_n_foxglove), inspection and suspicious (c2_tortoise_omen), committed (c6_theatre). Chapter 5 would otherwise carry six. Judgment call: "evidence" (c3_pieter2) and "disappointed" (c5_k_wren) are kept as fun, and should be logged.

**Evidence, the new text:**

> Found by listing every word of 10 or more letters in the 166 pieces, plus a read.

**Evidence, the canon or the other side:**

> `book-file.md:8` (language rule) and `:111-113` ("Stretch words used (budget: a handful per chapter) *(none yet)*").

**Proposed fix.** Replace the six that are not already fixed; log the rest in book-file.md (see F-105).

**Exact replacement wording:**

**c1_fire:**

```
The first spark sulks. The second one gives up. The third one catches, and you lean over it until your eyebrows complain. A fire, in this place. The ash around it glows a little, as if it remembers something.
```

**c1_bench, second sentence:**

```
The workbench is three logs, one plank and a great deal of hope.
```

**c1_hens, last sentence:**

```
By evening you are the one being watched.
```

**c3_goat_shed, second sentence:**

```
A goat walks in, walks out, climbs on the roof, and looks down at you, very pleased with itself.
```

**c5_k_tea, last sentence:**

```
Nothing in the world is more sensible.
```

**c6_oven, last sentence:**

```
Old Jan is behind her, very much not pretending.
```

**Action:** EDIT · **PARENT?** no

### F-060 · MINOR · c1_first_card, c1_spring2, c1_k_wave (and others) · several files · EDIT

**Piece:** `c1_first_card, c1_spring2, c1_k_wave (and others)` · **File:** `story/texts/more-ch1.md ... more-ch6.md` (lines: see list)

**What is wrong.** Crutch phrases (judgment call). "to check" / "in case" appears in 10 pieces (c1_first_card, c1_coin, c1_summer, c1_cleared, c1_coop, c1_spring2, c1_k_wave, c2_barn_frame, c4_window, c4_birthday), "as if / as though" in 19, "like a" in 19, "decide" in 7 (c1_bench, c1_scarecrow, c1_k_crow, c2_barn_done, c2_board, c3_scarecrow2, c6_orphanage), "You do not ..." in 10. Each is fine alone; in a row they sound like one writer's tic, and chapter 1 has seven of the ten "in case/check" lines.

**Evidence, the new text:**

> more-ch1.md:18 "You pat it, to check."; :58 "You take it out to check."; :73 "in case it is a mistake"; :103 "in case somebody is looking"; :128 "You check, in case it minds."; :245 "You wave back anyway, in case."

**Evidence, the canon or the other side:**

> Counted by script over the English text.

**Proposed fix.** Keep the best uses (c1_coin, c1_summer, c1_coop, c2_barn_frame) and change the three weakest.

**Exact replacement wording:**

**c1_first_card, last sentences:**

```
... and it sits in your head like a coin in a pocket. You pat it.
```

**c1_spring2, last sentence:**

```
You tread softly, in case it minds.
```

**c1_k_wave, last sentence:**

```
You wave back anyway.
```

**Action:** EDIT · **PARENT?** no

### F-061 · NOTE · c2_reply · story/texts/more-ch2.md:30-35 · KEEP-AND-DECIDE

**Piece:** `c2_reply` · **File:** `story/texts/more-ch2.md:30-35`

**What is wrong.** Tone chain of the mother's letters. c2_letter is anxious and loving ("my love ... The frost is far away. Isn't it?"), c2_reply (new) is glad and warm ("I am glad ... Eat properly. The table is still long."), and then the built c3_letter is cold ("Stay if you must ... To you it sounds like a warning"). A glad reply followed by a grudging one needs a reason the texts do not give. The strand also grows: the ladder row lists four letters, with c2_reply and c4_mei there are six.

**Evidence, the new text:**

> more-ch2.md:35: "“I am glad. I am not going to say 'I told you so', because I never told you anything.” "

**Evidence, the canon or the other side:**

> `texts/ch2.md:12`, `texts/ch3.md:33`; `characters/berit-and-family.md:26-27` (letters "about once a chapter": first "come home before the frost", later "stay if you must", at the end "we're coming to the Fair"); `outline/ladder.md` letter row.

**Proposed fix.** Either cool c2_reply a little (drop "I am glad.") or accept that c3_letter's chill is the cousin's news. A tone call for the parent.

**Exact replacement wording:**

```
“I am not going to say 'I told you so', because I never told you anything. Eat properly. The table is still long.”
```

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-062 · NOTE · c2_n_bees · story/texts/more-ch2.md:102-105 · KEEP-AND-DECIDE · PARENT?

**Piece:** `c2_n_bees` · **File:** `story/texts/more-ch2.md:102-105`

**What is wrong.** A second writer appears in Berit's own book: "Under it, in a different pen: “I mean it, B.”" The first line is not signed, and the second hand addresses "B." (Berit) as someone who has to be told. It is an invention the header does not list, the same kind as the second hand in c5_n_foxglove ("She does."). If the two are meant to rhyme (B. says "I MEAN IT", someone says it back), that is lovely, but then the parent must say who the second hand is: the child Fenna, the mother, another relative. Left open it reads as a mistake.

**Evidence, the new text:**

> more-ch2.md:105: "Next to the bees, in the margin: “Talk to them. It doesn't matter what about.” Under it, in a different pen: “I mean it, B.” You wonder who had to be told." and more-ch5.md:28 ("I MEAN IT. — B." / "She does.").

**Evidence, the canon or the other side:**

> Flagged inventions: `outline/long-game.md:62` and `book-file.md:189` list pencil notes, yarrow, flask, receipt, "Remarks: none", Mei's partner, and no second hands.

**Proposed fix.** If the second hand is the child Fenna, both notes are warm and the secret stays; then add the signature. If not, cut. Option B (no second hand) is below.

**Exact replacement wording:**

**Option B, c2_n_bees:**

```
Next to the bees, in the margin, in thin brown ink: “Talk to them. It doesn't matter what about. — B.” You wonder what the bees made of the early ones.
```

**Action:** KEEP-AND-DECIDE · **PARENT?** yes, the parent must decide

### F-063 · NOTE · c5_petals · story/texts/more-ch5.md:35-38 · KEEP-AND-DECIDE

**Piece:** `c5_petals` · **File:** `story/texts/more-ch5.md:35-38`

**What is wrong.** Geography is unclear, not wrong. The petals float down "a stream at the edge of the forest". The night garden (white flowers at dusk) is where the marsh was, i.e. the former lower meadow, which is downstream of the farm; petals cannot come from there. If they come from the forest itself, they are another flower, not Mumyo's. Pure choice; the awe is not hurt either way.

**Evidence, the new text:**

> more-ch5.md:38: "At the edge of the forest a stream goes by with petals on it. White ones. They are not from any tree you know."

**Evidence, the canon or the other side:**

> `world/hazelwood.md:14` ("The Hazel stream runs from the forest past the farm and the village"); `world/lease-and-collapse.md:40` (the lower meadow turns to marsh); `outline/ladder.md:128` (6.3: "where the marsh was, white flowers open at dusk"); `world/00-timeline.md:49`.

**Proposed fix.** Say nothing about where they come from, or change "the edge of the forest" to "the stream below the farm" and accept that the petals travel downstream to somebody.

**Replacement:** *(no text change proposed)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-064 · NOTE · c6_telescope, c6_poet · story/texts/more-ch6.md:55-58, … · KEEP-AND-DECIDE

**Piece:** `c6_telescope, c6_poet` · **File:** `story/texts/more-ch6.md:55-58, 60-63`

**What is wrong.** The text gives people looks the canon does not: "the old man at the telescope" (the favour-giver is "Astronomer Vega", gender and age not given, "the moon-watcher"), and a grown poet who is "her" (the favour-giver is "Kit the little poet"). The album pictures for these two favours show the people; I did not look at the pictures (not checked). If Vega is a woman, or Kit a boy, the text collides with the album.

**Evidence, the new text:**

> more-ch6.md:58 "The old man at the telescope waves you over."; :63 "wraps the scarf three times round her neck".

**Evidence, the canon or the other side:**

> `characters/hazelwood-people.md:51` ("Kit the little poet"), `:59` ("Vega the astronomer ... the moon-watcher"); nodes `sq_telescope`, `sq_poet_scarf` (picture strings above).

**Proposed fix.** Look at the two pictures and match the text to them; or write without a pronoun (done for Kit in F-051; for Vega: "The astronomer waves you over").

**Exact replacement wording:**

```
The astronomer at the telescope waves you over. “Look,” Vega says, and steps back. At first, black. Then a smear of silver, and then it is not a smear. It is hundreds. You say nothing. After a long time Vega says, quietly, “Yes. That is what I say, too.”
```

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-065 · NOTE · c6_n_last · story/texts/more-ch6.md:98 · KEEP-AND-DECIDE

**Piece:** `c6_n_last` · **File:** `story/texts/more-ch6.md:98`

**What is wrong.** The last word is "my love". That is the mother's address (c2_letter: "Come home before the frost, my love."). Berit's voice elsewhere is dry ("You will name the hens."). It may be exactly right (the one soft word, once), but it blends two voices at the very end.

**Evidence, the new text:**

> more-ch6.md:98: "Go and put the kettle on, my love."

**Evidence, the canon or the other side:**

> `texts/ch2.md:12`. `outline/long-game.md:58` plans the line in these words.

**Proposed fix.** Keep: the plan says so. Mention only.

**Replacement:** *(no text change proposed)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-066 · NOTE · all (27 pieces tagged A) · several files · KEEP-AND-DECIDE

**Piece:** `all (27 pieces tagged A)` · **File:** `story/texts/more-ch2.md ... more-ch6.md` (lines: see list)

**What is wrong.** The plan's awe column has 10 awe moments in six chapters (long-game.md table). The new pieces carry an A in the Register on 27: ch2 4, ch3 5, ch4 5, ch5 4, ch6 9 (12 of them pure A). Awe loses its force if it is everywhere, and the rule "never next to another awe piece" cannot hold when 9 awe pieces in chapter 6 hang on independent builds and favours that can come in a row.

**Evidence, the new text:**

> A-tagged: c2_kiln, c2_bees, c2_honey, c2_pond; c3_cellar, c3_tower, c3_sails, c3_north, c3_stream_n; c4_glass, c4_greenhouse, c4_watch, c4_birthday, c4_n_glass; c5_dry, c5_petals, c5_whirligig, c5_lamp; c6_seed_library, c6_dye, c6_flags, c6_well, c6_telescope, c6_painter, c6_eve, c6_n_soil, c6_n_last.

**Evidence, the canon or the other side:**

> `outline/long-game.md:13-20` (awe column: ch1 first harvest, ch2 pond and honey, ch3 sails, ch4 glass and tiny light, ch5 petals, ch6 telescope, dye, fire again) and `:22` (never adjacent). `outline/ladder.md:24`.

**Proposed fix.** A tagging decision, not a text one: the Register is authoring metadata. Suggested: keep A on the planned ones (c2_honey, c2_pond, c3_sails, c4_glass, c4_watch, c5_petals, c6_telescope, c6_dye, c6_eve) and re-tag the rest W or G.

**Replacement:** *(Register tags only)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-067 · NOTE · c2_kitten, c4_wedding, c5_whirligig, c3_goat_shed · several files · KEEP-AND-DECIDE

**Piece:** `c2_kitten, c4_wedding, c5_whirligig, c3_goat_shed` · **File:** `story/texts/more-ch2.md ... more-ch5.md` (lines: 70, 43, 43, 53)

**What is wrong.** Some pieces name the feeling ("you have never been so honoured", "people are happy about", "pleased with yourself", "great satisfaction"), others only show it. I found no written rule either way (the voice docs ask for "physical comedy" and for wonder only in the narration), so this is an observation. The ones that show it (c1_coin, c1_k_hands, c2_barn_frame) are stronger.

**Evidence, the new text:**

> more-ch2.md:70 "you have never been so honoured"; more-ch4.md:43; more-ch5.md:43.

**Evidence, the canon or the other side:**

> `book-file.md:12-14` (texture: "dialogue-forward with people ... physical comedy ... Narration-forward only for wonder"). No rule on naming feelings found in `story-delivery.md`, `book-file.md` or the character files.

**Proposed fix.** Leave. If a rule is wanted, "show, do not name" suits the voice.

**Replacement:** *(no text change proposed)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-068 · NOTE · c2_pond, c2_tortoise_omen, c3_stream_n (and c2_tortoise, c3_str… · several files · EDIT

**Piece:** `c2_pond, c2_tortoise_omen, c3_stream_n (and c2_tortoise, c3_stream)` · **File:** `story/texts/more-ch2.md / more-ch3.md` (lines: 47-50, 92-95 / 80-83)

**What is wrong.** One node, five pieces: c2_pond (new, `done:pond`), c2_tortoise (built, "goes straight to the pond"), c2_tortoise_omen (new, shell house "at the edge of the pond"), c3_stream (built, `done:pond`, the miller nods) and c3_stream_n (new, `done:pond + season:summer`). The id `c3_stream_n` says stream, but text and trigger are the pond. The pond is not a requirement of the tortoise (see B), so a reader can meet the pond five times or fewer.

**Evidence, the new text:**

> more-ch3.md:81 `*When:* done:pond + season:summer`; :83 "The sun is on the pond".

**Evidence, the canon or the other side:**

> `texts/ch3.md:62-67` (c3_stream: "The stream runs clear again"). `outline/ladder.md:83` (3.5). Node `pond` is a requirement only of `pond_station`, `patch_channel`, `weeder_geese`, `duck_house`.

**Proposed fix.** Rename c3_stream_n to c3_pond_sun (cosmetic) or turn it into a real stream piece (`tap:...`); otherwise leave.

**Replacement:** *(id only: c3_stream_n becomes c3_pond_sun)*

**Action:** EDIT · **PARENT?** no

### F-069 · NOTE · c1_soup, c2_jan, c2_hilde, c2_otto, c3_maud_goat, c4_wedding, c… · several files · KEEP-AND-DECIDE

**Piece:** `c1_soup, c2_jan, c2_hilde, c2_otto, c3_maud_goat, c4_wedding, c4_watch, c5_lamp, c6_theatre, c6_agnes, c6_orphanage, c6_telescope, c6_poet, c6_painter` · **File:** `story/texts/more-ch1.md ... more-ch6.md` (lines: see list)

**What is wrong.** The doc defines a Scene as a pop-up on the village square tied to a delivery (`done:d_...`). The new pieces use `scene` for 13 optional favours (`done:sq_...`) as well as for the one real delivery (c1_soup, `done:d_veg_soup`). In the engine a scene is not rationed, so favour scenes may arrive back-to-back; as `moment` they would be rationed. No bug, a doc/practice mismatch.

**Evidence, the new text:**

> Counted: 14 scenes (immersion-triggers.md:20), 13 of them favours.

**Evidence, the canon or the other side:**

> `story-delivery.md:17` (Scene row: "triggered by a delivery done (`done:d_...`)"), `game/farm/systems/story.gd:8-9`.

**Proposed fix.** Update the doc: a Scene is "a person scene on a delivery or a favour" (see F-100). No text change.

**Replacement:** *(no text change)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-070 · NOTE · c1_trips20, c4_window, c1_n_fire · several files · KEEP-AND-DECIDE

**Piece:** `c1_trips20, c4_window, c1_n_fire` · **File:** `story/texts/more-ch1.md / more-ch4.md` (lines: 162-165, 35-38, 187-190)

**What is wrong.** Three small threads. (1) c1_trips20: somebody leaves a stool by the track and it is never explained or paid off (not in the snag table, not Mumyo: he does not do helpful things). (2) c4_window is labelled Plant (the teacher cleans a clean pane), with no payoff in the plan. (3) c1_n_fire: "Never leave it alone in the house, and never blame the house" reads like a quiet plant for the hidden fire cause. That is allowed (it states no fact), and it may be a gift; mention because the hidden-truth rule is strict.

**Evidence, the new text:**

> more-ch1.md:165, 190; more-ch4.md:38.

**Evidence, the canon or the other side:**

> `story/README.md:56` (hidden truth not in player text before the reveal); `characters/mumyo.md:55`.

**Proposed fix.** Keep all three; for the stool, let a later piece (Hilde, Maud, Tom) own it with one line, or leave it as a kindness without a face.

**Replacement:** *(no text change proposed)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-071 · NOTE · c1_maud (and c1_fire, c4_wedding, c6_well) · several files · KEEP-AND-DECIDE

**Piece:** `c1_maud (and c1_fire, c4_wedding, c6_well)` · **File:** `story/texts/more-ch1.md / more-ch4.md / more-ch6.md` (lines: 150, 8, 43, 53)

**What is wrong.** The farmer's body in the text. "Berit's chin" (c1_maud) fixes a look (a resemblance to one woman); that is the only one that is more than generic. The rest is harmless and ordinary: "your eyebrows complain" (c1_fire), "a crumb on your nose" (c4_wedding), "you can see your own face in it" (c6_well), "your hat" (c1_board, c1_market_tap, c4_greenhouse), "your boots", "your hands". The hat is canon in the picture rules ("a backlit silhouette from behind in a farmer's hat") and in the shipped game (c1_board "keep your hat low"). The avatar can have "any look", so nothing may say what the face or hair is like.

**Evidence, the new text:**

> more-ch1.md:150: "“Berit's chin,” she says. “Berit's stubborn chin.”"; more-ch1.md:8 "until your eyebrows complain"; more-ch4.md:43 "a crumb on your nose"; more-ch6.md:53 "you can see your own face in it".

**Evidence, the canon or the other side:**

> `story-delivery.md:59` (✅ picture rules: the farmer is never painted; a hand, or a silhouette from behind in a hat); `:80-87` (the farmer is an avatar built from `data/avatar.json`, "your own avatar (any look)"); `texts/ch1.md:84` (c1_board: "keep your hat low"); `characters/mumyo.md:48` (the scarecrow wears Fenna's hat).

**Proposed fix.** The chin goes in F-008. Everything else stays (checked: generic).

**Replacement:** *(no further change)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### The ten checks, one line each

Where a check found nothing it says "checked, nothing found". Where it found something, the ids point to the entries above and in groups B to D.

- **1 World rules.** Religion words (church, chapel, pray, god, bless, holy, angel, funeral, Sunday ...) in the 166 pieces: checked, nothing found in the new pieces (the one live case is the built node, F-072). "ß" in the new files: checked, nothing found. The Lord offstage, the Import Broker, the cousin, Wren as a woman, the bend automatic, no epilogue chapter, the farmer never painted: checked, nothing found in the new texts (they do not mention the cousin or the Broker). Mumyo as traces only, no voice: two hits (c1_tower F-023, c6_terraces F-017). Helpers do not talk: one hit (c5_badger_job, F-005).
- **2 Voice rules.** No gendered word for the farmer and no third person: three hits (c2_hilde F-002, c2_otto F-003, c2_stove F-030) and one in the built German (F-073). `{player}`: used 0 times (see F-055). "ss": not applicable to English files. Everything else (second person, no 'Mum' or 'Dad' words for the parents) checked, nothing found.
- **3 People.** Names, jobs and pronouns against `hazelwood-people.md` and the node `friend` and picture strings: Maud, Ella, Tom, Hilde (she), Otto, Jan (he), Greenstem (he), Pieter, Mei (she), Ines (she), Ferdinand (he), Lucia (she), Agnes (she) checked, nothing found beyond the entries (F-014, F-016, F-018, F-008, F-064, F-051).
- **4 Timeline and chapter placement.** Every `done:<node>` against the node's chapter, by script: three pieces are in the wrong file (c3_north F-035, c4_blanket F-041, c5_whirligig F-047); four wait on purpose and are fine (c3_maud_goat has `chapter:3`; c3_stream_n, c3_swing, c6_quilt wait for their chapter). `seasons>=n` against the season index (spring 0, summer 1, autumn 2, winter 3, spring 4): checked, nothing found. `after:` windows: c1_hunger (10 steps inside one winter), c3_dread1/2, c6_eve: checked, nothing found. The 'year' pieces are in the findings.
- **5 Objects and places.** Tent and cottage, stick fence, orchard, still-room, coop, old mill, hook and cow, the bucket, the lantern: the hits are in the entries (F-027, F-023, F-038, F-045, F-047, F-037, F-010). The bucket (c1 start, c4_birthday, c6_eve) and the burnt page: checked, nothing found beyond the entries.
- **6 Reveals, plants, payoffs, snags, echoes.** Hidden-truth leak before the reveal: one (c2_barn_done, F-001); one spoiler of a smaller reveal (c1_winter, F-026). Echo of the first fire: the sentence "The ash around it glows a little, as if it remembers something" is identical in c1_fire (more-ch1.md:8) and c6_eve (more-ch6.md:78): checked, nothing found. Snag table against the texts: see F-097. Plants without payoff: see F-070.
- **7 Numbers.** Piece counts (166), kind counts (67/39/32/14/8/4/2) and chapter counts (51/29/28/20/15/23), 87 cards, 25 margin-note pieces, 5 boards, 22 favours, 6 omens, 6 taps: checked, correct as the files stand. Lord's share numbers (0.10 ch3, 0.20 ch4, 0.33 ch5, 0.50 ch6) against the texts (a half in the old lease, c6_lord back to a half, c6_quill_answer a tenth): checked, consistent; only `eased` is broken (F-075). In-text numbers (seven cellar steps, three prints, a hundred flags, six loaves): nothing in the data contradicts them (oven capacity is not in the data).
- **8 Duplication and tone.** Exact duplicate texts between new and built pieces: none. Near-duplicates: c2_n_sleep (see F-033), c6_free_garden/c6_ajar (B), five pond pieces (F-068). Tone: the three tone hits are in the entries (F-036, F-061, F-043).
- **9 Doc against doc.** See group C. Also checked, nothing found: the six chapter names and pets order (bunny, tortoise, goat, pony, badger, alpaca) across ladder, helpers and nodes; the rhyme lines in ch2-ch6 against `world/helpers-and-rhyme.md`.
- **10 Mechanics against prose.** Triggers against engine rules: kinds and ration (story.gd:8-9), `chapter:N` equality, `after:` meaning, `lord_shares`: see F-057, F-054, F-048, F-019, F-037. Markdown against the staged JSON for all 166 pieces (text, kind and trigger): identical. Markdown against the built JSON for chapters 1-6: identical except the two JSON-only pieces (B).

## B. Existing in-game pieces (`ch1.md` to `ch6.md`) and game data

Report only. These files are built (English and German) and were not touched.

### F-072 · BLOCKER · sq_chapel_roof · EDIT

**Piece or document:** `sq_chapel_roof`

**Where:** `godot-prototype/data/farm/nodes/09-side-quests.json:20; godot-prototype/data/i18n/data-de.json:2642-2652`

**What is wrong.** The favour is still "Fix the chapel roof", with a church emoji and a bell-ringer "waving from the dry chapel". The parent decided there is no religion and no chapel in this world; the bell belongs to the village hall. The rename has been planned since 8 Oct 2026 and is not done.

**Evidence, both sides:**

> Game: `"name": "Fix the chapel roof"`, `"emoji": "⛪"`, `"desc": "Reward: a picture for the album — Bell-ringer Ansel holding your last roof plank, waving from the dry chapel."`. German `data-de.json:2643-2652`: "Das Kapellendach reparieren", "... aus der trockenen Kapelle". Rule: `00-premise.md:65` ("No church or chapel"), `:218` (D15 ✅ none), `world/hazelwood.md:51` (✅ no church or chapel; the bell belongs to the village hall), `characters/hazelwood-people.md:44`, `game-hooks.md:81-82`, `TODO.md:553` (planned, not done).

**Proposed fix.** Rename as planned (the picture file and its prompt in `art-inbox/Story pictures/` were not checked). German "Glöckner" is a church word; "Glockenläuter" is neutral (judgment call).

**Exact replacement wording:**

**name (en / de):**

```
Fix the village hall roof / Das Dach des Gemeindehauses reparieren
```

**desc and reward/picture (en):**

```
Reward: a picture for the album — Bell-ringer Ansel holding your last roof plank, waving from the dry village hall.
```

**desc and reward/picture (de):**

```
Belohnung: ein Bild fürs Album — Der Glockenläuter Ansel hält dein letztes Dachbrett und winkt aus dem trockenen Gemeindehaus.
```

**emoji:**

```
⛪ becomes 🔔
```

**Action:** EDIT · **PARENT?** no

### F-073 · BLOCKER · c2_greenstem (German) · EDIT

**Piece or document:** `c2_greenstem (German)`

**Where:** `story/texts/ch2.md:28; godot-prototype/data/i18n/data-de.json:11876`

**What is wrong.** The German greeting uses a feminine form for the farmer: "Du bist die vom Mondrand". The ✅ rule is no gendered word for the farmer in English or German. The same phrase also spells the farm name differently: "Mondrand" here, "Moonedge" in c1_seller's German (3 times in data-de.json; "Mondrand" once).

**Evidence, both sides:**

> German: `„Du bist die vom Mondrand“, sagt er.` English (same piece): "“You're the Moonedge one,” he says". Rule: `book-file.md:10-11` ("no gendered word for the farmer anywhere, in English or German"), `:123` ("German (no gender needed); 'Moonedge one' is how the seller greets you"), `story-delivery.md:55` ✅.

**Proposed fix.** One word group; keep the name as "Moonedge" like the seller.

**Exact replacement wording:**

```
„Du bist doch von Moonedge“, sagt er. „Du hast mal einen Eimer getragen, der grösser war als du.“
```

**Action:** EDIT · **PARENT?** no

### F-074 · MAJOR · pet_badger, pet_alpaca · EDIT · PARENT?

**Piece or document:** `pet_badger, pet_alpaca`

**Where:** `godot-prototype/data/farm/nodes/06-main-path-chapter-5.json:20-21; godot-prototype/data/i18n/data-de.json:1935`

**What is wrong.** The badger's default name is "Bramble" in the data, which is the goat's name (pet_goat "Bramble"; the story's running snag is "the goat that is not Bramble"). Its own description says "default name Bracken", and the character file says Silverpaw. Three names for one animal, one of them taken. Also pet_alpaca says "Pet 5" (the badger is Pet 5; the alpaca is the sixth).

**Evidence, both sides:**

> `pet_badger`: `"defaultName": "Bramble"`, desc "Pet 5 (default name Bracken)". `pet_goat`: `"defaultName": "Bramble"`. `pet_alpaca`: desc "Pet 5 (default name Alfie)". `characters/helpers.md:48`: "Badger (💡 default Silverpaw)". `outline/long-game.md:45` (goat snag).

**Proposed fix.** The player can rename, but the default shows first. The parent picks the badger's name (Bracken is already in the German desc; Silverpaw is the character file's). Never Bramble.

**Exact replacement wording:**

```
pet_badger: defaultName "Bracken" (or "Silverpaw"); pet_alpaca desc: "Pet 6 (default name Alfie)" (and German "Haustier 6")
```

**Action:** EDIT · **PARENT?** yes, the parent must decide

### F-075 · MAJOR · c6_quill_answer / Lord's share · EDIT

**Piece or document:** `c6_quill_answer / Lord's share`

**Where:** `godot-prototype/game/farm/systems/lord.gd:38; godot-prototype/data/farm/rules/53-lord.json:3-6; godot-prototype/data/farm/story/30-chapter-6.json:15`

**What is wrong.** The story says the Lord sets the share at a tenth (c6_quill_answer), but nothing in the game ever sets `eased`, so the share stays at a half (chapter 6 fraction 0.50) after Quill's answer, and Pieter keeps collecting it. The rules file says the story sets it; the story files carry no effects.

**Evidence, both sides:**

> Story: `"With my numbers in hand, the Lord sets the share at a tenth, as in the old days."` Rules `53-lord.json`: "`eased` (set by the story in chapter 6, when the numbers are shown to the Lord) lowers the fraction to `easedFraction`", `"easedFraction": 0.10`, `"fraction": {"3": 0.10, "4": 0.20, "5": 0.33, "6": 0.50}`. Search: `eased` appears only in `lord.gd:14` (default false) and `:38` (read). Plan: `outline/ladder.md:133` (6.8).

**Proposed fix.** A one-line code change (not mine to make): ease the share when c6_quill_answer has been seen, e.g. in `fraction()`: `if bool(_s().get("eased", false)) or G.story.seen("c6_quill_answer")`.

**Replacement:** *(code, no text)*

**Action:** EDIT · **PARENT?** no

### F-076 · MAJOR · c2_tortoise · EDIT · PARENT?

**Piece or document:** `c2_tortoise`

**Where:** `story/texts/ch2.md:80-84; godot-prototype/data/farm/nodes/03-main-path-chapter-2.json:37`

**What is wrong.** The tortoise arrives and "goes straight to the pond and sits down where the spring first rose ... The pond fills a little", but `pet_tortoise` does not require `pond`. A player can bring the tortoise home before the pond is dug. The plan says the data should require it; it is not done.

**Evidence, both sides:**

> Text: "She goes straight to the pond and sits down where the spring first rose." Node `pet_tortoise` `requires`: `prep_table_1`, `pet_bunny`, `animal_cow` (no `pond`). `outline/ladder.md:70` (2.9: "💡 data: make `pond` a requirement"), `:156` ("`pet_tortoise` should require `pond`"). Node `pond` is required only by `pond_station`, `patch_channel`, `weeder_geese`, `duck_house`. The new c2_tortoise_omen (A) and c2_pond depend on the same order.

**Proposed fix.** Add `pond` to the tortoise's requirements (the explorer must be re-run, `ladder.md:156`), or reword c2_tortoise ("She goes to the water" with no pond).

**Exact replacement wording:**

```
pet_tortoise requires: [prep_table_1, pet_bunny, animal_cow, pond]
```

**Action:** EDIT · **PARENT?** yes, the parent must decide

### F-077 · MAJOR · c6_free_garden, c6_ajar, c6_frame6 (night garden) · EDIT · PARENT?

**Piece or document:** `c6_free_garden, c6_ajar, c6_frame6 (night garden)`

**Where:** `godot-prototype/data/farm/nodes/06-main-path-chapter-5.json:21; godot-prototype/data/farm/story/30-chapter-6.json; story/code-issues-story-timing.md:19`

**What is wrong.** The night garden is skippable. `c6_garden` fires on `done:river_meadow_drain`, but `pet_alpaca` does not require it. A player can finish the chapter without ever seeing the white flowers, yet c6_free_garden ("You set the bowl down at the edge of the garden"), c6_ajar ("the edge of the dark garden") and the last frame (the little fellow with bells) all assume the garden. Already known: code-issues item C9 and its last bullet; recorded here because the new c6_k_garden, c6_eve and c6_n_last sit in the same chain.

**Evidence, both sides:**

> Node `pet_alpaca` requires `pet_badger`, `oven_3`, `greenhouse`, `d_fair_cloth`, `farmhouse_sunroom`; `river_meadow_drain` requires `north_field`, `import_broker`, `steel_hoe` and nothing requires it except `river_meadow`. `sq_free_garden` requires only `pet_alpaca`. `outline/ladder.md:156`, `code-issues-story-timing.md:19` (C9) and `:27`.

**Proposed fix.** Do C9: require `river_meadow_drain` for `pet_alpaca`. Until then the new c6_k_garden (gated `seen:c6_garden`) is safe; c6_free_garden and c6_ajar are not.

**Exact replacement wording:**

```
pet_alpaca requires: [..., river_meadow_drain]
```

**Action:** EDIT · **PARENT?** yes, the parent must decide

### F-078 · MINOR · c2_berit_note, c2_k_rest · EDIT

**Piece or document:** `c2_berit_note, c2_k_rest`

**Where:** `godot-prototype/data/farm/story/15-chapter-2.json:2-3; story/texts/ch2.md; story/README.md:31`

**What is wrong.** Two built pieces exist only in the game JSON: c2_berit_note (discovery, `seen:face`) and c2_k_rest (bark). `texts/ch2.md` has 11 pieces, the JSON 13; ch2.md is meant to be the source of the JSON, and the book-file's "42 pieces" count (see D) leaves them out. German exists (`data-de.json:11838`). They carry the Rest strand (ladder 2.7) and the "thin brown ink" that the new notes should match.

**Evidence, both sides:**

> JSON: `"Between two pages of the old book there is a note in thin brown ink: “Rest the field. Rest yourself. — B.” You read it twice. Then you look at your hands."`; bark: "The note in the book flutters in the wind. It says what it always says." Not found in `texts/ch2.md`.

**Proposed fix.** Add both to ch2.md (English and German) so the markdown is the source again.

**Replacement:** *(add the two pieces to ch2.md, text as in the JSON)*

**Action:** EDIT · **PARENT?** no

### F-079 · MINOR · c1_seller · EDIT

**Piece or document:** `c1_seller`

**Where:** `story/texts/ch1.md:74, 78; godot-prototype/data/farm/story/10-chapter-1.json`

**What is wrong.** The decided rule is that no merchant visits the campfire; the first seller passes by on the track and stops by the land (ladder 1.6 as built; book-file: "the seller on the track"). The text puts her "on the village square" and has her say "cooking up here", which fits neither place. The bark c1_k_seller ("calls a cart driver from the track") is on the track.

**Evidence, both sides:**

> Text: "On the village square a seller sniffs the air. “Is that porridge?”" ... "I'll tell everyone that somebody is cooking up here again." Docs: `outline/ladder.md:39` ("1.6 is the seller stopping on the track by your land"), `book-file.md:120` ("the seller on the track (1.6, adapted: she stops at the land, not at a campfire)"), `:185`. Node `d_porridge` is a delivery to the village ("She shares news — and opens her cart properly").

**Proposed fix.** Put her on the track by the field (also in German).

**Exact replacement wording:**

```
Page 1. On the track by your field a seller sniffs the air. “Is that porridge?” You hand her a bowl. She eats it standing up, very fast.
```

**Action:** EDIT · **PARENT?** no

### F-080 · MINOR · c2_cottage · EDIT

**Piece or document:** `c2_cottage`

**Where:** `story/texts/ch2.md:73; godot-prototype/data/farm/nodes/03-main-path-chapter-2.json (cottage_roof)`

**What is wrong.** The first rain taps "on the tiles", but the cottage roof is thatched.

**Evidence, both sides:**

> Text: "while the first rain taps on the tiles". Node `cottage_roof`: "Cottage · thatched roof" (cost straw, rope, sticks).

**Proposed fix.** One word (and its German).

**Exact replacement wording:**

```
A real roof, before the frost. You sit under it while the first rain taps on the thatch.
```

**Action:** EDIT · **PARENT?** no

### F-081 · MINOR · c2_greenstem · EDIT

**Piece or document:** `c2_greenstem`

**Where:** `story/texts/ch2.md:24, 30`

**What is wrong.** Greenstem asks "Why is that wall crooked?" on `done:d_stone_soup` (requires only `seed_3`), but the crooked wall exists only after `cottage_walls` (c2_walls). A player who makes the soup before the walls gets a question about a wall that is not there.

**Evidence, both sides:**

> Text: `*When:* done:d_stone_soup` / "Why is that wall crooked?" Node `d_stone_soup` requires `seed_3`; `cottage_walls` requires `tent`, `shed`, `k_building`. `outline/ladder.md:64` (2.3 follows 2.2 in the plan).

**Proposed fix.** Add the walls to the trigger.

**Exact replacement wording:**

```
When: done:d_stone_soup + seen:c2_walls
```

**Action:** EDIT · **PARENT?** no

### F-082 · MINOR · c4_no · EDIT

**Piece or document:** `c4_no`

**Where:** `story/texts/ch4.md:34-43`

**What is wrong.** Quill finds the farmer looking "at the North Field, resting under clover". The trigger `done:farmhouse` does not require `north_field_clear` (it requires `iron_hoe`, `barn_2` and is a chapter 4 node of its own), so the North Field may not exist yet.

**Evidence, both sides:**

> Text: "You look at the North Field, resting under clover." Node `north_field_clear`: chapter 4, requires `iron_hoe`, `barn_2`; node `farmhouse`: chapter 4, requires `farmhouse_walls`, `glass_kiln`.

**Proposed fix.** Say a field that always exists.

**Exact replacement wording:**

```
You look at your best field, resting under clover.
```

**Action:** EDIT · **PARENT?** no

### F-083 · MINOR · c6_free_garden, c6_ajar · EDIT

**Piece or document:** `c6_free_garden, c6_ajar`

**Where:** `story/texts/ch6.md:43, 132`

**What is wrong.** The unsaid thing is done twice. In c6_free_garden the farmer opens their mouth, closes it again and walks home "not afraid"; in c6_ajar the farmer "came to say something" and goes home because "it is not time yet". The ladder has one bowl-of-milk beat (6.11) with the unsaid thing, which the built pieces split in two.

**Evidence, both sides:**

> c6_free_garden: "You open your mouth. You close it again. ... you are not afraid." c6_ajar: "You came to say something. You stand there a long time ... It is not time yet." `outline/ladder.md:136` (6.11: "You do not say what you meant to say").

**Proposed fix.** Keep the unsaid thing for c6_ajar; let the favour be only the bowl.

**Exact replacement wording:**

```
You set the bowl down at the edge of the garden. Far off, very softly, a very small bell rings twice. You nod, and walk home in the dark, and you are not afraid.
```

**Action:** EDIT · **PARENT?** no

### F-084 · NOTE · c6_free_miller · KEEP-AND-DECIDE · PARENT?

**Piece or document:** `c6_free_miller`

**Where:** `story/texts/ch6.md:29`

**What is wrong.** The miller's "sails creak, then turn", while the miller's mill is a water mill elsewhere (his wheel stopped when the stream silted; the miller-bridge picture shows a wheel). This is the parent's open question (mill type), not an error.

**Evidence, both sides:**

> Text: "The sails creak, then turn, slowly, as they did before the fire." `characters/hazelwood-people.md:13` ("the silted stream nearly stopped his wheel"); `art-inbox/Story pictures/canon-for-pictures.md:65-66` ("a windmill ... is in five pictures; a water wheel in one ... Undecided"); `TODO.md:585` (open: mill type).

**Proposed fix.** Wait for the decision. If the water wheel wins: "The wheel creaks, then turns".

**Replacement:** *(no change until the mill type is decided)*

**Action:** KEEP-AND-DECIDE · **PARENT?** yes, the parent must decide

### F-085 · NOTE · c3_frame3 · KEEP-AND-DECIDE

**Piece or document:** `c3_frame3`

**Where:** `story/texts/ch3.md:97`

**What is wrong.** A grandchild asks "What's an imp?" Frame 1 says they "know this story almost as well as you do. Almost." and frame 0 starts with "Again?". Fits "almost"; mentioned because the imp is also the word the cousin used (timeline Y+1..Y+7).

**Evidence, both sides:**

> Text: "“What's an imp?” “Shh!” say three children at once. “That comes later!”" and `texts/ch1.md:118` ("They know this story almost as well as you do. Almost.").

**Proposed fix.** Keep.

**Replacement:** *(no change)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-086 · NOTE · c2_letter, c3_letter · KEEP-AND-DECIDE

**Piece or document:** `c2_letter, c3_letter`

**Where:** `story/texts/ch2.md:12; story/texts/ch3.md:33`

**What is wrong.** The cousin is mentioned in both the chapter 2 and the chapter 3 letter with the same words ("Your cousin asks after you"). The ladder puts the cousin in chapter 3 only (3.9 "Your cousin may come to visit", letter row "stay if you must"). Probably a deliberate early plant; recorded because the plan and the text differ.

**Evidence, both sides:**

> `texts/ch2.md:12`: "Your cousin asks after you." `texts/ch3.md:33`: "Your cousin asks after you." `outline/ladder.md` letter row: before the frost (2); stay if you must / your cousin may come (3).

**Proposed fix.** Keep: it is a good double plant; add the sentence to the ladder.

**Replacement:** *(docs only)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

### F-087 · NOTE · quiz k_play question 2 · KEEP-AND-DECIDE

**Piece or document:** `quiz k_play question 2`

**Where:** `godot-prototype/data/i18n/data-de.json:8543-8544`

**What is wrong.** A wrong answer says "Only on Sundays" ("Nur sonntags"). Sunday is a weekday name and not a religious word here; mentioned only because the religion rule was checked by word search over the data.

**Evidence, both sides:**

> `nodes/k_play/questions/2/answers/2`: "Only on Sundays".

**Proposed fix.** Leave.

**Replacement:** *(no change)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

## C. Canon documents against each other

Each entry names the file that should win and why.

### F-088 · MAJOR · hazelwood-people.md, long-game.md  vs  fenna.md, story-delivery… · EDIT

**Piece or document:** `hazelwood-people.md, long-game.md  vs  fenna.md, story-delivery.md, book-file.md`

**Where:** `story/characters/hazelwood-people.md:22, 36; story/outline/long-game.md:62`

**What is wrong.** Two canon documents quote the forbidden third-person lines as wanted: Hilde is "first to say 'she's working hard, that one'", Otto "remembers the little girl who did not cry", and long-game.md lists "Hilde's 'she's working hard, that one' echoed by the board" as an invention to accept. The new pieces c2_hilde and c2_otto copied them (see their entries). The ✅ voice rule forbids exactly this.

**Evidence, both sides:**

> `hazelwood-people.md:36` ("first to say 'she's working hard, that one'"), `:22` ("Remembers the little girl who did not cry"), `long-game.md:62`. Against: `characters/fenna.md:13` ("Nobody talks *about* you in the third person ... 'she works hard', 'er ist fleißig'"), `story-delivery.md:55` (✅), `book-file.md:10-11` (✅).

**Which file wins, and why.** The ✅ voice rule wins: it is a parent decision with the same example in it; the character table is a 💡 draft. Reword the docs so they describe what the pieces now say.

**Exact replacement wording:**

**hazelwood-people.md:36:**

```
knows all the gossip; first to say to your face that the village is talking about you, kindly
```

**hazelwood-people.md:22:**

```
Ferried the family away the night they left. Remembers the child who did not cry.
```

**long-game.md:62:**

```
... (delete "Hilde's 'she's working hard, that one' echoed by the board")
```

**Action:** EDIT · **PARENT?** no

### F-089 · MAJOR · code-issues-story-timing.md · EDIT

**Piece or document:** `code-issues-story-timing.md`

**Where:** `story/code-issues-story-timing.md:26`

**What is wrong.** The retime list says to re-key `c4_frame4` (the chapter 4 end frame) to `seen:c4_window`. c4_window is an optional favour (`sq_school_window`). If applied, the frame, which Frame outranks everything, would wait for an optional favour and a player who skips it never gets the frame.

**Evidence, both sides:**

> `code-issues-story-timing.md:26`: "New `c4_window` beat; `c4_frame4` re-keyed to `seen:c4_window`". `texts/ch4.md:78` (c4_frame4 `seen:c4_quill_out`). Node `sq_school_window`: optional. `story-delivery.md:33` (beats hang only on must-do nodes).

**Which file wins, and why.** Do not apply. Keep `c4_frame4` on `seen:c4_quill_out`; c4_window stays an ordinary optional piece (and not a beat, see F-057). This document is not authoritative; the delivery doc is.

**Replacement:** *(docs: delete the c4_frame4 re-key)*

**Action:** EDIT · **PARENT?** no

### F-090 · MINOR · long-game.md, immersion-triggers.md, book-file.md  vs  the buil… · EDIT

**Piece or document:** `long-game.md, immersion-triggers.md, book-file.md  vs  the built game`

**Where:** `story/outline/long-game.md:62; story/immersion-triggers.md:15; story/book-file.md:189`

**What is wrong.** The documents call Berit's notes "pencil"; the built game and the first five new notes have "thin brown ink" (c1_book, c2_berit_note, and German already translated).

**Evidence, both sides:**

> Docs: "Berit's margin notes and her voice (pencil, dry, warm)" (`long-game.md:62`), "reading a card brings Berit's pencil" (`immersion-triggers.md:15`), "Berit's pencil margin notes" (`book-file.md:189`). Game: `texts/ch1.md:38` and `10-chapter-1.json` c1_book "in thin brown ink"; `15-chapter-2.json` c2_berit_note "in thin brown ink". Quill uses the pencil (`texts/ch4.md:19`).

**Which file wins, and why.** The built game wins: it is already in German and shipped; three new notes change one word each (see F-053). The docs change "pencil" to "ink".

**Replacement:** *(docs: "pencil" becomes "ink" in the three places)*

**Action:** EDIT · **PARENT?** no

### F-091 · MINOR · 00-timeline.md  vs  lease-and-collapse.md · EDIT

**Piece or document:** `00-timeline.md  vs  lease-and-collapse.md`

**Where:** `story/world/00-timeline.md:27-28; story/world/lease-and-collapse.md:23-24`

**What is wrong.** The year of the first fallow skip differs by two years.

**Evidence, both sides:**

> Timeline: "Y−12 | No more fallow. The straw is sold, not composted." Lease table: "−14 | a fifth | skips the fallow year on the best field" and "−12 | a fifth | sells the straw instead of composting it".

**Which file wins, and why.** The lease table is the detail file the timeline itself points to ("details in `lease-and-collapse.md`"), so it wins. Timeline: put "no more fallow" in Y−14 and "the straw is sold" in Y−12.

**Exact replacement wording:**

```
Y−14: The Lord raises the farm's share from a tenth to a fifth ... **and the best field skips its fallow year**. / Y−12: The straw is sold, not composted.
```

**Action:** EDIT · **PARENT?** no

### F-092 · MINOR · 00-premise.md  vs  hazelwood-people.md, game · EDIT

**Piece or document:** `00-premise.md  vs  hazelwood-people.md, game`

**Where:** `story/00-premise.md:177; story/characters/hazelwood-people.md:12`

**What is wrong.** The premise's chapter table puts Granny Maud in chapter 3; the people table, the node and the built c1_maud have her as a chapter 1 favour (and the project log says "Granny Maud and Greenstem kind from the start").

**Evidence, both sides:**

> Premise: "| 3 | Someone who was kind to her family (Granny Maud, Berit's old friend 💡) ...". People: "**Granny Maud** (favour, ch 1)"; node `sq_lost_goat` chapter 1. `PROJECT-LOG.md:261`.

**Which file wins, and why.** The node and people table win (built, and the first warm door is meant to be early). Premise row: "(Granny Maud, from chapter 1)".

**Replacement:** *(premise row 3: Maud from chapter 1)*

**Action:** EDIT · **PARENT?** no

### F-093 · MINOR · berit-and-family.md  vs  ladder, premise, texts · EDIT

**Piece or document:** `berit-and-family.md  vs  ladder, premise, texts`

**Where:** `story/characters/berit-and-family.md:33, 37`

**What is wrong.** The family file still says "the daughter or son" and uses "they" for the cousin; the cousin is a girl (✅, "default for now") and the built pieces say "she" (c6_free_family, c6_crisis, c6_bend).

**Evidence, both sides:**

> Doc: "**Who:** the daughter or son of Fenna's father's sister"; "The cousin is not lying; they are ..." (`:33`, `:37`). Decision: `outline/ladder.md:166` ("the cousin is **a girl**, default for now"). Texts: `texts/ch6.md:8` ("looks at her plate"), `:85`, `:96`.

**Which file wins, and why.** The ✅ wins. Doc: "daughter", "she".

**Replacement:** *(docs: daughter / she)*

**Action:** EDIT · **PARENT?** no

### F-094 · MINOR · ladder.md  vs  ladder.md · EDIT

**Piece or document:** `ladder.md  vs  ladder.md`

**Where:** `story/outline/ladder.md:132 vs :166`

**What is wrong.** The same ladder says the bend is a tap-or-text question (❓) in row 6.7 and ✅ automatic in the decisions block.

**Evidence, both sides:**

> `ladder.md:132`: "6.7 | Beat (**the bend**) ... ❓ text or a tap (*Sit down* / *Tell*)". `ladder.md:166`: "the chapter 6 bend triggers **automatically**, like every chapter end (no tap)". Built: c6_bend `seen:c6_crisis`.

**Which file wins, and why.** Line 166 wins (✅, and built that way). Remove the ❓ in 6.7.

**Replacement:** *(ladder 6.7: delete "❓ text or a tap (*Sit down* / *Tell*)")*

**Action:** EDIT · **PARENT?** no

### F-095 · MINOR · ladder.md 2.7  vs  the built c2_compost and c2_berit_note · EDIT

**Piece or document:** `ladder.md 2.7  vs  the built c2_compost and c2_berit_note`

**Where:** `story/outline/ladder.md:68; story/texts/ch2.md:66`

**What is wrong.** The ladder gives the compost pit the note "Rest the field. Rest yourself."; the built compost says "Feed the ground and it feeds you. — B." and the Rest note became a separate discovery (c2_berit_note, JSON only).

**Evidence, both sides:**

> Ladder 2.7: "A clean, dry compost pit. Berit's note: *Rest the field. Rest yourself.*" Built c2_compost: "Scratched on the lid: “Feed the ground and it feeds you. — B.”" c2_berit_note: "Rest the field. Rest yourself. — B." (see B).

**Which file wins, and why.** The built pair wins (both notes are good and distinct). Ladder 2.7 gets both.

**Replacement:** *(ladder 2.7: lid says "Feed the ground and it feeds you"; the Rest note is c2_berit_note)*

**Action:** EDIT · **PARENT?** no

### F-096 · MINOR · ladder.md  vs  long-game.md · KEEP-AND-DECIDE · PARENT?

**Piece or document:** `ladder.md  vs  long-game.md`

**Where:** `story/outline/ladder.md:24; story/outline/long-game.md:13-22`

**What is wrong.** Two awe plans. The ladder's check says "awe three times (ch 1, 5, 6), never in a build"; the long-game table plans ten awe moments (two or three per chapter) and names builds (sails, glass, dye). long-game.md:22 also claims "checked by the timeline, c3_tower and c3_sails are separated by the loom and the weather", which is not true: they are consecutive builds (windmill_1 requires windmill_tower), and nothing orders the loom or weather between them. And the new pieces tag 27 as awe (F-066).

**Evidence, both sides:**

> `ladder.md:24`: "awe three times (ch 1, 5, 6), never in a build ✔". `long-game.md:15-20` (awe column), `:22`. Node `windmill_1` requires `windmill_tower`.

**Which file wins, and why.** A design call. Neither is ✅. I would keep the long-game plan (richer) and retire the "never adjacent / never in a build" promises, or keep them and cut to the ladder's three.

**Replacement:** *(docs: one awe plan)*

**Action:** KEEP-AND-DECIDE · **PARENT?** yes, the parent must decide

### F-097 · MINOR · long-game.md snag table  vs  the texts · EDIT

**Piece or document:** `long-game.md snag table  vs  the texts`

**Where:** `story/outline/long-game.md:44-50`

**What is wrong.** The running-snag table (three appearances each) does not match the pieces in five places. (1) Pieter's lantern: absent in c3_pieter3 and c4_pieter4 (F-056). (2) The unclaimed glove: the ch4 board has no glove (F-043), and c6_board calls it "the first one" (F-050). (3) The swing knot: the row lists "ch5 petals", but c5_petals has no swing (so the snag has only two appearances). (4) The tiny light: c5_lamp has no light (fixed in F-016) and c6_ajar has only "a tiny bell". (5) The goat row lists Jan's "That goat could count" under ch3; it is in c2_jan (ch2).

**Evidence, both sides:**

> Table rows `long-game.md:44` (lantern), `:45` (goat), `:47` (glove), `:49` (swing: "c3_swing | ch5 petals | c6_terraces"), `:50` (tiny light: "c4_watch | ch5 c5_lamp | c6_ajar"). Texts: `more-ch5.md:38`; `texts/ch6.md:132`; `more-ch2.md:75`.

**Which file wins, and why.** Fix the pieces as listed, plus: give the swing its third appearance by one added sentence in c5_petals, and give c6_ajar the light.

**Exact replacement wording:**

**c5_petals, last sentence added:**

```
On your way home, the swing in the old orchard is moving, though there is no wind.
```

**c6_ajar (texts/ch6.md:132), middle:**

```
Somewhere in the white flowers a tiny bell moves, and is still, and a very small light goes out.
```

**Action:** EDIT · **PARENT?** no

### F-098 · MINOR · long-game.md, book-file.md, more-ch*.md headers  vs  the texts · EDIT

**Piece or document:** `long-game.md, book-file.md, more-ch*.md headers  vs  the texts`

**Where:** `story/outline/long-game.md:62; story/book-file.md:189; story/texts/more-ch4.md:3`

**What is wrong.** Flagged inventions that are not in the texts: Greenstem's yarrow (no hit), Quill's "Remarks: none" (no hit), "Mei written with no pronoun for her partner" (c4_mei has no partner; the replacement drops the idea). And inventions that are in the texts but not flagged: the second hands (c2_n_bees, c5_n_foxglove), the stool (c1_trips20), the rock tower (c1_tower), the folded blanket, "the child with a bucket" echoes.

**Evidence, both sides:**

> Search: 0 hits for "yarrow" and "Remarks" in `texts/*.md`. `more-ch4.md:3`: "Mei's letter written with no pronoun for the writer's partner"; `more-ch4.md:53` (c4_mei) has no partner.

**Which file wins, and why.** Strike the three absent items from the three lists; add the unflagged ones so the parent can accept or overrule them (the point of the list).

**Replacement:** *(docs: lists)*

**Action:** EDIT · **PARENT?** no

### F-099 · MINOR · hazelwood-people.md · EDIT

**Piece or document:** `hazelwood-people.md`

**Where:** `story/characters/hazelwood-people.md:47`

**What is wrong.** Pieter appears in the people file only as the chapter 4 favour-giver (the tiny light); but the story gives him the Lord's share from chapter 3 (c3_pieter, c3_pieter2, c3_pieter3, c4_pieter4, c4_receipt), a flask and a receipt. His real part has no row.

**Evidence, both sides:**

> `hazelwood-people.md:47`: "sq_night_watch | Pieter the night watchman | 4 | 💡 has seen 'a tiny light' over the marsh". Texts: `texts/ch3.md:5-20`; `more-ch3.md:5-13`; `more-ch4.md:5-13`. `more-ch3.md:3` ("Pieter collects the Lord's share; he is kind, tired and sure he is the villain of everyone's day").

**Which file wins, and why.** Add a row.

**Exact replacement wording:**

```
**Pieter the night watchman** (ch 3 on) | Carry the Lord's book | Collects the share; kind, tired, sure he is the villain of everyone's day. Lantern in daylight, the flask, the receipt that says "Thank you". Sees the tiny light (ch 4).
```

**Action:** EDIT · **PARENT?** no

### F-100 · NOTE · story-delivery.md  vs  more-ch*.md · EDIT

**Piece or document:** `story-delivery.md  vs  more-ch*.md`

**Where:** `story/story-delivery.md:17`

**What is wrong.** The doc defines Scene as the village-square pop-up for a delivery; the new texts also use it for 13 optional favours (F-069).

**Evidence, both sides:**

> `story-delivery.md:17`: "A pop-up window showing you on the village square, handing over a delivery ... triggered by a delivery done (`done:d_...`)".

**Which file wins, and why.** The practice wins (a favour closing with a scene is the plan, `immersion-triggers.md:13`: 'each favour closes with a scene, not a number'). Widen the definition.

**Replacement:** *(docs: "triggered by a delivery (`done:d_...`) or a favour (`done:sq_...`)")*

**Action:** EDIT · **PARENT?** no

### F-101 · NOTE · ladder.md, book-file.md, PROJECT-LOG.md  vs  gate.gd · EDIT

**Piece or document:** `ladder.md, book-file.md, PROJECT-LOG.md  vs  gate.gd`

**Where:** `story/outline/ladder.md:39, 166; PROJECT-LOG.md:259; godot-prototype/data/farm/rules/50-gate.json:3`

**What is wrong.** The docs use one word, "the merchant", for two different people: the ✅ "merchant first passes by on the road" is the seed seller of c1_seller (she); the travelling merchant of the gate system is "he" and "turns up at the gate". No contradiction in the texts (the new c1_bookcart_tap follows the second one with "he"), but a reader of the docs cannot tell.

**Evidence, both sides:**

> `ladder.md:39`, `:166` ("the travelling merchant first passes by on the road (changes 1.6)"); `PROJECT-LOG.md:259` ("The travelling merchant comes now and then ... can be tapped"); `rules/50-gate.json:3` ("The travelling merchant at the gate ... He comes only where a cart can come"); node `road_1` ("the seed seller with her basket"), `book_cart` ("Comes with the travelling merchant").

**Which file wins, and why.** Name them apart in the docs: "the seed seller (she)" and "the travelling merchant (he)".

**Action:** EDIT · **PARENT?** no

### F-102 · NOTE · 00-premise.md, book-file.md, 00-timeline.md · KEEP-AND-DECIDE

**Piece or document:** `00-premise.md, book-file.md, 00-timeline.md`

**Where:** `story/00-premise.md:115; story/book-file.md:88; story/world/00-timeline.md:52`

**What is wrong.** Berit's "funeral" is mentioned in three background documents. It is a human rite, not a religious one, and the word never reaches player text; mentioned only because the religion rule was checked by word search.

**Evidence, both sides:**

> `00-premise.md:115` ("After the funeral Fenna is meant to move to her parents"), `book-file.md:88`, `world/00-timeline.md:52`.

**Which file wins, and why.** Leave. Keep it out of player text.

**Replacement:** *(no change)*

**Action:** KEEP-AND-DECIDE · **PARENT?** no

## D. Numbers and docs to correct

### F-103 · MINOR · book-file.md, TODO.md · EDIT

**Piece or document:** `book-file.md, TODO.md`

**Where:** `story/book-file.md:186; TODO.md:570`

**What is wrong.** The Round 7 note says chapters 2 to 6 were built as "42 pieces". The real number is 61 pieces in `texts/ch2.md` ... `ch6.md` (11 + 12 + 9 + 11 + 18), 63 in the game JSON (c2_berit_note and c2_k_rest exist only there); with chapter 1 (17) that is 78 in the markdown and 80 in the game.

**Evidence, both sides:**

> `book-file.md:186`: "`texts/ch2.md` ... `ch6.md`; 42 pieces, English and German". `TODO.md:570`: "(42 pieces; 💡 flagged ...)". Counted by `grep -c "^## "` on the six files (17, 11, 12, 9, 11, 18) and over `data/farm/story/*.json` (17, 13, 12, 9, 11, 18).

**Proposed fix.** Correct both.

**Exact replacement wording:**

```
61 pieces (63 in the game; two Chapter 2 pieces exist only in the JSON); 78 and 80 with chapter 1
```

**Action:** EDIT · **PARENT?** no

### F-104 · MINOR · book-file.md · EDIT

**Piece or document:** `book-file.md`

**Where:** `story/book-file.md:16-17`

**What is wrong.** The form note says "Roughly 5-6 thousand words in all". The 166 new pieces alone are 6,231 words; the 78 built pieces about 3,300 (English only). The whole story is now about 9,500 English words (the average non-bark new page is about 41 words, inside the form; see F-058 for the long ones).

**Evidence, both sides:**

> Word counts over the English text (script; the "Page n." labels and German excluded): new 6,231 in 168 pages; built ch1-ch6 about 3,336. `book-file.md:16-17`.

**Proposed fix.** Update the number (and see F-058 for the page length).

**Exact replacement wording:**

```
Roughly 9–10 thousand words in all (3.3 thousand built, 6.2 thousand added 14 Oct 2026).
```

**Action:** EDIT · **PARENT?** no

### F-105 · MINOR · book-file.md · EDIT

**Piece or document:** `book-file.md`

**Where:** `story/book-file.md:111-113`

**What is wrong.** The stretch-word log says "(none yet)" although the built pieces and the new ones use some (F-059).

**Evidence, both sides:**

> `book-file.md:113`: "*(none yet)*". New: see F-059. After the fixes proposed there, what remains is: chapter 1 "thoughtful" (c1_k_nibbled); chapter 3 "evidence" (c3_pieter2); chapter 5 "disappointed" (c5_k_wren). The built pieces were not read for stretch words.

**Proposed fix.** Fill the log after the editor's pass.

**Exact replacement wording:**

```
ch 1: thoughtful · ch 3: evidence · ch 5: disappointed (new pieces, after the 14 Oct pass); built pieces not yet read.
```

**Action:** EDIT · **PARENT?** no

### F-106 · MINOR · README.md · EDIT

**Piece or document:** `README.md`

**Where:** `story/README.md:31`

**What is wrong.** The `texts/` row still says "ch1.md is the source ... Round 7, chapter 1 done". Chapters 2 to 6 were built on 13 Oct 2026 and `ch2.md` ... `ch6.md` are sources too.

**Evidence, both sides:**

> `README.md:31`; `book-file.md:186`.

**Proposed fix.** Update the row.

**Exact replacement wording:**

```
`texts/` | the short in-game story texts and the bedside frame scenes (English, then German): `ch1.md` ... `ch6.md` are the sources of `godot-prototype/data/farm/story/*.json` and the German in `data/i18n/data-de.json` | Round 7, chapters 1-6 built
```

**Action:** EDIT · **PARENT?** no

### F-107 · MINOR · more-ch2.md header, node orchard · EDIT

**Piece or document:** `more-ch2.md header, node orchard`

**Where:** `story/texts/more-ch2.md:3; godot-prototype/data/farm/nodes/04-main-path-chapter-3.json (orchard)`

**What is wrong.** The header says the orchard is "a chapter 3 node" and moves the swing to chapter 3 on that ground. The node file is called chapter 3, but the node's own field says `chapter: 2`, so a player can clear the orchard in chapter 2 and the swing (a chapter 3 piece) waits for chapter 3. The result is acceptable, the explanation is not true.

**Evidence, both sides:**

> `more-ch2.md:3`: "(The orchard swing moved to `more-ch3.md`: the orchard is a chapter 3 node.)" Node `orchard`: `"chapter": 2`, in `04-main-path-chapter-3.json`. `orchard_2` is chapter 6.

**Proposed fix.** Say what is true.

**Replacement:** *(The orchard swing is in `more-ch3.md`: it waits for chapter 3 on purpose; the orchard node itself is a chapter 2 node.)*

**Action:** EDIT · **PARENT?** no

### F-108 · MINOR · immersion-triggers.md · EDIT

**Piece or document:** `immersion-triggers.md`

**Where:** `story/immersion-triggers.md:9-20`

**What is wrong.** The category counts are approximate, and the rule behind each is not stated. Counted by the trigger text of the 166 pieces: Firsts 8 for the six listed triggers (doc: 12); Builds `done:<node>` 44 (not counting favours, deliveries and barks; 54 with the delivery and the barks) (doc: ~60); Seasons 8 non-bark pieces (18 with barks) (doc: 9). Matching: Taps 6, Favours 22 (24 with two barks), Pet and gift omens 6, Margin notes 25, Boards 5, Barks 32, Dread 2. The kind total changes with the fixes in this report (see below).

**Evidence, both sides:**

> `immersion-triggers.md:9` ("Firsts ... 12"), `:11` ("Builds ... ~60"), `:12` ("Seasons ... 9"), `:20` (the 166 by kind: 67 moments, 39 discoveries, 32 barks, 14 scenes, 8 beats, 4 visits, 2 letters; by chapter 51, 29, 28, 20, 15, 23). I recounted: kinds and chapters are correct as the files stand (166; 67/39/32/14/8/4/2; 51/29/28/20/15/23).

**Proposed fix.** Correct the three loose counts; after the editor's pass recount: beats 3 (c2_barn_done, c3_sails, c4_receipt), moments 69, scenes 17, discoveries 39, barks 32, visits 4, letters 2 (166). By chapter: 51, 29, 28 (+ blanket, - north), 20 (- blanket, + north), 14 (- whirligig), 24 (+ whirligig).

**Exact replacement wording:**

```
Firsts 8 · Builds 44 (54 with barks) · Seasons 8 (18 with barks); recount kinds and chapters after the fixes
```

**Action:** EDIT · **PARENT?** no

### F-109 · NOTE · 00-premise.md, 00-timeline.md, book-file.md, PROJECT-LOG.md · EDIT

**Piece or document:** `00-premise.md, 00-timeline.md, book-file.md, PROJECT-LOG.md`

**Where:** `story/00-premise.md:38; story/world/00-timeline.md:8; story/book-file.md:141; PROJECT-LOG.md:212`

**What is wrong.** "About twelve game years" (backstory documents) against the test run: chapter 6 ends at step 1069 and a game year is 120 steps (30 per season), which is 8.9 years; the 12 comes from "~1,417 answers in a full playthrough" (project log). Both are single runs. Nothing is counted in the texts (D11), so harmless; the documents should say "nine to twelve".

**Evidence, both sides:**

> `world/00-timeline.md:8` ("about twelve game years if anyone counted"); `PROJECT-LOG.md:212` ("~1,417 answers"); `code-issues-story-timing.md:3` (ch1 1-244, ... ch6 906-1069). Chapter ranges are from one bot run.

**Proposed fix.** Say "nine to twelve game years, depending on the run".

**Action:** EDIT · **PARENT?** no

## E. Not checked, and why

1. **German text of the 166 new pieces.** None exists yet (TODO I15). Everything about German in this report concerns the six built chapters only.
2. **Pictures and picture material.** `art-inbox/Story pictures/` (95 pictures, briefs, prompts, picture_review.csv, regen lists, references) was not opened. Text-to-album agreement was checked only through the node `desc` and `reward.picture` strings. The farmer-never-painted rule and the mill type are therefore checked in text only.
3. **The parent's original answers.** The ✅ marks were taken at face value from the story documents. I did not compare them with `planning/` (the answer files such as `planning/2026-10-10-answers-round-1.md`), nor with `research/`, `progression/` or `claude-skills/`.
4. **Quiz packs and the full German data.** `data-de.json` (about 3,300 keys), `quiz-en.json`, `quiz-de.json`, `learn-de.json`, `ui-de.json`: searched for religion words and for the story strings only. No gender audit of German outside the six story files.
5. **No play-through, no read-aloud.** I did not run the game or the bot. The chapter ranges (ch1 1-244 ... ch6 906-1069) are taken from `code-issues-story-timing.md:3`, one bot run; finding F-048 and the awe-adjacency remarks depend on them. I did not read the pieces aloud, so rhythm and read-aloud difficulty are judged by eye only.
6. **Code beyond the story engine.** Read: `systems/story.gd`, `lord.gd`, `seasons.gd` (names only), `ui/storybox.gd` (`_quiet`), the condition terms in `game.gd`. Not read: the rest of the game code. Node, item and counter names used in the 166 triggers were checked by script against the nodes, `items.json` and `game.gd`; the converter `staging/md_to_story_json.py` was not run (it writes files).
7. **Archive, builds and other documents.** `archive/`, `godot-prototype/` code outside the files named above, `web-build/` were not touched. `TODO.md` and `PROJECT-LOG.md` were read only where cited. `game-hooks.md` and `game-design-round4.md` were read only for the lines cited.
8. **Frame pieces and the built German.** The seven frames were read for continuity only (frame 0 to frame 6); I did not test German grammar or ss/ß in the built German beyond the gender search and the 'ß' search of the new English files.

## Fix list for the editor

One line per finding: `F-nnn | file | piece id | action | one-line instruction`. Every finding marked PARENT? in the report also has "parent decides" at the start of its line here.

```text
F-001 | story/texts/more-ch2.md | c2_barn_done | EDIT | Replace the whole text: no "set alight by you", no hook, no cow (wording in report).
F-002 | story/texts/more-ch2.md | c2_hilde | EDIT | Replace the text so Hilde speaks to the farmer (wording in report).
F-003 | story/texts/more-ch2.md | c2_otto | EDIT | Replace "a little girl who didn't cry" with "I took you across. You were so small, and you did not cry".
F-004 | story/texts/more-ch4.md | c4_birthday | EDIT | Retitle "The bucket"; replace "A year ago this week you came here" with "It was spring when you came here".
F-005 | story/texts/more-ch5.md | c5_badger_job | EDIT | Replace written words on the card with a picture of basket, leaves, cup and moon (wording in report).
F-006 | story/texts/more-ch6.md | c6_quilt | EDIT | Replace "A year of Hazelwood" with "All of Hazelwood"; "blue sail" with "a scrap of blue"; "quilt" with "patchwork cover".
F-007 | story/texts/more-ch6.md | c6_eve | EDIT | Replace the last three sentences (no year, no "only sure that you are"); wording in report.
F-008 | story/texts/more-ch1.md | c1_maud | EDIT | "relief to everyone" becomes "disappoints everyone, the goat included"; "Berit's chin" becomes "Berit's stubborn self".
F-009 | story/texts/more-ch2.md | c2_reply | KEEP-AND-DECIDE | Parent decides. Decide: pay off "Ask Maud about the goat" in c3_maud_goat (Option A) or cut it from c2_reply (Option B).
F-010 | story/texts/more-ch2.md | c2_barn_done | EDIT | Covered by the c2_barn_done replacement in F-001: no hook, no cow.
F-011 | story/texts/more-ch2.md | c2_tortoise_omen | EDIT | Rewrite so the tortoise is not in the scene: an empty shell house, door towards the water.
F-012 | story/texts/more-ch3.md | c3_maud_goat, c3_dread2, c3_goat_shed | EDIT | Three small edits: Maud takes her goat home; a hen (not "the goat") walks on the list; "A goat" in the barn piece.
F-013 | story/texts/more-ch4.md | c4_watch | EDIT | Pieter holds the farmer's new lantern on the town wall (wording in report).
F-014 | story/texts/more-ch4.md | c4_mei | EDIT | Replace the year-long bundle with the pickles hand-over and one letter (wording in report).
F-015 | story/texts/more-ch5.md | c5_n_foxglove | EDIT | Parent decides. Cut "apparently ten years old" ("smaller and rounder"); parent to say whether the second hand is the farmer's.
F-016 | story/texts/more-ch5.md | c5_lamp | EDIT | "her new lamp" becomes "pours your oil into a lamp"; "she" becomes "he" (wording in report).
F-017 | story/texts/more-ch6.md | c6_terraces | EDIT | Parent decides. Swing is in the first orchard; show a trace (moving swing, apple core), not a seen figure. Parent: confirm no visible sitter.
F-018 | story/texts/more-ch6.md | c6_theatre | EDIT | "village play ... Greenstem plays the cheese" becomes the travelling theatre's actor holding your wheel (wording in report).
F-019 | story/texts/more-ch6.md | c6_n_last | EDIT | Trigger `cards>=87 + seen:c6_supper`; "nothing printed" becomes "It is empty"; pencil becomes ink.
F-020 | story/texts/more-ch*.md | c1_n_* … c6_n_* (21 of the 25 margin-note pieces) | KEEP-AND-DECIDE | Parent decides. Decide how Berit's notes get into books bought at the cart (A: the seller says they came from up the hill; B: restrict; C: ignore).
F-021 | story/texts/more-ch1.md | c1_axe | EDIT | "Your first tool" becomes "Your first axe".
F-022 | story/texts/more-ch1.md | c1_summer, c1_autumn, c1_winter, c1_hunger, c1_spring2 | KEEP-AND-DECIDE | Parent decides. Decide whether "before the frost" (c2_letter, c2_cottage) stays after the c1 winter pieces; option: "before the next frost".
F-023 | story/texts/more-ch1.md | c1_tower | EDIT | "by the fence" becomes "at the edge of the field"; "like a laugh, or a bell" becomes "high and bright, like a bell".
F-024 | story/texts/more-ch1.md | c1_cleared | EDIT | Trigger: require clear_weeds, clear_thistles, clear_rocks and clear_stumps (not only clear_stumps).
F-025 | story/texts/more-ch1.md | c1_quern | EDIT | Trigger: "done:quern + has:flour:1" (the text is about the quern).
F-026 | story/texts/more-ch1.md | c1_winter | EDIT | Cut the sentence "Somebody has been guarding it." (judgment call: it pre-empts c1_bunny page 2).
F-027 | story/texts/more-ch1.md | c1_tom | EDIT | "on the tent pole" becomes "by the door".
F-028 | story/texts/more-ch1.md | c1_ella | EDIT | Trigger: add "+ seen:c1_bells".
F-029 | story/texts/more-ch1.md | c1_n_fire, c1_n_weeds, c1_n_ash, c1_n_chickens, c1_n_market | EDIT | Vary the opening words of the last four notes (wording in report).
F-030 | story/texts/more-ch2.md | c2_stove | EDIT | "Whoever lives here now does not have to eat standing up." becomes "You do not have to eat standing up any more."
F-031 | story/texts/more-ch2.md | c2_greenstem_hands | EDIT | Trigger "+ seen:c2_greenstem"; two pages (wording in report); "about nothing in particular" becomes "about nothing much".
F-032 | story/texts/more-ch2.md | c2_snug | EDIT | Title "The first snow-light" becomes "Snow-light".
F-033 | story/texts/more-ch2.md | c2_n_sleep | EDIT | Replace the note with “You, too.” (underlined, in thin brown ink).
F-034 | story/texts/more-ch3.md | c3_tower | EDIT | "Beyond it the forest" becomes "Behind you, the forest"; Register A to W; shorten (wording in report).
F-035 | story/texts/more-ch3.md | c3_north | RETIME | Move to more-ch4.md as c4_north (node north_field_clear is a chapter 4 node).
F-036 | story/texts/more-ch3.md | c3_board | EDIT | “WELCOME BACK, WE SUPPOSE.” becomes “WELCOME BACK. WE HAD OUR DOUBTS.”; last sentence "You take it as a compliment."
F-037 | story/texts/more-ch3.md | c3_k_wind | EDIT | Trigger: done:windmill_1 (sails exist only then).
F-038 | story/texts/more-ch3.md | c3_swing | EDIT | "young trees" becomes "old trees".
F-039 | story/texts/more-ch4.md | c4_receipt | EDIT | "next to the pressed flower" becomes "with the burnt page"; thanks becomes Pieter's; shorten (wording in report).
F-040 | story/texts/more-ch4.md | c4_greenhouse, c4_k_winter | EDIT | Remove "cold" and "frost" from c4_greenhouse; bark c4_k_winter gets "+ done:greenhouse".
F-041 | story/texts/more-ch4.md | c4_blanket | RETIME | Move to more-ch3.md as c3_blanket (wool_mattress is a chapter 3 node); Move becomes Plant.
F-042 | story/texts/more-ch4.md | c4_wedding | EDIT | Title "A tall cake"; "middle tier" becomes "in the middle, where the berry cake meets the apple pie"; no bell simile.
F-043 | story/texts/more-ch4.md | c4_board | EDIT | Notice becomes “WHOEVER IS DOING ALL THIS, PLEASE DON'T STOP.”; add the unclaimed glove near the bottom.
F-044 | story/texts/more-ch5.md | c5_board | EDIT | "You feel personally addressed, which is odd, because you never do." becomes "It seems like good advice, and you take it."
F-045 | story/texts/more-ch5.md | c5_dry | EDIT | "the kitchen smells" becomes "the still-room smells".
F-046 | story/texts/more-ch5.md | c5_lookalike | EDIT | End on the act: taste neither, wrap both leaves and take them to someone who knows (wording in report).
F-047 | story/texts/more-ch5.md | c5_whirligig | RETIME | Move to more-ch6.md as c6_whirligig, title "The singing pole", Register G; "barn" becomes "coop"; "not favourable" becomes "not kind".
F-048 | story/texts/more-ch5.md | c5_k_rain | EDIT | Trigger: "chapter:5 + chance:0.2" (drop season:autumn).
F-049 | story/texts/more-ch5.md | c5_k_wren | EDIT | Trigger "+ seen:c5_wren_check"; "You do not touch it" becomes "You do not pick it. It will keep until she has seen it."
F-050 | story/texts/more-ch6.md | c6_board | EDIT | "nearly all green" removed; "the first one" becomes "the old one"; "unaccountably funny" becomes "very funny".
F-051 | story/texts/more-ch6.md | c6_agnes, c6_orphanage, c6_flags, c6_poet | EDIT | Use what was delivered: Agnes + tapenade, orphanage + bread, flags + blue, poet = Kit + rainbow scarf (wording in report).
F-052 | story/texts/more-ch6.md | c6_k_alpaca | EDIT | "seen more of the year than you" becomes "seen more than she lets on".
F-053 | story/texts/more-ch2.md, story/texts/more-ch5.md, story/texts/more-ch6.md | c2_n_bread, c5_n_foxglove, c6_n_last (and c2_n_bees) | EDIT | Parent decides. Make every Berit note "thin brown ink" (three edits: c2_n_bread, c5_n_foxglove, c6_n_last).
F-054 | story/texts/more-ch1.md, story/texts/more-ch5.md | c1_hutch, c1_bowl, c5_tea_set (and c2_tortoise_omen) | KEEP-AND-DECIDE | Accept that omens can be missed, or merge c1_hutch and c1_bowl into one piece (hutch and bowl).
F-055 | story/texts/more-ch*.md | all 166 pieces | EDIT | Add {player} in c1_maud, c2_hilde, c3_pieter2, c4_pieter4 (wording in report).
F-056 | story/texts/more-ch3.md, story/texts/more-ch4.md | c3_pieter3, c4_pieter4 | EDIT | Add Pieter's lantern to c3_pieter3 and c4_pieter4 (wording in report).
F-057 | story/texts/more-ch2.md, story/texts/more-ch3.md, story/texts/more-ch4.md, story/texts/more-ch5.md | c2_bees, c2_kitten, c3_baby, c4_window, c5_badger_job | EDIT | Change kind: c2_bees and c5_badger_job to moment; c2_kitten, c3_baby, c4_window to scene.
F-058 | story/texts/more-ch*.md | all pieces (worst: c6_eve, c3_sails, c2_greenstem_hands, c2_kiln, c2_otto, c2_bees) | EDIT | Split or trim pages over 55 words (22 pages); examples c3_sails, c2_kiln, c2_bees in report.
F-059 | story/texts/more-ch*.md | c1_fire, c1_bench, c1_hens, c3_goat_shed, c5_k_tea, c6_oven (and others) | EDIT | Swap embarrassment, confidence, supervised, satisfaction, reasonable, definitely for short words (wording in report); log the rest in book-file.md.
F-060 | story/texts/more-ch*.md | c1_first_card, c1_spring2, c1_k_wave (and others) | EDIT | Vary the "check / in case" lines in c1_first_card, c1_spring2, c1_k_wave (wording in report).
F-061 | story/texts/more-ch2.md | c2_reply | KEEP-AND-DECIDE | Optional: drop "I am glad." from c2_reply so the mother does not warm up and then chill.
F-062 | story/texts/more-ch2.md | c2_n_bees | KEEP-AND-DECIDE | Parent decides. Decide who the second hand in c2_n_bees and c5_n_foxglove is (the child farmer?), or cut both.
F-063 | story/texts/more-ch5.md | c5_petals | KEEP-AND-DECIDE | Optional: settle where the petals come from (upstream in the forest, or below the farm); no wording change required.
F-064 | story/texts/more-ch6.md | c6_telescope, c6_poet | KEEP-AND-DECIDE | Check the Vega picture; until then write "The astronomer ... Vega says" with no pronoun (wording in report).
F-065 | story/texts/more-ch6.md | c6_n_last | KEEP-AND-DECIDE | No change (the plan has "my love"); noted that the mother says it first.
F-066 | story/texts/more-ch*.md | all (27 pieces tagged A) | KEEP-AND-DECIDE | Re-tag Register: keep A only on the planned awe pieces (list in report); others W or G.
F-067 | story/texts/more-ch*.md | c2_kitten, c4_wedding, c5_whirligig, c3_goat_shed | KEEP-AND-DECIDE | No change; if the parent wants a "show, do not name the feeling" rule, apply to these four.
F-068 | story/texts/more-ch2.md, story/texts/more-ch3.md | c2_pond, c2_tortoise_omen, c3_stream_n (and c2_tortoise, c3_stream) | EDIT | Rename c3_stream_n to c3_pond_sun (the text is the pond).
F-069 | story/texts/more-ch*.md | c1_soup, c2_jan, c2_hilde, c2_otto, c3_maud_goat, c4_wedding, c4_watch, c5_lamp, c6_theatre, c6_agnes, c6_orphanage, c6_telescope, c6_poet, c6_painter | KEEP-AND-DECIDE | No piece change; widen the Scene definition in story-delivery.md (see C).
F-070 | story/texts/more-ch1.md, story/texts/more-ch4.md | c1_trips20, c4_window, c1_n_fire | KEEP-AND-DECIDE | No change required; optional: a later line says who left the stool (c1_trips20).
F-071 | story/texts/more-ch1.md, story/texts/more-ch4.md, story/texts/more-ch6.md | c1_maud (and c1_fire, c4_wedding, c6_well) | KEEP-AND-DECIDE | Only "Berit's chin" (c1_maud) fixes a look: fixed in the c1_maud entry; the rest is generic, no change.
F-072 | godot-prototype/data/farm/nodes/09-side-quests.json, godot-prototype/data/i18n/data-de.json | sq_chapel_roof | EDIT | Rename sq_chapel_roof to "Fix the village hall roof" in the node, the German and the picture prompt (planned in TODO.md:553).
F-073 | story/texts/ch2.md, godot-prototype/data/i18n/data-de.json | c2_greenstem (German) | EDIT | German "Du bist die vom Mondrand" becomes „Du bist doch von Moonedge“ (no gender, same farm name as c1_seller).
F-074 | godot-prototype/data/farm/nodes/06-main-path-chapter-5.json, godot-prototype/data/i18n/data-de.json | pet_badger, pet_alpaca | EDIT | Parent decides. pet_badger defaultName must not be Bramble (goat); choose Bracken or Silverpaw and align the desc; pet_alpaca "Pet 5" becomes "Pet 6".
F-075 | godot-prototype/game/farm/systems/lord.gd, godot-prototype/data/farm/rules/53-lord.json, godot-prototype/data/farm/story/30-chapter-6.json | c6_quill_answer / Lord's share | EDIT | Code: ease the Lord's share when c6_quill_answer is seen (lord.gd fraction()); today the share stays at a half.
F-076 | story/texts/ch2.md, godot-prototype/data/farm/nodes/03-main-path-chapter-2.json | c2_tortoise | EDIT | Data: pet_tortoise should require pond (ladder.md:156), or c2_tortoise must not say "the pond"; parent decides (pace).
F-077 | godot-prototype/data/farm/nodes/06-main-path-chapter-5.json, godot-prototype/data/farm/story/30-chapter-6.json, story/code-issues-story-timing.md | c6_free_garden, c6_ajar, c6_frame6 (night garden) | EDIT | Data (C9): pet_alpaca must require river_meadow_drain, else c6_free_garden and c6_ajar describe a garden the player has never seen; parent decides (pace).
F-078 | godot-prototype/data/farm/story/15-chapter-2.json, story/texts/ch2.md, story/README.md | c2_berit_note, c2_k_rest | EDIT | Add c2_berit_note and c2_k_rest to texts/ch2.md (they exist only in the game JSON).
F-079 | story/texts/ch1.md, godot-prototype/data/farm/story/10-chapter-1.json | c1_seller | EDIT | "On the village square" becomes "On the track by your field" (English and German).
F-080 | story/texts/ch2.md, godot-prototype/data/farm/nodes/03-main-path-chapter-2.json | c2_cottage | EDIT | "taps on the tiles" becomes "taps on the thatch" (and German "Ziegel").
F-081 | story/texts/ch2.md | c2_greenstem | EDIT | Trigger: add "+ seen:c2_walls" (the wall must exist).
F-082 | story/texts/ch4.md | c4_no | EDIT | "the North Field" becomes "your best field".
F-083 | story/texts/ch6.md | c6_free_garden, c6_ajar | EDIT | Cut "You open your mouth. You close it again." from c6_free_garden (the unsaid thing belongs to c6_ajar).
F-084 | story/texts/ch6.md | c6_free_miller | KEEP-AND-DECIDE | Parent decides. Decide the mill type (open since 14 Oct); then c6_free_miller says "sails" or "wheel".
F-085 | story/texts/ch3.md | c3_frame3 | KEEP-AND-DECIDE | No change.
F-086 | story/texts/ch2.md, story/texts/ch3.md | c2_letter, c3_letter | KEEP-AND-DECIDE | No change; add "Your cousin asks after you" to ladder 2.1 (see C).
F-087 | godot-prototype/data/i18n/data-de.json | quiz k_play question 2 | KEEP-AND-DECIDE | No change (weekday, not religion).
F-088 | story/characters/hazelwood-people.md, story/outline/long-game.md | hazelwood-people.md, long-game.md  vs  fenna.md, story-delivery.md, book-file.md | EDIT | Fix hazelwood-people.md:22, :36 and long-game.md:62: no "she works hard", no "little girl" (the voice rule wins).
F-089 | story/code-issues-story-timing.md | code-issues-story-timing.md | EDIT | Delete the c4_frame4 re-key from code-issues-story-timing.md:26 (it would make the chapter frame depend on an optional favour).
F-090 | story/outline/long-game.md, story/immersion-triggers.md, story/book-file.md | long-game.md, immersion-triggers.md, book-file.md  vs  the built game | EDIT | Replace "pencil" by "thin brown ink" in long-game.md:62, immersion-triggers.md:15, book-file.md:189.
F-091 | story/world/00-timeline.md, story/world/lease-and-collapse.md | 00-timeline.md  vs  lease-and-collapse.md | EDIT | Timeline: skip of the fallow year moves to Y−14 (as in lease-and-collapse.md:23); straw sale stays Y−12.
F-092 | story/00-premise.md, story/characters/hazelwood-people.md | 00-premise.md  vs  hazelwood-people.md, game | EDIT | Premise §5 row 3: Granny Maud is a chapter 1 favour.
F-093 | story/characters/berit-and-family.md | berit-and-family.md  vs  ladder, premise, texts | EDIT | berit-and-family.md:33 and :37: the cousin is a girl ("daughter", "she").
F-094 | story/outline/ladder.md | ladder.md  vs  ladder.md | EDIT | ladder.md:132: delete the ❓ "text or a tap" (✅ automatic at :166).
F-095 | story/outline/ladder.md, story/texts/ch2.md | ladder.md 2.7  vs  the built c2_compost and c2_berit_note | EDIT | ladder.md:68 (2.7): note both built texts.
F-096 | story/outline/ladder.md, story/outline/long-game.md | ladder.md  vs  long-game.md | KEEP-AND-DECIDE | Parent decides. Decide the awe plan (3 as in ladder.md:24, or ~10 as in long-game.md:15-20) and delete the false "separated by the loom" claim at long-game.md:22.
F-097 | story/outline/long-game.md | long-game.md snag table  vs  the texts | EDIT | Snag table: add the swing sentence to c5_petals, the light to c6_ajar, move Jan's goat line to ch2 in the table; other rows are fixed by their own entries.
F-098 | story/outline/long-game.md, story/book-file.md, story/texts/more-ch4.md | long-game.md, book-file.md, more-ch*.md headers  vs  the texts | EDIT | Strike yarrow, "Remarks: none" and Mei's partner from the invention lists; add second hands, the stool, the blanket.
F-099 | story/characters/hazelwood-people.md | hazelwood-people.md | EDIT | Add a Pieter row to hazelwood-people.md (collects the share from chapter 3; lantern, flask, receipt).
F-100 | story/story-delivery.md | story-delivery.md  vs  more-ch*.md | EDIT | story-delivery.md:17: widen Scene to deliveries and favours.
F-101 | story/outline/ladder.md, PROJECT-LOG.md, godot-prototype/data/farm/rules/50-gate.json | ladder.md, book-file.md, PROJECT-LOG.md  vs  gate.gd | EDIT | Docs: call c1_seller "the seed seller (she)" and the gate system "the travelling merchant (he)".
F-102 | story/00-premise.md, story/book-file.md, story/world/00-timeline.md | 00-premise.md, book-file.md, 00-timeline.md | KEEP-AND-DECIDE | No change; keep "funeral" out of player text.
F-103 | story/book-file.md, TODO.md | book-file.md, TODO.md | EDIT | book-file.md:186 and TODO.md:570: "42 pieces" becomes 61 (ch2-6; 63 in the game JSON).
F-104 | story/book-file.md | book-file.md | EDIT | book-file.md:17: "Roughly 5-6 thousand words" becomes "roughly 9-10 thousand".
F-105 | story/book-file.md | book-file.md | EDIT | book-file.md:113: log the remaining stretch words (thoughtful, evidence, disappointed) instead of "(none yet)".
F-106 | story/README.md | README.md | EDIT | README.md:31: "ch1.md is the source ... chapter 1 done" becomes ch1-ch6, chapters 1-6 built.
F-107 | story/texts/more-ch2.md, godot-prototype/data/farm/nodes/04-main-path-chapter-3.json | more-ch2.md header, node orchard | EDIT | more-ch2.md:3: the orchard node is chapter 2 (the swing waits for chapter 3 on purpose).
F-108 | story/immersion-triggers.md | immersion-triggers.md | EDIT | immersion-triggers.md: fix Firsts (12 to 8), Builds (~60 to ~44), Seasons (9 to 8); recount kinds/chapters after the editor's pass.
F-109 | story/00-premise.md, story/world/00-timeline.md, story/book-file.md, PROJECT-LOG.md | 00-premise.md, 00-timeline.md, book-file.md, PROJECT-LOG.md | EDIT | Docs: "about twelve game years" becomes "nine to twelve (one bot run: 8.9)".
```
