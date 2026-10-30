# Text-change requests (one list, 24 Oct 2026)

Merged from slices 01, 02, 03, 04, 06 and 07 and the master outline. **Nobody has edited `texts/` or `staging/`.** This is a list for the parent and for the game agents; each row is a piece id, the problem, and a direction (all page texts are *sketch*, never final). The parent's answer 00-1 says nothing is fixed: the story matters more than the provisional prototype material, so these requests are open to be accepted. The source column says which slice asked (01, 02, 03, 04, 06, 07, M = the master outline). Ordered by chapter and piece. 💡 until accepted.

| # | Piece | Problem | Direction | From |
|---|---|---|---|---|
| **Frame 0 and chapter 1** | | | | |
| 1 | `c1_frame0` p1 | no relation word; no pot, book, bucket | "your grandchildren"; Minena brings tea in a small tin pot with a bent handle; a thin brown book on the blanket; a dented bucket of stones and feathers by the bed | 01 |
| 2 | `c1_frame0` p2 | never names the farm; no order rule | the old you answers "Moonedge"; the others enforce "in order". Parent's answer 01-5: one "Please, {player}" is **accepted** (slice 01 had removed it; re-add if wanted) | 01 |
| 3 | `c1_frame0` p3 | ends on "with ash"; no hum | "I never start with the fire. I start with the ash. I had borrowed a tent. It smelled of horse." plus the hum ("You're humming." "Am I?"); keep "not sure you remember it right"; at most 54 words; no age here | 01 |
| 4 | `c1_stalk` (title, p1) | says nothing of place or time | "Moonedge, long ago." First line "Moonedge. Early spring. The tent smells of horse."; a picture `c1_stalk_p1` | 01 |
| 5 | `welcome.gd` (UI strings lines 75, 77) | the bucket and pot listed as loose things; all three objects are in the box | "In the tent is the box your grandmother left. Open it, and your seed can grow." | 01 |
| 6 | new `c1_box` | the box is never a scene | one page, no days, Berit's note with the age ("fifteen") | 01 |
| 7 | `c1_book` p2, `c1_night` | "an old tune" / "a tune you do not know" | "Berit's kitchen song comes back, and a line of words"; "the tune that has followed you all week is coming from those stones", plus the stillness image (the awe) | 01, 06 |
| 8 | `c1_first_card` | fires at step 0 with the book | add `seen:c1_night` | 01 |
| 9 | `c1_bells` | trigger on an optional node | `done:clear_weeds`, priority 90; "When the last weed is out" | 01 |
| 10 | `c1_k_bell` | rings during the felt silence | retire; fold into the hall-bell pool | 01 |
| 11 | `c1_ledger` | numbers only | header MOONEDGE; a row of sacks (a tenth, a fifth, a third, a half; the last circled twice); burnt along one edge "where another column had been"; **sacks, never percentages** | 01, 07 |
| 12 | `c1_seller` | on the square; nameless; two names | on the track by your field; "I'll tell all of Hazelwood"; "when the road is dry"; name Rue only on her second visit | 01 |
| 13 | `c1_coin` | anonymous face; may fire before the ledger | WEXLEY on the rim; trigger `seen:coins + seen:c1_ledger` | 01 |
| 14 | `c1_fire` | funniest fire is also a fire-fearing child's | keep three sparks; end on the bucket by the fire; add the half-roll after the bucket | 01, 03 |
| 15 | `c1_maud`, `c1_tom`, `c1_ella` | thanks without an ask; Berit named, not planned | hat recognition, "She raised you on that hill"; new asks; every thanks gets `seen:<ask>` | 01 |
| 16 | `c1_trips20`, `c1_tower`, `c1_well2` | stool has no owner; tower relies on picture; well is a pure reward | Maud's stool ("My knees"); add "goes out like a candle. The quiet stays."; the old stones, the notch, the crate (this was your home) | 01 |
| 17 | `c1_summer`, `c1_autumn`, `c1_winter`, `c1_spring2`, `c1_coop` | W lulls in a row; "first" counts time (D11) | summer G(+W), autumn G; drop "first"/"again"; the coop ends on a joke | 01 |
| 18 | `c1_bunny` p3 | the rhyme looks like one line | "There are more lines. You say it over, and wait."; she eats standing, one eye on the sky | 01, 03 |
| 19 | `c1_frame1` | no hum | the old you hums; Minena puts a hand on the arm | 01 |
| 20 | `c1_bell_out` picture | "a spark at the edge" | a glint of a very small bell | 06 |
| **Chapter 2** | | | | |
| 21 | `c2_letter` | "Come home before the frost" sets a date (C1); no family voice; Mei "rows on" though the farm is not on the water | no deadline; keep "The house is small. The table is long." and "Your cousin asks after you."; the mother's real sentences in brackets, signed "-M."; the father speaks through Cobble the horse, a tent, a lantern (parent's answer 04-34: mother accepted; **father open**, see QUESTIONS); Mei "goes back down to her boat"; add Jan (E-2.L01); drop "before the frost" (✅ 07-45) | 01, 02, 04, 07 |
| 22 | `c2_lark` | no page for the list joke | add a page (E-2.M09): her own list read like a stern letter | 06 |
| 23 | `c2_tortoise` p2 | assumes the pond; plain waiting | require `pond` (✅ 00-4c); the bucket loop in p2; the stone she sits on is from the dry pond | 03 |
| **Chapter 3** | | | | |
| 24 | `c3_letter` | | add "(She asks every week. -M.)"; keep "To you it sounds like a warning." | 04 |
| 25 | `c3_stream` | the miller's apology is free | add the second sentence of E-3.R08 (success is taxed) | 07 |
| 26 | `c3_goat` | the deed is thistles (C13) | the deed is the bramble bed on the scrub (data wish) | 03 |
| 27 | `c3_goat_out` | the hat letter has no sender (C19) | Mei's note, through the gate; the goat at the scarecrow's feet "with a funeral face"; the hat is Berit's | 03, 04 |
| 28 | `c3_bell` p2 | "You look the other way" | keep, at most once per chapter | 06 |
| **Chapter 4** | | | | |
| 29 | `c4_lease` | only the half | add the Table line at the foot: "and never so much that the table is bare" | 07 |
| 30 | `c4_pony` p1 | the tail is not mentioned | add the tail (high), keep "both seen" | 03 |
| 31 | `c4_count`, `c4_quill_out` | | none (the paper boat is Mumyo's; E-4.R13 lands before `c4_quill_out`) | 03, 07 |
| **Chapter 5** | | | | |
| 32 | `c5_badger` | "He sets out two cups" | the first cup he sets before you is the smaller one | 03 |
| 33 | `c5_page` | fragile; no cousin | the finger-count line with Tilda (B17); whichever trigger the engine tidy chooses | 04 |
| 34 | `c5_collapse` | | one line, "The bucket's empty."; Wren fills it | 04 |
| 35 | `c5_conch` | "Some things are for later." | no second clause | 06 |
| 36 | `c5_letter` | the boy is dry; order inverted with `c6_lord` | the boy: "A bush," and does not explain; the seal comes after the letter flow (see 40) | 03, 07 |
| **Chapter 6** | | | | |
| 37 | `c6_alpaca` | only the hum | add a third page: the row of five is a row of six | 03 |
| 38 | `c6_broker` | "a very familiar face" | add the cheese-and-the-rest page (E-6.M24): the face is Lark's | 06 |
| 39 | `c6_garden` / `c6_free_garden` | the light; "You open your mouth…" reads wrongly after eight pages of speech | picture: thimbles in a ring, tin leaves on a thorn; one line, the alpaca has stopped behind you facing out; she sets the bowl down and says nothing because she has already spoken | 03, 04, 06 |
| 40 | `c6_lord` | fires before `c5_letter` and `c5_frame5`; no sign who wrote it | `when` `seen:c5_frame5`; "the seal is red, the writing on the cover is grey"; "From the next Share Day, a half. Quill will count when the tables are full." | 07 |
| 41 | `c6_fair_letter` | no bracket | "(He means: he is coming. -M.)" | 04 |
| 42 | `c6_crisis` | fires on `done:d_fair_cloth` | gains `seen:` the Players beat (E-6.B21); keep Liv's shipped lines; she holds a stone | 04 |
| 43 | `c6_bend` | two pages, the telling offstage; Liv says "Nobody believed me either" (she never told) | **seven pages, an exchange**; Liv: **"I saw the lights too. I never told anyone."** (accepted 04-31); add the mother's plain sentence "You were a child." (accepted 04-28; the farmer does not answer); the farmer's words as parent's answer 04-33 (a speech ladder before, long only in the telling) | 04 |
| 44 | `c6_quill_answer` | can precede the Fair and the bend; the chalk is not lifted | `when` `done:farmhouse_sunroom + seen:c6_bend + after:c6_bend:3`; "and the chalk comes off the loaves"; the seal is crooked; a second sheet "Hook outside, hay inside. For every barn in the valley. -W."; add the ruled line "Corrected." (E-6.B24) | 04, 07 |
| 45 | `c6_supper` | near the 54-word cap | keep p1; add pages for the lantern/snuffer/bucket (B26, with H08 merged: the lantern is hung on the hook outside), Tilda's hand (B27), the song and the spoons (M29: "You know the song", tune = Berit's kitchen song, answer 03-15), the six in a row (H55) | 03, 04, 06 |
| 46 | `c6_ajar` | "It is not time yet" | **replaced** by the garden telling (E-6.B28, "Mumyo" alone on a page; name flag in `QUESTIONS.md`) | 04 |
| 47 | `c6_frame6` | "all of it" | "Tonight I'll start with the fire."; the name; the funny beat (she falls asleep mid-sentence, 04-36); the request unchanged; the glowing stones picture; the white flower on the sill; Minena may hum the true last phrase (queued) | 04, 06 |
| 48 | frames 2 to 5 | | picture keepsakes only (stones in the bucket) | 04 |
| **Village and staged pieces** | | | | |
| 49 | `sq_chapel_roof` | a chapel (no religion ✅) | "Fix the Hall roof" (data string) | 02 |
| 50 | `c6_free_miller` | "sails" vs a wheel mill | none if the mill has both (atlas; parent answer 02-21 OK) | 02 |
| 51 | staged A-tags (nine) | too many awe pieces | re-tag W: `c2_honey`, `c3_sails`, `c4_glass`, `c5_petals`, `c6_dye`, `c6_telescope`, `c6_eve`; G: `c2_pond`; `c4_watch` stays A (the Wall) | 06 |
| 52 | slice-02 seeds E-3.L03, E-3.L06, E-6.L04 | keyed to `lord_paid` / after the paper | `lord_shares>=3`; `lord_shares>=4 + season:autumn`; `seen:c6_bend + after:c6_bend:3` | 07 |
| 53 | `c4_pony`, H41 / H30 | gag seeds that presume how claim and collection split | H41 lands between `c4_pony` and `c4_quill_out` (E-4.R13); H30 is E-6.R25 (parent 03-16: keep both) | 03, 07 |
| 54 | E-5.B15 (Quill's report) | clashes with "Quill absent in chapter 5" | plays at the very start of chapter 5 as his last scene before the Fair | M |
| 55 | E-6.H45 | id in ch6, trigger in ch5 | placed in chapter 5 (the badger's first scene) | M |
