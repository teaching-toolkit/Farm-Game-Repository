# Master outline, chapter 3: Smallholding

Written 24 Oct 2026 by the story manager. All 💡. Fates in `../registry.md`.

**Chapter question:** *Your cousin asks after you: is she a threat?* (and, for the Lord: what is the Share?).
**Farmer's want / obstacle / ending:** stay, so work twice as hard; the goat eats her lists, the miller still blames the family, the bell in the mill is too small for any cow; she lets the goat do a job for her (bend 1 ✅) and laughs at the dance.
**Pet:** goat. **Village rung:** 3, grudging and fair (the miller's one nod, Pieter's stool, the first Chain). **Lord:** a lantern at the gate; **a tenth** (about 6 % felt), the first **Share Day** (the first real date). **Length:** about 226 engine steps (422–648).

## Acts

1. **Lists and omens (422–470).** The goat is coming (a corner of a list nibbled, furniture, the long walk); the salt card plants the Table; the first Share Day (stool, thin soup).
2. **The village leans in (470–560).** Pieter's sacks, the cider and Rosa's tune, the sails, the thank-you tax, the ninth loaf, the Grey Breath. The drawing under the bell: the small one and the farmer were friends.
3. **Letting someone help (560–648).** Bucket Night's Chain (and someone in grey), the buckets at every corner, Lark's list, the goat comes home, the letter comes *through the gate*, the guest bed.

## Event seeds in play order

