# Master outline, chapter 5: Healing

Written 24 Oct 2026 by the story manager. All 💡. Fates in `../registry.md`.

**Chapter question:** *Why did the badger leave?* (and: what does the farmer do when she cannot stop?)
**Farmer's want / obstacle / ending:** stop the cough in Hazelwood; she makes every remedy herself, and the torn page says why the badger left (nobody let the children rest, and she was one of them); she collapses (the low point); she asks, and the badger comes home: tea first.
**Pet:** badger. **Village rung:** 5, needs her (it has to ask; that costs the village its pride). **Lord:** a seal brought by a boy; **a third on paper, a quarter in the till**; Pieter's mercy. **Length:** short, about 60 engine steps (845–905), so this chapter carries **fewer boxes** and several free-play seeds.

## Acts

1. **The cough (845–865).** Quill's last scene before the Fair (the report he will not read aloud); the cough map; the still-room swept; Liv's letter (the same round hand).
2. **The low point (865–885).** The torn page, the finger-count; Share Day in cough week; Pieter's lantern held; the collapse; "The bucket's empty."
3. **Tea first (885–905).** Bowls come up the road; the second water; the badger comes home; the guest bed; Flowers on the step; the letter with the Lord's seal.

## Event seeds in play order

| # | Seed | Trigger (short) | Reg | What the player gets | Fate |
|---|---|---|---|---|---|
| 1 | shipped `c5_cough` | `chapter:5` | T | the cough, children first | shipped |
| 2 | E-5.B15 A report Quill will not read | `chapter:5 + after:c5_cough:2`, gated on `seen:c4_lease` | T | you are named in a book (a girl, eight; a witness, twelve) | keep; **Quill's last scene before the Fair** (see ruling) |
| 3 | shipped `c5_stillroom` + E-5.H46 Someone has swept | `done:ruins_stillroom + after:2` | W (G in the broom) | "somebody was here before you" is not only Berit | keep |
| 4 | E-5.L01 The cough map, one name circled | `seen:c5_cough + tap:board` | T | the cough has a route and a name (ends unresolved until the badger) | keep |
| 5 | E-5.B16 The same round hand | `after:c5_cough:6` | W (T last line) | the letter signed **Liv** (Mei's hand): honey, thyme, second boiling water; "I am not asking anything"; you fold it small and put it in your apron | keep |
| 6 | E-5.H43 The pony's page | `page:k_rope + seen:c4_pony` | W (dry) | you learn what you knew at three | keep (free play) |
| 7 | E-5.M19 The forest barks | `forest_trips>=2` | G/W | the Outer Wood has its own life | keep (bark kit, free play) |
| 8 | E-5.L03 Hum, don't whistle | `forest_trips>=2 + chance` | G→T | Greenstem hums the tune back, wrong; she is afraid not of the tune but of what it wants | keep |
| 9 | E-5.H39 The tail | `chapter:5 + forest_trips>=2` | G→W | you read someone else's tiredness and act, not your own (the one mirror for the pony) | keep |
| 10 | shipped `c5_conch`: **the white spiral (awe #3)** | `forest_trips>=3` | **A** | something white and spiral between the trunks; you do not go closer | shipped (A3) |
| 11 | E-5.M21 Mr. Mumble, then "Yours." (Lark's one visit) | `seen:c5_conch + forest_trips>=5` | G→W | Q11 answered as a joke: Lark names the tune; the one hint of the imp's name is a nonsense name | keep |
| 12 | E-5.H07 The thump you wave off | `seen:c5_first_tea + after:2` | G (T under) | warn, wave off, next thing (the pattern on the page before the collapse) | keep |
| 13 | E-5.R19 The lantern, held (Share Day in cough week; Pieter's mercy; Table carrier 2) | `chapter:5 + done:tea_pot` | T→W | his lantern finally lights something; the lesser of the book and a quarter of the till; his post rides on it; the Table line (salt) reaches the player | keep (**the chapter's Lord scene**) |
| 14 | shipped `c5_page`: the torn page found complete + E-5.B17 The bucket's empty (finger-count) | `seen:c5_page`; after collapse +1 | W→T→W | the badger left after the fever; **you were one of those children**; "The bucket's empty." Wren fills it and asks nothing | keep (**the turn / the low point**) |
| 15 | shipped `c5_collapse` | | T | she collapses in the still-room | shipped |
| 16 | E-5.L02 Bowls come up the road (+ E-5.B18 The second water) | `seen:c5_collapse + after:2` | W (G in the doily) | fourteen bowls pile up; the goat eats a doily; she must be fed; in the same morning Wren has read the folded letter and made the syrup as written; "(from L. of Weir)"; "Who is L.?" "My cousin." first time aloud (the hook-out) | keep (B18 merged in) |
| 17 | E-5.M22 Flowers on the step (two mornings) | `seen:c5_collapse + after:1`; `seen:c5_badger + after:5` | W (G in Wren's hands) | Mumyo's care arrives while she can do nothing; glimpse 7 (silhouette at the foot of the step) | keep (picture; text fallback) |
| 18 | shipped `c5_badger` + E-6.H45 Tea first, in an emergency (**moved here from ch6**) | `done:pet_badger`; `seen:c5_badger + after:5` | G→W | the badger comes home and makes you sit; tea first; you ask him to help (bend 2 ✅) | keep (H45 moves to ch5) |
| 19 | E-5.B19 The guest bed, the third time | `seen:c5_badger + after:2` | G→W | the bed made for the person you fear takes you in | keep |
| 20 | E-5.M23 The Wait, held | `done:pet_badger` | W (sound cue; none without sound) | the first time the rest is given to her | keep (optional) |
| 21 | E-5.L05 Floating Lights | `done:sq_lamp_maker + seen:c5_badger` | W (re-tagged from A) | she sets one afloat and watches to the bend; Ferdinand says it is lovely | keep (free play) |
| 22 | E-5.H38 The procession (bark x2) | chance | G | the village comes to watch the pony and so sees the farm | keep (bark) |
| 23 | E-5.R20 Leave two | `forest_trips>=4 + seen:c5_first_tea` | G→W | you teach back what you were taught: take only what grows back | **free play** (first to move if over budget) |
| – | shipped `c5_letter`, `c5_frame5` | after badger | T | the letter with the Lord's seal; frame 5: "By the time it was ready, I was." | shipped |

**Cut:** E-5.M18 The Line glows more (a magic meter the player may see; extra A pressure; trace only). **Free play:** #21, #22, #23, #24.

## Charge audit

Lead registers in play order (main path, free play left out): T, T, W (still-room swept), T (cough map, moved behind the still-room so the opening is not three Ts), W (Liv's letter), G→T, G→W, **A** (the white spiral), G→W (Lark), G (thump), T→W (Pieter's lantern), W→T→W (torn page and finger-count), T (collapse), G→W (bowls, doily, Wren and the letter), W (flowers, picture only), G→W (badger and tea), G→W (guest bed). Runs checked: no three identical marks in a row; after the collapse the W boxes are merged (bowls and the second water are one morning) and the flowers are a picture beside it, so the post-collapse stretch is T, G→W, W (picture), G→W. Tension: the cough, the report, the torn page and the collapse make this chapter's T the highest before the Fair; Pieter's mercy lifts the Lord's line to its human height. Awe: one (the spiral), mid-chapter, followed by the poison-check T and the collapse, never next to a W-only box. Every W follows a G or T.

## Exposition and clue ledger

**Reveal of the chapter:** *You are named in a book, and a witness of twelve; the grown-ups were busy; it was not only you* (B15, the torn page, the finger-count). Clues: Q10 confirmed (the badger left after the fever), Q11 answered (the melody has a name; "Mr. Mumble"), Q13 hinted, Q16 hinted (the round hand: Liv), Q19 hinted (the witness: twelve). **Table:** Berit's salt line reaches the player in Pieter's scene. **Allowed to be wrong about:** that the grown-ups alone were the cause.

## Persistent costs

Pieter's post rides on his mercy (the grey line grows); the lean-to stays dark; Lotte's cough lasts a bark longer if the still-room is slow; the folded letter in her apron (read by Wren).

## Village strand (rung 5: needs her)

Wren (grumpy, exact, won last), Greenstem, Lotte's mother, the Nest (Matron Elsie's bowls), Ferdinand; Maud's bowl. The village's thaw costs it its pride: it has to ask. The cold faces from earlier chapters are now the ones carrying bowls (Appleby's loaf is in the pile).

## Chapter-end open question

*A letter with the Lord's seal.* And, softer: *Wren has read your letter.* Frame 5: "Did you get better?" "Badgers make very slow tea. By the time it was ready, I was."

## Notes and rulings

- **Quill is absent from chapter 5 after #2** (07's "absent on purpose"). His B15 scene sits at the very start of the chapter as his last appearance before the Fair; after it the seal comes by a boy, and the pressure is that he did not bring it. 04 and 07 both stand; this is the join (ruling R-M1, `../../slices/DECISIONS.md`).
- Pieter's mercy lives here because the 25 % cap binds from this chapter.
- "Better." is out of the text (06 revision 2).
