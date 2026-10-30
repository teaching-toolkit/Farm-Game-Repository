## 3. Joins and convention edits made during assembly

These edits are in both story files. Rendering "you" as Fenna (third person, present tense) and the frame's "you" as "the old woman" is convention 1 in `inventory.md`, and is not listed per passage. Every passage built from a seed rather than a game text is marked **N** in the source map. Where a seed directed a revision of a game text, the source-map note says so (basis "-rev").

| J | Location | Edit | Reason | Game impact |
|---|---|---|---|---|
| J1 | 1.09, 1.12, 1.28, 1.38, 1.61, 2.20, 2.28, 2.32, 2.40, 2.43, 3.21, 3.38, 3.41, 3.45, 3.53, 4.09, 4.15, 4.24, 4.39, 5.10, 5.24, 6.10, 6.14, 6.15 | Berit's margin notes say which page of the book they sit on (“In the margin of the page about fire”, “in the book”). | In the game the note opens on its card, so the page is visible; a straight read needs the page named. | none |
| J2 | 1.15 `c1_k_bucket` | “against the well stones” → “against the stones” | Early in chapter 1 there is no well yet (it is dug at 1.47). | trigger `step>=4` can fire before the well: drop "well" or re-key |
| J3 | 1.17 `c1_seller` | `{player}` dropped (“Good porridge, {player}.” → “Good porridge.”) | The seller has not been told Fenna's name; the seed also moves her from the square to the track. | `c1_seller` (text-change row 12 is already open) |
| J4 | 1.31 `c1_tom` | “by the door” → “by the tent flap” | In chapter 1 Fenna lives in a tent. | `c1_tom`: "by the door" is wrong until the cottage (chapter 2) |
| J5 | 3.22 `c3_tower` | “The tower stands” → “The mill tower stands” | Keeps it apart from the tower of rocks in chapter 1. | none (the game shows the node) |
| J6 | 5.26 `c5_page` | “The chest” → “The healer's chest” | The chest (an item) is not otherwise named. | none |
| J7 | 5.39 `c5_petals` | “Beside the path” → “Beside the forest path” | The game shows the place; the text does not. | none |
| J8 | 6.22 `c6_painter` | “as if she means for the whole season” → “means it for” | A missing word in the source. | `c6_painter`: typo |
| J9 | 6.43 / 6.46 `c6_supper` | The shipped page 2 is split: “The goat eats the blue ribbon.” stays at 6.43; “Somebody starts to sing …” opens 6.46. | The master puts the lantern beat (E-6.B26) and Tilda's hand (E-6.B27) between them. | the merges are the master's (text-change rows on `c6_supper`) |
| J10 | 6.49 `c6_eve` | “The bucket, by the door, is full of rain.” replaced by the bucket set beside the fire and the thimble (E-6.M27). | E-6.M27 takes over `c6_eve`'s slot after the garden. | `c6_eve` p2 changes; re-key after the garden piece |
| J11 | 2.33 `c2_otto` | “He stops. He starts again. He stops.” and “Then he goes, without another word.” added | E-6.L08 directs the hesitation and the silent leaving. | `c2_otto` |
| J12 | 1.06, 1.16, 1.19, 1.21, 1.48, 2.12, 3.14 and other **N** passages | the seeds' “who wants what” lines turned into narration (“Fenna wants …”) | No game text exists for these. The seeds' own sketch lines are kept verbatim. | each needs a new piece (see the source map, basis N) |
| J13 | 6.38 `c6_bend` | the shipped “Nobody believed me either” is replaced by “I never told anyone” | the parent's ruling (bible §10, 04-31) and telling.md P6 | `c6_bend` (7 pages per telling.md §4.2) |
| J14 | 4.19 / 4.20 | E-4.L11's two barks moved after the tin scene (E-4.R11) | the cold read found the reading and the tin split by the barks | none (barks fire on their own) |

## 4. Cold read

A fresh agent, given only `story-repaired.md`, read it start to finish (27 Oct 2026). Its findings, and what was done with them:

| Finding | Handling |
|---|---|
| Contradictions: the Lord's letter arriving twice; "the hand from the hay margin" (Liv) against "—T." (Tilda); Tilda counted among "the children"; "At the Fair I said I wasn't alone"; the farm's goat on the new barn before it comes home; "the barn" before the new barn; "borrowed a tent" against "her father's tent" | **Fixed** (#66, #62, #65, #71, #60, #54, and #5 reworded) |
| Bare references: Hazelwood, the kitten, Otto and the bridge, the old mill, the moonstone, the Broker, the marsh becoming a garden, the siblings, the row of animals, the Cup custom | **Fixed** (#53, #55, #56, #58, #63, #67, #68, #69, #70, #57) |
| Order: the seasons in chapter 3; the tin scene split; the poisoning with no cause; two passages opening with the same sentence | **Fixed** (#59, J14, #64, #61) |
| Things built or bought off-page ("The coop is finished", the hive, the cow, the sheep, the library room) | **Kept.** This is the farm's progress, which the game supplies by play. A straight read accepts it as time passing. |
| The THUMP not tied to the bunny until chapter 2; Lark's identity; Mumyo's name; "the lights" | **Kept**: productive mysteries (Type 3). The reader could state each as a question. |
| The Count never raised; the bells' meaning never given; Berit's feeling hardly raised | **Kept by design**: the Count never appears in text (bible §4); the bells' lexicon is taught by repetition; Berit's guilt lives only on the free-play alpaca page (bible §6). Noted for the person: the reader could not form the Count question at all; whether that is wanted is open-questions G9. |
| "Fill it at dusk, not at dawn" against "You took her water at dawn" | **Kept**: this is the clue to why the bucket was empty (B1). |
| "Afraid of flame" after forges and cooking fires; "the bucket is always in her hand" against "by the door"; "It was spring when Fenna came here" | **Kept**: consistent with her habit (she cooks with a bucket beside every fire); the others are moments, not rules. |
| "Nobody told her there would be so many stars" though she lived here until eight | **Kept** (staged bark); a child's memory. |
| Voice: the long explanatory additions (the Lord's share, the Chain, Share Day); the "Fenna wants …" pattern in N passages; game-flavoured words (pizza, tapenade, "Her first axe", "same time next season", the tech-tree margins) | Additions shortened where possible. The N pattern is open-questions G8. The game-flavoured lines are shipped or staged text and stay; phase 2 may want to look at "pizza" and "tapenade". |
| Many named villagers arriving in one rush in chapter 6 (Agnes, Elsie, Vega, Kit) | **Kept**: optional side scenes; each is named with a role on first mention. |
