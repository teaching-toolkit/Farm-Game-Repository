# Master outline, chapter 4: Village Trade

Written 24 Oct 2026 by the story manager. All 💡. Fates in `../registry.md`.

**Chapter question:** *Whose farm is it?* (the steward counts everything; the lease says a half; and who saw you with the bucket?)
**Farmer's want / obstacle / ending:** the farm to be hers; Master Quill arrives and counts, and the reading of the lease at the gate makes the pressure public; her first *no* (the field will rest, the pony will not be lent); the pony carries her first big order and she is seen.
**Pet:** pony. **Village rung:** 4, split ("the farm is rich, let it pay" against "we know that number"). **Lord:** a pencil (Quill); **a fifth** (about 19 % felt). **Length:** about 196 engine steps (649–844).

## Acts

1. **The steward at the gate (649–700).** Quill arrives and counts; the pencil that does not run; Old Jan's counted hen; someone saw you with the bucket.
2. **The reading (700–770).** Share Day: the lease read aloud at the gate; the village hears "a half"; the tin and the "Q."; the first thaw in Quill.
3. **The pony and the Wall (770–844).** The first refusal; the order chalked small; Longnight's tiny true thing; the farm seen from the Wall (awe #2); Quill rides out with "gives back more than it takes", a question.

## Event seeds in play order

