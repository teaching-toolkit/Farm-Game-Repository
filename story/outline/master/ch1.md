# Master outline, chapter 1: Ashes

Written 24 Oct 2026 by the story manager from the slice dossiers (`slices/01`, `02`, `03`, `04`, `06`, `07`). All 💡 until the parent has seen it. Seed ids are the slices' own (`E-<ch>.<letter><nn>`; L = lived-in village, H = Helpers, B = barn truth, M = Lark/Mumyo/melody, R = Lord/clock, bare number = opening hour). The registry of every seed and its fate is `../registry.md`. Triggers are shortened; the full trigger idea is in the slice.

**Chapter question (what the player wants to know):** *Who else is still here?* (who rings the bells, who kept the green patch).
**Farmer's want / obstacle / ending:** keep the one seed alive, alone, and so busy that nobody asks about the fire; ash, mud, a road no cart can use, and someone small moving her things; the bunny comes home and the patch turns out to have been kept alive *for her*.
**Pet:** bunny. **Rung (village):** 1, polite and watching. **Lord's rung:** none (a notch, a passing lantern). **Length:** about 244 engine steps (the bot's count; the opening hour). **Estimated order below is by node dependency, not measured**; the check is one bot run (see `../../QUESTIONS.md` item on the test-bot).

## Acts

1. **The bedside and the ash (steps 0–25).** Frame 0, the box, the song, the first night. Three objects (pot, bucket, book), the hum, "I never start with the fire". Awe #1 at the end of act 1.
2. **The green patch and the first neighbours (25–110).** Bells and a silly pile, Maud's goat, Rue, the boy, the doorframe, Maud's post. The village is polite; nobody comes up the road.
3. **A cost the child feels (110–200).** The coin, the burnt page, the tower and the tidying (the silence runs to the end of the hour), the soup, the well ("this was your home"), Longnight seen from the hill, the lantern on the road, the notch.
4. **The keeper (200–244).** Waiting for someone, the bunny comes home, two soft rings, back in the room.

## Event seeds in play order

Registers: G giggle · W warm · T tension · A awe. "Fate" is what the master did to the slice's seed (keep, merge into, or note).

