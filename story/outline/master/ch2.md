# Master outline, chapter 2: Homestead

Written 24 Oct 2026 by the story manager. All 💡. Seed ids as in `ch1.md`; fates in `../registry.md`. Frames are shipped (`c2_frame2`).

**Chapter question:** *If not lightning, then what? And who carried it in?*
**Farmer's want / obstacle / ending:** a real roof before the winter (her own deadline; the family's letters ask, never date); she cannot build alone, and the village is curious but wary; the barn ruin shows the fire began **low, in the hay**, and the tortoise comes home to the dry pond (data wish: `pet_tortoise` requires `pond`, ✅ parent 00-4c).
**Pet:** tortoise. **Village rung:** 2, curious (first cold face: Appleby chalks the first loaf "double"). **Lord:** a chalk thin moon, Pieter writes down the roof. **Length:** about 175 engine steps (245–420).

## Acts

1. **Letters and chalk (245–300).** The family's soft letter, Jan answering for Moonedge, the Mark on the loaves, the board paper with its end clause.
2. **The roof (300–360).** Greenstem and Hilde, Lark and his date joke, the hammer the size of a thumb, the roof, the Book's first line about her. The thumps get sorted (hawk in the lid, the rabbit's page).
3. **The low fire (360–420).** Hook outside, hay inside; Jan's cough at "past the sill"; the dry pond with a seat in it; the tortoise comes home.

## Event seeds in play order

| # | Seed | Trigger (short) | Reg | What the player gets | Fate |
|---|---|---|---|---|---|
| 1 | E-2.L01 Jan answers for Moonedge (+ E-2.B06 A leaf from the hedge, shipped `c2_letter`) | `chapter:2` | G→W, T last line | someone has answered "Here!" for her farm; Landing Day placed (fortnightly); the father by horse, the mother in brackets (signed -M.); a token you cannot place; Mei walks letters up | keep (B06 merged in) |
| 2 | E-2.H04 A hawk in the lid | `done:animal_cow` | G | three kinds of thump heard; the player starts to sort them | keep |
| 3 | E-2.M08 The white line by day | `tap:forest` | W | the forest has a border; the melody has a day face | keep |
| 4 | E-2.L02 What the Mark is (+ E-2.R03 The paper with the grey edge) | `seen:c2_greenstem + done:cottage`; `tap:board` | T→W | chalk is everywhere; the board paper has an end clause ("until the farm gives again") | keep (R03 merged in) |
| 5 | E-2.L11 Two skipping rhymes (+ E-2.B05 Lightning, lightning) | `chapter:2 + seen:greenstem + chance` | T | the Mark's rhyme; "lightning" skipped; she says "It started low." | keep (B05 merged) |
| 6 | E-2.H05 The rabbit's page | `page:k_roots + seen:c1_bunny` | W | a fact about you in Berit's hand; thumps are three kinds (Q7) | keep |
| 7 | E-2.M07 A very bad smile | `weeds>=20 + chance` | G | weeds in a smiley; she steps round it all day | keep (bark) |
| 8 | E-2.L10 "Moonedge pays double" | `done:oven_1 + sold_kinds>=2` | T→W | Appleby chalks the first loaf; Anna slips a bun in the bag; the Mark has a cost | keep (cold face a) |
| 9 | E-2.M09 Which frost | `done:road_3` | G | the date is hers, not the family's (the mother's "before the frost" is dropped) | keep (page added to `c2_lark`) |
| 10 | E-2.B04 Hook outside | `page:k_hay` | W (giggle) | Berit's rule; "Yes, Mother" x3 in a second hand (T.) | keep |
| 11 | E-2.L05 Longnight: the soup | winter | G→W | many bowls, nothing said; Mrs. Wiggins notices; a cup in her hand | keep (the Cup optional) |
| 12 | E-2.L08 Otto and the Hush | `done:sq_bridge` | W | one trailing sentence about a child who did not cry; he poles away | keep |
| 13 | E-2.M06 A hammer the size of a thumb | `done:cottage_roof` | G (W tail) | the first trace she does not dismantle; glimpse 3 (a hand at the thatch edge) | keep (text fallback) |
| 14 | E-2.R02 He wrote down the roof | `seen:c2_cottage + after:3` | T | the Book has a first line about you | keep |
| 15 | E-2.R01 The letter that does not get sent | `seen:c2_letter + after:2` | G | "I'm staying a bit longer" reads as the reply; "Small is…" | keep |
| 16 | shipped `c2_barn` + E-2.L06 Hook outside, hay inside (+ E-2.B07 Not past the sill) | `seen:c2_hook + after:2` | T | it began low; the hook found *inside* is out of place; Jan coughs at "past the sill": **Tilda is a person who is gone** | keep (B07 merged; **chapter turn**) |
| 16 | E-2.H11 The seat in the dry pond | `tap:pond` | W | the pond had a keeper who waited; the pond becomes a debt (Q6) | keep |
| – | shipped `c2_tortoise`, `c2_frame2` | `done:pet_tortoise` | W | the tortoise comes home; frame 2: "Did you find out who started it?" "Not then. I didn't want to." | shipped |