| # | Seed | Trigger (short) | Reg | What the player gets | Fate |
|---|---|---|---|---|---|
| 1 | shipped `c4_quill` (Q1) | `done:farmhouse_base` | T | "The Lord wishes to know why"; Quill counts | shipped |
| 2 | E-4.H35 Hoofprints in pairs, and a blanket | `done:road_4`; `has:saddle_blanket` | G | something is waiting for the pony's things | keep |
| 3 | E-4.L07 Landing Day: Here! (+ E-4.B13 Have you still got the bucket?) | `done:road_4 + chapter:4` | G→W (T on the jar) | her first public "Here!"; Jan beams; **someone saw you with the bucket** ("L." is the cousin and is afraid too): the chapter's one reveal | keep (B13 merged in; Q14, Q19) |
| 4 | E-4.R22 Pencil does not run | `seen:c4_count + after:1` | G (T under) | ink runs, pencil does not; Quill has a private number (Q2: the paper boat in the shipped `c4_count`) | keep |
| 5 | E-4.L01 Counted aloud, counted soft | `seen:c4_count + after:2` | G→W | the village decides he is brave or doomed; a thaw without a word | keep |
| 6 | E-4.L03 The gardener's sticks | `done:orchard + done:farmhouse_walls` | W (G in the pencil) | the Lord's household has a kind person (Thorne); the orchard gets old apples back | keep |
| 7 | E-4.H25 The counted hen | `seen:c4_count + after:10` | G | Old Jan's claim is true; Quill has met the only other counter and is not warmed | keep |
| 8 | E-4.H82 The fox she was right about | `chapter:4 + autumn` | T→G | a hen is gone for good; the coop door gets a bolt; the goat gets a post | keep |
| 9 | **The reading at the gate**: E-4.R42 (Share Day occasion) | notice `seen:c4_count + after:2` | T | the village hears the claim "a half" from the steward's mouth; the glass kiln and cheese vat are read; the Pay number rises | keep |
| 10 | E-4.L11 The Pot divides (**reduced to a two-bark series**, not a scene) | after #9 | T | Maud and Appleby stop speaking for a week; the Pot is cold on Marketday | keep (cut to barks) |
| 11 | E-4.R11 The tin, and a letter Q (Table carrier 3) | `seen:c4_lease + seen:c4_quill` | T→W | the "Q." on the lease: Quill wrote the half once; the Table line in the lease itself ("never so much that the table is bare") | keep (first crack in Quill) |
| 12 | E-4.H28 The one bramble | `done:north_field_clear` | W (G in the shears) | a tile left standing because someone asked without a word (data wish) | keep |
| 13 | E-4.B14 The bucket behind the barrel | `seen:jar piece + after:1` | G | she hides the bucket; the player laughs at the thing that will matter | keep |
| 14 | E-4.R19 The puddle on the Lord's Mile | `done:road_5` | G (T aftertaste) | the Lord is **poor**; the village laughs and goes quiet together | keep (may fall in ch5) |
| 15 | E-4.H15 Who minds the reeds | `seen:c3_goat + done:pond + summer` | G | goat x tortoise: the daisy a day | keep |
| 16 | E-4.H23 The goat's page | `page:k_compost + seen:c3_goat` | G | what you did at six; Old Jan was right | keep |
| 17 | E-4.L09 Longnight: a smaller true thing | `winter + chapter:4` | G→W | "My feet hurt"; a cup passed and drunk; a rehearsal of the bend | keep |
| 18 | E-4.L05 The view from the Wall (**awe #2**) | `done:sq_night_watch`; Pieter's invitation | A→T | Moonedge as a lit window from outside; a tiny light over the marsh | keep |
| – | shipped `c4_pony` | `done:pet_pony` | W | the pony comes home and carries the first big order; she is seen | shipped |
| 19 | E-4.R13 The Lord asks for the pony (+ E-4.L12 The pony's order is chalked) | `seen:c4_pony` priority 85; `+ after:2` | T→G | the Book's first refusal ("Declined (pony)"); the pony poses through the chalking; Appleby's chalk breaks | keep (L12 merged) |
| 20 | E-4.H27 Altitude (bark series, x3) | chance | G | the goat has a post, then a stage | keep (bark) |
| – | shipped `c4_quill_out`, `c4_frame4` | after pony | T | "gives back more than it takes", a question; frame 4: "He was afraid. That's worse, sometimes." | shipped |

18 story boxes plus three barks/series. **Cut:** E-4.R17 (the grey letter on the quay; the "Lord is not at the top" fact is told in ch3's Grey Breath and ch6's barge). **Free play / optional:** #12, #13, #15, #16, #20.

## Charge audit

Lead registers in play order: T, G, G→W, G, G→W, W, G (counted hen, moved behind the warm gardener beat), T→G, T (the reading), T barks, T→W, W, G, G, G (puddle, reeds, goat's page), G→W, A→T, W (pony), T→G, G. Runs checked: no three identical marks in a row (the hen was moved so that G, G is broken by W). Rows 9–11 are the **tension crowd** (the reading, the Pot's barks, the tin): the Pot is two barks, and the tin is T→W, so the farmer meets one heavy beat, a breath, then a softening one; a W (the bramble) and three Gs follow. Awe: one (the Wall), after a G stretch, followed by the pony (W) so awe never stands next to a W-only box. Tension rises: soft (steward counts), then the reading (the first felt cost to her standing), then the first refusal (the pony), then the open question at the end.

## Quill in this chapter (his 11 beats: six here)

Q1 arrives (#1), Q2 pencil and boat (#4, with the shipped `c4_count`), Q3 the reading (#9), Q4 the tin (#11), Q5 asks for the pony and is relieved to be refused (#19), Q6 `c4_quill_out` (shipped). He is **the pressure the child feels**: his honesty raises the bill (he finds the glass kiln; now they tax it). Pieter is warmer than Quill: the lantern at the gate. Helper-made Quill gags: the goat on the coop roof (#8, #20), the spit mark on his hat (E-3.H51 #2), the pony posing through the chalking (#19).

## Exposition and clue ledger

**Reveal of the chapter:** *Someone saw you with the bucket* (E-4.B13: the plank, the jar note signed "L."). Clues: Q2 (the paper boat), Q3 confirmed (`c4_lease` "a half"), Q9 face (grey wax is cut with R17; Q9 answered later), Q13 (the jar, the hiding of the bucket), Q14 (hook against dent, picture), Q19 planted. **Allowed to be wrong about:** that the cousin is a threat. Table: the line enters in the lease itself.

## Persistent costs

The Pay number (a fifth, with the new lines); "Declined (pony)" (the procession pauses; the farm gets quieter); the Pot is cold for a week; the pencil column.

## Village strand (rung 4: split)

Juno will not choose; Maud and Appleby stop speaking (cold face c); Pieter's lantern; Thorne's twenty-two sticks (a kind person on the Lord's side); Mei's long voyage; Ines's window. Nobody punishes the child.

## Chapter-end open question

*The steward rides back to the Lord* with "gives back more than it takes", a question; and the child still carries *have you still got the bucket?* Frame 4: "Was the Lord a villain?" "He was afraid. That's worse, sometimes."

## Notes and rulings

- Chapter 4 carries **one** reveal (B13). The report on the fire moved to chapter 5.
- The glimpse in this chapter is Quill's paper boat (back view; the farmer is not in the picture).
- The Pot divides is now barks only (to cut the crowd); a full scene would need the break of ch5's cough.