| # | Seed | Trigger (short) | Reg | What the player gets | Fate |
|---|---|---|---|---|---|
| 1 | E-1.01 Tea, order and a hum | `start` (frame) | G | whose bed; grandchildren; the farm's name; the hum; "I never start with the fire"; the tent and its horse smell | keep |
| 2 | E-1.02 Begin with ash | `start` | T | place and season; who left the grain | keep |
| 3 | E-1.03 Berit's box | `page:k_wheat` | G only | Berit named by initial and gone; you are fifteen; pot, bucket, book | keep |
| 4 | E-1.04 The kitchen song | `page:k_wheat` | W | Berit has a voice; tune A named | keep |
| 5 | E-1.M04 The part you skip (Rest Gag) | `step>=6`, chance | G | animals always stop at the same place (the rest, never named) | keep (bark pool, runs ch1–3) |
| 6 | E-1.05 The first night | `step>=2` | **A** (#1) | the tune has an address; why she came | keep |
| 7 | E-1.06 The last of the bread | `step>=5 + seen:c1_night` | G(+W) | family is in a town; "a while"; the child's drawing of a very large chicken; cousin planted | keep |
| 8 | E-1.H01 Half a roll at the fire | `done:campfire` | T→G | something small is afraid of open flame | keep (placed before 1.07) |
| 9 | E-1.07 The bucket beside the fire | `done:campfire` | W | someone being careful, nothing said | keep |
| 10 | E-1.08 A bell and a silly pile | `done:clear_weeds`, priority 90 | T/G | someone else is here; nothing missing | keep |
| 11 | E-1.B03 An empty bucket is a hat | `page:k_water` | G→W | Berit's bucket rule (Q14/Q6 planted) | keep |
| 12 | E-1.11 Maud's goat | ask after bells | G/W | Berit planned this; first warm door | keep |
| 13 | E-1.09 The seller who eats standing up | `done:d_porridge` | G | the village has a name; first customer; seeds | keep (Rue's name waits to visit 2) |
| 14 | E-1.10 A boy at the fence | ask `done:campfire` | T/W | the fear of the farm named by a small child; bent horseshoe | keep |
| 15 | E-1.B02 The doorframe | `tap:barn` | T→G | the first "not the barn" (Q1/Q13 planted); the woodpile | keep |
| 16 | E-1.L01 The buckets at the post | `done:road_1b` | G→W | someone has kept this post from far away | keep |
| 17 | E-1.B01 Stones on the post | `seen:L01 + after:2` | W | a row of river stones, uncounted; she puts it back exactly (Q15) | keep |
| 18 | E-1.L06 Old Cole and the stumps | `done:clear_stumps` | G→W | a neighbour who has watched the ruin and wants nothing | keep |
| 19 | E-1.12 The face on the coin | `seen:coins + seen:ledger` | G(+T) | the Lord has a face and name (WEXLEY) in the pocket | keep |
| 20 | E-1.13 The burnt page | `done:ruins_workshop` | T | the Lord's share grows each year (Q3) | keep |
| 21 | E-1.14 A basket for Ella | `done:sq_miller_basket` | G | a friend her age, half secret; the wrong bell | keep |
| 22 | E-1.16 Soup in two pots (+ L07 The Square Pot) | `done:d_veg_soup` | G(+W) | the village's first collective yes; the Pot; polite not warm | keep (L07 merged in) |
| 23 | E-1.17 A tower, and the tidying | `done:clear_rocks`; tidy after 6 | T | the bell-ringer stops; **the silence is a cost to the end of the hour** | keep (+ glimpse 1, M05 tail) |
| 24 | E-1.18 Flour and a grudge | `seen:c1_quern + after:3` | G | the first sale; word of the family, no date | keep |
| 25 | E-1.L05 Maud's bucket | `summer` | G→W | a full bucket left untouched one night; empty by morning (Maud only) | keep |
| 26 | E-1.19 Your hand knows the handle | `done:well_2` | W | **this was your home** (said once, by stones) | keep |
| 27 | E-1.15 The ghost hunters | `done:d_porridge + summer` | G | bells known before she came; two small allies | keep |
| 28 | E-1.20 Prints in the snow | `winter + seasons>=3` | T | the patch has a keeper; wrong size for a bell-ringer | keep |
| 29 | E-1.L08 Longnight, seen from the hill | winter | W | she sees what she does not have; works louder | keep |
| 30 | E-1.21 A lantern on the road | `seen:rue2 + done:coop_1` | T | someone from the manor walks past; hands shake | keep |
| 31 | E-1.22 Waiting for someone (x3) | `trips>=20`, `has:straw_hutch`, `has:bunny_bowl` | W,W,G | the want turns from "alone" to "for someone" | keep (one box, three triggers) |
| 32 | E-1.23 The notch | `seen:lantern + has:egg:1` | T | the Lord's count has begun; long fuse to the share | keep |
| 33 | E-1.L09 The cart at the Hop | step>=20, chance | G | the valley goes on without her | keep (bark) |
| 34 | E-1.H76 The village rhyme, with gaps | chance; later `seen:c3_goat`; Fair | W | the rhyme is older than Berit and kept by more people | keep (bark series, spans chapters) |
| 35 | E-1.M05 A tail, a glint (glimpses 1, 2) | `done:clear_rocks`; `seen:c1_bunny` | T | the player is ahead of the farmer | keep (picture-only; text fallback) |
| 36 | E-1.24 The bunny comes home | `done:pet_bunny` | W | the keeper revealed | keep |
| 37 | E-1.25 Two soft rings, and back in the room | `seen:c1_bunny + after:1`; `seen:c1_bell_out` | T→G | the cost paid back with a first answer; seam re-anchored by the hum | keep + **frame 1** |

37 rows, 36 distinct events. This is the densest chapter on purpose (it is the child's first hour). Optional for a thin build: #21, #27, #29, #33 (the chapter stays whole without them).

## Charge audit

Lead registers in order (rows 1–37): G T G W G A G T→G W T/G G→W G T→G G→W W G W T G G(+W) T G G→W W G T W T W/W/G T G W T T→G. Checked: no three identical marks in a row on the main path (the run G, G(+W) at rows 21–22 is followed by T at 23; the ghost hunters, which would have made a third G, sit after the well). Tension: T at rows 2, 10, 14, 15, 20, 23, 28, 30, 32, 35, 37; it rises (curiosity, then a cost the child feels at the tidied tower, then the manor lantern and the notch). Awe: one (row 6), at the end of act 1, after a day of hands; never adjacent to a W-only row. Every W follows a G or T.
**Unverified:** the step numbers are estimates (slice 01 §4 used node dependencies, not a bot run). Treat "no triple register, no sag" as a claim until one bot run over stub seeds confirms it.

## Exposition and clue ledger (what the player learns, once)

Facts 1–21 of the slice-01 ladder; the new ones this chapter: you lived here (1.19); the Lord has a face (1.12), a count (1.23), a share (1.13); the family is in a town and said "a while" (1.06); the bells predate her (1.15); the patch has a keeper (1.20). **Reveal of the chapter (04):** *You lived here. The fire is the thing you do not say.* Clues planted: Q1, Q2, Q3, Q6, Q13, Q14, Q15 (all nothing-said). **Forbidden before the telling:** the name Mumyo; "go away"; "I told them it was you".

## Persistent costs started here

The silence after the tidied tower (until the hour's end and then the bunny's answer); the notch (the Lord's count); "the Moonedge girl" is pointed at; a stool she does not have at Share Day seen from the hill.

## Village strand (stance rung 1)

Maud (warm, alone), Rue (a stranger), Old Jan (one old man), Tom, the twins, Ella, Old Cole. Only Maud, Rue and Jan carry anything. Nobody comes up the road. See `../../characters/village-arcs.md`.

## Chapter-end open question

*Who else is still here?* (two soft rings). Frame 1: "Was there really a bunny?" "There was. She was rude about carrots."

## Notes and rulings

- "Fifteen" is said once, early, by Berit's box and again by Rue; never in the frame.
- No `{player}` in Minena's mouth in frame 0 was ruled by the manager; the parent's later answer (01-5) **accepts** one use of {player} in frame 0 ("Please, {player}"). Slice 01 revision 2 removed it; re-adding it is a text-change request (see `../../text-change-requests.md` row 2).
- The hum is a frame object (the old you hums; the grandchild half-hears it: parent's answer 01-7 "yes").
- A "Where were we?" recap button (Option B) is a UI wish (see `../../data-wishes.md`).