| # | Seed | Trigger (short) | Reg | What the player gets | Fate |
|---|---|---|---|---|---|
| 1 | shipped `c3_letter` ("Stay if you must. Your cousin asks after you.") | `chapter:3` | W/T | the ask drops; read as a warning | shipped |
| 1 | E-3.H21 A corner of the list | `c3_k_nibbled` | G | something is coming and it wants your plans | keep |
| 2 | E-3.H14 Furniture (bark x3, chapters 3–5) | chance | G | she becomes the farm's furniture, then its desk | keep |
| 3 | E-3.H16 The Long Walk (bark x3, chapters 3–5) | chance | G | a stone path pond-to-house exists because she cannot not mark things | keep |
| 4 | E-3.H22 The wall of bramble | `tap:patch:scrub` | G | the goat's deed has a target (data wish: goat tied to scrub) | keep |
| 5 | E-3.R41 Berit on the salt card (Table carrier 1) | `page:k_salt` | W (G in the margin) | the Table planted on the main path, in Berit's voice | keep |
| 6 | E-3.H13 The tortoise's page | `page:k_water + seen:tortoise` | W | the bucket has a history, and it was kindness (Q7) | keep |
| 8 | **First Share Day**: E-3.R04 (lateness is neighbours' patience) + E-3.L02 A stool for Pieter + E-3.R40 Thin soup, thick soup (the occasion) | `lord_shares>=2` | G→W | a date you can see coming; the thin pot is a poor village's baseline; the upgrade is a dish in the store; Pieter eats standing, then on the ground | keep (three merged into one occasion scene of two boxes) |
| 7 | E-3.L07 The grandfather and the sails | `done:windmill_1` | W | the miller says "put that on, you'll catch cold" | keep |
| 8 | E-3.L05 The cider, the Late Mug, Rosa's lost tune | `seen:c3_dance + after:1` | G | the farmer's tune enters the village; Rosa plays it badly all night | keep |
| 9 | E-3.B09 A drawing under the bell | `seen:c3_bell + after:1` | W/T | the small one and the farmer were friends (Q8); the hum is the tell | keep (`c3_bell` is critical) |
| 10 | E-3.M10 The bottom of the list | `seen:c3_goat + after:4` | G | what she writes at the bottom of every list; a new list (Lark's one visit) | keep |
| 11 | E-3.L03 Pieter and the widows' sacks | after #8 baseline + 6 (**re-keyed**: `lord_paid` is a coin sum, not a count) | T→W | the Mark has a human hand; Pieter risks his post | keep, re-keyed |
| 12 | E-3.R08 The thank-you tax | `seen:c3_stream + after:1` | G (T flicker) | success is taxed; a mill that runs is a mill the Hurst charges | keep |
| 13 | E-3.L10 The ninth loaf | `done:oven_2 + sold_kinds>=4` | T→W | she sells to the Nest for less; Appleby will not say thank you (cold face b) | keep |
| 14 | E-3.L06 The Grey Breath | `season:autumn + seen:#8` (**re-keyed**) | T (G in the breath) | where the money goes; the Count is **never named in text**; one small hand takes hers | keep, re-keyed |
| 15 | E-3.L11 Bucket Night: the Chain forms (+ E-3.B08 Someone in grey) | `summer + chapter:3` | G→W | more than Maud comes; the Chain; a figure in grey is real and becomes a legend | keep (B08 merged; Q15 hint) |
| 16 | E-3.B12 A bucket at every corner | `done:barn_2`; `done:farmhouse_base` | G | the fear is now a farm habit (Not the Barn #2, #3) | keep |
| 17 | E-3.H10 The job card (template, six idioms) | `seen:<next Helper's return> + after:10` | G (W at badger/alpaca) | the job board opens for each Helper | keep (one template) |
| 18 | E-3.H51 The Spit Trail (x3, chapters 3–6) | `lord_shares>=2`; later | G | something at the forest edge has a view about the Lord's claim and a line between a man and his book | keep |
| 19 | E-3.H65 The Queue (bark x4, chapters 3–6) | chance | G (W by the last) | the rhyme lined up and walking; the gap | keep |
| – | shipped `c3_goat`, `c3_goat_out` | `done:pet_goat` | W | the goat comes home; she eats thistles nobody could clear and you **let her** | shipped |
| 20 | E-3.B10 Through the gate (C19) | `seen:c3_goat` | W (plank giggle) | the letter is human; Liv has been asking to come *in*; **the letter under the hat is Mei's** | keep |
| 21 | E-3.B11 The guest bed (loop x3) | `seen:c3_goat_out + after:3` | G | a room waits: preparing is safer than meeting | keep |

23 events plus the shipped goat pair. **Free play / optional:** #3, #4, #20 (barks and omens), #12 if the chapter runs long.

## Charge audit

Lead registers in play order (story boxes only; barks #3, #4, #20, #21 do not take a slot): W/T (letter), G (H21), G (H22), W (salt card), G→W (the Share Day occasion), W (tortoise page, now behind the occasion), G, W, W/T (drawing), G, T→W, G, T→W, T, G→W, G, G, then the goat (W), W, G. Runs checked: no three identical marks in a row. Tension is a *rising simmer*, not a spike: it enters at the Share Day, the sacks, the ninth loaf, the Grey Breath and the drawing; the jump comes in chapter 4. Awe: none. Every W follows a G or T.

## Exposition and clue ledger

**Reveal of the chapter:** *A small someone is real and knew you* (the drawing, Q8; the imp may have done it: the player's allowed wrong belief). Clues: Q2 hinted (paper boat is ch4), Q3 (Pieter's ledger, the sack), Q7 (tortoise page), Q8 confirmed-lightly, Q13 hinted ("your cousin asks after you" as a warning), Q14 (buckets at corners), Q15 hint (grey figure), Q16 planted (Tilda's name should be said in ch2–3: **see ruling below**). The Table (Berit's salt card) is planted; the player does not yet know what it is for.

**Ruling:** Tilda is named by Jan in ch2 (#16 there); her second hand is "T." in ch2 (B04); this chapter adds only the Mei letter (#22) with Liv's *name unsaid* (she is "your cousin" until ch5).

## Persistent costs

The thin pot (never refunded); the thank-you tax (the miller); Pieter's lantern on every Share Day; the ninth loaf (her Marketday corner gone every second week); Rosa's tune now in the village.

## Village strand (rung 3: grudging and fair)

The miller's one nod (#10), Pieter's stool (#8), the Chain (#17). Cold face (b) is Appleby (#15). First Quill-adjacent omens: Pieter's ledger and the lantern at the gate.

## Chapter-end open question

*Your cousin may come to visit* (the letter through the gate). Frame 3: "Were you scared of the cousin?" "More than of any imp." (The word "imp" stays in frames only.)

## Notes and rulings

- Data wish: the goat's deed tied to `patch:scrub` (the H22 target); `lord_paid` is not a count: any seed keyed to it is re-keyed to `seen:` chains.
- "Berit's six pages" are in "you", hang on `page:` triggers; the guilt is written only in the alpaca page (ch6).
- The village rhyme (E-1.H76) never has a spell-like effect; the alpaca gives wool, not a feather.
