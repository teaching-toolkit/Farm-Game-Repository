# Review of slice 07: the Lord, the lease, the ecology and the clock

Reviewer, fresh eye, 23 Oct 2026. Read: charter, DECISIONS, digest (dossier, node map), the whole slice (dossier, accounts, people), ticket 07, `rules/53-lord.json`, `51-trust.json`, `chapters.json`, `systems/lord.gd`, `trade.gd`, `pace.gd`, the node data (barter, costs, `assumed()` inputs), the shipped pieces (c1_ledger, c2_letter, c2_cottage, c3_*, c4_*, c5_*, c6_*, all frames), `world/lease-and-collapse.md`, `characters/hazelwood-people.md`, slices 01 to 04 and 06 where they touch the Lord, reviews 01 to 03, and the live-wire-style files (SKILL, diagnose, structure, character). Nothing but this file was written. No git writes.

---

## 1. Verdict in five lines

1. **The people and the images are excellent; the clock is not yet a clock.** A man with a drawer, a puddle on his road, a cork Pieter pulls with his teeth, "Too sweet. Send another." and a Fair that answers a claim with a table are things a child will repeat. What the slice calls the clock is a ratchet plus a rhythm (a lantern every season), with no date and, as the engine really behaves, hardly a felt rise after chapter 4.
2. **The load-bearing "Hold" (late means barter for eggs) does not exist in the game.** Every barter recipe costs coins as well, so the Lord's block stops barter, seed buying and the 82 coin-cost builds alike. E-3.R04, §6.2, cost 2 and barks B2/B3 promise a mechanism the child cannot find. The JSON note the author calls inconsistent (T-F) is in fact correct; that "trap" is a misreading.
3. **The ladder (10/20/33/50) is real in the data but, by the data's own tuning note, the quarter-of-the-till cap takes over from chapter 5.** The child pays about 6, 19, 25, 25 per cent of a season's sales; the third and the half are only words, and Pieter's "secret mercy" is placed in chapter 3, where the cap does not yet bind. The Fair's relief (the eased tenth) is probably felt as a halving, not a rescue.
4. **The villain is child-readable only half-way:** the Lord's defining irony (he never opened the middle of his letters, which offered patience) is bible-only and never reaches the player; his link to the fire (the lantern order, slice 04) is absent from the resolution. Quill, meanwhile, is a cold pressure in the labels and a warm mystery in the seeds: nine of his fifteen steps pile into chapter 4.
5. **Fixable inside the slice without the parent.** One cheap rewrite of the Hold, a move of the mercy to chapter 5, one line that shows the drawer, a pruned chapter 4 (27 seeds to about 21), the Table carried by something on the critical path, and a handful of re-keys. Then it is a strong thread; do not rewrite it.

---

## 2. What holds (and must not be lost)

- **The Lord as "the man who did not open his post" (when it is shown).** An eight-year-old knows the letter you leave in a drawer because you are scared of it; it rhymes with 03's through-line (the warning nobody read) and with the farmer's own folded letters. It makes him a person and keeps frame 4 ("He was afraid. That's worse, sometimes.") true. Must not be lost; it needs one line to reach the player (F4).
- **The Table.** "Never so much that the table is bare" is the best single device in the slice: a child understands a table, the ancestor of the cap, Pieter's mercy, the mother's "the table is long", the Open Bowl and the Fair. "The farm does not argue the claim, it lays a table and Quill counts the plates by name" is a real answer to a ledger. It needs a safer carrier (F5).
- **The Hurst ladder** (gong once, no hounds, a puddle on the Mile, the boy with the seal running, a cold chimney). This is the best "bite" in the slice: a villain a child watches *shrinking*. E-4.R19 (the village standing round a puddle like a visitor) is the best seed here. Keep all of it.
- **Colours before columns:** red for the Lord, grey for the one above, pencil for Quill's own. A child follows colours when it cannot follow money. The Grey Breath turning into a block of grey salt that everyone licks is exactly the right size of answer.
- **E-3.R08 the thank-you tax** (success is taxed, in the miller's mouth), **E-4.R12** ("fallow, per B."; a dead woman's word enters the Lord's Book), **E-5.R19** (Pieter holds the lantern for Wren's throat), **E-6.R25** (the goat eats the letter, "I did not write it"), **E-6.R26** (no collector crosses a laid table), **E-6.R27** (names before plates), **E-6.R29's cork** (Pieter with his teeth), **E-6.R31**, **E-4.R22** (the paper boat, the pencil that survives). Each is a want meeting an obstacle with a changed state.
- **No fail state is honoured.** Nothing in the slice punishes the child; lateness has a warm face. (The engine's real lateness block is wider than the slice thinks: see F1.)
- **The ending's refusal of tidy justice** (a tenth stays, the Lord keeps his debt, the Mark's years are not refunded, the Count is shown a better sum rather than defeated). It keeps one cost, as structure.md §13 asks.
- **Honest self-flagging.** T-A, T-B, T-C, T-D and the cap suspicion (T-H) are real and well found. The "traps" table is the most useful thing in the slice for 08a.

