# Changes log

All changes from `story-assembled.md` (the baseline) to `story-repaired.md`. Then the joins and convention edits made while assembling, the cold read, and the status of every item in Appendices A and B. Locations use the block ids of `source-map.md` (Loc column) and the passage's opening words. The decisions on B2 and B3 are in `open-questions.md` (D-B2, D-B3). Changes #1–#52 come from the appendix check; #53–#71 come from the cold read (§4).

## 1. Word counts per chapter

| Section | Assembled | Repaired | Growth |
|---|---:|---:|---:|
| Before the first page | 145 | 157 | +8.3 % |
| Chapter 1: Ashes | 3266 | 3364 | +3.0 % |
| Chapter 2: Homestead | 2746 | 2830 | +3.1 % |
| Chapter 3: Smallholding | 2944 | 3041 | +3.3 % |
| Chapter 4: Village Trade | 2610 | 2633 | +0.9 % |
| Chapter 5: Healing | 2229 | 2277 | +2.2 % |
| Chapter 6: Master Farm | 3212 | 3292 | +2.5 % |
| The last evening | 163 | 163 | +0.0 % |
| Reference (not part of the chapters) | 916 | 916 | +0.0 % |

Growth stays far under the 25 % limit everywhere. The frame grows most in relative terms (the name in F0.1).

## 2. Repairs

