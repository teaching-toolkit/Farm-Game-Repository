# Master outline, chapter 6: Master Farm

Written 24 Oct 2026 by the story manager. All 💡. Fates in `../registry.md`. The frame (frame 6) and what comes after it are in `ending.md`. This chapter is the most crowded: five slices fed it (about 48 seeds). The master cut it to **23 main-path boxes** and moved the rest to free play.

**Chapter question:** *Will she sit down and tell?* (the Lord's letter, the family arriving, the cousin in public; and the thing she has never said.)
**Farmer's want / obstacle / ending:** a perfect Fair and a farm safe from "a half" again; the Lord's letter, the family on the steps, the cousin standing up in front of everyone; **the bend**: she sits and tells the barn; the village wipes the chalk, Quill signs a number in ink, the alpaca comes home, the rhyme is whole, and she tells the rest to the dark garden.
**Pet:** alpaca. **Village rung:** 6, home. **Lord:** a rider, then a paper with a crooked seal; **a half on paper, a quarter in the till; a tenth after the paper**. The Fair has no date: "called by full tables". **Length:** about 164 engine steps (906–1069).

## Acts

1. **The letter and the marsh (906–950).** The Lord's letter, the soft clock folded flat, the half argued at the Pot, the alpaca waits on the ridge, the night garden opens (awe #4).
2. **The Fair eve (950–990).** Quill writes "fallow, per B." and asks names before plates; the family comes up the steps; the Empty Table; everyone hums; one long note in the dark.
3. **The Fair (990–1030).** The Players' Ballad, Liv stands, the bend, the village wipes the chalk, Quill's ink and "Corrected.", the alpaca comes home.
4. **The supper (1030–1050).** Lark and the squirrel, the lantern on its hook, Tilda's hand, the song and the roll.
5. **The garden and the frame (1050–1069).** The telling to the dark; frame 6.

## Event seeds in play order (main path)

| # | Seed | Trigger (short) | Reg | What the player gets | Fate |
|---|---|---|---|---|---|
| 1 | shipped `c6_lord` | `chapter:6` | T | the Lord's letter: "from the next Share Day", a half, "as before" (the claim) | shipped (engine trap: it fires before `c5_letter`; data wish) |
| 2 | E-6.R24 Pressed flat | `seen:c5_frame5 + chapter:6` | G→W | the folded letters read as warnings; the child sees the shape, the farmer does not (does **not** end the misreading) | keep, re-keyed |
| 3 | E-6.M24 The cheese and the rest | `done:import_broker` | G | the Broker knows the tune; Lark withholds "Home" because it is not his to give | keep (page added to `c6_broker`) |
| 4 | E-6.L11 The half at the Pot (+ E-6.R25 The letter, digested) | `seen:c6_lord + after:3` | G→T→W | the goat eats the Lord's letter (G), the village chooses the tables over quiet, Appleby gives her flour, Maud puts a spoon in; Quill: "I did not write it." | keep (R25 merged; H30 gag) |
| 5 | E-6.B25 The alpaca will not come down (bark x2) | `seen:c6_bend + tap:patch:marsh`, or early if not drained | W (goat G) | she waits on the ridge facing the reeds and hums one long note; the goat eats her ribbon | keep (the story reason for `pet_alpaca` requiring the garden) |
| 6 | shipped `c6_garden` + E-6.H58 Her back to the garden: **awe #4** | `done:river_meadow_drain` | **A** | white flowers open at dusk; thimbles in a ring; bells very softly; nobody comes | shipped (A4) |
| 7 | E-6.R12 Fallow, per B. (+ E-6.R27 Names before plates) | `seen:c6_fair_letter + after:3`; `seen:c6_fair_tables + after:2` | G→W | "a dead woman's word enters the Lord's Book"; Quill asks names before counting plates | keep (R27 merged) |
| 8 | E-6.B20 Last up the steps (+ E-6.L08 The barge is late) | `seen:c6_fair_letter + after:4` | T→W | the family climbs the Landing steps (sister 91, brother 92); Maud puts a bowl in the father's hands; he hands you the tent folded ("You patched it."); Liv, last, a pole on her back, a stone in her fist | keep (L08 merged) |
| 9 | E-6.L01 The Empty Table (with the three rings) | `done:d_fair_pies` | W | the table laid at every Fair since the fire; the stool for no one; she sets her cloth over the old one | keep |
| 10 | E-6.L03 Everybody hums | `seen:c6_fair_tables + after:3` | G→W | she stops humming, everyone looks, she starts again; she knows where they got it | keep |
| 11 | E-6.H54 One long note | `done:d_fair_pies` | T | the player hears the note once, in the dark, so it means something at home (a flinch, not awe) | keep |
| 12 | E-6.B21 The Players come (+ E-6.L05 The Ballad) | `done:d_fair_cloth` priority above `c6_crisis` | G→T | the child-hero runs out shouting "the lights!", the village sings, the lie is on stage in the child's own word; a grey coat goes still at the back | keep (trigger changed; **the Ballad is before the crisis**) |
| 13 | E-6.B22 Liv stands (+ `c6_crisis`) | `seen:` the Players | T | "It wasn't lightning. You were in the barn that night." | keep |
| 14 | E-6.B23 The bend: an exchange (`c6_bend`, 7 pages) | `seen:c6_crisis` (automatic ✅) | T→W | the barn told in the farmer's own words, up to what she cannot say; "I saw the lights too. I never told anyone." | keep |
| 15 | E-6.L04 The chalk is wiped | `seen:c6_bend + after:3` (**re-keyed**) | G→T→W | the village wipes the Mark before the paper reaches the Square; Quill, arriving: "You are two hours early" | keep |
| 16 | E-6.R29 Ink (+ E-6.B24 Corrected, + shipped `c6_quill_answer`) | `seen:c6_bend + after:2`; `done:farmhouse_sunroom` | G→T→W | the cork, the signed and witnessed count (a tenth), the drawer line ("He had them all in a drawer. The last line he read. Never the middle."), a ruler through "the girl", "Corrected." | keep (Quill's bend) |
| 17 | shipped `c6_alpaca` | `done:pet_alpaca` | W (G opener: the goat) | the alpaca comes home; her alarm woke the house; the rhyme is whole | shipped |
| 18 | shipped `c6_supper` (Lark and the squirrel, the goat eats the blue ribbon) | `seen:c6_alpaca` | G | Lark sits very still at a place laid for him | shipped |
| 19 | E-6.B26 Lantern, snuffer, bucket (+ E-6.H08 The lantern at the supper) | `seen:c6_supper`, priority above the garden | T→W→G | the lantern is hung on the hook outside by the bales; **a hand is already on it: the father's**; Liv snuffs it out with her pole; a bucket goes under the hook; next night every lantern in the square hangs outside | keep |
| 20 | E-6.B27 Tilda's hand | `seen:` lantern + after 3 | W | Liv reads "Yes, Mother" x3; "I used to think the lights were her." "They weren't." "They were somebody's, though." | keep |
| 21 | E-6.M29 The song, and the spoons (+ E-6.H55 The line closes, + E-6.L10 The roll call) | `seen:c6_alpaca` (as shipped) | G→W | Lark stops sorting the spoons; the rhyme to Berit's tune A; the roll: "Here!" from the farmer, then parents, siblings, cousin; Jan sits down; the six in sight | keep (three merged) |
| 22 | E-6.B28 The garden, Half 2 (+ E-6.M27 A thimble beside the bucket) | `seen:c6_bend + seen:c6_supper` | T→W | "Mumyo." The telling to the dark; "I said go away…"; the answer is a sound **and** a thing (the thimble): the player reads it, the farmer does not | keep (replaces `c6_ajar`) |
| 23 | E-6.B29 Start with the fire (**frame 6**) | `seen:` the garden piece | W→G | see `ending.md` | keep |

**Free play after the chapter (not on the main path):** E-6.L06 Lightning, kindly (Maud, one line); E-6.L09 The bucket, the other way; E-6.H09 The ear that lies down; E-6.H19 The warm tile; E-6.H42 The Mane; E-6.H66 The ladder; E-6.H47 The cold kettle; E-6.H49 The thimble; E-6.H68 Tea for everyone; E-6.H56 The look; E-6.H72 Over the shell; E-6.H73 Roll call (`tap:pets`); E-6.H78 The bowl; E-6.H59 The alpaca's page (`page:k_birds`); E-6.M28 Quill hums; E-6.R30 The barge that took nothing; E-6.R31 Too sweet, send another.

## The supper, settled (eight beats from five slices)

| Beat | Slice | Fate |
|---|---|---|
| The lantern at the supper | 03 H08 / 04 B26 | **one beat** (B26) on the main path |
| Tilda's hand | 04 B27 | main path |
| The song and the spoons | 06 M29 | main path, merged with H55 and L10 |
| The line closes (the six in sight) | 03 H55 | merged into M29's finale |
| The roll call | 02 L10 | merged into M29's finale; the family stays on |
| The bowl (the badger and the alpaca) | 03 H78 | free play |
| Roll call (`tap:pets`) | 03 H73 | free play |
| Lightning, kindly | 02 L06 | free play, one line |

## Charge audit

Dominant marks in play order: T, W, G, T, W (G), A, W, W/T, W, G, T, G, T, T→W, W (T opener), W (T opener), W, G, T→W→G, W, W (G opener), T→W, W→G. Runs checked: the crisis (rows 12–14: G, T, T→W) is the book's one deliberate double T, bracketed by G before (the Ballad's giggle build) and a G joke after (Quill, two hours late). The long post-bend strip (rows 14–17) has four endings that are W, and each opens on a T or a G (Quill's "two hours early", the cork, the goat) so no run of three identical dominant marks exists; the supper is G, T→W→G, W, G→W so the last W before the garden follows a G. Awe: **one in the chapter** (#6, early; the frame-6 picture of the glowing stones is the second, 18 boxes later, never adjacent); the supper song and the roll call are W by ruling. Tension: rises from the letter (#1) to the crisis; after the bend the tension is *cost* (Quill's post, the village's risk), then the telling is a quiet T. The chapter ends G (frame 6 falls asleep mid-sentence).

## Exposition and clue ledger

**Reveal of the chapter:** the telling, in two halves: the Fair (an exchange with Liv, up to "I'm not going to say. Not here.") and the garden (the dark, the name "Mumyo" alone, "I said go away", "I told them it was you"). Clues confirmed: Q1, Q2, Q5, Q8, Q12, Q13, Q16, Q19; **never answered:** Q17 (whose hands carried the lantern in) and the farmer's honest "I'd rather it was mine". Q9 answered in one line (the Count: grey salt, "the one above"; never named). **Forbidden before #22:** the name Mumyo (the one earlier hint is Lark's "Mr. Mumble", ch5).

## Persistent costs (what this chapter leaves standing)

The tenth for as long as the farm stands; Quill's post (his signed count; he goes down the river after the harvest to explain); the village risked the Hurst by wiping the chalk first; the Mark's years are not refunded; the Lord keeps his debt (rescheduled, not erased); "go away" cannot be taken back; the one thing unsaid (Minena carries the request).

## Village strand (rung 6: home)

Appleby wipes the first board; Maud puts the bowl in the father's hands; Ansel rings the Fair in; Juno's scroll is read aloud to a goat; Thorne's apples; Wren and Greenstem at the table. The village's act (the chalk) comes before the paper; the stool at the head of the Empty Table is for no one and the farmer sits at the long table.

## Engine and data checks this chapter needs

`pet_alpaca` requires `river_meadow_drain` (data wish; the garden is on the critical path), otherwise the fallback is the barn doorframe (the garden telling moves there; B25 reads the same). `c6_lord` fires before `c5_letter` (retime); `c6_quill_answer` can precede the Fair (needs `seen:` the bend and the chalk piece); the Fair has no date, so triggers use `done:d_fair_*`. Intended play order (to be confirmed by one bot run): drain, garden sight, Fair, bend, chalk, paper, alpaca, supper, garden telling; if the drain falls after the bend, A4 simply plays later and the order still holds.