---

## 3. The diagnose lens, question by question

**(1) Bite and the two clocks.** Pass 1: the thread has wants and obstacles; the spine drives some failures (R06 pays too much, R07 hides the barn, R24 folds the letters). Pass 2 bottleneck: **"does the reader want to know what happens next?"** is the thinnest, and the cause sits upstream. The Lord's *rung* rises four times but is announced once (shipped `c6_lord`); the mid-rungs (a fifth, a third) have no story piece and, with the cap, no change the child feels. A season-end lantern is a rhythm, not a deadline; by the second visit it is furniture. What really makes a child lean forward is **mystery tension** (Quill's pencil column, the grey wax, "Q.", the grey cover) and **dread of the cousin's arrival** (the mother's and Liv's letters: "your cousin asks after you" is the best clock in the book). The slice reads the family letters as a clock that *falls* (asks get smaller). From the farmer's side each softer ask is *nearer* and 04 rules that she misreads them as warnings until the Fair. So the two clocks are distinct in colour (good) but the second one is mis-described: it is a dread that rises under a surface that softens. Fix in F8 (R24 and 04's misreading rule) and F2 (a felt rung). The Fair, which the slice makes the answer, has no stake in-fiction (nothing says the Hurst *counts* there). One clause in `c6_lord` ("Quill will count when the tables are full") would turn the Fair into the count day without a date.

**(2) Villain and abstraction.** The Lord is not a cartoon: a seal, a coin face, a drawer, a gong rung once. The Count is a colour (grey) and a salt block: nice, but the *stakes of his number* never reach the child. "Afraid of what?" "Of a number" (frame 4) is answered by "somebody grey wants it", not by what happens if he cannot pay. The Hurst ladder shows the cost to the Lord; nothing shows what the number is *for* (bread in twelve valleys is bible-only). The child needs one concrete image of the number's weight; see F4. The abstraction of **columns** is the weakest part: Taken (red), Held (grey line, "carried down"), Given back (pencil, then ink). "Held" is not child-readable (what is held, by whom?). The player can follow red, pencil and "a grey line at the foot of every page that says carried down"; call the middle one "carried down" only and keep "Held" in the bible. The **Table line** and the **third column as "what the farm gave back"** are comprehensible. The **claim vs collection** distinction (a half in the lease, a fifth in the purse) is never explained to the child, which is right (never explain it), but nothing else carries it: they will believe the Lord lied about the number. Acceptable if the child blames the Book, not Pieter.

**(3) Quill's 15 steps.** An arc a child can follow (cold, a crack, a joke, a flag, ink in public, a smile) but too many of them are in the same 196-step chapter. Q1 to Q9 are all chapter 4; chapter 4 also carries shipped `c4_quill`, `c4_count`, `c4_lease`, `c4_no`, `c4_quill_out`, 04's B14/B16, 02's L01/L02/L03/L11/L12, 03's H25/H52 and 07's R10, R11, R12, R13, R14, R17, R22. Reading that strip, Quill is warm from R11 on and the "pressure" (people.md: "a child must feel: he found the glasshouse; now they'll tax the glasshouse") appears in **no seed**: cost 6 has no scene, and in the engine the glasshouse (patches) is counted but the farmhouse and the sails (`windmill_1`, a building) are not. The 03 review asked that Quill stay a pressure; the labels say so, the seeds do not. Also "Q." (R11) is a clue that is never decoded for the child (people.md: "never told"), a plant with no payoff; and R22 shows ink *running* in the pond while R29 asks ink to mean *permanent*; the child just saw ink fail (F9).

**(4) Engine realism.** See section 6. Short form: the 10/20/33/50 ladder and the cap are correctly read; the slice misses that barter is coin-bound, that the lease can be found as late as chapter 6, that the badger's cost eats the tea set, and that "late" (`lord_owed>=1`) is a window of a few steps for a child who pays at once.

**(5) Charge audit** in section 7. Short form: tension is a hump in chapter 4, thin in chapters 3 and 5, and mostly G to W in chapter 6 where the half arrives; no register triple if the moves in §10 are made, but chapter 3 is five G-led seeds.

**(6) Ecology chain.** The six-row table (Rest, Return, Ask; "what the player teaches back") is a clean design and teaches without lecturing *where it has a seed*: R12 (fallow), R14 (rested rows), R20 (leave two), R27 (names). Rows 1 to 3 (clover, compost, stumps, pond) have **no seeds in this slice**; "Jan says nothing, warmly" is a hope, not a seed. R14 asserts the rested rows are fuller, which the game only makes true if the child rested the field (rotation: tired -15 %, rested +10 %). "Teaching back" is the freshest idea (R12: the steward learns a word from a dead woman's margin; R20: you hear Wren in your mouth). It does lecture in two places that must stay out of text: R25's "paper does not change the number; it only carries it" (adult aphorism) and the three-rule gloss "Rest, Return, Ask" (architect shorthand; never say it).

**(7) Consistency.** Locked facts hold (Wexley; steward in chapter 4; hidden truth untouched; the Fair as answer; Count never named). Two D11 leaks: E-2.R03 ("you have been giving all year") and Q15 ("rides down the river once a year"; soft). Contradictions with 04 listed in section 8, the most important being that the Lord's **lantern order** never appears in his resolution, and that R24 ends the farmer's misreading of the letters before the Fair, which 04 forbids.

**(8) Over-reach.** Into 05: Quill's 15-step arc is pre-written (05 not yet authored), Pieter × Wren (R19), Greenstem/Wren in R18/R20, Tally's last moon. Into 04: R01 (the reply letter), R05 (Mei, the cousin's answer, a branching choice), R24 (the whole letter ladder), the "corrected line" (handed over, but the post-bend strip omits it). None is fatal; list in section 9.

**(9) Six-year-old listener.** Land: Rue "not allowed to *see* eggs", "hedge with a door", the thank-you tax, a puddle visited like a guest, Pieter's teeth on the cork, the grey salt licked, "Too sweet. Send another." Fail (for the six, fine for the eight): "columns", "carried down", the Q-flourish, "his pencil column is longer than the ink one", the grey cover colour-reading (R23), "paper does not change the number". The eight-year-old can follow all of it except claim vs collection.

**(10) Excellent, do not lose:** section 2.

---

## 4. Ranked fixes

Format: symptom; upstream cause; concrete change; who.

### F1. The Hold does not exist (high; build before anything else)
- **Symptom.** E-3.R04 ("Eggs, I'll take eggs"), §6.2, cost 2, barks B2/B3 and the dossier's promise that "late costs a funny kindness, not a punishment" rest on barter that bypasses the coin block.
- **Upstream cause.** `trade.barter` and `barter_gate` run through `pace.pay(cost)`, and `missing_cost` adds a `lord` entry whenever the cost has coins above 0. The only barter recipes in the data are `culture_1` (225 or 450 coins plus milk), `import_broker` (225 to 900 coins plus a dish) and the gate merchant's axle (900 coins plus baskets). There is no barter at the seed merchant. `buy_seeds` and `buy_item` both refuse with "The Lord's share first: pay Pieter at the gate." And 82 of 467 nodes (42 buildings, 16 stations, 13 books, 7 land, ...) cost coins, so a house that owes cannot build either. Selling, making from stock, farming and trips do go on, so nobody is stuck; but "eggs buy seed" is not in the game. The author's T-F is wrong: the JSON note says "(selling, making, farming, trips and barter go on)", which lists what *continues*, and `lord.gd` agrees. The note's "barter go on" is the only soft spot (true only for a zero-coin barter, which none is).
- **Change.** Reword the Hold to what the game does. Rue (and every trader) turns the cart round while the lantern stands: "Pay the man first. I'll wait. I'm good at waiting." The funny kindness is Rue's waiting, the egg joke as a joke ("I could see an egg, if you had one to sell me", you *sell* eggs, which always works), and Pieter, who has plainly walked the long way round. Drop "the lease forbids coin to leave a house that owes" (the engine's rule is only buying). Delete data wish D-3. Optional data wish for the manager (D-8): a zero-coin barter at one seed merchant (eggs for onions) if the parent wants the Hold to exist; otherwise leave it out.
- **Who.** Author (reword E-3.R04, §6.2, cost 2, B2/B3); manager (D-8); 08a (check the Pay popup text).

### F2. The ladder is not felt; the mercy is in the wrong chapter (high)
- **Symptom.** The child is told the Lord asks more each time; the wallet says 6, about 19, then a flat quarter. Pieter's "the lesser of the book and a quarter of the till" is scripted for chapter 3 (R06, `lord_shares>=3 + chapter:3`).
- **Upstream cause.** From `lord.gd`: `due = min(share, max(200, 0.25 x sales))`. The JSON tuning note gives the share as about 6 % of sales in chapter 3 and about 19 % in chapter 4. Doubling the fraction gave a 3.2-fold rise in sales share, so `assumed` is growing faster than sales; going on to 0.33 gives at least 31 % in chapter 5, above 25. The cap therefore binds in chapters 5 and 6 (T-H calls it "probable"; by the note's own numbers it is near-certain), and in chapter 3 it does not: the book's figure *is* what Pieter takes. Also: the floor is 200 bronze, so in a quiet season the cap is 200, not a quarter; "never more than a quarter" is false below that. And the eased tenth is a tenth of a *bigger* assumed value, so the Fair's relief is probably 25 % to somewhere near a seventh of sales, about a halving, not "back to the old days".
- **Change.** (a) Move the mercy beat to chapter 5, merged with E-5.R19 (Pieter at the lantern for Wren; he will write only a quarter of the till; "don't tell the Hurst"). Chapter 3 keeps the grey "carried down" line and the apology, nothing that claims a discount. (b) Give each rise a line: one Pieter line per rung in the Pay popup (promote D-6 from wish to the main carrier) or four barks keyed to `chapter:3..6` plus `lord_shares` of the first share at the new rung. (c) Data wish D-9: `eased` also lowers `maxOfSales` (say to 0.10), and D-1 sets `eased` from `seen:c6_quill_answer` (already D-1; F-075). (d) 08a verifies with the bot the real share and cap by chapter and the eased share; extend D-7 to include the eased relief.
- **Who.** Author (move R06, merge into R19, text lines); 08a/08c (bot, data wishes D-6, D-7, D-9).

### F3. Pick one reason for the rise (medium)
- **Symptom.** "The Book counts beasts; I am sorry about the bunny" hands the child a lever (a Helper raises the rate, so delay the pony). T-G sees the incentive and answers it with a joy-tax gloss that makes it worse.
- **Upstream cause.** The engine ties the fraction to `chapter()`, which is 1 plus Helpers home; but `assumed()` counts only patches (field, orchard, glasshouse) and 29 producing nodes (kilns, forge, press, looms, cheese vat...). Beasts and pets are not in the sum. The shipped `c6_lord` gives its own reason ("Your farm prospers"). The old farm *lost* beasts as the share rose (lease file: fifth, third, half over the years the Helpers left), so "per beast" cannot be the old logic either. Two different mechanisms have been glued to one staircase.
- **Change.** One reason, the shipped one: the Hurst's Book climbs when the Hurst hears the farm is alive (smoke, bells, a pony on the square). Cut "the Book counts beasts" and "I am sorry about the bunny" as a rule; keep Pieter's apology as plain feeling. The bunny's thump at the lantern (B4) stays as a gag with no price.
- **Who.** Author (accounts §3, R06, T-G).

### F4. Show the drawer; tie the Lord to the lantern he ordered (high for the villain)
- **Symptom.** The Lord's whole defining fact, that the middle lines of the grey letters offered patience and he never read them, is bible-only. The player hears "The Lord has now read the whole of every letter. It took him a night", which only works if you already know. His resolution (a crooked seal, a pie plate) is also light against what 04 gives him: the Reeve's order put a lit lantern in every barn, the father obeyed, and the Lord ended the lease and saw to it no one took the family in.
- **Upstream cause.** The slice kept the Lord offstage and the Count unnamed, so the irony lives only in notes; it did not read 04's night account (the order) when writing the resolution.
- **Change.** (a) A single line in Quill's mouth, after the ink: "He had them all in a drawer. The last line he read. Never the middle." Place it so it chimes with R24 (the badger flattens the farmer's folded letters; she reads them all; later the Lord reads his). (b) Give the crooked-seal paper one extra act that is the Lord's only repentance-that-is-not-a-speech: **a hook-outside order** ("lanterns hang outside the barn"), the reverse of the Reeve's order, matching 04's custom and 02's "Hook outside". (c) One image for what the number is for: the grey barge carries *grain*, not just paper, so the grey salt reads as "bread said yes". A sack on the barge in the Grey Breath bark is enough.
- **Who.** Author (07 seeds), with 04 (the order, B35 "Corrected") and the manager (is the hook-outside order a ✅-adjacent invention? 💡).

### F5. The Table needs a carrier on the critical path (high)
- **Symptom.** The Table line enters play only through `c4_lease` (T-4), keyed `done:ruins_greenhouse`.
- **Upstream cause.** The node map says it outright: `ruins_greenhouse` is **not** on the pony's path; the alpaca needs `greenhouse`, which needs it, so the lease can be found as late as chapter 6, even after the Fair deliveries. R11 (Quill reads the lease, the "Q.", the eleven words) needs Quill present, so a late lease loses the scene, and R26/R27/R29 pay off a line the child may never have read.
- **Change.** Plant the Table twice more on the path: in Pieter's chapter-5 page (F2, "the lease says the table is not to be bare"), and as a margin note in Berit's book (`page:` hook). Key R11 on `seen:c4_lease + chapter:4`, and give Lark or Pieter a fallback line if the lease is found later. The Fair's "no collector crosses a laid table" (R26) then reads as an old custom.
- **Who.** Author (R11, R06/R19, a Berit note); 08a (confirm the lease timing with the bot).

### F6. Quill: restore the pressure, thin chapter 4, pay the "Q." (high)
- **Symptom.** Chapter 4 carries about 14 tension-led pieces from five slices and Quill is warm from R11. The 03 review asked that he stay a pressure.
- **Upstream cause.** The slice labels Q5 to Q9 "still a pressure" but writes no pressure seed; each Quill beat is a mystery beat or a crack.
- **Change.** (a) Merge R10 into R22: the paper boat rescue and the pencil column glimpsed in one scene. (b) Cut R14 or move it to the Fair eve (it carries `after:c4_no:45`, which can land after `c4_quill_out`, when Quill has gone). (c) Add the one pressure scene that cost 6 promises: Quill counts a new line (the glass kiln, the orchard, the cheese vat), and Pieter's next lantern comes with a number the child can feel (a Pay-popup line, F2b). "He found the glasshouse; now they'll tax the glasshouse." (d) Pay the "Q.": at R29, Quill sets a second, steadier "Q." beside the old one in the tin's lease (the village sees; the child gets it). (e) Hold the 15 steps to about 9 (Q1 arrive, Q2+Q3 boat and pencil, Q5 lease, Q6 fallow, Q7 declined, Q8 out, Q11 the letter, Q12 names, Q13 ink, Q14 the tenth, Q15 the poem).
- **Who.** Author, then 05 (Quill's village fit).

### F7. Re-key what the engine cannot fire (medium)
Listed in section 6.2. Highlights: **E-6.R24** `has:tea_set:1` (the badger's cost consumes the tea set); **E-3.R05** offers a choice the box cannot show; **R04, R05, R07, R18, R19, R26, B2, B3, B9** depend on `lord_owed>=1`, true only between a season end and the payment, so a child who pays at once never sees them; **R31** `has:apple_pie:1` (the child may hold none); **R14** timing; **R17** `chapter:4` plus `done:road_4` (road_4 is a chapter-3 job, fine) but see F6.
- **Change.** Re-key lateness seeds to `lord_shares>=n` plus `seen:` chains and write them so they work whether or not the child has already paid (Pieter holds the lantern *anyway*); drop `has:` conditions or key to a delivery (`done:d_fair_pies`); R05 picks one outcome and goes to 04.
- **Who.** Author, 08a.

### F8. Collapse the post-bend paper strip and respect 04's misreading (medium)
- **Symptom.** After `c6_bend`: R29 ink, L04 chalk wiped, 04's B35 "Corrected" (a ruled line), `c6_quill_answer`, then the alpaca: four "paper resolves" beats in a row, all Quill's. §8 does not mention B35.
- **Change.** One Quill scene on the Cloth Table: cork (G), ink (T to W), "Corrected." (the ruled line through the child), then the tenth. L04 stays separate and first. R24 must not end the farmer's misreading (04: it runs until Liv speaks): she reads the unfolded letters and still does not believe the last one.
- **Who.** Author with 04; 08b (the strip).

### F9. The ink motif contradicts itself (low, cheap)
- **Symptom.** R22 teaches that ink runs and pencil survives; R29 asks the child to feel that ink "cannot be rubbed out".
- **Change.** Keep R22 (the best of the motif). Make R29's point **witnessed and signed**: "in front of the people it is about", the cost his post, not permanence. Reword accounts §1 ("pencil = Quill's own, ink = what he is told to write" becomes "pencil = what he may be wrong about; ink = what he will stand behind in front of you").
- **Who.** Author.

### F10. A few smaller fixes
- **R03** ("you have been giving all year") is a D11 leak; remove "all year". Q15 "once a year": make it "after the harvest" or cut.
- **R01 duplicates the shipped reply** (`c2_cottage`: "I'm staying a bit longer"). Make R01 the failed drafts that *precede* the shipped line, or cut the final text.
- **R03 and 02's E-2.L02** both explain the Mark on the board in chapter 2; make them two pages of one scene, one carrier (02 owns Greenstem's explanation; 07 owns the end clause).
- **Registers tally** in §17 ("G 12, T 7, W 3, mixed 5") does not match the seed blocks: by lead letter they are G 17, T 8, W 2.
- **Canon table.** `lease-and-collapse.md` starts the old share at a fifth (Y−14), slice 01 draws four sacks including a tenth. Manager reconciles when merging.

---

## 5. Seeds to cut or merge (27 to about 21)

| Seed | Action | Why |
|---|---|---|
| E-4.R10 pencil column | **merge into E-4.R22** | one scene: boat rescued, pencil survives, column glimpsed; saves a T in the flooded chapter |
| E-4.R14 what the rested field gave | **cut, or move to the Fair eve** (fold into R27) | timing may fall after Quill rides out; claims a result the game only guarantees if the child rested the field |
| E-3.R07 a hedge with a door | **cut first** if chapter 3 is G-heavy (author already says so); or fold the hen-through-the-hedge gag into R04 | third "hide from Pieter" gag; Pieter is not a threat |
| E-3.R05 two at the gate | **cut or hand to 04** | needs a choice the engine cannot show; 04 owns Mei and the cousin; hiding gag duplicates R07 |
| E-5.R18 the still-room is a kiln | **cut** | `tea_pot` is cat `cook`, not counted by `assumed()`; chapter 5 is two seasons long; Wren and Greenstem are 05's |
| E-6.R26 no lantern at a laid table | **merge into R27** as a clause (Pieter at the table) | needs `lord_owed>=1` at the Fair; fires rarely; the custom line is lovely, keep it as one line |
| E-5.R20 leave two | **keep, first to move to free play** if chapter 5 is over budget (author already says so) | |
| E-2.R03 grey-edged paper | **keep, merge with E-2.L02** into one board scene | two seeds, one board |
| E-6.R23 grey on the cover | **make it a page of `c6_lord`**, not a seed (author already says so) | avoids a T T pair |
| Barks B3, B9 | **cut** | depend on `lord_owed` and on `has:straw:10`; marginal |

Keep: R01 (reworked), R02, R04 (reworked), R06 (moved), R08, R11, R12, R13, R17, R19-puddle, R19-lantern, R20, R22 (plus R10), R24 (re-keyed), R25, R27, R29, R30, R31, and the Hurst ladder barks.

---

## 6. Contradictions with data and files

### 6.1 The author's eight traps, audited

| Trap | Verdict | Note |
|---|---|---|
| T-A `lord_paid` is a sum | **Confirmed** | `pay()` adds the amount; `game.gd` line 608. Slice 02's E-3.L03/L06 misfire; the re-key to `lord_shares` is right |
| T-B `c6_lord` before `c5_letter` | **Confirmed** | `chapter()` = 1 + pets home (badger = 5th, so chapter 6 starts then); `c5_badger` 90, `c6_lord` 85, `c5_letter` needs `after:1` |
| T-C `c6_quill_answer` can precede the Fair | **Confirmed** | `done:farmhouse_sunroom` only; the sunroom needs `import_broker` and 5625 coins; it is not ordered against the Fair or the bend |
| T-D `eased` not wired | **Confirmed** | no `.gd` sets it; `easedFraction` is dead data |
| T-E no "late" term | **Confirmed, understated** | `lord_owed>=1` is true only from season end to payment; most children pay at once, so every late-keyed seed is rare |
| T-F JSON note vs code | **Wrong: not a trap** | the note's parenthesis lists what *goes on*; code and note agree. The real gap is that "barter goes on" is empty (F1) |
| T-G delay a Helper to delay a rung | **Confirmed**, and the "beasts" story makes it worse (F3) | |
| T-H cap binds in ch5 and ch6 | **Confirmed, stronger** | from the JSON's own 6 % / 19 % tuning note; also the floor is 200 bronze (F2) |

### 6.2 Missed traps and new findings

- **M1 Barter is coin-bound** (F1).
- **M2 The lease can be found as late as chapter 6** (node map says so; the slice's R11 and the Table depend on it; F5).
- **M3 `has:tea_set:1` after the badger** (R24): `pet_badger` cost is `healers_chest`, `tea_set`, energy; the tea set is consumed.
- **M4 What `assumed()` actually counts:** fields, orchards, glasshouse patches, and 29 producing nodes (kilns, glass kiln, forge, presses, cheese vat, fermenter, cellar, looms...). It does **not** count the farmhouse, sun room, windmill (`windmill_1` is a building), greenhouse building, barns, roads, wells, tea hearth (cat `cook`), stoves or ovens. "The Book counts anything with a chimney" is half true (kilns and the forge, yes; the farmhouse chimney, no). Cost 6 and R18 name things the number does not react to; the child cannot see the formula, so no one will notice, but 08a should not promise "the farmhouse is now charged".
- **M5 The quarter is a ceiling above 200 bronze only** (`max(floor, 25 %)`).
- **M6 `season_ended` can shrink arrears** when a quiet season's due is smaller than the cap computed from earlier seasons (`min(owed + due, 2 x due)`). Harmless; mention for 08a.
- **M7 `E-3.R05` branches**: the box has no choices (node map §3).
- **M8 E-4.R14 timing:** `after:c4_no:45` may fall after `seen:c4_pony`, and `c4_quill_out` takes Quill away.
- **M9 Chapter 5 is two season ends** (845 to 905): R18, R19 and the cap fight for two lantern visits.
- **M10 Share ranges** (ch3 1 to 7, ch4 8 to 14, ch5 15 to 16, ch6 17 to 21): checked against season length and chapter starts, they are right.

### 6.3 The ladder and cap, as asked

- **10/20/33/50:** correct in `53-lord.json` (`startChapter` 3; fraction 3: 0.10, 4: 0.20, 5: 0.33, 6: 0.50; `easedFraction` 0.10). Chapter 6 is the top because `chapter()` stops at 6 (the alpaca does not count), so there is no chapter 7 and `chapter:6` barks stay true in free play.
- **Quarter of the till:** correct as `maxOfSales` 0.25 with `floor` 200. Binds from chapter 5.
- **Arrears cap two seasons:** correct.
- **Mismatch the manager should know:** the felt rate is about 6 / 19 / 25 / 25 per cent; the eased relief at the Fair is a halving.

### 6.4 Files

- **04:** B14 (the tin holds the lantern order) and R11 (the tin holds the lease and "Q.") are one object in two slices; make it one scene or order them (R11, then B16). B16 (Quill finds a report) makes five Quill conscience beats in chapter 4. Pieter's lantern: 04 says it burns by day because of his guilt; 07 says "so people see him coming" and "sign of the Hold": both can stand (public reason, private cause); say so. 04's chapter-4 note from Liv ("Have you still got the bucket?") reads to the farmer as a threat; 07's family ladder calls it "a question" and the whole ladder "falls". Reconcile as in section 3 (1). 07's post-bend order omits B35.
- **02:** the Mark logic holds (fixed grievance; ends as a village act before Quill's paper; "two hours early"). The thin-moon shape is 07's invention and fits. R03 and E-2.L02 overlap. 02's "the Hurst's reach trimmed to the Mark and the share" is consistent.
- **03:** E-6.H30 and E-6.H41 placed (R25, R13) as T-11 says; fine. R13 puts the pony's refusal in chapter 4, which suits the 03 review's call for a real T mid-chapter.
- **01:** the sacks are the same four numbers: confirmed and right; the notch, the coin face and the ledger line up.
- **Digest/DECISIONS:** C10 satisfied in story terms; "hard clock is the Lord's share" (C1) is satisfied only as a rhythm; D11 breaches R03 and Q15.
- **Canon:** `world/lease-and-collapse.md` has the old share starting at a fifth; four-sack ladder needs the tenth added or the first sack cut.

---

## 7. Charge audit (27 seeds, by chapter, lead register, then where it sits beside slices 01 to 06)

| Ch | Seeds (lead) | Reading |
|---|---|---|
| 2 | R01 G, R02 T, R03 T | fine; R02 and R03 are separated by other pieces |
| 3 | R04 G, R05 G (to W), R06 G (to W), R07 G (to T), R08 G | **five G-led** beside the shipped dance, goat, goat_out; the only T is a flicker in R06's grey line. The Lord's thread is at its softest here. With R06 moved and R05/R07 cut, chapter 3's Lord tension rests on R04 and the bell: thin; accept, since Pieter is kind from his first line |
| 4 | R22 G, R10 T, R17 T, R11 T, R12 G, R19 G, R13 T, R14 W | **hump**: with shipped quill T, lease T, no T, quill_out T and 04's B14/B16/B19 T and 02's L11/L12 T, about 14 tension-led pieces. After the F6/§5 cuts: R22(+R10) G/T, R11 T, R12 G, R17 T, R19 G, R13 T, with c4_pizza W between |
| 5 | R18 G, R19 T to W, R20 G to W | the Lord's thread nearly vanishes where the half is about to land; F2 puts the mercy here. Do not add a T beside 04's page and 03's collapse |
| 6 | R23 T, R25 G, R24 G, R26 G, R27 G, R29 G to W, (L04 T to W, B35 W to G) | the half arrives and is answered in comedy at once; the highest-stakes chapter for the Lord is G and W. That is partly right (the cousin carries the T); but the *claim* never bites: no seed shows the half costing anyone. 02's "the half argued in the Pot" is the only cost; keep it |
| free | R30 W, R31 G | G ends the thread: correct |

**Tension line of the thread:** a pencil stroke (ch2, T) / a soft ch3 / a hump in ch4 / a thin ch5 / a high-then-comic ch6. It does not rise; it humps and relaxes. The rise has to come from the dread of the cousin (04) and from the *felt* rung (F2), not from this slice's seeds. W follows G or T in every seed; no awe is added (correct). Chapter 6 after the bend: bend W, then (R29 G to W, L04 T to W, B35 W to G, quill_answer W to G): collapse as in F8.

---

## 8. Hand-offs

| To | What |
|---|---|
| **Author of 07 (07b)** | F1 to F10; rewrite E-3.R04, move R06, merge R10 into R22, decode "Q.", the drawer line, the hook-outside order, the Table carriers, re-keys, D11 |
| **04** | One scene for the tin (B14 + R11); the lantern order and the Lord's hook-outside paper; B35 "Corrected" in the ink scene; the letter ladder as rising dread (R24 may not end the misreading); R05 (Mei and the cousin's answer) and R01's reply letter |
| **05** | Quill: the pressure scene (cost 6) and the reduced 9 steps; Pieter × Wren in R19; Pieter's lantern going dark after the tenth; Tally's last moon |
| **06** | Mumyo's hand in the boat and the gust (if R10 merges into R22, only the boat); the garden as the repaired link |
| **08a** | Bot check: share by chapter, whether the cap binds from chapter 5, eased relief, how long `lord_owed>=1` lasts, when the lease is found; the Pay popup text; D-1, D-6, D-7, D-9 |
| **08b** | Post-bend strip; chapter 4 budget; `c6_lord` clause "Quill will count when the tables are full" (T-5 extended) |
| **08c** | Data wishes: D-1 (`eased`), D-4 (a lateness term), D-6 (per-rung Pieter line), D-7 (verify), **D-8** (zero-coin egg barter, optional), **D-9** (`eased` lowers the cap); delete D-3 |
| **Manager** | Is the hook-outside paper an acceptable 💡 beside the ✅ facts? Accept "no mercy before chapter 5"; the "beasts" reason cut; canon table of the old share (fifth vs tenth); decide if the Lord's single line stays "Too sweet. Send another." (this reviewer: yes) |

---

## 9. Over-reach into 04 and 05 (what to leave)

- **Leave in 07:** the claim/collection accounts, the Mark's end clause, the three-colour code, the Hurst ladder, the Table, the Lord's person, the seeds that are pure Lord/Quill/Pieter-as-collector.
- **Hand over or trim:** R05 (04), the letter-by-letter ladder and R24's dread (04), R19's Pieter × Wren (05), R18/R20 where Greenstem and Wren speak (05), Quill's 15-step table (05 fits it; 07 owns the beats that touch the Lord's paper: R11, R13, R22, R29), the "witness of twelve" placement (04).
- The slice was right to hand the Reeve and the corrected line over; the only thing missing is to say where "Corrected." sits in the ink scene.

---

## 10. One last honest note

The slice holds up as a design; the weak point is fit with the engine, not imagination. Most of this review is the same three fixes in different clothes: say only what the game does (F1, F2, F7), show the one fact that makes the man human (F4), and let Quill be the pressure before he is the friend (F6). A single cheap bot run (08a) answers the open arithmetic. After F1 to F8 the thread is ready to merge; another full pass would not help, and a child reading the Hold, the puddle and the cork aloud would tell you more than another review.