| # | Issue | Location | What changed | Why | Source | Game impact (phase 2) |
|---|---|---|---|---|---|---|
| 1 | A1 | Frame 0 · F0.1 · Evening. The room smells of tea. … | “on the old woman's feet: her grandchildren, all of them.” → “on the old woman's feet. Her name is Fenna. She is very old now, and these are her grandchildren, all of them.” | The reader could not tell that the old woman is Fenna. In the game the second person carries it; the third-person story needs the name once. | outline/story-bible.md §1 (Fenna, Minena's grandmother) | None in the game: `c1_frame0` is second person, so the identity is automatic there. Story-file only. |
| 2 | A6 | Ch1 · 1.02 · In the tent is the box … | “In the tent is the box her grandmother left.” → “In the tent is the box her grandmother left her when she died this winter.” | Says once that the grandmother is dead and that the box is an inheritance; the note's "If you are reading this" then reads as foreknowledge. | bible §1 (Berit gone); world/00-timeline.md (Berit dies Y+7, winter); slice 01 §7.2 | New piece `c1_box` (E-1.03): add the clause, or let the welcome hint say it (`welcome.gd` string, text-change row 5). |
| 3 | A-new-1 | Ch1 · 1.03 · The book in the box is … | “Then Berit's kitchen song comes back” → “Then her grandmother Berit's kitchen song comes back” | "Berit" was named before anything linked her to the grandmother (the note is signed "B."; Maud's line comes later). | bible §1; slice 01 §3.1 fact 5 | `c1_book` p2 (already under text-change row 7): name Berit as the grandmother. |
| 4 | A6, A46 | Ch1 · 1.06 · The last of the bread is … | “with a wheel burnt into it and the letters WEIR.” → “with a wheel burnt into it and the letters WEIR. Weir is the town down the river where her family lives now.” | WEIR on the canvas read as a mystery word; the family's whereabouts were fog until Rue's carter. | characters/liv-tilda-berit.md (Weir); world/00-timeline.md ("the river town of Weir") | New piece `c1_bread` (E-1.06): one sentence. |
| 5 | A55 | Ch1 · 1.06 · The last of the bread is … | “She told them she would stay a while.” → “She told them she would stay a while. That evening she patches the hole in the tent, which she borrowed from her father.” | "You patched it" (ch6) had no setup: the tent was never her father's, and nothing was ever patched. | slice 01 §7.1 (the tent is her father's wagon cover, 💡); E-1.06 plant "the canvas → the tent returned, patched"; E-6.B20 | `c1_bread` (E-1.06) gains the line, or the bark kit's "the tent" bark (slice 01 §6) carries it. **Proposed material** (see open-questions P4). |
| 6 | A4 | Ch1 · 1.24 · Under the black boards of the … | “At the bottom, in red: “The Lord's share.”” → “At the bottom, in red: “The Lord's share.” That was the part of every harvest that went to the Lord, whose land Moonedge was.” | The Lord and the share appeared with no setup. One clause makes the basics solid; "what does the Lord want?" stays open. | bible §4 (the lease, the claim); world/lease-and-collapse.md | `c1_ledger` (text-change row 11 is already open): add the clause. |
| 7 | B1 | Ch1 · 1.47 · The spade rings on old stones, … | “The spade rings on old stones, a curve of them.” → “The spade rings on old stones, a curve of them: the old well, dry since before the fire.” | The dry well, the reason the bucket was empty on the barn night, had no setup anywhere in the story. | bible §3 ("the dry well"); world/00-timeline.md (Y−3, the well drops) | `c1_well2` (E-1.19): one clause. |
| 8 | A-new-3 | Ch1 · 1.48 · Two children come up the track, … | “Lotte and Linus.” → “Lotte and Linus, the twins.” | Later passages call them "the twins" (3.54, 1.15 seed) without the link. | slices/02-lived-in-hazelwood/people.md | New piece `c1_ghosts` (E-1.15). |
| 9 | A-new-5 | Ch1 · 1.54 · On Longnight, the longest night of … | “On Longnight, far below, the village's lights go out one by one, all but the Hall.” → “On Longnight, the longest night of the year, far below, the village's lights go out one by one, all but the lights of the Hall.” | Longnight and the Hall were named as if known. | slices/02-lived-in-hazelwood/almanac.md (Longnight); atlas (the Hall) | E-1.L08 (new piece). |
| 10 | A-new-9, A40 | Ch1 · 1.64 · Rue wants Fenna to see something: … | “Fenna cannot un-cut it.” → “The manor is called the Hurst. Fenna cannot un-cut it.” | "The Hurst" is used from chapter 3 (salt card, the miller, the Hurst Gate) with no introduction. | bible §9 (Hurst Manor, accepted name) | New piece `c1_rue3` (E-1.23). |
| 11 | A-new-6 | Ch1 · 1.66 · Two carts meet on the narrow … | “by the Hop.” → “by the Hop, the stepping stones across the river.” | "The Hop" was an unexplained place name. | slices/02-lived-in-hazelwood/atlas.md | E-1.L09 (bark). |
| 12 | A5 | Ch1 · 1.73 · A bunny sits on the one … | “And one grain was left for her.” → “And one grain was left for her. The bunny was Moonedge's once. She has come home.” | That the animals belonged to the farm, and that their arrival is a return, was never said; "why did they leave, who comes next?" stays a question. | bible §2, §8 (six Helpers, order of return); slice 03 | `c1_bunny` p2: add the two sentences (the piece's title already says "comes home"). |
| 13 | A12, A13 | Ch2 · 2.01 · It is Landing Day, when the … | “A pressed hazel leaf falls out.” → “A pressed hazel leaf falls out. Cobble is the family's old horse.” | Cobble was a name with no referent. | characters/liv-tilda-berit.md (the father speaks through the horse Cobble) | `c2_letter` (text-change row 21 is open): name Cobble's kind once. |
| 14 | A14 | Ch2 · 2.01 · It is Landing Day, when the … | “when the river barge brings the post, every second week.” → “when the river barge ties up at the Landing below the village and brings the post, every second week.” | "The Landing" was later used as a known place. | bible §9 (Landing Day fortnightly); atlas | `c2_letter`. |
| 15 | A16 | Ch2 · 2.12 · Greenstem, the boy with the herbs, … | “After that, she sees chalk everywhere.” → “The Lord still wants the share the farm stopped paying when it burned, so the village pays it, one thin chalk moon at a time. After that, she sees chalk everywhere.” | The Mark had a name and no purpose. Now the reader knows why it exists; what "until the farm gives again" means stays open. | bible §4 (a chalk thin moon on every loaf; fixed grievance); slices/02-lived-in-hazelwood/foodways-and-trades.md §5 ("the Lord's way of making good the share", 💡) | E-2.L02 (new piece). **Proposed material** (open-questions P5). |
| 16 | A17 | Ch2 · 2.12 · Greenstem, the boy with the herbs, … | “Greenstem wants to know why bread is so dear” → “Greenstem, the boy with the herbs, wants to know why bread is so dear” | Greenstem was named after he appeared, with no link to the boy at the gate. | c2_greenstem; slice 02 people | `c2_greenstem` never says his name: add "Greenstem" there (best), or keep the appositive in E-2.L02. |
| 17 | A-new-4 | Ch2 · 2.21 · Fenna wants to sell her first … | “Mistress Appleby has a chalk board” → “Mistress Appleby, the baker, has a chalk board” | Appleby's trade was unstated. | slice 02 people (Appleby, the bakery) | E-2.L10. |
| 18 | A-new-4 | Ch2 · 2.21 · Fenna wants to sell her first … | “On the way out, Anna slips” → “On the way out, Anna, who shapes the loaves at the bakery, slips” | Anna was a bare name. | slice 02 people (Mistress Appleby with Anna and Ben) | E-2.L10. |
| 19 | A17 | Ch2 · 2.25 · Hilde the washerwoman hangs the last … | “Hilde hangs the last sheet” → “Hilde the washerwoman hangs the last sheet” | Hilde was a bare name. | node `sq_washing_line` ("The washerwoman's line snapped") | `c2_hilde`. |
| 20 | A-new-11 | Ch2 · 2.37 · A real roof, before the frost. … | “taps on the tiles.” → “taps on the thatch.” | The roof is thatch in the two pieces before and after it (the hammer at the ridge, "Good thatch"); "tiles" contradicted them. | E-2.M06, E-2.R02 (outline rank 2 over game text rank 4) | `c2_cottage`: tiles → thatch (also in German). |
| 21 | A-new-2 | Ch2 · 2.38 · A lantern stops at the gate, … | “Pieter looks at the roof” → “Pieter, the night watchman who carries the Lord's book, looks at the roof” | Pieter was named here before his introduction (3.12, `c3_pieter`). | c3_pieter; bible §4 | E-2.R02 fires in chapter 2, before `c3_pieter` introduces him: give E-2.R02 the appositive, or move the introduction earlier. |
| 22 | B2 | Ch2 · 2.44 · Fenna clears the last black beam … | “Something else began this. She does not know what. And she finds” → “Something else began this. And she finds” | Canon: Fenna was in the barn and knows how it began; what she does not know is whose hands carried the lantern. "She does not know what" made her sound like an outsider (B2). | bible §3; telling.md §4.2 P4 | `c2_barn` p2: drop the sentence. |
| 23 | B2, A-new-10 | Ch2 · 2.47 · In the new barn frame Fenna … | “In the new barn frame Fenna finds an old iron hook.” → “In the new barn frame Fenna finds the old iron hook from the doorframe.” | Ties the hook to the one on the old doorframe (1.20), so there is one hook, outside by the door, as canon has it. | bible §3 (the lantern hung on its hook outside the barn door) | `c2_hook`. |
| 24 | B2 | Ch2 · 2.47 · In the new barn frame Fenna … | ““If it was not lightning,” she thinks, “then what?” She hangs” → “She holds it for a long time. Then she hangs” | The inner question made her an investigator who does not know (B2), and avoidance must be shown through action, not thought (brief). | bible §3; brief "What must not change" | `c2_hook`: replace the thought with the action. |
| 25 | A-new-9 | Ch3 · 3.09 · On the salt page, in thin … | “On the salt page, in thin brown ink:” → “On the salt page, in thin brown ink, Berit writes about the Keepers, who farmed Moonedge first and made its lease:” | "The Keepers" were named as if known. | world/00-timeline.md ("a family of Keepers settles on the forest edge … This is Moonedge", 💡) | E-3.R41 (new margin). **Proposed material** (open-questions P6). |
| 26 | A22 | Ch3 · 3.14 · Share Day comes at the end … | “On Share Day the Hall feeds everyone before Pieter writes” → “Share Day comes at the end of every season, when Pieter collects the Lord's share from every house. On Share Day the Hall feeds everyone before Pieter writes” | Share Day had a name and no purpose. | bible §4 (collected by Pieter); slices/02-lived-in-hazelwood/almanac.md §4.2 (the end of every season, 💡); slice 07 dossier (the clock table) | E-3.R40 (new). **Proposed material** (P7). |
| 27 | B3 | Ch3 · new 3.17b | New passage after 3.17: “A child at the gate says, “My mum says it was lightning.” “Did she?” says Fenna.” | Restores the village's "lightning" in a plain line, so the reader holds both the village's word and the ground's ("it started low") before the Fair. | slice 04 E-2.B05 (2); bible §5 Q5 | New bark (E-2.B05 #2, `chapter:3 + chance:0.15`); it exists only as a seed. |
| 28 | A-new-8 | Ch3 · 3.35 · On market day the village will … | “sells to the Nest instead, for less.” → “sells to the Nest, the orphanage, instead, for less.” | The Nest was a bare name. | slice 02 atlas (the Nest, the orphanage) | E-3.L10. |
| 29 | A31, A42 | Ch3 · 3.52 · One autumn day Fenna is on … | “The grey barge comes round the bend.” → “The grey barge comes round the bend. Even the Lord's share goes onto it, down the river.” | The grey barge had no purpose, and the Lord's fear (frame 4, "of a number") had no anchor. Now the share goes on, past the Lord; who it goes to stays unnamed. | slice 07 accounts §2 (the grey barge carries the grain); bible §4 (the Lord owes upward; the Count never in text) | E-3.L06 (new). |
| 30 | A32, B6 | Ch3 · 3.52 · One autumn day Fenna is on … | “One small hand takes hers.” → “One small hand, a child's, takes hers.” | A "small hand" in the crowd read as Mumyo's, which breaks his size (hand-sized) and the rule that he is never seen. | bible §7 (Mumyo hand-sized, present only as traces) | E-3.L06. |
| 31 | A28 | Ch3 · 3.54 · The next summer the village children … | “want to run the Chain for the first time in a long time” → “want to run the Chain, the line of buckets the village made from the stream to the barn the night Moonedge burned, for the first time in a long time” | "The Chain" was capitalised as if known, and the custom had no origin or purpose. | slices/02-lived-in-hazelwood/dossier.md §3 item 1 ("The village came", 💡); customs-and-sayings R5 | E-3.L11 (new). **Proposed material** (P8). |
| 32 | A28 | Ch3 · 3.54 · The next summer the village children … | “runs from the Deep to the Hall and back” → “runs from the Deep, the well in the Square, to the Hall and back” | The Deep was an unexplained name. | slice 02 atlas (Deep: the well in the Square) | E-3.L11. |
| 33 | A28 | Ch3 · 3.54 · The next summer the village children … | “Ansel rings five fast, one slow.” → “Ansel the bell-ringer rings the Hall bell five fast, one slow: fire, then all's well.” | Ansel and the signal were unexplained. | slice 02 people (Ansel the bell-ringer); almanac §4.1 ("fire, then all well") | E-3.L11. |
| 34 | B1 | Ch3 · 3.56 · Fenna sets four buckets, full, at … | “Four buckets, full, stand at the corners of the barn. Then eight at the farmhouse.” → “Fenna sets four buckets, full, at the corners of the barn. Then eight at the farmhouse.” | The passive voice made the buckets read as set down by nobody (magic). They are her habit, which is the point. | E-3.B12 ("you want to be safe from a thing you do not say") | E-3.B12 (bark). |
| 35 | A36 | Ch4 · 4.04 · Quill wants his folded pages back. … | “The red and grey inks have run to smears. The faint pencil down the margin, a third column, is perfectly clear.” → “The red and grey inks of the Lord's accounts have run to smears. The faint pencil down the margin, a third column in Quill's own hand, is perfectly clear.” | The "private number" and the ink-versus-pencil point were hard to follow. | slice 07 accounts §1 (red = the Lord, grey = the one above, pencil = may be wrong) | E-4.R22 (new). |
| 36 | B4 | Ch4 · 4.16 · In a rusty tin under the … | “The red number is the same.” → “The red number is the same. Pieter has never asked for half. Not yet.” | Claim versus collection: the lease claims half, and the collection climbs toward it. Without the line, "a half" and the smaller shares read as a contradiction. | bible §4 (claim versus collection) | `c4_lease`: add the two sentences. |
| 37 | A-new-7 | Ch4 · 4.18 · Share Day. Quill wants the lease … | “because the Book requires it” → “because the Book, the Lord's great ledger, requires it” | "The Book" (capitalised) was not linked to Pieter's book. | bible §4; slice 07 | E-4.R42. |
| 38 | A-new-7 | Ch4 · 4.34 · Fenna's paved road reaches the Hurst … | “Tally measures it. Juno wants it filled.” → “Tally the tollman measures it. Mayor Juno wants it filled.” | Two bare names. | slice 02 people; slice 07 people | E-4.R19. |
| 39 | A50 | Ch5 · 5.19 · Fenna wants to finish sorting the … | “Later he asks, “What's it called?” Fenna does not know what he means.” → “Later he asks, about the tune she is humming, “What's it called?”” | The assembled join was vague; the question is about her tune. | E-5.M21 | E-5.M21 page 2. |
| 40 | B9, A19, A45 | Ch5 · 5.26 · The healer's chest is full. In … | “She counts the children of that winter on her fingers. Herself. The two small ones. The aunt who laughed:” → “She counts the children of that winter, the fever winter before the fire, on her fingers. Herself. The two small ones. Aunt Tilda, who laughed:” | When the fever was, and how Tilda died, were unclear. Canon: Tilda died in the fever winter, before the fire. This also makes Liv's "I used to think the lights were her" possible. | characters/liv-tilda-berit.md (Tilda gone in the fever winter); world/00-timeline.md Y−1 | E-5.B17 (new). |
| 41 | A-new-12, A44, A63 | Ch5 · 5.31 · At the door of the still-room … | “The badger pours.” → “The badger pours. And the fifth line of the old rhyme comes back to her: “Wise badger heals what aches and stings.”” | Line 5 never came back in any text, though the alpaca's piece says the rhyme is "whole". It also gives the badger his role. | world/helpers-and-rhyme.md; slice 03 §4.1 (return in `c5_badger`) | `c5_badger` p2: add the line (and the German line). |
| 42 | A-new-7 | Ch5 · 5.38 · Ferdinand the old lamp-maker, whose eyes … | “Ferdinand wants her” → “Ferdinand the old lamp-maker, whose eyes are going, wants her” | Ferdinand was a bare name, and "cannot see it" was unexplained. | slice 02 people (Ferdinand, the old lamp-maker, going blind) | E-5.L05 (and `c5_lamp`, which calls him only "the lamp-maker"). |
| 43 | A52 | Ch6 · 6.01 · Fenna opens the letter with the … | “She reads it twice.” → “As it was before the fire, at the foot of the burnt page. She reads it twice.” | "As before" had no referent. | bible §4; `c1_ledger` | `c6_lord`. |
| 44 | A-new-7 | Ch6 · 6.03 · Fenna wants to read the Lord's … | “Juno wants the tables set for the Fair.” → “Juno wants the tables set for the Harvest Fair.” | The Fair was named as if known. | slice 02 almanac §4.4 | E-6.L11. |
| 45 | A64 | Ch6 · 6.06 · Fenna has drained the old marsh … | “Somewhere in the dark, very quietly, bells.” → “In a ring round the first flower stand thimbles, full of water. Somewhere in the dark, very quietly, bells.” | The thimble beside the bucket (6.49) had no earlier link to Mumyo. | slice 06 §5.1 A4 (the night garden: "in a ring round the first, thimbles, full", 💡) | `c6_garden`. **Proposed material** (P9). |
| 46 | A24, A57 | Ch6 · 6.33 · Mayor Juno wants the Cloth Table … | “The table has been laid at every Fair since the fire” → “The table has been laid for Moonedge at every Fair since the fire” | Whom the Empty Table and its stool are for was fog. | slice 02 customs (The Empty Table) | E-6.L01. |
| 47 | A58 | Ch6 · 6.36 · The Wagon Players, the travelling theatre, … | “The Wagon Players want” → “The Wagon Players, the travelling theatre, want” | The Players were unintroduced. | E-6.L05; `c6_theatre` | E-6.B21. |
| 48 | A58 | Ch6 · 6.36 · The Wagon Players, the travelling theatre, … | “Lil Thunder shakes” → “Lil Thunder, their sound girl, shakes” | A bare name. | E-6.L05 ("their sound girl") | E-6.B21. |
| 49 | A29, A56, A69, B8 | Ch6 · 6.32 · The whole village waits on the … | “Liv is last off the barge, a snuffing pole on her back and a stone in her fist.” → “Liv is last off the barge, in a grey coat too short at the wrists, with a lamplighter's snuffing pole on her back and a flat grey stone in her fist.” | The grey figure, the grey stones and the cousin were three threads with no visible join; her job was never said. This is where the materials join them. | characters/liv-tilda-berit.md (grey coat, lamplighter in Weir, Liv's stones; accepted 04-35) | E-6.B20. |
| 50 | A61 | Ch6 · 6.40 · Quill wants to write his count, … | “Then, dry, to nobody:” → “Then, dry, to nobody, about the Lord and his letters:” | "He had them all in a drawer" had no referent. | bible §4 (he did not open his post) | E-6.R29. |
| 51 | A62, B4 | Ch6 · 6.40 · Quill wants to write his count, … | “With his numbers in hand, the share is set at a tenth, as in the old days.” → “With Quill's numbers in hand, the Lord has set the share at a tenth, as in the old days.” | Restores the shipped subject (the Lord sets the tenth), so it is clear by what authority; Quill signs his count, not the rate. | `c6_quill_answer` ("the Lord sets the share at a tenth"); bible §4 | Merged piece E-6.R29 + `c6_quill_answer`: keep "the Lord sets". |
| 52 | A66 | Ch6 · 6.44 · The village wants a bright supper. … | “The next night every lantern in the square hangs outside, with a bucket under it.” → “The next night every lantern in the square has a bucket under it.” | "Hangs outside" implied that lanterns used to hang inside, but hook-outside has been the valley's rule since the fire. What the village copies is the bucket. | slice 02 customs R12 (Hook outside, hay inside: Berit's rule, now the valley's) | E-6.B26. |
| 53 | cold read | Ch1 · 1.17 · A seller comes along the track … | “cooking up here.” She looks” → “cooking up here.” Hazelwood is the village below the hill. She looks” | Hazelwood was named with no explanation. | bible §9; slice 02 atlas | `c1_seller` (text-change row 12 already asks for "all of Hazelwood"). |
| 54 | cold read | Ch2 · 2.05 · The cow comes down the plank, … | “looks at the barn, looks at the yard” → “looks at the burnt barn, looks at the yard” | The new barn is built later in the chapter; this is the ruin. | sequence of chapter 2 | `c2_cow`: "the barn" is ambiguous before `barn_1`. |
| 55 | cold read | Ch2 · 2.31 · The stray kitten sniffs the saucer. … | “She sniffs the saucer.” → “The stray kitten sniffs the saucer.” | The passage had no antecedent. | node `sq_stray_kitten` | `c2_kitten`: name the kitten in the first line. |
| 56 | cold read | Ch2 · 2.33 · Otto, the old ferryman, crosses the … | “Otto crosses the mended bridge slowly” → “Otto, the old ferryman, crosses the footbridge Fenna has mended, slowly,” | The bridge and Otto were unintroduced. | node `sq_bridge` ("Mend the footbridge"); c2_otto | `c2_otto`. |
| 57 | cold read, A-new-7 | Ch2 · 2.42 · On Longnight, Greenstem wants her to … | “Fenna takes the ladle, so that she never has to say a true thing, though no one has asked her to.” → “On that night anyone who wants to says one true thing, and the nearest person passes them a cup. Fenna takes the ladle, so that she will not have to. No one has asked her to.” | The custom of the Cup was never explained, and the sentence read as garbled. | slice 02 customs R8 (The Cup, 💡) | E-2.L05. **Proposed material** (open-questions P13). |
| 58 | cold read | Ch3 · 3.23 · In the ruin of the old … | “In the old mill, on a rusty nail,” → “In the ruin of the old mill, on a rusty nail,” | Unclear how the old mill relates to the mill tower being built. | node `ruins_windmill` | `c3_bell`. |
| 59 | cold read | Ch3 · 3.54 · The next summer the village children … | “In summer the village children” → “The next summer the village children” | The seasons ran autumn (the Grey Breath) then summer. | order convention O12 | none |
| 60 | cold read | Ch3 · 3.55 · The bigger barn is finished. Maud's … | “A goat walks in, walks out” → “Maud's goat walks in, walks out” | The farm's goat has not come home yet (3.60). | c3_maud_goat (Maud's goat keeps coming to the yard) | `c3_goat_shed`: the trigger can fire before `pet_goat`; name the goat or re-key. |
| 61 | cold read | Ch4 · 4.11 · Another day, Quill counts the hens … | “Quill wants an exact number of hens. The goat” → “Another day, Quill counts the hens again. The goat” | Two passages opened with the same sentence. | E-4.L01, E-4.H25 | none (two seeds in two pieces). |
| 62 | cold read, A16 | Ch5 · 5.07 · A letter comes by Mei, signed … | “It is the hand from the hay margin.” → “It looks like the second hand in the hay margin, small and round.” | The hay margin is signed "T." (Tilda); Liv's hand is like her mother's, not the same hand. | E-6.B27 (the second hand is her mother's); liv-tilda-berit.md | E-5.B16: "looks like". |
| 63 | cold read | Ch5 · 5.13 · In the forest, a ribbon on … | “The moonstone is warm on its shaded side.” → “One of the white stones is warm on its shaded side.” | "Moonstone" was an unexplained term. | slice 06 §4.3 F2 | forest bark F2. |
| 64 | cold read | Ch5 · 5.23 · Once, Fenna uses a leaf from … | “The ceiling. A blanket.” → “Once, Fenna uses a leaf from her basket before Wren has seen it. Then: the ceiling. A blanket.” | The poisoning itself was missing, so the passage read as out of order. | `c5_poison` trigger (`forest_poisoned`) | `c5_poison`: the cause is shown by the game; the text could add the first line. |
| 65 | cold read, B9 | Ch5 · 5.26 · The healer's chest is full. In … | “She counts the children of that winter, the fever winter before the fire, on her fingers. Herself. The two small ones. Aunt Tilda, who laughed:” → “She counts the fever winter before the fire on her fingers. Herself. The two small ones. Aunt Tilda, who laughed:” | Tilda was counted among "the children". | E-5.B17; liv-tilda-berit.md | E-5.B17. |
| 66 | cold read, O7 | Ch6 · 6.01 · Fenna opens the letter with the … | “A rider brings a letter with a red seal. Fenna's farm prospers” → “Fenna opens the letter with the red seal. Her farm prospers” | The Lord's letter arrived twice (a boy at the end of chapter 5, a rider here). | c5_letter; master ch6 note (c6_lord fires before c5_letter: engine trap) | `c6_lord`: drop the rider, or merge with `c5_letter` (data wish already listed). |
| 67 | cold read | Ch6 · 6.04 · A new trader, a broker, unpacks … | “A new trader unpacks his cart on the square.” → “A new trader, a broker, unpacks his cart on the square.” | "The Broker" was a capitalised role with no introduction. | c6_broker (title "The Import Broker") | `c6_broker`. |
| 68 | cold read | Ch6 · 6.06 · Fenna has drained the old marsh … | “Where the marsh was, white flowers open at dusk.” → “Fenna has drained the old marsh meadow by the river. Where the marsh was, white flowers open at dusk.” | The change from marsh to garden was never shown. | node `river_meadow_drain` | `c6_garden`: one opening clause. |
| 69 | cold read | Ch6 · 6.32 · The whole village waits on the … | “Fenna's sister counts ninety-one. Her brother counts ninety-two.” → “Fenna's little sister counts the steps: ninety-one. Her little brother counts ninety-two.” | The siblings and what they counted were unclear. | E-6.B20; world/00-timeline.md (younger siblings) | E-6.B20. |
| 70 | cold read | Ch6 · 6.41 · An alpaca stands at the gate, … | “The row of five animals has a space at the end, and has not known how to stop leaving it.” → “At dusk the five animals stand in a row by the gate, as they do, with a space at the end that they have not known how to stop leaving.” | No row had been set up. | E-3.H65, E-6.H55 | E-6.H55. |
| 71 | cold read | Ch6 · 6.48 · Night. In the garden where the … | ““At the Fair I said I wasn't alone. It was you.” → ““At the Fair I wouldn't say who I was with. It was you.” | She did not say "I wasn't alone" at the Fair; she said "I'm not going to say. Not here." | telling.md §4.2 P3 against §5.3 P3 | E-6.B28 page 3: match page 3 of the Fair half. |
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


## 5. Status of every item in Appendices A and B

| Item | Status |
|---|---|
| A1 | **Fixed** (#1). |
| A2 | resolved in source: the garden telling ends on the sentence she cannot finish ("I never … I wasn't …", 6.48), so the request through Minena (F6) is set up. The retelling's "It wasn't hers to say" is not in the material |
| A3 | resolved in source: the retelling's "belongs to a different story" is not in the material; F6 keeps the shipped line ("she dreams of a melody, and in the morning she hums it") |
| A4 | **Fixed** (#6). |
| A5 | **Fixed** (#12). Why each left stays a question, answered for the badger in ch5 (torn page) |
| A6 | **Fixed** (#2, #4). "You lived here" is told once, by the well notch (1.47), as slice 01 requires. The family left after the fire (Otto, 2.33) |
| A7 | resolved in source: no "seven years" in the material; the ages carry it (fifteen in the box, "a girl, eight" in Quill's report, 5.02). Game time is never counted (D11) |
| A8 | resolved in source: the grain is sown and multiplies (1.37) and is explained by the bunny (1.73) |
| A9 | resolved in source: no hearthstones in the material. The white stones that answer the hum recur (1.04, 2.08, 5.13, F6) |
| A10 | resolved in source: two motifs, kept apart in the text. Field rocks and sticks are Mumyo's piles (1.13, 1.40); the flat grey river stones are "not from here" (1.22) and lead to Liv (3.54, 6.32 with fix #49) |
| A11 | resolved in source: bells = the bell-ringer; the buckets at the post = Maud (1.21 → 1.44, the tin leaf); the bucket by the fire = Fenna's habit (1.10); the stones = the grey visitor. See B1 for the corner buckets |
| A12 | **Fixed** (#13). |
| A13 | **Fixed** (#13). "Your brother asks about the horse" is not in the material |
| A14 | **Fixed** (#14). |
| A15 | resolved in source: no farm name is crossed off in the material |
| A16 | **Fixed** (#15). The double mark is explained in 2.21 (one mark for the loaf, one for the name). "Gives again" stays a question (protected) |
| A17 | **Fixed** (#16, #19). |
| A18 | resolved in source: "practically immortal" is not in the text. Lark's oddness is consistent and nameable (appears, vanishes, sorts by weight, answers with jokes). Magic is established from the first night (1.04) |
| A19 | **Fixed** (#40). |
| A20 | resolved in source: Quill's report names "a witness, twelve" (5.02) and Liv says what she saw (6.37); the link is visible and is the question "who is the witness?" until ch6 |
| A21 | resolved in source: every Helper is preceded by its signs (prints and hutch; seat and shell house; nibbled list and bramble; hoofprints and blanket; the swept still-room; the long note). The reader learns the pattern by seeing it |
| A22 | **Fixed** (#26). |
| A23 | resolved in source: "so that nobody pays on an empty stomach" (3.14) |
| A24 | **Fixed** (#46). resolved in source for the stool ("so that the man who comes to take can sit while he does it", 3.14); fix #46 for the Fair table (laid for Moonedge). The stool "for no one" stays a question |
| A25 | resolved in source: the line returns in the lease (4.20) and in Pieter's mercy (5.25) |
| A26 | resolved in source: Rosa hears Fenna hum and plays it all night (3.49); Greenstem has it (5.14); the village hums it (6.34). Where it really comes from stays a question (protected) |
| A27 | resolved in source: "Fenna does not remember drawing it" and the two prints, a hand and a thumb (3.24). The open question is what happened between them (protected) |
| A28 | **Fixed** (#31, #32, #33). |
| A29 | **Fixed** (#49). |
| A30 | Resolved in source: the retelling's sentence is not in the material. Fix #34 makes the corner buckets Fenna's habit, shown by action. |
| A31 | **Fixed** (#29). |
| A32 | **Fixed** (#30). |
| A33 | resolved in source: the letter under the hat is Mei's (3.61); the round hand is Liv's (4.28, 5.07); the visit comes at the Fair (6.32) |
| A34 | resolved in source: "Goats lie" is on the goat's page (4.38) and paid by the counted hen (4.11) and Jan (2.30) |
| A35 | resolved in source: the frame itself asks "What's an imp?" "That comes later!" (F3), a nameable question |
| A36 | **Fixed** (#35). |
| A37 | resolved in source: no name board in the material |
| A38 | resolved in source: the jar goes on the long voyage (4.27) and comes back with Liv's note (4.28) |
| A39 | resolved in source: "carriage on request", the old lease (4.47); his relief is shown, not explained (a question about Quill) |
| A40 | **Fixed** (#10). resolved in source: the town wall and the Watch Walk are set out in 4.42 |
| A41 | resolved in source: the light over the marsh returns (5.37, the lamp-maker) and the marsh becomes the night garden (6.06) |
| A42 | **Fixed** (#29). Anchor: even the Lord's share goes down the river; the Count stays unnamed. |
| A43 | resolved in source: her fear is shown by action (the grey coat goes below deck when it hears Fenna, 4.07) |
| A44 | **Fixed** (#41). |
| A45 | **Fixed** (#40). |
| A46 | **Fixed** (#4). |
| A47 | resolved in source: he is looking for "the lease's twin" and tells her because he does not like what the report counts (5.02) |
| A48 | resolved in source: white flowers and two soft rings (5.29, 5.34), the same as the bell-ringer's rings (1.74) and the night garden (6.06). Who leaves them is a nameable question |
| A49 | kept as a nameable question: the white spiral (5.18) is the conch, deepest layer, never in any text (bible §2). Logged in open-questions G3 |
| A50 | **Fixed** (#39). |
| A51 | resolved in source: "The Book says a third … a quarter and no more" (5.25). "Cough week" is not in the text |
| A52 | **Fixed** (#43). |
| A53 | resolved in source: the Pot is introduced in 1.50 |
| A54 | resolved in source: 6.30–6.31 tell both in full ("per B." under "Rest the field", the names before plates) |
| A55 | **Fixed** (#5). |
| A56 | **Fixed** (#49). |
| A57 | **Fixed** (#46). |
| A58 | **Fixed** (#47, #48). |
| A59 | resolved in source and in D-B3: the Ballad's child is the little one who ran out (2.15 rhyme; 6.36). Why the village made her a hero who shouted "the lights!" is the open 02-19 question |
| A60 | resolved in source: the village wipes it after the telling, on its own word and at its own risk (6.39). What "gives again" means stays a question (protected) |
| A61 | **Fixed** (#50). |
| A62 | **Fixed** (#51). |
| A63 | **Fixed** (#41). Line 5 now returns, so "whole" is earned; every line has come back one per Helper before. |
| A64 | **Fixed** (#45). |
| A65 | kept: a Lark question ("Why does a place laid for him undo him?"). His want (to be asked to stay) is bible-only; logged as G4 |
| A66 | **Fixed** (#52). |
| A67 | resolved in source: the bucket of Minena's stones is in the room from the first page (F0.1) |
| A68 | resolved in source: the feather is in Minena's bucket from the first page (F0.1, "stones and feathers") |
| A69 | **Fixed** (#49). makes the link visible; who added them stays a soft question |
| B1 | **Fixed** (#7 the dry well; #34 the corner buckets are Fenna's). Resolved in source: one bucket, hers since childhood (1.02 "smaller than she remembers"; Greenstem 2.09; the tortoise page 3.10); Berit's rule sets up the empty bucket (1.14 "Fill it at dusk, not at dawn"); Bucket Night's buckets are Maud's (1.44) and the village's (3.54) |
| B2 | **Fixed** (#22, #23, #24). decided from canon (D-B2): she remembers; she avoids; she does not know whose hands |
| B3 | **Fixed** (#27). decided from canon (D-B3), one part open (why "lightning", 02-19) |
| B4 | **Fixed** (#36, #51). resolved in source otherwise (claim versus collection). The far-field link is a gap (G1) |
| B5 | resolved in source: two moments, both canon. Before the fire she warned at the barn and was moved to the far paddock (Berit's page, free play; reference R.1); on the night her alarm woke the house (6.41). No edit |
| B6 | **Fixed** (#30). |
| B7 | resolved in source: the bells do not fade; they go silent after the tidied tower (1.40) and return with meanings (1.74, 3.23, 3.49, 4.03, 5.34, 6.06, 6.48) |
| B8 | **Fixed** (#49). resolved in source: the stones are left by someone who comes off Mei's boat at dusk (3.54); fix #49 joins them to Liv |
| B9 | **Fixed** (#40). |
| B10 | resolved in source: no "took things apart" in the material |

### New items found while assembling

| Item | Problem | Status |
|---|---|---|
| A-new-1 | "Berit" named before she is linked to the grandmother | **Fixed** (#3) |
| A-new-2 | Pieter named (2.38) before his introduction (3.12) | **Fixed** (#21) |
| A-new-3 | "the twins" with no link to Lotte and Linus | **Fixed** (#8) |
| A-new-4 | Appleby's trade and Anna unintroduced | **Fixed** (#17, #18) |
| A-new-5 | Longnight and the Hall unintroduced | **Fixed** (#9) |
| A-new-6 | the Hop unintroduced | **Fixed** (#11) |
| A-new-7 | the Book, Tally, Mayor Juno, Ferdinand, the Harvest Fair, Lil Thunder unintroduced | **Fixed** (#37, #38, #42, #44, #48) |
| A-new-8 | the Nest unintroduced | **Fixed** (#28) |
| A-new-9 | the Hurst and the Keepers unintroduced | **Fixed** (#10, #25; the Keepers is proposed material, P6) |
| A-new-10 | one hook or two? The empty hook on the old doorframe (1.20) and the hook found in the new frame (2.47); the master says the hook was "found inside" | **Fixed** (#23) for the text; the master's phrase contradicts the bible → open-questions C1 |
| A-new-11 | roof: tiles (shipped) against thatch (seeds) | **Fixed** (#20) |
| A-new-12 | rhyme line 5 never returns in any text | **Fixed** (#41) |
| B-new-1 | master ch2 merges "It started low" (E-2.B05) into the skipping rhyme before the barn is cleared | order fixed in assembly (2.45); open-questions O2 |
| B-new-2 | `c6_free_family` (Liv: "I should have said it differently") against Liv's outline arc | left out (free play); open-questions C3 |
| B-new-3 | the Fenna who "does not remember drawing it" (3.24) can still read as forgetting | kept (seed wording; consistent with canon's doubt "not sure he was real"); noted in D-B2 |

