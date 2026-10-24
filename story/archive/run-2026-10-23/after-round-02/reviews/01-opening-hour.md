# Review of slice 01: the opening hour

Reviewer, fresh eye, 23 Oct 2026. Read: charter, DECISIONS, digest, dossier and ticket 01, `texts/ch1.md` and `more-ch1.md`, the live-wire-style files (SKILL, diagnose, structure, character), `characters/*.md`, `world/00-timeline.md`, `00-premise.md`, `story-delivery.md`, the node map, and the real code/data that opens the game (`welcome.gd`, `storybox.gd`, `10-chapter-1.json`). Nothing edited. "Author" means the ticket-01 author; "manager" the story manager.

---

## 1. Verdict in five lines

1. The slice is strong where it matters most: the seam has a real, layered answer (the three objects, the hand-over line, the hum) and the farmer's spine is carried by objects and by other people's reactions, not by announcements.
2. The seam is **over-loaded, not under-built**: frame 0 now carries about eight new facts in four pages, and the player reads about eleven pages (about 350 words) before the first action. Trim it, keep the three objects and the hand-over line first.
3. The **charge audit is not yet an audit of the hour**: the strip covers only the 25 seeds, in an intended order that disagrees with the node dependencies (ledger, bell, tower and Rue are early critical-path nodes), and it ignores about 25 kept staged pieces that are mostly W lulls. Re-run it on a step-ordered merged list before it is trusted.
4. **Bottleneck:** the middle (steps 40 to 200) has questions but no cost the child can feel. Raise one notch: make the bell-ringer's silence after the tidied tower a felt, persistent cost (a small absence bark pool, and gate the existing `c1_k_bell` bark that contradicts it).
5. Several facts the ticket asked for are thin or missing ("this was your home as a child", "the Lord" as a role, the melody as the reason you came), and a handful of triggers will misfire (comparison below). All fixable inside the slice or by cheap text and data changes; none needs the parent.

---

## 2. What holds (and must not be lost)