17 rows. Small on purpose: chapter 2 is the first place the player is *asked to wait* (the tortoise, the winter) and carries the turn of the book (not lightning). **Free play / optional:** #3, #7, #11, #12.

## Charge audit

Lead registers in play order (rows 1–17): G/W, G, W, T→W, T, W, G, T→W, G, W, G→W (Longnight), W (Otto), G/W (hammer), T, G, T (the turn), W. Runs checked: no three identical marks in a row (the two Ws at rows 11–12 are Longnight G→W then Otto's W, with a G before and after). Tension: soft T at 1, 4, 5, 8, 14; the barn turn (row 16) is the highest T so far; the chapter ends on W (tortoise). Awe: **none** (A1 was chapter 1; chapters 2–3 are the longest gap, carried by G and T). Every W follows a G or T.

## Exposition and clue ledger

**Reveal of the chapter:** *It was not lightning. It began low in the hay, and a lantern that never went past the sill had gone in.* (`c2_barn`, `c2_hook`, E-2.B04, B07, L06.) Clues: Q1, Q4 (stumps: shipped), Q5 (confirmed it was low), Q6 (compost, the seat), Q7 (the rabbit's page), Q12 hinted (hook found empty by the door + Jan), Q16 planted ("T."), Q17 planted (who carried it in; **never answered**), Q18 planted (village says lightning). **Allowed to be wrong about:** that the village lies out of malice. **Not yet allowed:** Mumyo's name; "Liv saw the lights"; "go away".
**Family clock (C1, "a while"):** letters ask, ask less, or arrive; none gives a date. The text change for `c2_letter` is T-1 (drop "before the frost", ✅ 07-45).

## Persistent costs

The grey-edged paper (the Mark has an end clause); the first line in the Book; the chalk on every loaf; Appleby's coldness (cold face a); the pond debt.

## Village strand (rung 2)

Greenstem and Hilde break the ice; Otto's half-sentence; Appleby is the cold face (cost: she earns less, then a bun). Millward's miller still blames (first glare from the bridge is a shipped bark). Jan is the old man who kept the name.

## Chapter-end open question

*Who carried the lantern in?* (never answered, 04 Q17) and, softer, *what is the cousin like?* ("Your cousin asks after you.") Frame 2: the farmer says "I didn't want to."

## Notes and rulings

- Data wish: the tortoise requires `pond`. Story fallback if not built: the tortoise sits at the dry pond edge and waits anyway; E-2.H11 reads the same.
- Lark's first date joke (#9) replaces the mother's clock.
- The shipped `c2_cottage` line "I'm staying a bit longer" is **the reply** (#15), not a decision.