- **The three-objects trick** (pot, book, bucket in the frame and in the box). Object identity is the one cue a six-year-old never misses, and it pays twice later (the bucket that hauled water now carries a child's stones). Keep exactly as designed. The match cut tea/horse (frame page 4 ends on the tent's smell, the farm's first box begins with it) is the same device in words.
- **"I never start with the fire."** A perfect plant: it opens Q1, it makes the teller fallible (matches the shipped "not sure I remember it right"), and it pays at the chapter 6 telling.
- **The spine is carried by the world, not announced.** Standing to eat, Rue copying it, the bucket set beside the fire, a hen moving into the bucket, the stool she will not sit on, "Do you ever stop?". This is exactly what `fenna.md` asks for. Nobody names a feeling in any of the 25 seeds; the body does it (hands shake).
- **E-1.17, the tower taken down for the hearth.** The farmer's usefulness hurts the one who wanted her to look, and the reader knows before she does. This is the best joint of spine and plot in the hour; it is dramatic irony as `structure.md` §9 wants it. Do not trade it for a bigger event.
- **E-1.13 plus the share.** The burnt page replaying the timeline's slide (a tenth, a fifth, a third, a half) and then the new farm replaying it in the engine (10/20/33/50): the player will see the Lord's arc coming before the farmer does. Keep, subject to ticket 07.
- **Rue as the farmer's mirror** (never stops, eats standing, a place where she is expected) and "Is it the burnt farm soup?" "It's soup."
- **Berit's voice** ("Do not apologise to the bucket", "watch me") and Maud's line. Berit is felt without ever being seen.
- **The hutch, the bowl, the stool, the "more lines" ache** as a build-up to the bunny: the farmer builds for a guest before she knows she wants one. The want turns from "alone" to "for someone" inside the hour.
- **The hour's exit:** two soft rings, then the room, the hum, Minena's hand on the old arm. Ends tense, lands in the frame.
- **The honest "cheapest viable version" split** (text and titles only) and the child-test script with a pass mark. Both are what a manager needs.
- **Disclosure discipline:** the held silences list (3.2), one fact and ideally one name per box, nothing named that Mumyo, the barn or the cousin would give away.

---

## 3. Ranked fixes

Each: symptom, upstream cause, concrete change, who.

### F1. Frame 0 and the cold open are too heavy (seam, exposition)
- **Symptom.** The ladder puts facts 1 to 5 (whose bed, grandchildren, the three objects, Moonedge, fifteen, ash-first, hum, borrowed tent, horse) into one box (`c1_frame0`), against the dossier's own rule "one new fact per box, at most one new name". Names in that box: Minena and Moonedge. Before the first action the child now reads frame (4 pages), stalk (3), box (2), book (2): about eleven pages; the shipped open is six. Page 3 as designed must hold the age exchange, the closing of eyes, "not sure I remember it right", the hum and "You're humming. Am I?" inside 54 words.
- **Cause.** The author fixed all six breaks in the first box instead of spreading them over the first four.
- **Change.** Keep in frame 0: relation word, the three objects (page 1), "Moonedge" (page 2), the hand-over (page 4: borrowed tent, horse, ash). Move **"fifteen"** off the frame: let it arrive through Rue ("hardly more than a child") and the stalk or box, or put the arithmetic exchange on page 2 and drop the closing-eyes page's duplicate material. Move the hum's first appearance to the hand-over page. If a page still goes over 54 words, drop "Please, {player}" (see F8) first. Test the result by reading it aloud against the six-question script in 3.4 of the dossier.
- **Who.** Author (revise the table in §8, rows for `c1_frame0` p1 to p4); manager checks the page word counts when text is drafted.

### F2. The charge strip does not describe the hour (audit)
- **Symptom.** (a) The strip uses the 25 seeds only; about 25 kept staged pieces are left out (summer, autumn, cleared, quern, coop, spring2, well2, first_harvest, trips10, market, first_trip, and so on) and most are W lulls; unmerged, W will run three or four in a row in any real order. (b) The "intended play order" contradicts the node map. `ruins_workshop` (the ledger) needs only the campfire, `clear_weeds` (the bell, once moved) and `d_porridge` (Rue) are early critical nodes, and `clear_rocks` (the tower) sits on the path to the workbench and quern. In play, the ledger, the bell, Rue and the tower arrive in the first 40 to 60 steps, not at positions 13, 8, 9 and 17 after the favours; the coin (first sale) may come after the ledger, the reverse of the strip. The T line will therefore cluster early and sag in Acts III and IV, where the strip shows it rising. (c) The strip labels by lead register, so E-1.04 W "follows a G" only because E-1.03 is marked G while its own register line says G to W: the first hour still reads W W A (box, book, night), the exact fault the digest named ("warm, warm, warm, awe"). (d) Five seeds share one shape, joke then tender button (03, 06, 07, 11, 18, plus 10 and 22): the formula repeats.
- **Cause.** The author scheduled by feel and did not map each seed to a step range.
- **Change.** Add a table with each seed, its trigger node, and an estimated step (use the node map's dependencies: campfire, workshop, weeds, porridge, workbench, rocks, quern, coop, wells, hens, pets). Re-run the audit on that list with the kept pieces included; target: no two W lulls adjacent (convert one of summer/autumn/spring2 to a G or T variant, or space them by bark), T seeds spread, not packed into steps 5 to 60. For the opening: make E-1.03 (box) G only (Berit's dry note, the bucket, the hat) and let the tenderness sit in E-1.04, so the run is G, W, A, not W, W, A.
- **Who.** Author for the table; ticket 08a for the merged audit (hand-off).

### F3. The bottleneck: the middle has no felt cost (see §5)
- **Symptom.** Steps 40 to 200 are favours (fire, goat, basket, ghost, soup, flour): each want is met and thanked; nothing the player did hurts anyone in a way they can feel except the tower, whose silence is then unmarked for about 150 steps.
- **Cause.** The only persistent cost (Mumyo's silence) has no piece between the tidy bark and the final rings, and an existing bark (`c1_k_bell`, `step>=15 + chapter:1`) rings anyway.
- **Change.** (1) Text-change request: `c1_k_bell` must not fire after the tidy (the engine has no negation, so retime it to before the tower: tie it to `done:clear_weeds` and one use only, or retire it and fold it into the "hall bell" pool). Also check `c1_k_grass`, `c1_k_nibbled`, `c1_k_spring`: these are small-creature noises that are fine, but they should not be a bell. (2) Add a pool of two or three "absence" barks (a sky that is too quiet; the bell you only notice by its absence; once, a single small *tink* as Mumyo's "sorry" sound, tapped away) triggered `seen:c1_tidy + chance`. (3) The twins' line "the village hears the bell at night" (E-1.15, summer) must not come after the tidy; if it can, change it to "they used to hear". (4) Text must carry the "that was a feeling" reading in words, not only in the picture glimpse (E-1.17 relies on art; if the art is late, the beat reads as a tower and nothing more).
- **Who.** Author (seeds 08/17/15, bark kit); the data-wishes list (08c) for the retimed bark.

### F4. Facts the ticket asked for that are thin or missing (exposition ladder)
- **"This was your home when you were small" is never told.** The ticket's list includes "the fire when you were small"; the ladder has "Moonedge burned" and "smaller than you remember" and nothing that says you lived here. The profile (7.1) lists remembered things (the well chain, the kitchen window, the cousin whistling) but no seed delivers one. This is the cheapest and most important emotional anchor: why does a 15-year-old work this hard for ash? Add one seed on `done:well_2` or `c1_winch`: the chain sounds as it did when you were small, and your hand knows where the handle is. Revise the existing `c1_well2`/`c1_winch` rather than adding a piece.
- **"The Lord" as a role is never explained** before the coin and ledger use the word. The coin may fire before the ledger, and its WEXLEY rim then points at nobody. Fix: gate the coin (`seen:coins + seen:c1_ledger`), so "the Lord's face" is understood; and put one person's line (Rue or the board: the biggest paper bears the same face) between "Lord" the word and "manor" the place. Without this the child meets "Lord", "manor", "share" with no referent for about 100 steps.
- **Why you came is two stories.** `00-premise.md` and `book-file.md:56` say Fenna is *drawn by a melody* that "starts in her head" the same week (pre-game). The dossier explains the coming by Berit's note ("you went") and Maud's "sending you back", and then lets the melody be "unknown" at the first night. Child test question 4 ("why are you here alone?") gets two answers. Reconcile in favour of canon: Berit gives the means and the permission, the tune gives the pull; the first night's wonder becomes "the tune that has been in your head all week is coming from those stones". That is a larger awe than the present one and needs only a small change to `c1_night` ("You know this tune" in place of "You do not know it"). Ask ticket 06; it touches a shipped piece, not a ✅ fact.
- **What the melody is "doing"** is met once (E-1.05) and then only by the hum barks. Acceptable for the hour; say so and hand to 06.
- **Fact 20 (the family's clock of care)** needs three hops for a child (a carter in Weir asked Rue, who tells you about a dented bucket). Cut to two: Rue brings a message by hand, or "a carter asked after you; I said you were busy". The dented bucket detail is lovely; keep it for the child to enjoy, not to decode.

### F5. Triggers that will misfire or be missed (engine fit)
- **Seasons-keyed seeds can be skipped by an efficient player.** E-1.21 (`seasons>=7` winter) and E-1.23 (spring, `seasons>=4`, plus an egg) are keyed to the clock; the bunny ends engine chapter 1 around season 8 for the bot, and a faster child never sees them. E-1.23 may also fire before E-1.21 (seasons 4 against 7), reversing the lantern-then-manor order the plants rely on. Key both to node completions or `seen:`/`after:` chains.
- **Asks and thanks are not chained.** Tom, Maud, Ella: the ask on `done:campfire + step>=10`, the thanks on `done:sq_*`. A player who finishes the favour before step 10 sees a thanks for an ask never shown. Add `seen:<ask>` to every thanks. Also confirm where each favour is delivered (the village, as a `scene`, or the farm fence): E-1.10 puts Tom at the fence and the engine cannot walk a visitor.
- **Three pieces hang on `done:clear_weeds`** (E-1.08 bell, E-1.11 Maud's ask, plus `c1_cleared` and the workbench unlock). Give them explicit priorities (bell first) so the order is not left to "least recently seen".
- **E-1.15 uses `chance:0.5`** on a visit that sets up a favour; make it deterministic.
- **E-1.08 changes the trigger but not the text:** the shipped `c1_bells` says "when the last thistle is out". Add that to the §8 table.
- **E-1.19 `rest_quick>=1`:** the counter exists (node map vocabulary), so it is not an "engine wish" (§9); correct the list.
- **"Rue comes at the turn of every season"** is a promise the engine will not keep (three visits in about eight seasons). A lived-in world notices. Soften ("when the road is dry"), or add a cart bark pool at the season turn.
- **"Hum for them" in E-1.24:** the player hums for the rhyme's missing lines, but the rhyme is tune A (Berit's) and the hum thread is tune B (the melody). That reintroduces break 6 (two things called "a tune"). Change to "you say it over, and wait for the next line".

### F6. Small continuity errors inside the slice
- **The hint box already lists the bucket and the tin pot as loose things, not box contents.** `welcome.gd:77`: "a tent, an old bucket by a wild pond, a tin pot, a few sticks and stones, one wheat seed — and a box with a book in it". The dossier cites only the other branch (`welcome.gd:75`). `world/00-timeline.md:52` puts all three in the box. E-1.03 and the "three objects come out of the box" picture follow the timeline. Decide one (my pick: the timeline; change line 77 to "a tent, one wheat seed, a few sticks and stones, and a box with a book, a tin pot and a bucket in it"), add the row to §8, and note the "wild pond" (a pond that the story drained in Y−6).
- **"You waited three days to open the box"** (E-1.03): the player was told by the hint to open it at once; "three days" also counts game-world time (D11). Cut to "You did not open it at the funeral" or drop.
- **The wheel/WEIR mark** is on the tent canvas in Invention 8, on the bread cloth in E-1.06 and on the "wheel mark by candle" bark. Pick one object (my pick: the tent has the wheel and WEIR; the bread cloth is a corner cut from the same canvas).
- **Berit is sudden and prepared.** She sat down in a chair mid-turnip (sudden); she packed the box in autumn and wrote "If you are reading this" (foreknowledge). Say she knew she was failing; it makes the note stronger.
- **The dent:** Berit's note says it was dented *when I found it*; the profile says it is Fenna's own childhood bucket and the dent is "where something hit it". Where did Berit find it, and was it in the barn? That is ticket 04's question; do not fix the dent's origin in the hour.
- **The frame emoji claim is wrong:** `c1_frame0` already has `"emoji": "🛏️"` and `"title": "Bedtime"` in the data (`10-chapter-1.json`). A different emoji is a data edit, not an engine wish; only the tint and the "Bedtime" group in the scroll need code. Correct §2.1 L6 and §9.
- **Page drafts not marked as sketches:** the §8 "direction" lines are near-final dialogue. The charter allows a line or two marked *sketch*. Mark them.

### F7. Leaks (diagnose catalogue)
- **Explained mystery:** the shipped `c1_bunny` page 2 explains the whole patch ("Now you understand… because somebody…") and the prints, hutch, bowl, stool and rhyme line have already solved it for the child (long ears, long prints, short prints). Fine as confirmation, but then the *hour's* mystery is the bell, not the grain; weight the hour's questions accordingly (F3).
- **Silence in "bell language"** (E-1.17: "silence is shame") is architect knowledge. The child has no table. See F3(4).
- **Named feeling:** none found. **Announced growth:** none. **Awareness break:** none inside a joke; the quoted-speech lines for the farmer ("A while." "I'm fine.") are the nearest risk and also cut across `fenna.md` ("the spine shows through the world, not through 'you'"). Keep them to two, and never both inside the same joke.
- **Technique-led:** the stool ("you will not sit on it") and the "lie down for a moment" telegraph; both survive because the delivery is quick. Keep each to one line.
- **Escalation in kind:** four T beats are the same note, *someone is watching* (prints, lantern, manor, the unknown ring). They differ by watcher, which helps, but vary the form of at least one (a cost, not a glance).
- **Vocabulary:** "adequate" (Rue on the flour), "manor", "ledger", "quern", "share" in one hour. Budget one stretch word per chapter beat; "adequate" is the funniest and may stay.
- **Fractions:** "a tenth, a fifth, a third, a half" asks an 8-year-old to compare unfamiliar fractions "in the child's own arithmetic". Safer as pictures or counts ("one sack in ten… one in two"). Check against the game's arithmetic level.

### F8. Decisions the author left open that should be settled by the manager
- **Minena says {player} once.** `fenna.md` has the grandchildren say *du*; D14 and the ✅ rule forbid "Grandma". The device is sound but is one more thing in an overloaded frame (F1). Recommend **no** for now; the objects and the hand-over bind the name well enough. Reconsider only if the child test fails question 1.
- **Option B ("Where were we?")** is a good fix for a child who was away for a week and costs nothing in the story; recommend as a UI ticket, not as part of the outline. **Option C** (a frame bark) is not allowed by the charter; drop it.
- **The rest-screen picture** is chrome and does not break the frame rule; accept, but do not let it show the old person's bed during the farm hour if it can confuse (test with the child).

---

## 4. Seam, layer by layer

| Layer | Would a lost child now follow? | Free text, art, or engine |
|---|---|---|
| L1 hand-over line ("I was fifteen, and I had borrowed a tent." "It smelled of horse.") and the matching first farm line | **Yes**; the strongest text layer and the cheapest | Free text (two pieces) |
| L2 the age as arithmetic | Charming; the least necessary. Cut first if the frame is too long | Free text |
| L3 title "Moonedge, long ago" | Helps readers; **a listener (6) never hears a title** | Free text (`title` field) |
| L4 pictures (same three objects; grey farm with one green; old hand not face) | The strongest layer for non-readers; needs four new images (stalk page 1 has none today) | Art. "Old hands": allowed by the picture rule (hand from the camera) |
| L5 sound (room tone, the four-note hum) | Would be the best bridge; **no hook exists** | Engine |
| L6 lamp emoji, tint, "Bedtime" group | Emoji is **data** (set it on the frame pieces); tint and group need code | Data + small engine |
| L7 action: open the box | Works today (the card opens the beats); but the hint box must say box, pot and bucket consistently (F6) | Existing |

Cheapest sufficient set, in order of value: the three objects (text + picture), L1, the hum, L3, then L7. Everything else is a bonus. Three further checks: (a) the farm layer must carry a time/place word on its first line ("Early spring… Moonedge" is good); (b) the older "you" speaking in the first person ("I was fifteen") inside quotes is fine as long as no told-voice aside appears inside a chapter; (c) the dossier's six "breaks" are a good reading but are not tied to what the test child actually did or said. Ask the parent or the manager what the child asked or where they stopped; behaviour beats verdict (diagnose.md). Add an observation column to the child-test script (where they tapped past without reading, what they asked unprompted) and use at least three children of 6 to 8.

---

## 5. The bottleneck

Pass 2, applied to the listening experience of the whole hour:

1. *Does the reader want to know what happens next?* Strong at the start (the grain, the bell, "who left it"); **thin from step 40 to about 200**.
2. *Fun to say aloud?* Yes (the sketches are short and dry).
3. *Care about this person?* Strongest element; objects and others carry the spine.
4. *Does it land?* Yes (two rings, the frame, the hum).

**The one notch:** question 1 in the middle. The cheapest lift that also reuses the best idea in the dossier is to give the silence after the tidied tower a *cost the child feels*: Mumyo goes quiet because of what the farmer did, the reader knows, the farmer does not, and the quiet is audible for the next 150 steps (F3). No new engine, no new character, and it turns the bunny's arrival into a release rather than a mere answer. Do not also add a deadline: DECISIONS C1 has deliberately made the family soft and the Lord's share the book's clock (ticket 07).

---

## 6. Charge audit findings in numbers

- Strip as claimed: G T G W A G G T G T G G T G G W T G G T T W T W T. Lead-register pairs only; no triples. The pairs GG occur four times and TT once.
- Real problems: (1) W W A at the start (box, book, night), see F2; (2) five "joke then tender button" seeds; (3) four "being watched" T beats; (4) the audit leaves out about 25 kept pieces (about 60% W) and ignores node order; (5) one awe (E-1.05) at step 2 is fine for the book's 2 to 4 budget but is not "after a release": it follows the book's W. It is the opening wonder, so I accept it; if the melody-in-the-head fix (F4) is adopted, the awe becomes earned (a mystery answered, not just a view).
- Every W earned? 16 (after G), 22 (after T), 24 (after T) yes; 04 only nominally (F2).
- Awe adjacency: no other awe in the hour; no conflict.
- The T line: should rise on the *real* order; the plan has the Lord's face and the ledger early and the manor late; if the Lord thread is front-loaded (F2b) and the manor question lands in a season-keyed seed that may not fire (F5), the rising line is a hope, not a design.

---

## 7. Contradictions found

| # | Where | What disagrees | Suggested winner |
|---|---|---|---|
| X1 | Dossier E-1.03, §2.2, Inventions vs `welcome.gd:77` | Hint box lists the bucket and pot as loose; the dossier and timeline put them in the box | The timeline; change the hint |
| X2 | Dossier §3.1 row 9 / E-1.05 vs `00-premise.md`, `book-file.md:56` | Premise: a melody starts in her head the same week and draws her; dossier: she first hears it at night and "does not know it" | The premise; adjust `c1_night` (F4) |
| X3 | E-1.03 "you went… three days" vs the hint box and D11 | Opening the box immediately vs waiting; counts days | Drop "three days" |
| X4 | Dossier §2.1 L6, §9 vs `10-chapter-1.json` | Says the frame shows the book emoji; the data has 🛏️ | Data; fix the claim |
| X5 | E-1.24 "hum for them" vs §2.3 tune A/B | The hum is tune B; the rhyme is tune A | Keep the tunes apart (F5) |
| X6 | E-1.17 (silence) vs staged `c1_k_bell`, E-1.15 (bell heard at night) | A bell rings during the silence | Retime or retire the old bark (F3) |
| X7 | Dossier Inventions 8 / E-1.06 / bark kit | The wheel and WEIR mark on three objects | One object (F6) |
| X8 | Dossier 7.1 and E-1.06 (the cousin, the funeral, the reason for "a while") vs `book-file.md:56` ("for perspective") and DECISIONS C7 | The dossier invents the funeral and says she asks for "a while" because the cousin will be at the table; C7 gives ticket 04 that account | Mark as a proposal for 04; do not treat as given |
| X9 | Dossier Invention 24 (the cousin saw Fenna with the bucket) vs DECISIONS C7 (lights from a window, then Fenna running out sooty) | The bucket is not in C7 | 04 decides |
| X10 | `fenna.md` ("spine shows through the world, not through 'you'") vs the three quoted farmer lines | Allowed in frames; in the farm layer rarely | Keep to two lines, never inside a joke |
| X11 | Charter §1 (25 to 40 seeds a chapter) vs ticket (15 to 25) | Different counts; the slice has 25 | Fine; the merge will reach 40 with kept pieces |
| X12 | Dossier §2.1 L4, §9 art ("two ears' worth of light") vs the bunny hook | A glimpse of Mumyo reads as a bunny's ears | Use a spark or a tail, not ears |
| X13 | Maud knows Berit "told me in autumn" (E-1.11) vs the family being driven from the district | How did Berit meet Maud in autumn? | Ticket 02/05: a letter, a market, a secret visit |

---

## 8. Over-reach and hand-offs

Decided too far here; present as *proposals* for the owner, not as given:

- **Ticket 04:** the funeral details, the reason for "a while" being the cousin, the cousin's note "Everyone means everyone", Berit finding the bucket, "the cousin saw Fenna with the bucket". "Everyone means everyone" is also beyond a six-year-old; it is a plant for the second hearing, which is fine, but nothing in the child test should depend on it.
- **Ticket 06:** the whole Mumyo ladder in chapter 1 (bell, pile, tower, tidy, silence, two rings), the glimpse budget, the "silence is shame" reading, the A/B tune split, the old you humming the melody in every frame. The ladder is good; the owner confirms it. The question "does the old you hum tune B" is a real ❓ because it changes what Minena's dream in *Minena 01* means (recognition, not discovery).
- **Ticket 05:** Rue's three-visit arc, her spine and name, the asks and obstacles for Tom, Maud, Ella, the twins, the stool's owner, the miller. Keep as seeds; 05 shapes the people.
- **Ticket 07:** the ledger fractions equal to the engine's 10/20/33/50 (the author already flagged), the lantern, the manor's question, Pieter as a lantern in winter.
- **Ticket 02:** the hall bell, Weir's distance, where Rue's cart stops, how Maud met Berit, where the track meets the road.
- **Ticket 03:** the bunny's pre-return traces (prints, nibbles) and what the bunny does when unseen.
- **Ticket 08a/08b/08c:** the merged charge strip, the choice of which staged pieces to retime; the frame length plan (C3); every later frame's hum and objects (stones multiply, a new lid); the data wishes (emoji, tint, group, `rest_quick`, `unlocked:` triggers, sound hooks, Option B).
- **The manager:** accept or overrule Inventions 1 to 25; decide F8; make the call on the hint-box text (X1).

---

## 9. Lived-in test and child test

- **Lived-in.** The hour has a village that talks (the miller's "adequate", the hall bell, other people's suppers, a lantern). But almost every person exists in order to want something from the player, and nothing happens in Hazelwood that is not about Moonedge. A single event that does not involve the player (a market day, a wedding, a cart stuck in the track that you only pass) belongs to ticket 02; ask it for one *hour-1 sized* seed.
- **Child test (reading as a six-year-old listening, an eight-year-old playing).** Likely understood: the grandchildren, the bed, the three objects, Moonedge, the tent, the bucket by the fire, the tower and the silence (with F3), the soup, the hutch, the two rings. Likely lost: "Everyone means everyone", the three-hop bucket question, the Lord/manor/share chain before a person explains it, fractions as numbers, "adequate" as anything but a funny word. Names in the hour: about 13 (Minena, Moonedge, Berit, Weir, Hazelwood, Rue, Tom, Maud, Wexley, Ella, Lotte, Linus, Pieter). Fine for the hour if no two share a box (E-1.01 and E-1.09 break the dossier's own rule).

---

## 10. Next steps, in order of value per effort

1. F1: trim frame 0 (author, today).
2. F3 and F5: gate the contradicting bark, add absence barks, chain the asks, key seeds to nodes (author).
3. F4: add the "this was your home" memory beat; gate the coin; reconcile the melody (author, with 06).
4. F2: the step-ordered merged strip (author for the table, 08a for the merge).
5. F6 and §7: small corrections (author), manager decides X1, F8.
